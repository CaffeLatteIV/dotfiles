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
        // top -bn1 reads /proc/stat internally and reports the idle field; we
        // print 100 - idle. No bash process-substitution hack, no sleep-per-tick.
        command: ["sh", "-c", "top -bn1 | awk -F'[,:]' '/^%Cpu/{for(i=1;i<=NF;i++) if($i ~ / id/) {gsub(/[^0-9.]/,\"\",$i); printf \"%d\", 100-$i; exit}}'"]
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
