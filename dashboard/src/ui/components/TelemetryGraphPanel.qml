import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts

Rectangle {
    id: root

    // --- Public Reusable Properties ---
    property string panelTitle: "Telemetry Chart"
    property string yAxisTitle: "°C"
    property string unitSuffix: "°C"
    property var dataModel: null          // Replaces telemetryController.temperatureModel
    property var activeNode: null         // Replaces telemetryController.activeNodeModel
    property real minimumY: -20
    property real maximumY: 100
    property bool isPaused: false

    Layout.fillWidth: true
    Layout.fillHeight: true
    color: "#FFFFFF"
    border.color: "#CBD5E1"
    radius: 8

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 4

        // Header Controls
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: root.panelTitle
                font.bold: true
                font.pixelSize: 14
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "📷"
                onClicked: {
                    temperatureChart.grabToImage(function(result) {
                        var dateTimeStr = Qt.formatDateTime(new Date(), "yyyy-MM-dd_hh-mm-ss")
                        var baseName = root.panelTitle.toLowerCase().replace(/\s+/g, "_")
                        var fileName = baseName + "_" + dateTimeStr + ".png"

                        var success = result.saveToFile(fileName)
                        if (success) {
                            console.log("Screenshot saved: " + fileName)
                        } else {
                            console.error("Failed to save screenshot!")
                        }
                    })
                }
            }

            Button {
                text: root.isPaused ? "PAUSED" : "LIVE"
                onClicked: root.isPaused = !root.isPaused
            }
        }

        // Chart View
        ChartView {
            id: temperatureChart
            title: root.panelTitle
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
                min: root.minimumY
                max: root.maximumY
                titleText: root.yAxisTitle
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
                        var valueStr = point.y.toFixed(2) + " " + root.unitSuffix
                        temperatureChart.ToolTip.show(timeStr + "\n" + valueStr, 3000)
                    } else {
                        temperatureChart.ToolTip.hide()
                    }
                }
            }

            VXYModelMapper {
                series: tempSeries
                model: root.dataModel
                xColumn: 0
                yColumn: 1
            }

            Connections {
                target: root.activeNode
                enabled: !root.isPaused && root.activeNode !== null

                function onTelemetryUpdated() {
                    var latestMs = root.activeNode.timestamp
                    if (latestMs > 0) {
                        tempAxisX.max = new Date(latestMs)
                        tempAxisX.min = new Date(latestMs - 60000)
                    }
                }
            }
        }
    }
}