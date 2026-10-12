import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: settingsView
    objectName: "settingsView"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Label {
                text: "Settings"
                font.bold: true
                font.pixelSize: 15
            }
        }
    }
}