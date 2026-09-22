import Quickshell
import QtQuick

PanelWindow {
    id: topBar

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 30
    color: "#1a1b26"

    // --- LATO SINISTRO ---
    Row {
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 10
        }
        spacing: 10

        NotificationWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
        WorkspacesWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // --- CENTRO ---
    Row {
        anchors.centerIn: parent
        spacing: 20

        UpdatesWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
        WeatherWidget {
            currentScreen: topBar.screen // Riferimento alla proprietà screen del PanelWindow
            anchors.verticalCenter: parent.verticalCenter
        }
        ClockWidget {
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
