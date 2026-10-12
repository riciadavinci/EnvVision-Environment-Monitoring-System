#include "udpserver.h"
#include <QDebug>
#include <QNetworkDatagram>
#include "globals.h"


UdpServer::UdpServer(QObject* parent) : QObject {parent} {}

UdpServer::~UdpServer() {
    stopServer();
}

void UdpServer::startServer() {
    m_udp_socket = new QUdpSocket(this);

    if (m_udp_socket->bind(QHostAddress::LocalHost, UDP_PORT)) {
        qDebug() << "UDP Server successfully bound to poer 45454.\n";

        connect(m_udp_socket, &QUdpSocket::readyRead, this, &UdpServer::readPendingDatagrams);
    } else {
        qDebug() << "UDP Server failed to bind: " << m_udp_socket->errorString() << "\n";
    }
}

void UdpServer::stopServer() {
    if (m_udp_socket) {
        if (m_udp_socket->isOpen()) {
            m_udp_socket->close();
        }
        m_udp_socket->deleteLater();
        m_udp_socket = nullptr;
    }
}



void UdpServer::readPendingDatagrams() {
    while(m_udp_socket->hasPendingDatagrams()) {
        QNetworkDatagram datagram = m_udp_socket->receiveDatagram();
        
        auto expected_size = static_cast<size_t>(sizeof(TelemetryData));
        auto actual_size = static_cast<size_t>(datagram.data().size());
        // std::cout << "static_cast<size_t>(datagram.data().size()): " << actual_size << "\n";
        // std::cout << "sizeof(TelemetryData): " << expected_size << "\n";

        if (actual_size == expected_size) {
            // std::cout << "Datagram is of type 'TelemetryData'!\n";

            TelemetryData packet;
            std::memcpy(&packet, datagram.data().constData(), sizeof(TelemetryData));
            
            uint64_t now_ms = std::chrono::duration_cast<std::chrono::milliseconds>(
                std::chrono::system_clock::now().time_since_epoch()
            ).count();

            TelemetrySample telemetry_sample {
                .timestamp = now_ms,
                .temperature = packet.temperature,
                .pressure = packet.pressure,
                .humidity = packet.humidity
            };

            QString node_id = QString::fromUtf8(packet.node_id, strnlen(packet.node_id, MAX_NODE_ID_SIZE));

            emit telemetryReceived(node_id, telemetry_sample);
        }
    }
}

