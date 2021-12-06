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
    readonly property var mouseWheelScale: 1/15

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
                Frame {
                    padding: 0
                    Row {
                        Tumbler {
                            id: monthsTumbler
                            enabled: settime.checked
                            currentIndex: 5
                            model: 12
                            WheelHandler {
                                property: "currentIndex"
                                rotationScale: mouseWheelScale
                            }
                            delegate: Label {
                                text: locale.standaloneMonthName(index, Locale.ShortFormat)
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        Tumbler {
                            id: daysTumbler
                            enabled: settime.checked
                            currentIndex: 24
                            model: 31
                            WheelHandler {
                                property: "currentIndex"
                                rotationScale: mouseWheelScale
                            }
                            delegate: Label {
                                text: index + 1
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
                Frame {
                    padding: 0
                    Row {
                        Tumbler {
                            id: hoursTumbler
                            enabled: settime.checked
                            currentIndex: 16
                            model: 24
                            WheelHandler {
                                property: "currentIndex"
                                rotationScale: mouseWheelScale
                            }
                        }
                        Tumbler {
                            id: minutesTumbler
                            enabled: settime.checked
                            currentIndex: 58
                            model: 60
                            WheelHandler {
                                property: "currentIndex"
                                rotationScale: mouseWheelScale
                            }
                        }
                        Tumbler {
                            id: secondsTumbler
                            enabled: settime.checked
                            currentIndex: 28
                            model: 60
                            WheelHandler {
                                property: "currentIndex"
                                rotationScale: mouseWheelScale
                            }
                        }
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
                    mydate.setHours(hoursTumbler.currentIndex, minutesTumbler.currentIndex, secondsTumbler.currentIndex)
                    mydate.setMonth(monthsTumbler.currentIndex, daysTumbler.currentIndex + 1)
                }
                return mydate
            }
        }
    }
}
