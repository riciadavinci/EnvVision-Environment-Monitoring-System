import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts
import "components"

Item {
    id: liveTelemetryView
    objectName: "liveTelemetryView"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            TextField {
                id: searchInput
                placeholderText: "Search nodes ..."
                Layout.preferredWidth: 200

                onTextEdited: {
                    telemetryController.searchQuery = text
                }
            }

            ComboBox {
                id: nodeCombo
                Layout.preferredWidth: 260
                model: telemetryController.filteredNodes

                onActivated: (index) => {
                    telemetryController.selectActiveNode(currentText)
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Label {
                text: "Active Node: " + telemetryController.currentNodeId
                font.bold: true
                font.pixelSize: 15
            }
        }

        // ================================================================
        // Move this to LiveTelemetryWindow.qml
        // ================================================================
        GridLayout {
            id: telemetryGridMain
            anchors.margins: 15
            columns: 2
            rows: 2
            columnSpacing: 15
            rowSpacing: 15


            // ================================================================
            // Quadrant 1: Instantaneous Physical Quantities
            // ================================================================
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 0
                Layout.preferredHeight: 0
                Layout.minimumWidth: 0
                Layout.minimumHeight: 0
                color: "#F8F9FA"
                border.color: "#E0E0E0"
                border.width: 1
                radius: 6

                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    columns: 2
                    rows: 2
                    columnSpacing: 10
                    rowSpacing: 10

                    // -----------------------------------------------------------
                    // Mini-Card 1: Top-Left
                    // -----------------------------------------------------------
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 0
                        Layout.preferredHeight: 0
                        color: "#FFFFFF"
                        border.color: "#E2E8F0"
                        border.width: 1
                        radius: 6

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 6

                            Text {
                                text: "ACTIVE NODE"
                                font.pixelSize: 11
                                font.bold: true
                                color: "#64748B"
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {
                                text: telemetryController.activeNodeModel?.nodeId ?? "N/A"
                                font.pixelSize: 18
                                font.bold: true
                                color: "#1E293B"
                                Layout.alignment: Qt.AlignHCenter
                            }

                            RowLayout {
                                spacing: 6
                                Layout.alignment: Qt.AlignHCenter

                                Rectangle {
                                    width: 10
                                    height: 10
                                    radius: 5
                                    color: telemetryController.activeNodeModel?.statusColor ?? "#94A3B8"
                                }

                                Text {
                                    text: telemetryController.activeNodeModel?.statusText ?? "Disconnected"
                                    font.pixelSize: 13
                                    font.bold: true
                                    color: telemetryController.activeNodeModel?.statusColor ?? "#64748B"
                                }
                            }
                        }
                    }


                    // -----------------------------------------------------------
                    // Mini-Card 2: Top Right (Pressure)
                    // -----------------------------------------------------------
                    TelemetryGridMiniCard {
                        metricTitle: "Pressure"
                        metricValue: (telemetryController.activeNodeModel?.pressure ?? 0).toFixed(2) + " hPa"
                        valueColor: "#0284C7"
                        iconText: "⏲️"
                    }


                    // -----------------------------------------------------------
                    // Mini-Card 3: Top Right (Temperature)
                    // -----------------------------------------------------------
                    TelemetryGridMiniCard {
                        metricTitle: "Temperature"
                        metricValue: (telemetryController.activeNodeModel?.temperature ?? 0).toFixed(2) + " °C"
                        valueColor: "#E11D48"
                        iconText: "🌡️"
                    }


                    // -----------------------------------------------------------
                    // Mini-Card 4: Bottom Right
                    // -----------------------------------------------------------
                    TelemetryGridMiniCard {
                        metricTitle: "Humidity"
                        metricValue: (telemetryController.activeNodeModel?.humidity ?? 0).toFixed(2) + " %"
                        valueColor: "#0D9488"
                        iconText: "💧"
                    }

                }
            }


            // ================================================================
            // Quadrant 2: Temperature Chart (Top-right)
            // ================================================================

            TelemetryGraphPanel {
                panelTitle: "Temperature vs Time"
                yAxisTitle: "°C"
                unitSuffix: "°C"
                minimumY: -20
                maximumY: 100
                dataModel: telemetryController.temperatureModel
                activeNode: telemetryController.activeNodeModel
            }


            // ================================================================
            // Quadrant 3: Pressure Chart (Top-right)
            // ================================================================

            TelemetryGraphPanel {
                panelTitle: "Pressure vs Time"
                yAxisTitle: "hPa"
                unitSuffix: "hPa"
                minimumY: 975
                maximumY: 1030
                dataModel: telemetryController.pressureModel
                activeNode: telemetryController.activeNodeModel
            }


            // ================================================================
            // Quadrant 4: Humidity Chart (Bottom-right)
            // ================================================================

            TelemetryGraphPanel {
                panelTitle: "Humidity vs Time"
                yAxisTitle: "%"
                unitSuffix: "%"
                minimumY: 0
                maximumY: 100
                dataModel: telemetryController.humidityModel
                activeNode: telemetryController.activeNodeModel
            }

        }


    }      
}