#include "telemetrycontroller.h"
#include <QDebug>

TelemetryController::TelemetryController(DataManager* data_manager, QObject *parent) 
    : QObject{parent} 
    , m_data_manager {data_manager}
{
    m_active_node_model = new ActiveNodeModel(this);
    m_pressure_list_model = new TelemetryListModel(this);
    m_temperature_list_model = new TelemetryListModel(this);
    m_humidity_list_model = new TelemetryListModel(this);
    
    // Initial setup:
    m_filtered_nodes = m_available_nodes;
    for (const auto& node_id: m_available_nodes) {
        m_data_manager->registerNode(node_id);
    }
    // if (!m_available_nodes.isEmpty()) {
    //     selectActiveNode(m_available_nodes[0]);
    // }

    connect(m_data_manager, &DataManager::telemetryBufferUpdated, 
            this, &TelemetryController::handleTelemetryData);
}


void TelemetryController::setSearchQuery(const QString& new_search_query) {
    if (m_search_query == new_search_query) { return; }

    m_search_query = new_search_query;
    updateFilteredNodes();
    emit searchQueryChanged();
}

void TelemetryController::updateFilteredNodes() {
    m_filtered_nodes.clear();
    for (const auto& node_id : m_available_nodes) {
        if (m_search_query.isEmpty() || node_id.contains(m_search_query, Qt::CaseInsensitive)) {
            m_filtered_nodes.append(node_id);
        }
    }
    emit filteredNodesChanged();
}


void TelemetryController::handleTelemetryData(QString node_id, TelemetrySample data) {
    // Executing on Main Thread! Safe to update QML models/properties.
    if (node_id != m_current_node_id) {
        return;
    }

    m_active_node_model->updateState(node_id, data);

    // TelemetryListModel(s):
    double timestamp = static_cast<double>(data.timestamp);
    m_pressure_list_model->appendPoint(timestamp, static_cast<double>(data.pressure));
    m_temperature_list_model->appendPoint(timestamp, static_cast<double>(data.temperature));
    m_humidity_list_model->appendPoint(timestamp, static_cast<double>(data.humidity));
}


void TelemetryController::selectActiveNode(QString node_id) {
    if (m_current_node_id == node_id) { return; }
    m_current_node_id = node_id;
    emit currentNodeIdChanged(node_id);

    auto slice = m_data_manager->getLatestSlice(node_id.toStdString());
    if (slice.size() == 0) {
        TelemetrySample data {
            .timestamp = 0UL,
            .temperature = 0.0F,
            .pressure = 0.0F,
            .humidity = 0.0F
        };
        m_active_node_model->updateState(node_id, data);
        return;
    }
    
    QVector<QPointF> temperature_stream {};
    QVector<QPointF> pressure_stream {};
    QVector<QPointF> humidity_stream {};

    temperature_stream.reserve(slice.size());
    pressure_stream.reserve(slice.size());
    humidity_stream.reserve(slice.size());

    for (const auto& data : slice) {
        double timestamp = static_cast<double>(data.timestamp);
        temperature_stream.emplace_back(timestamp, static_cast<double>(data.temperature));
        pressure_stream.emplace_back(timestamp, static_cast<double>(data.pressure));
        humidity_stream.emplace_back(timestamp, static_cast<double>(data.humidity));
    }
    
    auto latest_telemetry = slice.back();
    m_active_node_model->updateState(node_id, latest_telemetry);
    
    m_pressure_list_model->loadSlice(pressure_stream);
    m_temperature_list_model->loadSlice(temperature_stream);
    m_humidity_list_model->loadSlice(humidity_stream);
}

