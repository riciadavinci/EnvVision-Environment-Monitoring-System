import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    // --- Public Reusable Properties ---
    property string metricTitle: "Metric"
    property string metricValue: "0.00"
    property color valueColor: "#0284C7"
    property string iconText: "📊"

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
                text: root.metricTitle
                font.pixelSize: 13
                color: "#64748B"
            }

            Text {
                text: root.metricValue
                font.pixelSize: 20
                font.bold: true
                color: root.valueColor
            }
        }

        Text {
            text: root.iconText
            font.pixelSize: 28
            Layout.alignment: Qt.AlignVCenter
        }
    }
}