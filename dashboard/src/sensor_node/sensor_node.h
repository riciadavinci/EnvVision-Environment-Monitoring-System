#pragma once

#include <string>

struct SensorNode {
    std::string id;
    std::string name;
    std::string ip_address;
    std::string status;
    float battery_status;
    std::string last_seen;
};
Q_DECLARE_METATYPE(SensorNode)
