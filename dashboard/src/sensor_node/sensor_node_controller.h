#pragma once

#include <QObject>
#include <vector>
#include "sensor_node.h"
#include "sensor_node_list_model.h"


class SensorNodeController : public QObject {
    Q_OBJECT

    Q_PROPERTY(SensorNodeListModel* sensorNodeListModel READ sensorNodeListModel CONSTANT)

public:
    explicit SensorNodeController(const std::vector<SensorNode>& nodes, QObject* parent = nullptr);

    SensorNodeListModel* sensorNodeListModel() const { return m_sensor_node_list_model; };

private:

    SensorNodeListModel* m_sensor_node_list_model {nullptr};
};