import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ItemDelegate {
    id: root

    // --- Public Reusable Properties ---
    property string iconText: ""             // Unicode string for Material Symbol
    property string titleText: "Menu Item"
    property string targetObjectName: ""     // e.g., "liveTelemetryView"
    property string targetFile: ""           // e.g., "LiveTelemetry.qml"
    property var targetStackView: null       // Reference to stackView
    property var targetDrawer: null          // Reference to navDrawer

    Layout.fillWidth: true
    highlighted: targetStackView !== null && targetStackView.currentItem?.objectName === targetObjectName

    background: Rectangle {
        color: root.highlighted 
            ? "#E0F2FE" // Soft light-blue tint when active
            : (root.hovered ? "#F1F5F9" : "transparent") // Subtle gray on hover
        radius: 6
    }

    contentItem: RowLayout {
        spacing: 12

        Text {
            text: root.iconText
            font.family: "Material Symbols Outlined"
            font.pixelSize: 20
            color: root.highlighted ? "#0284C7" : "#64748B"
            visible: root.iconText !== ""    // Hide icon container if no icon is specified
        }

        Text {
            text: root.titleText
            font.pixelSize: 14
            font.bold: true
            color: root.highlighted ? "#0284C7" : "#64748B"
        }
    }

    onClicked: {
        if (targetStackView && targetStackView.depth > 0 && targetStackView.currentItem?.objectName !== targetObjectName) {
            targetStackView.replace(targetFile)
        }
        if (targetDrawer) {
            targetDrawer.close()
        }
    }
}