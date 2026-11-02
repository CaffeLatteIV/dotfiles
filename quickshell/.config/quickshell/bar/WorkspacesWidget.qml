import QtQuick
import Quickshell
import Quickshell.Hyprland

// Real Hyprland workspace switcher.
//
// Shows, for this screen's monitor, only the workspaces that are occupied
// (have windows) plus the currently active/focused one, so you always see where
// you are. The active workspace gets a solid Tokyo Night blue pill; hovering any
// workspace gives a faded-background highlight.
Row {
    id: root
    spacing: 6

    // Screen this bar instance lives on, passed from Bar.qml (topBar.screen).
    property var currentScreen

    // The Hyprland monitor backing this screen (may be null until screens settle).
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(currentScreen)

    Repeater {
        model: Hyprland.workspaces

        delegate: Item {
            id: ws
            required property var modelData

            readonly property bool onMonitor: root.monitor != null && modelData.monitor === root.monitor
            // "Occupied" = has at least one toplevel window on it.
            readonly property bool occupied: modelData.toplevels != null && modelData.toplevels.count > 0
            readonly property bool isActive: modelData.active

            // Show occupied workspaces, plus the active one even when empty.
            visible: onMonitor && (occupied || isActive)

            width: 26
            height: 24

            Rectangle {
                id: pill
                anchors.fill: parent
                radius: 4
                // Active = solid accent pill; hover = faded bg; otherwise transparent.
                color: isActive ? "#7aa2f7" : (wsHover.containsMouse ? "#414868" : "transparent")
            }

            Text {
                anchors.centerIn: parent
                text: modelData.id
                // Active = dark text on the blue pill; hover = accent blue; else dim.
                color: isActive ? "#1a1b26" : (wsHover.containsMouse ? "#7aa2f7" : "#545c7e")
                font.pixelSize: 14
                font.bold: isActive
            }

            MouseArea {
                id: wsHover
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    modelData.activate();
                }
            }
        }
    }
}
