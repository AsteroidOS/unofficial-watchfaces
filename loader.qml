import QtQuick 2.15
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.1

ApplicationWindow {
    id: root
    visible: true
    minimumWidth: 640
    minimumHeight: mysize + header.height // + menuBar.height
    property bool displayAmbient: false
    property bool round: true
    property int mysize: 640
    property var testface: Qt.application.arguments[1]

        /*
    menuBar: MenuBar {
        Menu {
            title: qsTr("&Help")
            Action { text: qsTr("&About") }
        }
    }
        */
    header: ToolBar {
        background: Rectangle {
            color: "lightblue"
        }
        ColumnLayout {
            RowLayout {
                Layout.alignment: Qt.AlignCenter
                CheckBox {
                    id: roundCheckBox
                    text: "Round"
                    Component.onCompleted: checked = round
                    onCheckedChanged: round = checked; 
                }
                CheckBox {
                    id: halfsize
                    text: "320x320"
                    Component.onCompleted: checked = mysize == 320
                    onCheckedChanged: mysize = checked ? 320 : 640; 
                }
                CheckBox {
                    id: checkBox12h
                    text: "12h time"
                    Component.onCompleted: checked = use12H.value
                    onCheckedChanged: use12H.value = checked; 
                }
                CheckBox {
                    id: ambientCheckBox
                    text: "Dark"
                    Component.onCompleted: checked = displayAmbient
                    onCheckedChanged: displayAmbient = checked; 
                }
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
            }
            RowLayout {
                Layout.alignment: Qt.AlignCenter
                CheckBox {
                    id: settime
                    text: "Set Static Time"
                    checked: false
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
            RowLayout {
                Text {
                    leftPadding: 100
                    text: "featureSlider"
                }
                Slider {
                    id: featureSlider
                    width: 700
                    from: 0
                    value: 0.5
                    to: 1
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
                        text: "0.0"
                        anchors.left: parent.left
                    }
                    Text {
                        text: "1.0"
                        anchors.right: parent.right
                    }
                }
                Text {
                    text: featureSlider.value.toFixed(3)
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
