import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: telemetryLogsView
    objectName: "telemetryLogsView"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Label {
                text: "Telemetry Logs"
                font.bold: true
                font.pixelSize: 15
            }
        }
    }
}