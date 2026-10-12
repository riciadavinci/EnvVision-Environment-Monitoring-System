#include "sensor_node_list_model.h"

SensorNodeListModel::SensorNodeListModel(QObject* parent) 
    : QAbstractListModel {parent}
{}

int SensorNodeListModel::rowCount(const QModelIndex& parent) const {
    if (parent.isValid()) {
        return 0;
    }
    return static_cast<int>(m_sensor_nodes.size());
}

QVariant SensorNodeListModel::data(const QModelIndex& index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_sensor_nodes.size()) {
        return QVariant();
    }

    const auto& node = m_sensor_nodes[index.row()];

    switch (role) {
    case NodeIdRole:
        return QString::fromStdString(node.id);
    case NodeNameRole:
        return QString::fromStdString(node.name);
    case IpAddressRole:
        return QString::fromStdString(node.ip_address);
    case StatusRole:
        return QString::fromStdString(node.status);
    case BatteryStatusRole:
        return node.battery_status;
    case LastSeenRole:
        return QString::fromStdString(node.last_seen);
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> SensorNodeListModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NodeIdRole] = "nodeId";
    roles[NodeNameRole] = "nodeName";
    roles[IpAddressRole] = "ipAddress";
    roles[StatusRole] = "status";
    roles[BatteryStatusRole] = "batteryLevel";
    roles[LastSeenRole] = "lastSeen";
    return roles;
}

void SensorNodeListModel::insertOrUpdateSensorNode(const SensorNode& node) {
    auto it = std::find_if(
        m_sensor_nodes.begin(), 
        m_sensor_nodes.end(), 
        [&](const SensorNode& other_node){
            return node.id == other_node.id;
        }
    );
    if (it != m_sensor_nodes.end()) {
        // Update path
        const int row = static_cast<int>(std::distance(m_sensor_nodes.begin(), it));
        *it = node;

        const QModelIndex idx = createIndex(row, 0);
        emit dataChanged(idx, idx);
    } else {
        // Insert path
        const int row = static_cast<int>(m_sensor_nodes.size());

        beginInsertRows(QModelIndex(), row, row);
        m_sensor_nodes.append(node);
        endInsertRows();
    }
}

void SensorNodeListModel::removeSensorNode(const QString& node_id) {
    const std::string target_node_id = node_id.toStdString();
    auto it = std::find_if(
        m_sensor_nodes.begin(), 
        m_sensor_nodes.end(), 
        [&](const SensorNode& other_node){
            return target_node_id == other_node.id;
        }
    );
    if (it != m_sensor_nodes.end()) {
        // Update path
        const int row = static_cast<int>(std::distance(m_sensor_nodes.begin(), it));
        
        beginRemoveRows(QModelIndex(), row, row);
        m_sensor_nodes.erase(it);
        endRemoveRows();
    } 
}

void SensorNodeListModel::initializeData(const std::vector<SensorNode>& nodes) {
    beginResetModel();

    m_sensor_nodes = QVector<SensorNode>(nodes.begin(), nodes.end());

    endResetModel();
}
