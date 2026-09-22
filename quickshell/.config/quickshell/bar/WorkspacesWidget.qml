import QtQuick

Row {
    spacing: 8 // Spazio tra i numeri

    Repeater {
        model: 10

        delegate: Item {
            // Diamo una dimensione fissa all'elemento invisibile
            // così è facile da cliccare anche se il numero è stretto (es. "1")
            width: 20
            height: 24

            Text {
                anchors.centerIn: parent
                text: index === 9 ? "0" : (index + 1).toString()

                // Effetto hover: il testo diventa bianco se il mouse è sopra,
                // altrimenti rimane grigio chiaro
                color: mouseArea.containsMouse ? "#c0caf5" : "#545c7e"
                font.pixelSize: 14
                font.bold: true
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    let targetDesktop = index === 9 ? 10 : (index + 1)
                    console.log("Cliccato per andare al desktop:", targetDesktop)
                }
            }
        }
    }
}
