import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: updatesWidget
    width: layout.width
    height: 30

    // Read the shared counter (computed once by the UpdatesModel singleton)
    // so every bar shows the same number.
    property string updatesCount: UpdatesModel.updatesCount

    Row {
        id: layout
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter

        Text {
            text: "󰏗"
            // Giallo/Arancio Tokyo Night se > 0, altrimenti Grigio inattivo
            color: parseInt(updatesWidget.updatesCount) > 0 ? "#e0af68" : "#545c7e"
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: updatesWidget.updatesCount
            color: "#c0caf5"
            font.pixelSize: 13
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
