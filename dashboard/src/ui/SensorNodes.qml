import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// Explicit relative import so QML finds SensorNodeCard inside ui/components/
import "components"

Page {
    id: root
    title: "Sensor Nodes"
    objectName: "sensorNodes"

    background: Rectangle {
        color: "#1C1C1E"
    }

    // Top ToolBar Header
    header: ToolBar {
        background: Rectangle {
            color: "#2C2C2E"
            border.color: "#38383A"
            border.width: 1
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 12

            Text {
                text: "Sensor Nodes Overview"
                font.pixelSize: 18
                font.bold: true
                color: "#FFFFFF"
            }

            Item { Layout.fillWidth: true } // Spacer

            TextField {
                id: searchInput
                placeholderText: "Search node..."
                placeholderTextColor: "#8E8E93"
                color: "#FFFFFF"
                implicitWidth: 200

                background: Rectangle {
                    color: "#1C1C1E"
                    radius: 6
                    border.color: searchInput.activeFocus ? "#0A84FF" : "#38383A"
                }
            }
        }
    }

    // Grid Container for Node Cards
    GridView {
        id: gridView
        anchors.fill: parent
        anchors.margins: 16
        clip: true

        // Tile spacing
        cellWidth: 295
        cellHeight: 200

        // ---------------------------------------------------------------------
        // Model Binding:
        // Replace 'activeNodeModel' with the exact name under which you registered
        // your C++ ActiveNodeModel (via setContextProperty or QML_ELEMENT).
        // ---------------------------------------------------------------------
        model: typeof sensorNodeController.sensorNodeListModel !== "undefined" ? sensorNodeController.sensorNodeListModel : null

        delegate: SensorNodeCard {
            // Map your C++ roleNames() to the properties exposed by SensorNodeCard.qml
            nodeId: model.nodeId ?? "N/A"
            nodeName: model.nodeName ?? "Unknown"
            ipAddress: model.ipAddress ?? "0.0.0.0"
            status: model.status ?? "Offline"
            batteryLevel: model.batteryLevel ?? 0.0
            lastSeen: model.lastSeen ?? "N/A"

            onCardClicked: {
                console.log("Clicked card for Node ID:", model.nodeId)
                // Example StackView navigation:
                // stackView.push("NodeDetail.qml", { nodeId: model.nodeId })
            }
        }

        // Empty state UI when the C++ model has 0 items
        Item {
            anchors.centerIn: parent
            visible: gridView.count === 0

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 8

                Text {
                    text: "No Active Sensor Nodes"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#8E8E93"
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Waiting for UDP data from active nodes..."
                    font.pixelSize: 13
                    color: "#636366"
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}