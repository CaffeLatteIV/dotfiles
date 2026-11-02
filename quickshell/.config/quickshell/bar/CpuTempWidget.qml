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
        // Pick the actual CPU thermal zone (x86_pkg / cpu / core / package),
        // not the first zone (thermal_zone0 here is the motherboard ACPI sensor).
        command: ["sh", "-c", "for z in /sys/class/thermal/thermal_zone*; do t=$(cat $z/type 2>/dev/null); case \"$t\" in *x86_pkg*|*cpu*|*core*|*package*) cat $z/temp; break;; esac; done | head -n1 | awk '{print int($1/1000)}'"]
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
