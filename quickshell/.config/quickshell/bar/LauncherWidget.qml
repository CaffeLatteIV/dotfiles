import QtQuick
import Quickshell
import Quickshell.Io
import "../menu"

// Launcher toggle: opens the in-bar application menu (menu/Menu.qml).
// The menu is a pragma Singleton with 3 tabs (Apps/Run/Files) and full
// keyboard navigation (Tab to cycle tabs, arrows + Enter, Esc to close).
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

    MouseArea {
        id: launcherMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            Menu.toggle();
        }
    }
}
