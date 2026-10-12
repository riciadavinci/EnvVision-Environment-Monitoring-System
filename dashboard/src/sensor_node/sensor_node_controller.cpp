#include "sensor_node_controller.h"

SensorNodeController::SensorNodeController(const std::vector<SensorNode>& nodes, QObject* parent) 
    : QObject {parent}
{
    m_sensor_node_list_model = new SensorNodeListModel(this);
    m_sensor_node_list_model->initializeData(nodes);
}
