
qt_standard_project_setup()

# Server
qt_add_executable(EnvDash 
    main.cpp
    udp_server/udpserver.cpp 
    udp_server/udpserver.h 
    live_telemetry/telemetrycontroller.cpp 
    live_telemetry/telemetrycontroller.h 
    data_source/data_manager.cpp
    data_source/data_manager.h
    core/fixedsizeringbuffer.h
    live_telemetry/telemetry_list_model.cpp
    live_telemetry/telemetry_list_model.h
    live_telemetry/active_node_model.cpp
    live_telemetry/active_node_model.h
    sensor_node/sensor_node.h
    sensor_node/sensor_node_list_model.cpp
    sensor_node/sensor_node_list_model.h
    sensor_node/sensor_node_controller.cpp
    sensor_node/sensor_node_controller.h
)

target_include_directories(EnvDash PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/../../shared/include
    ${CMAKE_CURRENT_SOURCE_DIR}/core
    ${CMAKE_CURRENT_SOURCE_DIR}/data_source
    ${CMAKE_CURRENT_SOURCE_DIR}/live_telemetry
    ${CMAKE_CURRENT_SOURCE_DIR}/sensor_node
    ${CMAKE_CURRENT_SOURCE_DIR}/udp_server
    ${CMAKE_CURRENT_SOURCE_DIR}/ui
)

qt_add_resources(EnvDash "qml"
    PREFIX "/"
    FILES
        ui/Main.qml
        ui/LiveTelemetry.qml
        ui/Settings.qml
        ui/TelemetryLogs.qml
        ui/components/SensorNodeCard.qml
        ui/components/TelemetryGraphPanel.qml
        ui/SensorNodes.qml
        ui/fonts/MaterialSymbolsOutlined.ttf
)


target_link_libraries(EnvDash
    PRIVATE
        Qt6::Core
        Qt6::Widgets
        Qt6::Network
        Qt6::Qml
        Qt6::Quick
        Qt6::Charts
)

set_target_properties(EnvDash PROPERTIES
    WIN32_EXECUTABLE FALSE
)
