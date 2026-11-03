pragma Singleton
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

// Application menu (singleton, opened by the bar launcher).
//
// Keyboard-only navigation:
//   Tab        cycle the 3 tabs (Apps -> Run -> Files)
//   Up/Down    move selection in the active list (Apps/Files)
//   Enter      launch / run / open the selection
//   Escape     close the menu
// Tabs: 0=Apps (installed apps), 1=Run (type a command), 2=Files (browse $HOME).
PanelWindow {
    id: menuWindow

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    implicitWidth: 520
    implicitHeight: 600
    color: "transparent"
    visible: false
    focusable: true

    property int currentTab: 0 // 0=Apps, 1=Run, 2=Files
    property var allApps: []
    property var filteredApps: []
    property var allFiles: []
    property var filteredFiles: []

    function toggle() {
        visible = !visible;
        if (visible) {
            menuFocus.focus = true;
            updateFilter();
            focusActiveInput();
        }
    }

    function closeMenu() { visible = false; }

    function focusActiveInput() {
        if (currentTab === 0) appsSearch.forceActiveFocus();
        else if (currentTab === 1) runInput.forceActiveFocus();
        else if (currentTab === 2) filesSearch.forceActiveFocus();
    }

    function cycleTab() {
        currentTab = (currentTab + 1) % 3;
        if (currentTab === 2) refreshFiles();
        updateFilter();
        focusActiveInput();
    }

    function launch(cmd) {
        launcher.command = ["bash", "-c", cmd + " &"];
        launcher.running = true;
        closeMenu();
    }

    function updateFilter() {
        const q = appsSearch.text.trim().toLowerCase();
        filteredApps = q === "" ? allApps : allApps.filter(a => a.name.toLowerCase().includes(q));
        appList.currentIndex = 0;

        const fq = filesSearch.text.trim().toLowerCase();
        filteredFiles = fq === "" ? allFiles : allFiles.filter(f => f.toLowerCase().includes(fq));
        fileList.currentIndex = 0;
    }

    function refreshFiles() {
        fileScanner.running = true;
    }

    // Componente bottone tab
    component TabBtn: Rectangle {
        property string label
        property bool active
        signal clicked
        width: 80
        height: 30
        radius: 6
        color: active ? "#7aa2f7" : "#24283b"
        Text {
            anchors.centerIn: parent
            text: label
            color: active ? "#1a1b26" : "#c0caf5"
            font.pixelSize: 13
            font.bold: true
        }
        MouseArea {
            anchors.fill: parent
            onClicked: parent.clicked()
        }
    }

    // Processo per lanciare i binari separati dalla shell
    Process { id: launcher }

    // Scansione delle app .desktop
    Process {
        id: appScanner
        command: ["python3", "-c",
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
            "print(json.dumps(apps))"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                if (!data || data.trim() === "") return;
                try {
                    allApps = JSON.parse(data);
                    updateFilter();
                } catch (e) {}
            }
        }
    }

    // Elenco dei file in $HOME per la tab Files
    Process {
        id: fileScanner
        command: ["sh", "-c", "ls -1A ~ 2>/dev/null"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                let out = this.text.trim();
                allFiles = out === "" ? [] : out.split("\n");
                updateFilter();
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#1a1b26"
        radius: 12
        border.color: "#414868"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 10

            // Barra delle tab
            Row {
                Layout.fillWidth: true
                spacing: 6

                TabBtn { label: "Apps";  active: menuWindow.currentTab === 0; onClicked: { menuWindow.currentTab = 0; menuWindow.focusActiveInput(); } }
                TabBtn { label: "Run";   active: menuWindow.currentTab === 1; onClicked: { menuWindow.currentTab = 1; menuWindow.focusActiveInput(); } }
                TabBtn { label: "Files"; active: menuWindow.currentTab === 2; onClicked: { menuWindow.currentTab = 2; menuWindow.refreshFiles(); menuWindow.focusActiveInput(); } }
            }

            // Contenuto per tab
            StackLayout {
                id: tabStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: menuWindow.currentTab

                // --- Tab Apps ---
                Item {
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 8

                        TextField {
                            id: appsSearch
                            Layout.fillWidth: true
                            placeholderText: "Cerca un'applicazione..."
                            placeholderTextColor: "#565f89"
                            color: "#c0caf5"
                            font.pixelSize: 14
                            padding: 10
                            activeFocusOnTab: false
                            background: Rectangle { color: "#24283b"; radius: 8; border.color: appsSearch.activeFocus ? "#7aa2f7" : "#414868"; border.width: 1 }
                            onTextChanged: menuWindow.updateFilter()
                            Keys.onDownPressed: { appList.currentIndex = Math.min(appList.currentIndex + 1, appList.count - 1); appList.positionViewAtIndex(appList.currentIndex, ListView.Contain); }
                            Keys.onUpPressed: { appList.currentIndex = Math.max(appList.currentIndex - 1, 0); appList.positionViewAtIndex(appList.currentIndex, ListView.Contain); }
                            Keys.onReturnPressed: { if (menuWindow.filteredApps.length > 0) menuWindow.launch(menuWindow.filteredApps[appList.currentIndex].exec); }
                        }

                        ListView {
                            id: appList
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 4
                            model: menuWindow.filteredApps
                            delegate: Rectangle {
                                width: appList.width
                                height: 42
                                radius: 6
                                color: appList.currentIndex === index ? "#33384c" : (mouseArea.containsMouse ? "#24283b" : "transparent")
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 10
                                    Text { text: modelData.name; color: appList.currentIndex === index ? "#7aa2f7" : "#c0caf5"; font.pixelSize: 14; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: appList.currentIndex = index
                                    onClicked: menuWindow.launch(modelData.exec)
                                }
                            }
                        }
                    }
                }

                // --- Tab Run ---
                Item {
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 10

                        TextField {
                            id: runInput
                            Layout.fillWidth: true
                            placeholderText: "Scrivi un comando e premi Invio..."
                            placeholderTextColor: "#565f89"
                            color: "#c0caf5"
                            font.pixelSize: 14
                            padding: 10
                            activeFocusOnTab: false
                            background: Rectangle { color: "#24283b"; radius: 8; border.color: runInput.activeFocus ? "#7aa2f7" : "#414868"; border.width: 1 }
                            onAccepted: menuWindow.launch(runInput.text)
                        }

                        Text {
                            text: "Premi Invio per eseguire il comando. Esc per chiudere."
                            color: "#565f89"
                            font.pixelSize: 12
                        }
                    }
                }

                // --- Tab Files ---
                Item {
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 8

                        TextField {
                            id: filesSearch
                            Layout.fillWidth: true
                            placeholderText: "Filtra i file..."
                            placeholderTextColor: "#565f89"
                            color: "#c0caf5"
                            font.pixelSize: 14
                            padding: 10
                            activeFocusOnTab: false
                            background: Rectangle { color: "#24283b"; radius: 8; border.color: filesSearch.activeFocus ? "#7aa2f7" : "#414868"; border.width: 1 }
                            onTextChanged: menuWindow.updateFilter()
                            Keys.onDownPressed: { fileList.currentIndex = Math.min(fileList.currentIndex + 1, fileList.count - 1); fileList.positionViewAtIndex(fileList.currentIndex, ListView.Contain); }
                            Keys.onUpPressed: { fileList.currentIndex = Math.max(fileList.currentIndex - 1, 0); fileList.positionViewAtIndex(fileList.currentIndex, ListView.Contain); }
                            Keys.onReturnPressed: { if (menuWindow.filteredFiles.length > 0) menuWindow.launch("xdg-open \"" + menuWindow.filteredFiles[fileList.currentIndex] + "\""); }
                        }

                        ListView {
                            id: fileList
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 4
                            model: menuWindow.filteredFiles
                            delegate: Rectangle {
                                width: fileList.width
                                height: 34
                                radius: 6
                                color: fileList.currentIndex === index ? "#33384c" : (mouseArea.containsMouse ? "#24283b" : "transparent")
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    Text { text: modelData; color: fileList.currentIndex === index ? "#7aa2f7" : "#c0caf5"; font.pixelSize: 13; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: fileList.currentIndex = index
                                    onClicked: menuWindow.launch("xdg-open \"" + modelData + "\"")
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Cattura la tastiera e gestisce Tab / Esc a livello del menu
    FocusScope {
        id: menuFocus
        anchors.fill: parent
        focus: menuWindow.visible
        Keys.onTabPressed: menuWindow.cycleTab()
        Keys.onEscapePressed: menuWindow.closeMenu()
    }
}
