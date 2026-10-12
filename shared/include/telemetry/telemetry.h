#pragma once

#include <cstdint>
#include <QMetaType>

static const size_t MAX_NODE_ID_SIZE {20};


#pragma pack(push, 1)

struct TelemetryData {
    float temperature;
    float pressure;
    float humidity;
    char node_id[MAX_NODE_ID_SIZE];
};

#pragma pack(pop)

static_assert(sizeof(TelemetryData) == 32, "TelemetryData struct has incorrect size!");


struct TelemetrySample {
    uint64_t timestamp;
    float temperature;
    float pressure;
    float humidity;
};


Q_DECLARE_METATYPE(TelemetryData)
Q_DECLARE_METATYPE(TelemetrySample)