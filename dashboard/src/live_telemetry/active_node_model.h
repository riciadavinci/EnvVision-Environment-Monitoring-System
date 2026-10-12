#pragma once

#include <QObject>
#include <QString>
#include <QTimer>
#include <QColor>
#include <telemetry/telemetry.h>

class ActiveNodeModel : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString nodeId READ nodeId NOTIFY telemetryUpdated)
    Q_PROPERTY(float temperature READ temperature NOTIFY telemetryUpdated)
    Q_PROPERTY(float pressure READ pressure NOTIFY telemetryUpdated)
    Q_PROPERTY(float humidity READ humidity NOTIFY telemetryUpdated)
    Q_PROPERTY(uint64_t timestamp READ timestamp NOTIFY telemetryUpdated)

    // Watchdog to Track if Node is Live or Not
    Q_PROPERTY(bool isOnline READ isOnline NOTIFY statusChanged)
    Q_PROPERTY(QString statusText READ statusText NOTIFY statusChanged)
    Q_PROPERTY(QColor statusColor READ statusColor NOTIFY statusChanged)

public:
    explicit ActiveNodeModel(QObject* parent = nullptr);

    QString nodeId() const { return m_node_id; }
    float temperature() const { return m_temperature; }
    float pressure() const { return m_pressure; }
    float humidity() const { return m_humidity; }
    uint64_t timestamp() const { return m_timestamp; }

    // Watchdog to Track if Node is Live or Not
    bool isOnline() const { return m_is_online; }
    QString statusText() const { return m_status_text; }
    QColor statusColor() const { return m_status_color; }

    void updateState(const QString& node_id, const TelemetrySample& data);

signals:
    void telemetryUpdated();
    void statusChanged();

private:
    QString m_node_id {"N/A"};
    float m_temperature {0.0f};
    float m_pressure {0.0f};
    float m_humidity {0.0f};
    uint64_t m_timestamp {0UL};
    
    // Watchdog to Track if Node is Live or Not
    QTimer* m_watchdogTimer {nullptr}; 
    bool m_is_online {false};
    QString m_status_text {"N/A"};
    QColor m_status_color = QColor("#757575");  
};
