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

        implicitWidth: popupLayout.implicitWidth
        implicitHeight: popupLayout.implicitHeight

        anchors {
            top: true
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

                Item {
                    width: 1
                    height: 45
                }

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
    Process {
        id: weatherProc
        command: ["curl", "-s", "https://wttr.in/Bologna,Italy?format=j1"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let data = JSON.parse(this.text);
                    let current = data.current_condition[0];

                    const WEATHER_CODES = {
                        '113': '☀️', '116': '⛅️', '119': '☁️', '122': '☁️', '143': '🌫', '176': '🌦',
                        '179': '🌧', '182': '🌧', '185': '🌧', '200': '⛈', '227': '🌨', '230': '❄️',
                        '248': '🌫', '260': '🌫', '263': '🌦', '266': '🌦', '281': '🌧', '284': '🌧',
                        '293': '🌦', '296': '🌦', '299': '🌧', '302': '🌧', '305': '🌧', '308': '🌧',
                        '311': '🌧', '314': '🌧', '317': '🌧', '320': '🌨', '323': '🌨', '326': '🌨',
                        '329': '❄️', '332': '❄️', '335': '❄️', '338': '❄️', '350': '🌧', '353': '🌦',
                        '356': '🌧', '359': '🌧', '362': '🌧', '365': '🌧', '368': '🌨', '371': '❄️',
                        '374': '🌧', '377': '🌧', '386': '⛈', '389': '🌩', '392': '⛈', '395': '❄️'
                    };

                    let currentCode = current.weatherCode;
                    let emoji = WEATHER_CODES[currentCode] || '❓';

                    weatherWidget.mainText = emoji + " " + current.FeelsLikeC + "°";

                    let tt = "<b>" + current.weatherDesc[0].value + " " + current.temp_C + "°</b><br>";
                    tt += "Feels like: " + current.FeelsLikeC + "°<br>";
                    tt += "Wind: " + current.windspeedKmph + "Km/h<br>";
                    tt += "Humidity: " + current.humidity + "%<br>";

                    let currentHour = new Date().getHours();

                    for (let i = 0; i < data.weather.length; i++) {
                        let day = data.weather[i];
                        tt += "<br><b>";
                        if (i === 0) tt += "Oggi, ";
                        if (i === 1) tt += "Domani, ";
                        tt += day.date + "</b><br>";
                        tt += "⬆️ " + day.maxtempC + "° ⬇️ " + day.mintempC + "° ";
                        tt += "🌅 " + day.astronomy[0].sunrise + " 🌇 " + day.astronomy[0].sunset + "<br>";

                        for (let j = 0; j < day.hourly.length; j++) {
                            let hour = day.hourly[j];
                            let timeStr = hour.time.replace("00", "").padStart(2, '0');

                            if (i === 0 && parseInt(timeStr) < currentHour - 2) {
                                continue;
                            }

                            let hourEmoji = WEATHER_CODES[hour.weatherCode] || '❓';
                            let hourTemp = (hour.FeelsLikeC + "°").padEnd(4, '\u00A0');

                            let chances = {
                                "chanceoffog": "Fog", "chanceoffrost": "Frost",
                                "chanceofovercast": "Overcast", "chanceofrain": "Rain",
                                "chanceofsnow": "Snow", "chanceofsunshine": "Sunshine",
                                "chanceofthunder": "Thunder", "chanceofwindy": "Wind"
                            };

                            let conditions = [];
                            for (let key in chances) {
                                if (parseInt(hour[key]) > 0) {
                                    conditions.push(chances[key] + " " + hour[key] + "%");
                                }
                            }
                            let chancesStr = conditions.length > 0 ? ", " + conditions.join(", ") : "";

                            tt += timeStr + ":00 " + hourEmoji + " " + hourTemp + " " + hour.weatherDesc[0].value + chancesStr + "<br>";
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
