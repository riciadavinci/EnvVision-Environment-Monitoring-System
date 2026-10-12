#include "active_node_model.h"

ActiveNodeModel::ActiveNodeModel(QObject* parent) : QObject {parent} {
    m_watchdogTimer = new QTimer(this);
    m_watchdogTimer->setSingleShot(true);
    connect(m_watchdogTimer, &QTimer::timeout, this, [this]() {
        m_is_online = false;
        m_status_text = "Node Offline (Timeout)";
        m_status_color = QColor("#C62828"); // Red
        emit statusChanged();
    });
}


void ActiveNodeModel::updateState(const QString& node_id, const TelemetrySample& data) {
    m_node_id = node_id;
    m_temperature = data.temperature;
    m_pressure = data.pressure;
    m_humidity = data.humidity;
    m_timestamp = data.timestamp;
    
    m_is_online = true;
    m_status_text = "Connected";
    m_status_color = QColor("#2E7D32");
    m_watchdogTimer->start(3000); // Reset countdown

    emit telemetryUpdated();
    emit statusChanged();
}
