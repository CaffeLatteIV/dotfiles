import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: updatesWidget
    width: layout.width
    height: 30

    property string updatesCount: "0"

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

    // Processo per LEGGERE il numero di aggiornamenti in background
    Process {
        id: updatesProc
        command: ["sh", "-c", "waybar-module-pacman-updates"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let out = this.text.trim();
                updatesWidget.updatesCount = out !== "" ? out : "0";
            }
        }
    }

    // Controlla la presenza di aggiornamenti ogni 30 minuti
    Timer {
        interval: 1800000
        running: true
        repeat: true
        onTriggered: updatesProc.running = true
    }
}
