import QtQuick
import Quickshell
import Quickshell.Io

Item {
    width: 24
    height: 24

    Text {
        anchors.centerIn: parent
        text: "󱅫" // Icona notifiche/campanella NerdFont
        // Diventa del colore di accento azzurro Tokyo Night al passaggio del mouse
        color: notifMouseArea.containsMouse ? "#7aa2f7" : "#c0caf5"
        font.pixelSize: 18
    }

    Process {
        id: notifProc
        // Esegue lo script Rofi specificato
        command: ["sh", "-c", "~/.config/rofi/toggle_launcher.sh"]
    }

    MouseArea {
        id: notifMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            notifProc.running = true;
        }
    }
}
