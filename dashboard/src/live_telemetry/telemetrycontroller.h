#ifndef TELEMETRYCONTROLLER_H
#define TELEMETRYCONTROLLER_H

#include <QObject>
#include <QString>
#include <QTimer>
#include <QColor>
#include <telemetry/telemetry.h>
#include "data_manager.h"
#include <memory>
#include <globals.h>
#include "active_node_model.h"
#include "telemetry_list_model.h"

class TelemetryController : public QObject {
    Q_OBJECT

    Q_PROPERTY(ActiveNodeModel* activeNodeModel READ activeNodeModel CONSTANT)
    Q_PROPERTY(TelemetryListModel* pressureModel READ pressureModel CONSTANT)
    Q_PROPERTY(TelemetryListModel* temperatureModel READ temperatureModel CONSTANT)
    Q_PROPERTY(TelemetryListModel* humidityModel READ humidityModel CONSTANT)

    Q_PROPERTY(QString currentNodeId READ currentNodeId NOTIFY currentNodeIdChanged)
    Q_PROPERTY(QStringList filteredNodes READ filteredNodes NOTIFY filteredNodesChanged)
    Q_PROPERTY(QString searchQuery READ searchQuery WRITE setSearchQuery NOTIFY searchQueryChanged)

public:
    explicit TelemetryController(DataManager* data_manager, QObject *parent = nullptr);


    ActiveNodeModel*    activeNodeModel() const { return m_active_node_model; }
    TelemetryListModel* pressureModel() const { return m_pressure_list_model; }
    TelemetryListModel* temperatureModel() const { return m_temperature_list_model; }
    TelemetryListModel* humidityModel() const { return m_humidity_list_model; }

    QString currentNodeId() const { return m_current_node_id; }
    QStringList filteredNodes() const { return m_filtered_nodes; }
    QString searchQuery() const { return m_search_query; }

    // void setcurrentNodeId(const QString& new_node_id);
    void setSearchQuery(const QString& new_search_query);
    Q_INVOKABLE void selectActiveNode(QString node_id);

public slots:
    // Receiver slot connected to UdpServer::telemetryReceived
    void handleTelemetryData(QString node_id, TelemetrySample data);

signals:
    void currentNodeIdChanged(QString node_id);
    void filteredNodesChanged();
    void searchQueryChanged();

private:
    void updateFilteredNodes();

private:
    DataManager* m_data_manager {nullptr};

    ActiveNodeModel*    m_active_node_model {nullptr};
    TelemetryListModel* m_pressure_list_model {nullptr};
    TelemetryListModel* m_temperature_list_model {nullptr};
    TelemetryListModel* m_humidity_list_model {nullptr};

    QString m_current_node_id {"N/A"};
    QStringList m_available_nodes {AVAILABLE_SENSOR_NODES};
    QStringList m_filtered_nodes;
    QString m_search_query;
};

#endif // TELEMETRYCONTROLLER_H