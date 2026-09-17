import QtQuick
import Quickshell
import Quickshell.Io

Row {
    spacing: 4
    property string cpuStr: "--%"

    Text {
        text: "󰻠"
        color: "#7aa2f7"
        font.pixelSize: 15
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        text: cpuStr
        color: "#c0caf5"
        font.pixelSize: 13
        font.bold: true
        anchors.verticalCenter: parent.verticalCenter
    }

    Process {
        id: cpuProc
        // Calcola l'utilizzo della CPU basandosi su due campioni rapidi di /proc/stat
        command: ["sh", "-c", "awk '/^cpu / {u=$2+$4; t=$2+$3+$4+$5; if (NR==1){u1=u; t1=t} else {print int(100*(u-u1)/(t-t1))}}' /proc/stat <(sleep 0.2; cat /proc/stat)"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let val = this.text.trim();
                cpuStr = val !== "" ? val + "%" : "--%";
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: cpuProc.running = true
    }
}
