import QtQuick
import Quickshell
import Quickshell.Io

// Bluetooth status + bluetui launcher.
//
// Now reports connection state instead of just being a launcher icon:
//   - green icon  : controller on AND a device connected
//   - blue icon   : controller on, nothing connected
//   - dim icon    : controller off
// A small status dot mirrors the same state. Clicking opens bluetui in kitty.
Item {
    id: bt
    width: 24
    height: 24

    property bool powered: false
    property bool connected: false

    Text {
        anchors.centerIn: parent
        text: "󰂯" // Icona Bluetooth NerdFont
        color: bt.powered ? (bt.connected ? "#9ece6a" : "#7aa2f7") : "#545c7e"
        font.pixelSize: 16
    }

    // tiny status dot
    Rectangle {
        width: 5
        height: 5
        radius: 2.5
        anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
        color: bt.powered ? (bt.connected ? "#9ece6a" : "#7aa2f7") : "#414868"
    }

    // Controller powered state
    Process {
        id: btStatusProc
        command: ["sh", "-c", "bluetoothctl show 2>/dev/null | awk -F': ' '/Powered:/{print $2}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                bt.powered = this.text.trim() === "yes";
            }
        }
    }

    // Any connected device?
    Process {
        id: btConnProc
        command: ["sh", "-c", "bluetoothctl devices Connected 2>/dev/null | wc -l"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                bt.connected = parseInt(this.text.trim()) > 0;
            }
        }
    }

    // Launch bluetui in kitty
    Process {
        id: bluetuiProc
        command: ["kitty", "-e", "bluetui"]
    }

    MouseArea {
        id: btMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            bluetuiProc.running = true;
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            btStatusProc.running = true;
            btConnProc.running = true;
        }
    }
}
