import Quickshell
import QtQuick

PanelWindow {
    id: topBar

    // Injected by the parent Variants: the Screen this bar belongs to.
    required property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 30
    // Reserve the bar's height so maximized windows don't slide underneath it.
    exclusiveZone: implicitHeight
    color: "#1a1b26"

    // --- LATO SINISTRO ---
    Row {
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 10
        }
        spacing: 10

        LauncherWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
        WorkspacesWidget {
            currentScreen: topBar.screen
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // --- CENTRO ---
    Row {
        anchors.centerIn: parent
        spacing: 20

        UpdatesWidget {
            currentScreen: topBar.screen
            anchors.verticalCenter: parent.verticalCenter
        }
        WeatherWidget {
            currentScreen: topBar.screen // Riferimento alla proprietà screen del PanelWindow
            anchors.verticalCenter: parent.verticalCenter
        }
        ClockWidget {
            currentScreen: topBar.screen
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // --- LATO DESTRO ---
    Row {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 15
        }
        spacing: 10

        CpuTempWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
        CpuUsageWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
        RamWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
        VramWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
        // Battery charge % + charging state (green/blue/gold/red by level).
        BatteryWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
        NetworkWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
        BluetoothWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
        AudioWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
        PowerWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
