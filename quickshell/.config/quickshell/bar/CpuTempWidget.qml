import QtQuick
import Quickshell
import Quickshell.Io

// CPU temperature. The old thermometer icon (U+F0504) isn't in any installed
// Nerd font and rendered as a stray "°" before the number, so it's removed —
// the widget now just shows the value, e.g. "45°C".
Item {
    id: tempWidget
    width: tempLabel.implicitWidth
    height: 24

    property string tempStr: "--°C"

    Text {
        id: tempLabel
        anchors.verticalCenter: parent.verticalCenter
        text: tempStr
        color: "#f7768e" // Rosso Tokyo Night
        font.pixelSize: 13
        font.bold: true
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
