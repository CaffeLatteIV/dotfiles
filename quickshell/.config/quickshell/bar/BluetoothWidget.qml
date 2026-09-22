import QtQuick
import Quickshell
import Quickshell.Io

Item {
    width: 24
    height: 24

    Text {
        anchors.centerIn: parent
        text: "󰂯" // Icona Bluetooth NerdFont
        color: btMouseArea.containsMouse ? "#7aa2f7" : "#545c7e"
        font.pixelSize: 16
    }

    // Processo che lancia l'interfaccia terminale
    Process {
        id: bluetuiProc
        // Lancia bluetui usando Kitty
        command: ["kitty", "-e", "bluetui"]
    }

    MouseArea {
        id: btMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            // Esegue il comando. Se la finestra di kitty è già aperta tramite questo
            // widget, i click successivi verranno ignorati finché non la chiudi.
            bluetuiProc.running = true;
        }
    }
}
