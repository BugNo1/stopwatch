import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Window {
    id: mainWindow
    width: 1280
    height: 800
    visible: true
    title: qsTr("Stoppuhr")

    property double startTime: 0
    property double currentTime: 0
    property bool isClockRunning: false

    ColumnLayout {
        anchors.fill: parent

        Text {
            id: time
            font.pixelSize: 150
            font.family: "Courier"
            text: "0000:00,00"
            Layout.alignment: Qt.AlignCenter
        }

        RowLayout {
            Layout.alignment: Qt.AlignCenter

            Button {
                id: startButton
                text: "Start"
                Layout.alignment: Qt.AlignCenter

                onClicked: {
                    if (isClockRunning) {
                        startButton.text = "Weiter"
                        zeroButton.enabled = true
                        isClockRunning = false
                        updateTimer.stop()
                        currentTime += new Date().getTime() - startTime
                        mainWindow.setTimeString(currentTime)

                    } else {
                        startButton.text = "Pause"
                        zeroButton.enabled = false
                        startTime = new Date().getTime()
                        isClockRunning = true
                        updateTimer.start()
                    }
                }
            }

            Button {
                id: zeroButton
                text: "Löschen"
                enabled: true

                onClicked: {
                    if (! isClockRunning) {
                        time.text = "0000:00,00"
                        currentTime = 0
                        startButton.text = "Start"
                    }
                }
            }

        }

        Timer {
            id: updateTimer
            interval: 30;
            running: false;
            repeat: true;
            onTriggered: {
                mainWindow.setTimeString(new Date().getTime() - startTime + currentTime)
            }
        }
    }

    function setTimeString(ct) {
        var ms = Math.floor((ct / 10) % 100).toString().padStart(2, "0")
        var s = Math.floor((ct / 1000) % 60).toString().padStart(2, "0")
        var m = Math.floor(ct / 1000 / 60).toString().padStart(4, "0")
        time.text = m + ":" + s + "," + ms
    }
}
