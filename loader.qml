import QtQuick 2.15
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.1

ApplicationWindow {
    id: root
    visible: true
    minimumWidth: 640
    minimumHeight: mysize + header.height
    property bool displayAmbient: false
    property bool round: true
    property int mysize: 640
    property var testface: Qt.application.arguments[1]

    header: ToolBar {
        background: Rectangle {
            color: "lightblue"
        }
        GridLayout {
            rows: 3
            flow: GridLayout.TopToBottom
            CheckBox {
                id: roundCheckBox
                text: "Round"
                Component.onCompleted: checked = round
                onCheckedChanged: round = checked; 
            }
            CheckBox {
                id: checkBox12h
                text: "12h time"
                Component.onCompleted: checked = use12H.value
                onCheckedChanged: use12H.value = checked; 
            }
            CheckBox {
                id: settime
                text: "Set Static Time"
                checked: false
            }
            CheckBox {
                id: halfsize
                text: "320x320"
                Component.onCompleted: checked = mysize == 320
                onCheckedChanged: mysize = checked ? 320 : 640; 
            }
            CheckBox {
                id: ambientCheckBox
                text: "Dark"
                Component.onCompleted: checked = displayAmbient
                onCheckedChanged: displayAmbient = checked; 
            }
            Button {
               id: reload
               text: "Reload"
               onClicked: {
                    watchfaceLoader.source = testface + "/usr/share/asteroid-launcher/watchfaces/" + testface + ".qml?" + Math.random()
               }
            }
            Item { Layout.fillWidth: true }
            Button {
                id: screenshot
                flat: false
                text: "Screenshot"
                onClicked: myFrame.snapshot()
            }
            Button {
                id: reload
                flat: false
                text: "Reload"
                onClicked: {
                    watchfaceLoader.source = testface + "/usr/share/asteroid-launcher/watchfaces/" + testface + ".qml?"+Math.random()
                }
            }
            Slider {
                id: timeSlider
                enabled: settime.checked
                opacity: settime.checked ? 1 : 0.4
                width: 700
                from: 0
                value: 16.9
                to: 24
                Repeater {
                    model: 25
                    delegate: Rectangle {
                        x: parent.horizontalPadding + parent.availableWidth * index / 24
                        y: parent.height - height
                        implicitWidth: 1
                        implicitHeight: 8
                        color: "brown"
                    }
                }
                Text {
                    text: "0"
                    anchors.left: parent.left
                }
                Text {
                    text: "24"
                    anchors.right: parent.right
                }
            }
        }
    }

    Rectangle {
        id: myFrame
        height: root.mysize
        width: root.mysize
        function snapshot() {
            myFrame.grabToImage(
            function(result) {  
                result.saveToFile(testface + (round ? "-round.jpg" : ".jpg"))
            }, Qt.size(320, 320) )
        }

        Rectangle {
            id: frame
            anchors.fill: parent
            color: "black"
            focus: true
            Image {
                id: background
                visible: !displayAmbient
                source: "background.jpg"
                anchors.fill: parent
            }
            Loader {
                id: watchfaceLoader
                anchors.fill: parent
                source: testface + "/usr/share/asteroid-launcher/watchfaces/" + testface + ".qml"
            }

            layer.enabled: round
            layer.effect:  OpacityMask {
                anchors.fill: parent
                source: frame
                maskSource: Rectangle {
                    width: frame.width
                    height: frame.height
                    radius: frame.width/2
                }
            }

            Keys.onReturnPressed: snapshot()
        }

        Item {
            id: use12H
            property var value: false
        }

        Item {
            id: wallClock
            property var time: timewidget(settime.checked)
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: wallClock.time = wallClock.timewidget(settime.checked)
            }
            function timewidget(statictime) {
                var mydate = new Date()
                if (statictime) {
                    var hh = Math.floor(timeSlider.value)
                    var mm = Math.floor(timeSlider.value * 60) % 60
                    var ss = Math.floor(timeSlider.value * 3600) % 60
                    mydate.setHours(hh, mm, ss)
                }
                return mydate
            }
        }
    }
}
