import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts

ApplicationWindow {
    id: window
    width: 1280
    height: 800
    visible: true
    title: "Telemetry Dashboard"

    FontLoader {
        id: symbolFont
        source: "qrc:/ui/fonts/MaterialSymbolsOutlined.ttf"
        
        onStatusChanged: {
            if (status === FontLoader.Ready) {
                console.log("Font loaded successfully! Family name:", name)
            } else if (status === FontLoader.Error) {
                console.error("Failed to load font from source!")
            }
        }
    }

    // ================================================================
    // Part of Main.qml: Burger Menu / Sidebar
    // ================================================================
    Drawer {
        id: navDrawer
        width: 240
        height: window.height


        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Label {
                text: "Navigation"
                font.bold: true
                font.pixelSize: 16
                Layout.margins: 16
            }

            ItemDelegate {
                id: liveNav
                Layout.fillWidth: true
                highlighted: stackView.currentItem?.objectName === "liveTelemetryView"

                background: Rectangle {
                    color: liveNav.highlighted 
                        ? "#E0F2FE" // Soft light-blue tint when active
                        : (liveNav.hovered ? "#F1F5F9" : "transparent") // Subtle gray on hover
                    radius: 6 // Optional rounded corners
                }

                contentItem: RowLayout {
                    spacing: 12

                    Text {
                        text: "\ue871"
                        font.family: "Material Symbols Outlined"
                        font.pixelSize: 20
                        color: liveNav.highlighted ? "#0284C7" : "#64748B"
                    }

                    Text {
                        text: "Live Telemetry"
                        font.pixelSize: 14
                        font.bold: true
                        color: liveNav.highlighted ? "#0284C7" : "#64748B"
                    }
                }

                onClicked: {
                    if (stackView.depth > 0 && stackView.currentItem.objectName !== "liveTelemetryView") {
                        stackView.replace("LiveTelemetry.qml")
                    }
                    navDrawer.close()
                }
            }

            ItemDelegate {
                text: "Sensor Nodes"
                Layout.fillWidth: true
                onClicked: {
                    if (stackView.depth > 0 && stackView.currentItem.objectName !== "sensorNodes")
                    stackView.replace("SensorNodes.qml")
                    navDrawer.close()
                }
            }

            ItemDelegate {
                text: "Telemetry Logs"
                Layout.fillWidth: true
                onClicked: {
                    if (stackView.depth > 0 && stackView.currentItem.objectName !== "telemetryLogsView") {
                        stackView.replace("TelemetryLogs.qml")
                    }
                    navDrawer.close()
                }
            }

            ItemDelegate {
                text: "Settings"
                Layout.fillWidth: true
                onClicked: {
                    if (stackView.depth > 0 && stackView.currentItem.objectName !== "settingsView")
                    stackView.replace("Settings.qml")
                    navDrawer.close()
                }
            }

            Item { Layout.fillHeight: true } // Spacer

        }
    }



    header: ToolBar {
        RowLayout {
            anchors.fill: parent

            ToolButton {
                text: "☰"
                font.pixelSize: 20
                onClicked: navDrawer.open()
            }

            Label {
                text: "Telemetry Monitor"
                font.bold: true
                font.pixelSize: 16
                Layout.fillWidth: true
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: "LiveTelemetry.qml"
    }

}