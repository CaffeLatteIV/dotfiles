import QtQuick
import Quickshell
import Quickshell.Io

// Battery: shows charge % and whether it is charging. Color follows the Tokyo
// Night palette by how much charge is left (green >= 75%, blue >= 50%,
// gold >= 25%, red below). Icon is a Nerd Font battery/charging glyph.
Row {
    id: batteryWidget
    spacing: 4

    property int capacity: -1          // -1 until first read
    property bool charging: false
    property string chargeStr: "--%"
    property string iconStr: "\uf007a" // 󰁺 placeholder until data arrives

    // Nerd Font battery glyphs, indexed by 10% bucket (0..9, 10 = full).
    readonly property var battIcons: [
        "\uf007a", // 󰁺 0%
        "\uf007b", // 󰁻 10%
        "\uf007c", // 󰁼 20%
        "\uf007d", // 󰁽 30%
        "\uf007e", // 󰁾 40%
        "\uf007f", // 󰁿 50%
        "\uf0080", // 󰂀 60%
        "\uf0081", // 󰂁 70%
        "\uf0082", // 󰂂 80%
        "\uf0083", // 󰂃 90%
        "\uf0084"  // 󰂄 100%
    ]

    // Nerd Font charging glyphs, indexed by 10% bucket (1..10).
    readonly property var chgIcons: [
        "\uf0085", // 󰂅 10%
        "\uf0086", // 󰂆 20%
        "\uf0087", // 󰂇 30%
        "\uf0088", // 󰂈 40%
        "\uf0089", // 󰂉 50%
        "\uf008a", // 󰂊 60%
        "\uf008b", // 󰂋 70%
        "\uf008c", // 󰂌 80%
        "\uf008d", // 󰂍 90%
        "\uf008e"  // 󰂎 100%
    ]

    // Color by remaining charge (Tokyo Night palette).
    readonly property color levelColor: {
        if (capacity < 0) return "#545c7e";               // inactive while unknown
        if (capacity >= 75) return "#9ece6a";             // green
        if (capacity >= 50) return "#7aa2f7";             // blue
        if (capacity >= 25) return "#e0af68";             // gold
        return "#f7768e";                                 // red (critical)
    }

    Text {
        text: batteryWidget.iconStr
        color: batteryWidget.levelColor
        font.pixelSize: 15
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        text: batteryWidget.chargeStr
        color: batteryWidget.levelColor
        font.pixelSize: 13
        font.bold: true
        anchors.verticalCenter: parent.verticalCenter
    }

    // Read capacity + status from the first BAT* power supply.
    Process {
        id: battProc
        command: [
            "sh", "-c",
            "b=$(ls /sys/class/power_supply/ | grep '^BAT' | head -n1); " +
            "[ -n \"$b\" ] && cat /sys/class/power_supply/$b/capacity; " +
            "echo; " +
            "b=$(ls /sys/class/power_supply/ | grep '^BAT' | head -n1); " +
            "[ -n \"$b\" ] && cat /sys/class/power_supply/$b/status"
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let out = this.text.trim().split(/\s+/);
                if (out.length >= 2) {
                    let cap = parseInt(out[0]);
                    if (!isNaN(cap)) {
                        batteryWidget.capacity = cap;
                        batteryWidget.charging = out[1] === "Charging";
                        batteryWidget.chargeStr = cap + "%";
                        let idx = Math.min(10, Math.max(0, Math.floor(cap / 10)));
                        if (batteryWidget.charging) {
                            let ci = Math.min(10, Math.max(1, Math.ceil(cap / 10)));
                            batteryWidget.iconStr = batteryWidget.chgIcons[ci - 1];
                        } else {
                            batteryWidget.iconStr = batteryWidget.battIcons[idx];
                        }
                    }
                }
            }
        }
    }

    Timer {
        interval: 10000 // battery changes slowly; refresh every 10 s
        running: true
        repeat: true
        onTriggered: battProc.running = true
    }
}
