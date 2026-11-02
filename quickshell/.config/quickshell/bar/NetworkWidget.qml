import QtQuick
import Quickshell
import Quickshell.Io

Row {
    spacing: 6

    property string ipAddress: "..."

    Text {
        text: "󰩟" // Icona NerdFont
        color: "#7aa2f7"
        font.pixelSize: 16
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        text: ipAddress
        color: "#c0caf5"
        font.pixelSize: 13
        font.bold: true
        anchors.verticalCenter: parent.verticalCenter
    }

    Process {
        id: ipProc
        // Robust across iproute2 versions: grab the token right after "src"
        // instead of assuming it is always field $7.
        command: ["sh", "-c", "ip route get 1.1.1.1 | awk '/src/{for(i=1;i<=NF;i++) if($i==\"src\"){print $(i+1); exit}}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let out = this.text.trim();
                ipAddress = out !== "" ? out : "Disconnesso";
            }
        }
    }

    Timer {
        interval: 10000 // Controlla ogni 10 secondi
        running: true
        repeat: true
        onTriggered: ipProc.running = true
    }
}
