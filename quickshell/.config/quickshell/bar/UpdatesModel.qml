pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Shared update data: runs `checkupdates` exactly once across all bars.
// Without this, every bar's UpdatesWidget spawned its own Process and the
// concurrent pacman DB lock made one bar read 59 updates and another read 0.
// Stores both the count and the list of outdated packages for the popup.
Scope {
    id: root

    property string updatesCount: "0"
    // List of { name, version } outdated packages.
    property var updatesList: []

    Process {
        id: updatesProc
        command: ["sh", "-c", "checkupdates 2>/dev/null"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let text = this.text.trim();
                let lines = text === "" ? [] : text.split("\n");
                let list = [];
                for (let i = 0; i < lines.length; i++) {
                    let line = lines[i];
                    if (line === "") continue;
                    // Format: "pkgname oldver -> newver"
                    let m = line.match(/^(\S+)\s+.*->\s+(\S+)$/);
                    list.push(m ? { name: m[1], version: m[2] } : { name: line, version: "" });
                }
                root.updatesList = list;
                root.updatesCount = String(list.length);
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
