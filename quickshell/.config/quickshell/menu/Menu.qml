import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: menuWindow

    // Layer shell Wayland: posizionato come overlay con cattura del focus
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    // Senza ancoraggi top/bottom/left/right, il compositor centra la finestra
    implicitWidth: 460
    implicitHeight: 560
    color: "transparent"
    visible: false

    property var allApps: []
    property var filteredApps: []

    // Funzione pubblica per aprire/chiudere il menu
    function toggle() {
        visible = !visible;
        if (visible) {
            searchField.text = "";
            searchField.forceActiveFocus();
            updateFilter();
        }
    }

    function launch(cmd) {
        launcher.command = ["bash", "-c", cmd + " &"];
        launcher.running = true;
        menuWindow.visible = false;
    }

    function updateFilter() {
        const query = searchField.text.trim().toLowerCase();
        if (query === "") {
            filteredApps = allApps;
        } else {
            filteredApps = allApps.filter(app => app.name.toLowerCase().includes(query));
        }
        appList.currentIndex = 0;
    }

    // Processo per lanciare i binari separati dalla shell
    Process {
        id: launcher
    }

    // Processo di scansione dei file .desktop all'avvio
    Process {
        id: appScanner
        command: [
            "python3", "-c",
            "import os, glob, json;\n" +
            "dirs = ['/usr/share/applications', os.path.expanduser('~/.local/share/applications')];\n" +
            "apps = []; seen = set();\n" +
            "for d in dirs:\n" +
            "    for p in glob.glob(os.path.join(d, '*.desktop')):\n" +
            "        try:\n" +
            "            with open(p, 'r', encoding='utf-8', errors='ignore') as f:\n" +
            "                name, exec_cmd, nodisp, is_entry = '', '', False, False\n" +
            "                for l in f:\n" +
            "                    l = l.strip()\n" +
            "                    if l == '[Desktop Entry]': is_entry = True\n" +
            "                    elif l.startswith('[') and is_entry: break\n" +
            "                    if is_entry:\n" +
            "                        if l.startswith('Name=') and not name: name = l.split('=', 1)[1]\n" +
            "                        elif l.startswith('Exec=') and not exec_cmd:\n" +
            "                            c = l.split('=', 1)[1]\n" +
            "                            for code in ['%f','%F','%u','%U','%d','%D','%n','%N','%i','%c','%k','%v','%m']:\n" +
            "                                c = c.replace(code, '')\n" +
            "                            exec_cmd = c.strip()\n" +
            "                        elif l.startswith('NoDisplay=true'): nodisp = True\n" +
            "                if is_entry and name and exec_cmd and not nodisp and name not in seen:\n" +
            "                    seen.add(name)\n" +
            "                    apps.append({'name': name, 'exec': exec_cmd})\n" +
            "        except: pass\n" +
            "apps.sort(key=lambda x: x['name'].lower());\n" +
            "print(json.dumps(apps))"
        ]
        running: true

        stdout: SplitParser {
            onRead: data => {
                if (!data || data.trim() === "") return;
                try {
                    allApps = JSON.parse(data);
                    updateFilter();
                } catch (e) {
                    console.error("Errore parsing lista applicazioni:", e);
                }
            }
        }
    }

    // Contenitore principale con stile Tokyo Night
    Rectangle {
        anchors.fill: parent
        color: "#1a1b26"
        radius: 12
        border.color: "#414868"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 12

            // Campo di ricerca
            TextField {
                id: searchField
                Layout.fillWidth: true
                placeholderText: "Cerca un'applicazione..."
                placeholderTextColor: "#565f89"
                color: "#c0caf5"
                font.pixelSize: 15
                padding: 10

                background: Rectangle {
                    color: "#24283b"
                    radius: 8
                    border.color: searchField.activeFocus ? "#7aa2f7" : "#414868"
                    border.width: 1
                }

                onTextChanged: updateFilter()

                // Navigazione da tastiera
                Keys.onDownPressed: {
                    if (appList.currentIndex < appList.count - 1) {
                        appList.currentIndex++;
                        appList.positionViewAtIndex(appList.currentIndex, ListView.Contain);
                    }
                }

                Keys.onUpPressed: {
                    if (appList.currentIndex > 0) {
                        appList.currentIndex--;
                        appList.positionViewAtIndex(appList.currentIndex, ListView.Contain);
                    }
                }

                Keys.onReturnPressed: {
                    if (filteredApps.length > 0 && appList.currentIndex >= 0) {
                        launch(filteredApps[appList.currentIndex].exec);
                    }
                }

                Keys.onEscapePressed: {
                    menuWindow.visible = false;
                }
            }

            // Lista dei programmi filtrati
            ListView {
                id: appList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 4
                model: filteredApps

                delegate: Rectangle {
                    id: itemBox
                    width: ListView.view.width
                    height: 42
                    radius: 6
                    color: ListView.isCurrentItem ? "#33384c" : (mouseArea.containsMouse ? "#24283b" : "transparent")

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Text {
                            text: modelData.name
                            color: ListView.isCurrentItem ? "#7aa2f7" : "#c0caf5"
                            font.pixelSize: 14
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: appList.currentIndex = index
                        onClicked: launch(modelData.exec)
                    }
                }
            }
        }
    }
}
