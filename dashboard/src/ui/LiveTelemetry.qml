import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts

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
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 0
                        Layout.preferredHeight: 0
                        color: "#FFFFFF"
                        border.color: "#E2E8F0"
                        border.width: 1
                        radius: 6

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 8

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4

                                Text {
                                    text: "Pressure"
                                    font.pixelSize: 13
                                    color: "#64748B"
                                }

                                Text {
                                    text: (telemetryController.activeNodeModel?.pressure ?? 0).toFixed(2) + " hPa"
                                    font.pixelSize: 20
                                    font.bold: true
                                    color: "#0284C7"
                                }
                            }

                            Text {
                                text: "⏲️"
                                font.pixelSize: 28
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }
                    }


                    // -----------------------------------------------------------
                    // Mini-Card 3: Top Right (Temperature)
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

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 8

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4

                                Text {
                                    text: "Temperature"
                                    font.pixelSize: 13
                                    color: "#64748B"
                                }

                                Text {
                                    text: (telemetryController.activeNodeModel?.temperature ?? 0).toFixed(2) + " °C"
                                    font.pixelSize: 20
                                    font.bold: true
                                    color: "#E11D48"
                                }
                            }

                            Text {
                                text: "🌡️"
                                font.pixelSize: 28
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }
                    }


                    // -----------------------------------------------------------
                    // Mini-Card 4: Bottom Right
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

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 8

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4

                                Text {
                                    text: "Humidity"
                                    font.pixelSize: 13
                                    color: "#64748B"
                                }

                                Text {
                                    text: (telemetryController.activeNodeModel?.humidity ?? 0).toFixed(2) + " %"
                                    font.pixelSize: 20
                                    font.bold: true
                                    color: "#0D9488" // Teal accent
                                }
                            }

                            Text {
                                text: "💧"
                                font.pixelSize: 28
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }
                    }
                }
            }


            // ================================================================
            // Quadrant 2: Temperature Chart (Top-right)
            // ================================================================

            Rectangle {
                id: temperatureSeriesCard
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#FFFFFF"
                border.color: "#CBD5E1"
                radius: 8

                property bool isPaused: false

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 4

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Temperature vs Time"
                            font.bold: true
                            font.pixelSize: 14
                        }

                        Item { Layout.fillWidth: true }

                        Button {
                            text: "📷"
                            onClicked: {
                                temperatureChart.grabToImage(function(result) {
                                    var fileName = "temperature_snapshot.png"
                                    var success = result.saveToFile(fileName)
                                    if (success) {
                                        console.log("Screenshot saved successfully!")
                                    } else {
                                        console.error("Failed to save screenshot!")
                                    }
                                })

                                telemetryGridMain.grabToImage(function(result) {
                                    var fileName = "telemetry_snapshot.png"
                                    var success = result.saveToFile(fileName)
                                    if (success) {
                                        console.log("Screenshot saved successfully!")
                                    } else {
                                        console.error("Failed to save screenshot!")
                                    }
                                })
                            }
                        }

                        Button {
                            text: temperatureSeriesCard.isPaused ? "PAUSED" : "LIVE"
                            onClicked: temperatureSeriesCard.isPaused = !temperatureSeriesCard.isPaused
                        }
                    }

                    // 
                    ChartView {
                        id: temperatureChart
                        title: "Temperature (°C)"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 0
                        Layout.preferredHeight: 0
                        Layout.minimumWidth: 0
                        Layout.minimumHeight: 0
                        antialiasing: true
                        legend.visible: true

                        DateTimeAxis {
                            id: tempAxisX
                            format: "hh:mm:ss"
                            titleText: "Time"
                            tickCount: 7
                            min: new Date(Date.now() - 60000)
                            max: new Date(Date.now())
                        }

                        ValueAxis {
                            id: tempAxisY
                            min: -20
                            max: 100
                            titleText: "°C"
                        }

                        LineSeries {
                            id: tempSeries
                            axisX: tempAxisX
                            axisY: tempAxisY
                            pointsVisible: true
                            pointLabelsVisible: false

                            onHovered: (point, state) => {
                                if (state) {
                                    var timeStr = Qt.formatDateTime(new Date(point.x), "hh:mm:ss.zzz")
                                    var valueStr = point.y.toFixed(2) + " hPa"
                                    temperatureChart.ToolTip.show(timeStr + "\n" + valueStr, 3000)
                                } else {
                                    temperatureChart.ToolTip.hide()
                                }
                            }
                        }

                        VXYModelMapper {
                            series: tempSeries
                            model: telemetryController.temperatureModel
                            xColumn: 0
                            yColumn: 1
                        }

                        Connections {
                            target: telemetryController.activeNodeModel

                            function onTelemetryUpdated() {
                                var latestMs = telemetryController.activeNodeModel.timestamp
                                if (latestMs > 0) {
                                    tempAxisX.max = new Date(latestMs)
                                    tempAxisX.min = new Date(latestMs - 60000)
                                }
                            }
                        }
                    }
                }

            }





            // ================================================================
            // Quadrant 3: Pressure Chart (Top-right)
            // ================================================================

            ChartView {
                id: pressureChart
                title: "Pressure (hPa)"
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 0
                Layout.preferredHeight: 0
                Layout.minimumWidth: 0
                Layout.minimumHeight: 0
                antialiasing: true
                legend.visible: true

                DateTimeAxis {
                    id: pressAxisX
                    format: "hh:mm:ss"
                    titleText: "Time"
                    tickCount: 7
                    min: new Date(Date.now() - 60000)
                    max: new Date(Date.now())
                }

                ValueAxis {
                    id: pressAxisY
                    min: 975
                    max: 1030
                    titleText: "hPa"
                }

                LineSeries {
                    id: pressSeries
                    axisX: pressAxisX
                    axisY: pressAxisY
                    pointsVisible: true
                    pointLabelsVisible: false

                    onHovered: (point, state) => {
                        if (state) {
                            var timeStr = Qt.formatDateTime(new Date(point.x), "hh:mm:ss.zzz")
                            var valueStr = point.y.toFixed(2) + " hPa"
                            pressureChart.ToolTip.show(timeStr + "\n" + valueStr, 3000)
                        } else {
                            pressureChart.ToolTip.hide()
                        }
                    }
                }

                VXYModelMapper {
                    series: pressSeries
                    model: telemetryController.pressureModel
                    xColumn: 0
                    yColumn: 1
                }

                Connections {
                    target: telemetryController.activeNodeModel

                    function onTelemetryUpdated() {
                        var latestMs = telemetryController.activeNodeModel.timestamp
                        if (latestMs > 0) {
                            pressAxisX.max = new Date(latestMs)
                            pressAxisX.min = new Date(latestMs - 60000)
                        }
                    }
                }
            }




            // ================================================================
            // Quadrant 4: Humidity Chart (Bottom-right)
            // ================================================================

            ChartView {
                id: humidityChart
                title: "Humidity (%)"
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 0
                Layout.preferredHeight: 0
                Layout.minimumWidth: 0
                Layout.minimumHeight: 0
                antialiasing: true
                legend.visible: true

                DateTimeAxis {
                    id: humidAxisX
                    format: "hh:mm:ss"
                    titleText: "Time"
                    tickCount: 7
                    min: new Date(Date.now() - 60000)
                    max: new Date(Date.now())
                }

                ValueAxis {
                    id: humidAxisY
                    min: 0
                    max: 100
                    titleText: "%"
                }

                LineSeries {
                    id: humidSeries
                    axisX: humidAxisX
                    axisY: humidAxisY
                    pointsVisible: true
                    pointLabelsVisible: false

                    onHovered: (point, state) => {
                        if (state) {
                            var timeStr = Qt.formatDateTime(new Date(point.x), "hh:mm:ss.zzz")
                            var valueStr = point.y.toFixed(2) + " hPa"
                            humidityChart.ToolTip.show(timeStr + "\n" + valueStr, 3000)
                        } else {
                            humidityChart.ToolTip.hide()
                        }
                    }
                }

                VXYModelMapper {
                    series: humidSeries
                    model: telemetryController.humidityModel
                    xColumn: 0
                    yColumn: 1
                }

                Connections {
                    target: telemetryController.activeNodeModel

                    function onTelemetryUpdated() {
                        var latestMs = telemetryController.activeNodeModel.timestamp
                        if (latestMs > 0) {
                            humidAxisX.max = new Date(latestMs)
                            humidAxisX.min = new Date(latestMs - 60000)
                        }
                    }
                }
            }

        }


    }      
}