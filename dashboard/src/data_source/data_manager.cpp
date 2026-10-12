#include "data_manager.h"


DataManager::DataManager(QObject* parent) : QObject {parent} {
    /* DataManager Constructor */
}



void DataManager::handleTelemetrySample(QString node_id, TelemetrySample telemetry_sample) {
    std::string key = node_id.toStdString();
    auto it = m_registered_nodes.find(key);
    if (it != m_registered_nodes.end()){
        m_buffers[key].push(telemetry_sample);
        auto packet = m_buffers[key].getLatest();
        emit telemetryBufferUpdated(node_id, telemetry_sample);
    }
}

void DataManager::registerNode(std::string node_id) {
    m_registered_nodes[node_id] = true;
}

void DataManager::registerNode(QString node_id) {
    registerNode(node_id.toStdString());
}

std::vector<TelemetrySample> DataManager::getLatestSlice(const std::string& node_id, std::size_t count) const {
    auto it = m_buffers.find(node_id);
    if (it != m_buffers.end()) {
        return it->second.getLatestSlice(count);
    }
    return {};
}
