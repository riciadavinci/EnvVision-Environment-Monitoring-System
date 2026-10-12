#pragma once

#include <QObject>
#include <QString>
#include <QAbstractListModel>
#include <QVector>
#include "sensor_node.h"
#include <algorithm>

class SensorNodeListModel : public QAbstractListModel {
    Q_OBJECT

public:
    enum Roles {
        NodeIdRole = Qt::UserRole + 1,
        NodeNameRole,
        IpAddressRole,
        StatusRole,
        BatteryStatusRole,
        LastSeenRole
    };

    explicit SensorNodeListModel(QObject* parent = nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void insertOrUpdateSensorNode(const SensorNode& node);

    Q_INVOKABLE void removeSensorNode(const QString& node_id);

    void initializeData(const std::vector<SensorNode>& nodes);

private:
    QVector<SensorNode> m_sensor_nodes;
};
