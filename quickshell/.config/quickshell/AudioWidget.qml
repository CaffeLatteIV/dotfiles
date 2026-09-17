import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: audioWidget

    // Calcoliamo dinamicamente la larghezza in base ai contenuti per far funzionare bene la MouseArea
    width: layout.width
    height: 30

    property string volumeStr: "--%"
    property bool isMuted: false

    Row {
        id: layout
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter

        Text {
            // Cambia icona se è muto
            text: audioWidget.isMuted ? "󰖁" : "󰕾"
            // Rosso se muto, Accento azzurro altrimenti
            color: audioWidget.isMuted ? "#f7768e" : "#9ece6a"
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: audioWidget.isMuted ? "Muted" : audioWidget.volumeStr
            color: audioWidget.isMuted ? "#f7768e" : "#9ece6a"
            font.pixelSize: 13
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Processo in lettura: ottiene il volume e lo stato muto
    Process {
        id: volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let out = this.text.trim();
                // wpctl restituisce ad es: "Volume: 0.55" oppure "Volume: 0.55 [MUTED]"

                audioWidget.isMuted = out.includes("[MUTED]");

                // Estrae il numero usando una semplice Regex e lo converte in percentuale
                let match = out.match(/Volume:\s+([0-9.]+)/);
                if (match && match[1]) {
                    let vol = parseFloat(match[1]) * 100;
                    audioWidget.volumeStr = Math.round(vol) + "%";
                }
            }
        }
    }

    // Processo in scrittura: inverte lo stato del muto
    Process {
        id: toggleProc
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        // Appena il comando finisce, forziamo la rilettura del volume per aggiornare la UI all'istante
        onExited: volProc.running = true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            toggleProc.running = true;
        }
    }

    // Timer per controllare se hai cambiato volume da tastiera o da altre app
    Timer {
        interval: 2000 // Aggiorna ogni 2 secondi
        running: true
        repeat: true
        onTriggered: volProc.running = true
    }
}
