import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ItemDelegate {
    id: root

    // --- Public Exposed Properties (Mapped from C++ Model Roles) ---
    property string nodeId: "NODE-000"
    property string nodeName: "Unknown Node"
    property string ipAddress: "0.0.0.0"
    property string status: "Offline"    // "Online", "Warning", "Offline"
    property real batteryLevel: 0.0      // Range: 0.0 to 1.0 (0% - 100%)
    property string lastSeen: "N/A"

    // --- Interaction Signals ---
    signal cardClicked()

    implicitWidth: 280
    implicitHeight: 185

    background: Rectangle {
        color: root.down ? "#2C2C2E" : (root.hovered ? "#3A3A3C" : "#242426")
        radius: 12
        border.color: root.hovered ? "#0A84FF" : "#38383A"
        border.width: 1

        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on border.color { ColorAnimation { duration: 150 } }
    }

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        // --- Header Row: Node Name & Dynamic Status Badge ---
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: root.nodeName
                font.pixelSize: 15
                font.bold: true
                color: "#FFFFFF"
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            // Status Badge
            Rectangle {
                implicitWidth: statusText.implicitWidth + 16
                implicitHeight: 22
                radius: 11
                color: {
                    switch (root.status.toLowerCase()) {
                        case "online": return "#1C3B2B"
                        case "warning": return "#3D3019"
                        case "offline": return "#3A1E1E"
                        default: return "#2C2C2E"
                    }
                }
                border.color: {
                    switch (root.status.toLowerCase()) {
                        case "online": return "#30D158"
                        case "warning": return "#FFD60A"
                        case "offline": return "#FF453A"
                        default: return "#8E8E93"
                    }
                }

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 5

                    Rectangle {
                        width: 6
                        height: 6
                        radius: 3
                        color: parent.parent.border.color
                    }

                    Text {
                        id: statusText
                        text: root.status
                        font.pixelSize: 11
                        font.bold: true
                        color: parent.parent.border.color
                    }
                }
            }
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: "#38383A"
        }

        // --- Details Section ---
        GridLayout {
            columns: 2
            rowSpacing: 5
            columnSpacing: 10
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text { text: "Node ID:"; color: "#8E8E93"; font.pixelSize: 12 }
            Text { 
                text: root.nodeId
                color: "#EBEBF5"
                font.pixelSize: 12
                font.family: "Monospace"
                font.bold: true
            }

            Text { text: "IP Address:"; color: "#8E8E93"; font.pixelSize: 12 }
            Text { 
                text: root.ipAddress
                color: "#EBEBF5"
                font.pixelSize: 12
                font.family: "Monospace"
            }

            Text { text: "Last Seen:"; color: "#8E8E93"; font.pixelSize: 12 }
            Text { text: root.lastSeen; color: "#EBEBF5"; font.pixelSize: 12 }
        }

        // --- Battery Gauge Footer ---
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text { text: "Battery:"; color: "#8E8E93"; font.pixelSize: 11 }

            ProgressBar {
                Layout.fillWidth: true
                value: Math.max(0.0, Math.min(1.0, root.batteryLevel))
                from: 0.0
                to: 1.0

                background: Rectangle {
                    implicitHeight: 6
                    color: "#38383A"
                    radius: 3
                }
                contentItem: Item {
                    implicitHeight: 6
                    Rectangle {
                        width: parent.width * parent.parent.value
                        height: parent.height
                        radius: 3
                        color: root.batteryLevel < 0.20 ? "#FF453A" : (root.batteryLevel < 0.50 ? "#FFD60A" : "#30D158")
                    }
                }
            }

            Text {
                text: Math.round(root.batteryLevel * 100) + "%"
                color: "#EBEBF5"
                font.pixelSize: 11
                font.bold: true
            }
        }
    }

    onClicked: root.cardClicked()
}