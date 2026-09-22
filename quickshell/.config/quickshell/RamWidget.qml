import QtQuick
import Quickshell
import Quickshell.Io

Row {
    spacing: 4
    property string ramStr: "--GB (--%)"

    Text {
        text: "󰍛"
        color: "#ff9e64"
        font.pixelSize: 15
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        text: ramStr
        color: "#ff9e64"
        font.pixelSize: 13
        font.bold: true
        anchors.verticalCenter: parent.verticalCenter
    }

    Process {
        id: ramProc
        // free -m legge i dati in Megabyte.
        // awk divide i MB usati per 1024 (ottenendo i GB con 1 decimale) e calcola la % rispetto al totale
        command: ["sh", "-c", "free -m | awk '/^Mem/ {printf \"%.1fGB (%d%%)\", $3/1024, $3/$2*100}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let val = this.text.trim();
                // Se awk restituisce un valore, lo usa, altrimenti mostra un placeholder
                ramStr = val !== "" ? val : "--GB (--%)";
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: ramProc.running = true
    }
}
