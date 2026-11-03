import QtQuick
import Quickshell
import Quickshell.Io

// Bluetooth status + bluetui launcher.
//
// Shows the connected device name next to the icon, plus connection state:
//   - green icon + device name : controller on AND a device connected
//   - blue icon                : controller on, nothing connected
//   - dim icon                 : controller off
// A small status dot mirrors the same state. Clicking opens bluetui in kitty.
Item {
    id: bt
    width: btRow.width
    height: 24

    property bool powered: false
    property bool connected: false
    property string deviceName: ""

    Row {
        id: btRow
        spacing: 4
        anchors.verticalCenter: parent.verticalCenter

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "󰂯" // Icona Bluetooth NerdFont
            color: bt.powered ? (bt.connected ? "#9ece6a" : "#7aa2f7") : "#545c7e"
            font.pixelSize: 16
        }

        // Connected device name (only when connected)
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: bt.deviceName
            color: "#9ece6a"
            font.pixelSize: 12
            font.bold: true
            visible: bt.connected && bt.deviceName !== ""
        }
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

    // Connected device(s): extract the first connected device name.
    Process {
        id: btConnProc
        command: ["sh", "-c", "bluetoothctl devices Connected 2>/dev/null | awk '{for(i=3;i<=NF;i++) printf \"%s \", $i; print \"\"}' | head -1"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let name = this.text.trim();
                bt.deviceName = name;
                bt.connected = name !== "";
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
