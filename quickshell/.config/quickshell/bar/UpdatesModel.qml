pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Shared update counter: runs `checkupdates` exactly once across all bars.
// Without this, every bar's UpdatesWidget spawned its own Process and the
// concurrent pacman DB lock made one bar read 59 updates and another read 0.
Scope {
    id: root

    property string updatesCount: "0"

    Process {
        id: updatesProc
        command: ["sh", "-c", "checkupdates 2>/dev/null | wc -l"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let out = this.text.trim();
                root.updatesCount = out !== "" ? out : "0";
            }
        }
    }

    // Re-check every 30 minutes.
    Timer {
        interval: 1800000
        running: true
        repeat: true
        onTriggered: updatesProc.running = true
    }
}
