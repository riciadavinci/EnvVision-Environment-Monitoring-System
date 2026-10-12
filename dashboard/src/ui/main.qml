import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts
import "components"

ApplicationWindow {
    id: window
    width: 1280
    height: 800
    visible: true
    title: "EnvDash - Dashboard for EnvVision"

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
          
            BurgerMenuItem {
                iconText: "\ue871"
                titleText: "Live Telemetry"
                targetObjectName: "liveTelemetryView"
                targetFile: "qrc:/ui/LiveTelemetry.qml"
                targetStackView: stackView
                targetDrawer: navDrawer
            }

            BurgerMenuItem {
                iconText: "\ue8f4"
                titleText: "Sensor Nodes"
                targetObjectName: "sensorNodes"
                targetFile: "qrc:/ui/SensorNodes.qml"
                targetStackView: stackView
                targetDrawer: navDrawer
            }

            BurgerMenuItem {
                iconText: "\ue896"
                titleText: "Telemetry Logs"
                targetObjectName: "telemetryLogsView"
                targetFile: "qrc:/ui/TelemetryLogs.qml"
                targetStackView: stackView
                targetDrawer: navDrawer
            }

            BurgerMenuItem {
                iconText: "\ue8b8"
                titleText: "Settings"
                targetObjectName: "settingsView"
                targetFile: "qrc:/ui/Settings.qml"
                targetStackView: stackView
                targetDrawer: navDrawer
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
                text: "<i>EnvDash</i> Telemetry Dashboard"
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