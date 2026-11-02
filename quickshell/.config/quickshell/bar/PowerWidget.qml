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
        // Open the rofi power menu (shutdown/reboot/lock/suspend/logout)
        // instead of only locking, so the power icon matches the action.
        command: ["sh", "-c", "~/.config/rofi/scripts/powermenu_t1"]
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
