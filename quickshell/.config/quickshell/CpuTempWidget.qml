import QtQuick
import Quickshell
import Quickshell.Io

Row {
    spacing: 4
    property string tempStr: "--°C"

    Text {
        text: "󰔄"
        color: "#f7768e" // Rosso Tokyo Night
        font.pixelSize: 15
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        text: tempStr
        color: "#f7768e" // Rosso Tokyo Night
        font.pixelSize: 13
        font.bold: true
        anchors.verticalCenter: parent.verticalCenter
    }

    Process {
        id: tempProc
        // Legge la temperatura standard della CPU in milligradi e la converte in gradi
        command: ["sh", "-c", "cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | head -n 1 | awk '{print int($1/1000)}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let val = this.text.trim();
                tempStr = val !== "" ? val + "°C" : "N/D";
            }
        }
    }

    Timer {
        interval: 3000 // Aggiorna ogni 3 secondi
        running: true
        repeat: true
        onTriggered: tempProc.running = true
    }
}
