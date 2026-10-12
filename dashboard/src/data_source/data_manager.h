#pragma once

#include <QObject>
#include <iostream>
#include <QDebug>
#include <telemetry/telemetry.h>
#include "fixedsizeringbuffer.h"
#include <unordered_map>
#include <vector>

static const size_t MAX_BUFFER_CAPACITY {3600};


class DataManager : public QObject {
    Q_OBJECT

public:
    explicit DataManager(QObject* parent = nullptr);

    void registerNode(std::string node_id);
    void registerNode(QString node_id);

    std::vector<TelemetrySample> getLatestSlice(const std::string& node_id, std::size_t count = DEFAULT_SLICE_SIZE) const;

signals:
    void telemetryBufferUpdated(QString node_id, TelemetrySample telemetry_sample);

public slots:
    void handleTelemetrySample(QString node_id, TelemetrySample telemetry_sample);

private:
    std::unordered_map<std::string, FixedSizeRingBuffer<TelemetrySample, MAX_BUFFER_CAPACITY>> m_buffers {};
    std::unordered_map<std::string, bool> m_registered_nodes {};
};
