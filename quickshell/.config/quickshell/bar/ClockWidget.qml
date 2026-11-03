import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// Date/time widget. Click it to open a dropdown showing the current time in
// the three major timezones: local (Europe/Rome), UTC, New York.
Item {
    id: clockWidget
    width: clockLabel.implicitWidth
    height: 30

    property string timeText: "Caricamento..."
    property string popupContent: ""
    // Riceve lo schermo corrente da Bar.qml, così il popup appare sul monitor giusto.
    property var currentScreen

    Text {
        id: clockLabel
        anchors.verticalCenter: parent.verticalCenter
        text: clockWidget.timeText
        color: "#c0caf5"
        font.pixelSize: 14
        font.bold: true
    }

    // Gestione del click: apre/chiude il popup con i tre fusi orari
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            timePopup.visible = !timePopup.visible;
            if (timePopup.visible) {
                focusScope.focus = true;
                zonesProc.running = true; // aggiorna i tempi all'apertura
            }
        }
    }

    // --- IL POP-UP: finestra Wayland autonoma ---
    PanelWindow {
        id: timePopup
        screen: clockWidget.currentScreen
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
            focus: timePopup.visible

            Keys.onEscapePressed: {
                timePopup.visible = false;
            }

            Column {
                id: popupLayout

                Rectangle {
                    id: popupRect

                    width: popupText.implicitWidth + 30
                    height: Math.min(popupText.implicitHeight + 30, 600)

                    color: "#1a1b26"
                    radius: 8
                    border.color: "#7aa2f7"
                    border.width: 1

                    ScrollView {
                        anchors.fill: parent
                        anchors.margins: 15
                        clip: true

                        Text {
                            id: popupText
                            text: clockWidget.popupContent
                            color: "#c0caf5"
                            font.pixelSize: 13
                            textFormat: Text.RichText
                        }
                    }
                }
            }
        }
    }

    // --- OROLOGIO (data e ora locale) sulla barra ---
    Process {
        id: dateProc
        command: ["date", "+%a %d %b - %H:%M"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: clockWidget.timeText = this.text.trim()
        }
    }

    // --- TEMPI NEI TRE FUSI ORARI per il popup ---
    Process {
        id: zonesProc
        command: ["sh", "-c",
            "printf 'Roma (locale)\\t%s\\nUTC\\t%s\\nNew York\\t%s\\n' \"$(TZ=Europe/Rome date +%H:%M)\" \"$(TZ=UTC date +%H:%M)\" \"$(TZ=America/New_York date +%H:%M)\""]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let out = this.text.trim();
                if (out === "") {
                    clockWidget.popupContent = "<b>Errore nel recupero dei fusi orari</b>";
                    return;
                }
                let rows = out.split("\n");
                let html = "";
                for (let i = 0; i < rows.length && i < 3; i++) {
                    let parts = rows[i].split("\t");
                    if (parts.length < 2) continue;
                    let label = parts[0];
                    let time = parts[1];
                    html += "<b>" + label + "</b>&nbsp;&nbsp;<span style='color:#7aa2f7'>" + time + "</span><br>";
                }
                clockWidget.popupContent = html;
            }
        }
    }

    // Aggiorna data/ora e i fusi orari ogni minuto
    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: {
            dateProc.running = true;
            zonesProc.running = true;
        }
    }
}
