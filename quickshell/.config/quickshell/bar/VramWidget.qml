import QtQuick
import Quickshell
import Quickshell.Io

// VRAM widget: shows used GPU memory via nvidia-smi (RTX 4060).
// Same glyph as the RAM widget (proven to render in the bar font),
// but green so it's distinguishable from RAM's orange.
Row {
    spacing: 4
    property string vramStr: "--GB (--%)"

    Text {
        text: "󰍛"
        color: "#9ece6a"
        font.pixelSize: 15
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        text: vramStr
        color: "#9ece6a"
        font.pixelSize: 13
        font.bold: true
        anchors.verticalCenter: parent.verticalCenter
    }

    Process {
        id: vramProc
        // nvidia-smi returns used,total in MiB; awk converts to GB and %.
        command: ["sh", "-c", "nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null | awk -F', ' '{printf \"%.1fGB (%d%%)\", $1/1024, $1/$2*100}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let val = this.text.trim();
                // Se nvidia-smi fallisce o non c'è GPU, mostra un placeholder.
                vramStr = val !== "" ? val : "--GB (--%)";
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: vramProc.running = true
    }
}
