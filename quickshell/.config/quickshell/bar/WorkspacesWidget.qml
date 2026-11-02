import QtQuick
import Quickshell
import Quickshell.Hyprland

// Real Hyprland workspace switcher.
//
// Replaces the old static 1..10 stub, which only logged to the console and never
// actually switched workspaces. Now it binds to Hyprland's live workspace model:
// the bar updates instantly on workspace create/destroy/focus, no polling.
Row {
    id: root
    spacing: 8

    // Screen this bar instance lives on, passed from Bar.qml (topBar.screen).
    property var currentScreen

    // The Hyprland monitor backing this screen (may be null until screens settle).
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(currentScreen)

    Repeater {
        model: Hyprland.workspaces

        delegate: Item {
            required property var modelData

            // Only render workspaces that belong to this screen's monitor.
            // Hyprland workspace ids can be non-contiguous (e.g. 1, 2, 5), so we
            // always treat the model as an ordered list, never as an id-indexed array.
            visible: root.monitor != null && modelData.monitor === root.monitor

            width: 20
            height: 24

            Text {
                anchors.centerIn: parent
                text: modelData.id
                // Active workspace highlighted, inactive dimmed
                color: modelData.active ? "#c0caf5" : "#545c7e"
                font.pixelSize: 14
                font.bold: true
            }

            MouseArea {
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
