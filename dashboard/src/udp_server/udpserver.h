#pragma once

#include <QObject>
#include <QUdpSocket>
#include <QString>
#include <chrono>
#include <iostream>
#include <telemetry/telemetry.h>

class UdpServer : public QObject {
    Q_OBJECT

public:
    explicit UdpServer(QObject* parent = nullptr);
    ~UdpServer() override;

public slots:
    void startServer();
    void stopServer();

signals:
    // void telemetryReceived(const TelemetryData& data);
    void telemetryReceived(QString node_id, TelemetrySample data);

private slots:
    void readPendingDatagrams();

private:
    QUdpSocket* m_udp_socket {nullptr};
};
