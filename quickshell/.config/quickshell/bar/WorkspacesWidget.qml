import QtQuick
import Quickshell
import Quickshell.Hyprland

// Real Hyprland workspace switcher.
//
// Always shows the full available set of workspaces (1-9) on every monitor's
// bar, so empty workspaces stay visible. A workspace is highlighted only when
// it actually lives on THIS screen's monitor:
//   - the currently active workspace gets a solid Tokyo Night blue pill,
//   - any occupied workspace (has windows) gets a soft purple highlight,
//   - everything else (empty, or sitting on the other monitor) renders dim.
// Clicking a workspace switches to it (creating it if it doesn't exist yet).
Row {
    id: root
    spacing: 6

    // Screen this bar instance lives on, passed from Bar.qml (topBar.screen).
    property var currentScreen

    // The Hyprland monitor backing this screen (may be null until screens settle).
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(currentScreen)

    // Look up the live Hyprland workspace for an id. Workspaces are created
    // lazily by Hyprland, so ids 3-9 may not exist in the model yet.
    function findWorkspace(id) {
        var values = Hyprland.workspaces.values;
        for (var i = 0; i < values.length; i++) {
            if (values[i].id === id) return values[i];
        }
        return null;
    }

    Repeater {
        // The full available range, 1..9. Rendered on every monitor's bar.
        model: 9

        delegate: Item {
            id: ws
            required property int index
            readonly property int wsId: index + 1

            readonly property var workspace: root.findWorkspace(wsId)
            readonly property bool onMonitor: root.monitor != null && workspace != null && workspace.monitor === root.monitor
            // "Occupied" = has at least one toplevel window on it (on this monitor).
            readonly property bool occupied: onMonitor && workspace.toplevels != null && workspace.toplevels.values.length > 0
            // Active only when it's this monitor's current workspace.
            readonly property bool isActive: onMonitor && workspace.active

            width: 26
            height: 24

            Rectangle {
                id: pill
                anchors.fill: parent
                radius: 4
                // Active = solid accent blue; occupied = soft purple wash
                // (less prominent); hover = faded bg; otherwise transparent.
                color: isActive ? "#7aa2f7"
                     : occupied ? "#50c6a0f6"
                     : (wsHover.containsMouse ? "#414868" : "transparent")
            }

            Text {
                anchors.centerIn: parent
                text: wsId
                // Active = dark text on blue; occupied = purple text on the
                // soft wash; hover = accent blue; else dim.
                color: isActive ? "#1a1b26"
                     : occupied ? "#c6a0f6"
                     : (wsHover.containsMouse ? "#7aa2f7" : "#545c7e")
                font.pixelSize: 14
                font.bold: isActive
            }

            MouseArea {
                id: wsHover
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    if (workspace != null) {
                        workspace.activate();
                    } else {
                        // Workspace not created yet: dispatch creates + switches to it.
                        Hyprland.dispatch("workspace " + wsId);
                    }
                }
            }
        }
    }
}
