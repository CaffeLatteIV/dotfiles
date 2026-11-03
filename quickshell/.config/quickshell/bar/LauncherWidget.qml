import QtQuick
import Quickshell
import Quickshell.Io

// Launcher toggle.
//
// Formerly "NotificationWidget": the icon actually opened a launcher, and it
// referenced ~/.config/rofi/toggle_launcher.sh, which does not exist, so every
// click was a silent no-op. Now it points at the real rofi drun script.
//
// NOTE: if you prefer to use the in-bar app menu instead, this widget is
// redundant with menu/Menu.qml — you can drop it from Bar.qml entirely.
Item {
    width: 24
    height: 24

    Text {
        anchors.centerIn: parent
        text: "󰀄" // launcher / apps glyph
        // Accent on hover, otherwise default text color
        color: launcherMouseArea.containsMouse ? "#7aa2f7" : "#c0caf5"
        font.pixelSize: 18
    }

    Process {
        id: launcherProc
        command: ["sh", "-c", "~/.config/rofi/launchers/type-1/launcher.sh"]
    }

    MouseArea {
        id: launcherMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            launcherProc.running = true;
        }
    }
}
