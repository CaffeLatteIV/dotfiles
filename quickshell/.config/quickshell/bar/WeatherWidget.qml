import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Item {
    id: weatherWidget
    width: weatherText.implicitWidth
    height: 30

    property string mainText: "☀️ --°"
    property string popupContent: "Recupero meteo in corso..."

    // Riceve lo schermo corrente da shell.qml
    property var currentScreen

    // Il testo sulla barra
    Text {
        id: weatherText
        anchors.verticalCenter: parent.verticalCenter
        text: weatherWidget.mainText
        color: "#c0caf5"
        font.pixelSize: 14
        font.bold: true
    }

    // Gestione del click
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            weatherPopup.visible = !weatherPopup.visible;
            if (weatherPopup.visible) {
                focusScope.focus = true;
            }
        }
    }    // --- IL POP-UP: Una nuova finestra Wayland autonoma ---
    PanelWindow {
        id: weatherPopup
        screen: weatherWidget.currentScreen
        visible: false
        color: "transparent"

        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        // Without focusable:true the FocusScope never gets keyboard focus,
        // so ESC wouldn't close the popup.
        focusable: true

        implicitWidth: popupLayout.implicitWidth
        implicitHeight: popupLayout.implicitHeight

        anchors {
            top: true
        }

        // Drop the window below the status bar (30px bar + 6px gap) instead of
        // relying on the old fixed 45px spacer inside the layout.
        margins {
            top: 36
        }

        // Usiamo un FocusScope per catturare la tastiera all'interno del pop-up
        FocusScope {
            id: focusScope
            anchors.fill: parent
            focus: weatherPopup.visible

            // Chiude il popup se premi ESC
            Keys.onEscapePressed: {
                weatherPopup.visible = false;
            }

            // Layout a colonna per impilare gli elementi verticalmente
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
                            text: weatherWidget.popupContent
                            color: "#c0caf5"
                            font.pixelSize: 13
                            textFormat: Text.RichText
                        }
                    }
                }
            }
        }
    }    // ------------------------------------
    // wttr.in is repeatedly down (connection refused), so we use Open-Meteo:
    // free, no key, reliable JSON.
    Process {
        id: weatherProc
        command: ["sh", "-c", "curl -s --max-time 15 'https://api.open-meteo.com/v1/forecast?latitude=44.49&longitude=11.34&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset&timezone=Europe%2FRome&forecast_days=3&hourly=temperature_2m,apparent_temperature,weather_code,precipitation_probability&timeformat=unixtime'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let data = JSON.parse(this.text);
                    let cur = data.current;

                    // WMO weather code -> emoji (Open-Meteo uses WMO codes)
                    function wmo(code) {
                        if (code === 0) return '☀️';
                        if (code === 1) return '🌤';
                        if (code === 2) return '⛅️';
                        if (code === 3) return '☁️';
                        if (code === 4 || code === 45 || code === 48) return '🌫';
                        if (code >= 51 && code <= 57) return '🌦';
                        if (code >= 58 && code <= 67) return '🌧';
                        if (code >= 71 && code <= 77) return '🌨';
                        if (code >= 80 && code <= 82) return '🌦';
                        if (code >= 85 && code <= 86) return '🌨';
                        if (code >= 95) return '⛈';
                        return '❓';
                    }

                    function hhmm(ts) {
                        let d = new Date(ts * 1000);
                        return d.getHours().toString().padStart(2, '0') + ":" + d.getMinutes().toString().padStart(2, '0');
                    }

                    function dayLabel(ts) {
                        let d = new Date(ts * 1000);
                        return d.getDate().toString().padStart(2, '0') + "/" + (d.getMonth() + 1).toString().padStart(2, '0');
                    }

                    weatherWidget.mainText = wmo(cur.weather_code) + " " + cur.apparent_temperature + "°";

                    let tt = "<b>" + cur.temperature_2m + "° (percepita " + cur.apparent_temperature + "°)</b><br>";
                    tt += "Vento: " + cur.wind_speed_10m + " km/h<br>";
                    tt += "Umidità: " + cur.relative_humidity_2m + "%<br>";

                    let now = Date.now() / 1000;
                    let hourly = data.hourly;

                    // Group hourly entries by day key (YYYY-MM-DD)
                    let byDay = {};
                    for (let i = 0; i < hourly.time.length; i++) {
                        let ts = hourly.time[i];
                        let d = new Date(ts * 1000);
                        let key = d.getFullYear() + "-" + d.getMonth() + "-" + d.getDate();
                        if (!byDay[key]) byDay[key] = [];
                        byDay[key].push({
                            ts: ts,
                            temp: hourly.apparent_temperature[i],
                            code: hourly.weather_code[i],
                            precip: hourly.precipitation_probability[i]
                        });
                    }

                    let daily = data.daily;
                    for (let i = 0; i < daily.time.length; i++) {
                        let d = new Date(daily.time[i] * 1000);
                        let key = d.getFullYear() + "-" + d.getMonth() + "-" + d.getDate();
                        tt += "<br><b>";
                        if (i === 0) tt += "Oggi, ";
                        if (i === 1) tt += "Domani, ";
                        tt += dayLabel(daily.time[i]) + "</b><br>";
                        tt += "⬆️ " + daily.temperature_2m_max[i] + "° ⬇️ " + daily.temperature_2m_min[i] + "° ";
                        tt += "🌅 " + hhmm(daily.sunrise[i]) + " 🌇 " + hhmm(daily.sunset[i]) + "<br>";

                        let rows = byDay[key] || [];
                        rows.sort((a, b) => a.ts - b.ts);
                        for (let j = 0; j < rows.length; j++) {
                            let r = rows[j];
                            // Skip hours already past (today only)
                            if (i === 0 && r.ts < now - 7200) continue;
                            let h = new Date(r.ts * 1000);
                            let hh = h.getHours().toString().padStart(2, '0') + ":00";
                            let tempStr = (r.temp + "°").padEnd(4, '\u00A0');
                            let precip = r.precip > 0 ? ", 💧 " + r.precip + "%" : "";
                            tt += hh + " " + wmo(r.code) + " " + tempStr + precip + "<br>";
                        }
                    }

                    weatherWidget.popupContent = tt;

                } catch (e) {
                    weatherWidget.mainText = "❌ Err";
                    weatherWidget.popupContent = "Errore nel parsing: " + e;
                }
            }
        }
    }

    Timer {
        interval: 1800000
        running: true
        repeat: true
        onTriggered: weatherProc.running = true
    }
}
