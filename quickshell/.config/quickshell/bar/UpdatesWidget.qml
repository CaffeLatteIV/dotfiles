import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// Updates widget. Click it to open a dropdown listing the outdated packages.
Item {
    id: updatesWidget
    width: layout.width
    height: 30

    // Read the shared data (computed once by the UpdatesModel singleton)
    // so every bar shows the same count and list.
    property string updatesCount: UpdatesModel.updatesCount
    property var updatesList: UpdatesModel.updatesList
    property string popupContent: ""
    // Riceve lo schermo corrente da Bar.qml, così il popup appare sul monitor giusto.
    property var currentScreen

    Row {
        id: layout
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter

        Text {
            text: "󰏗"
            // Giallo/Arancio Tokyo Night se > 0, altrimenti Grigio inattivo
            color: parseInt(updatesWidget.updatesCount) > 0 ? "#e0af68" : "#545c7e"
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: updatesWidget.updatesCount
            color: "#c0caf5"
            font.pixelSize: 13
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Gestione del click: apre/chiude il popup con la lista dei pacchetti
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            updatePopup.visible = !updatePopup.visible;
            if (updatePopup.visible) {
                focusScope.focus = true;
            }
        }
    }

    // --- IL POP-UP: finestra Wayland autonoma ---
    PanelWindow {
        id: updatePopup
        screen: updatesWidget.currentScreen
        visible: false
        color: "transparent"

        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        // focusable:true è necessario perché il FocusScope riceva la tastiera (ESC per chiudere)
        focusable: true

        implicitWidth: popupLayout.implicitWidth
        implicitHeight: popupLayout.implicitHeight

        anchors {
            top: true
        }

        // Finestra sotto la barra (barra 30px + 6px di spazio)
        margins {
            top: 36
        }

        FocusScope {
            id: focusScope
            anchors.fill: parent
            focus: updatePopup.visible

            Keys.onEscapePressed: {
                updatePopup.visible = false;
            }

            Column {
                id: popupLayout

                Rectangle {
                    id: popupRect

                    width: Math.min(popupText.implicitWidth + 30, 700)
                    height: Math.min(popupText.implicitHeight + 30, 600)

                    color: "#1a1b26"
                    radius: 8
                    border.color: "#e0af68"
                    border.width: 1

                    ScrollView {
                        anchors.fill: parent
                        anchors.margins: 15
                        clip: true

                        Text {
                            id: popupText
                            text: updatesWidget.popupContent
                            color: "#c0caf5"
                            font.pixelSize: 13
                            textFormat: Text.RichText
                        }
                    }
                }
            }
        }
    }

    // Costruisce il contenuto del popup quando cambia la lista dei pacchetti
    onUpdatesListChanged: {
        let list = updatesWidget.updatesList;
        if (list.length === 0) {
            updatesWidget.popupContent = "<b>Nessun aggiornamento disponibile</b>";
            return;
        }
        let html = "<b>Aggiornamenti disponibili (" + list.length + "):</b><br><br>";
        for (let i = 0; i < list.length; i++) {
            let p = list[i];
            html += p.name + (p.version !== "" ? " &rarr; " + p.version : "") + "<br>";
        }
        updatesWidget.popupContent = html;
    }
}
