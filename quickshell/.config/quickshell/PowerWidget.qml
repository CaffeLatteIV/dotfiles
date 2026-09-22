import QtQuick
import Quickshell
import Quickshell.Io

Item {
    width: 24
    height: 24

    Text {
        anchors.centerIn: parent
        text: "󰐥" // Icona Power di NerdFont
        // Diventa rosso Tokyo Night al passaggio del mouse
        color: pwrMouseArea.containsMouse ? "#f7768e" : "#c0caf5"
        font.pixelSize: 18
    }

    Process {
        id: lockProc
        command: ["sh", "-c", "~/.config/rofi/myscripts/lock.sh"]
    }

    MouseArea {
        id: pwrMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            lockProc.running = true;
        }
    }
}
