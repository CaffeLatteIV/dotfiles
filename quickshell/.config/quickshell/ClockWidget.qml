import QtQuick
import Quickshell
import Quickshell.Io

Text {
    id: clockLabel

    // Proprietà interna del widget
    property string timeText: "Caricamento..."

    text: timeText
    color: "#c0caf5"
    font.pixelSize: 14
    font.bold: true

    Process {
        id: dateProc
        command: ["date", "+%a %d %b - %H:%M"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: clockLabel.timeText = this.text.trim()
        }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: dateProc.running = true
    }
}
