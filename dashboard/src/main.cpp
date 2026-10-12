// #include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QThread>
#include <QFontDatabase>

#include "udpserver.h"
#include "telemetrycontroller.h"
#include "data_manager.h"
#include <globals.h>
#include "sensor_node/sensor_node.h"
#include "sensor_node/sensor_node_controller.h"

int main(int argc, char *argv[]) {
    // QGuiApplication app(argc, argv);
    QApplication app(argc, argv);

    //  Register font globally
    int font_id = QFontDatabase::addApplicationFont(":/qt/qml/TelemetryApp/ui/fonts/MaterialSymbolsOutlined.ttf");
    if (font_id != -1) {
        QString font_family = QFontDatabase::applicationFontFamilies(font_id).at(0);
        qDebug() << "Loaded font family:" << font_family;
    }

    // Register type for QueuedConnection thread safety
    qRegisterMetaType<TelemetryData>("TelemetryData");
    qRegisterMetaType<TelemetrySample>("TelemetrySample");
    qRegisterMetaType<SensorNode>("SensorNode");

    qSetMessagePattern("[%{type}] %{category} - %{message} (%{file}:%{line})");

    DataManager* data_manager = new DataManager(&app);

    // 1. Create Main UI Controller (Lives on Main UI Thread)
    TelemetryController controller(data_manager);

    SensorNodeController sn_controller(sensor_nodes);

    // 2. Create Background Thread & Worker
    QThread *workerThread = new QThread(&app);
    
    // IMPORTANT: UdpServer MUST NOT have a parent when using moveToThread!
    UdpServer *udpServer = new UdpServer(); 
    udpServer->moveToThread(workerThread);

    // 3. Setup Signal/Slot Connections
    // Start socket when thread starts
    QObject::connect(workerThread, &QThread::started, udpServer, &UdpServer::startServer);

    // Cross-thread data bridge (automatic Qt::QueuedConnection)
    // QObject::connect(udpServer, &UdpServer::telemetryReceived, 
    //                  &controller, &TelemetryController::handleTelemetryData);
    QObject::connect(udpServer, &UdpServer::telemetryReceived, 
                     data_manager, &DataManager::handleTelemetrySample);

    // Graceful Shutdown Sequence
    QObject::connect(&app, &QGuiApplication::aboutToQuit, workerThread, [workerThread, udpServer]() {
        QMetaObject::invokeMethod(udpServer, "stopServer", Qt::QueuedConnection);
        workerThread->quit();
        workerThread->wait();
    });
    QObject::connect(workerThread, &QThread::finished, udpServer, &QObject::deleteLater);

    // 4. Start Thread Event Loop
    workerThread->start();

    // 5. QML UI Engine Setup
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("telemetryController", &controller);
    engine.rootContext()->setContextProperty("sensorNodeController", &sn_controller);

    const QUrl url(QStringLiteral("qrc:/ui/Main.qml")); // Adjust path to your QML file
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}