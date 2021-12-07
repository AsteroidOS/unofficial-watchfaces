import QtGraphicalEffects 1.12
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.2

ApplicationWindow {
    id: approot
    property bool displayAmbient: ambientCheckBox.checked
    property var testface: Qt.application.arguments[1]
    readonly property var initialStaticTime: new Date('1997-06-25T16:50:47')
    readonly property var mouseWheelScale: 1 / 15

    minimumWidth: 640
    minimumHeight: 640 + header.height

    Rectangle {
        id: watchfaceDisplayFrame

        function snapshot() {
            watchfaceDisplayFrame.grabToImage(function(result) {
                result.saveToFile(approot.testface + (roundCheckBox.checked ? "-round.jpg" : ".jpg"));
            }, Qt.size(320, 320));
        }

        height: halfSize.checked ? 320 : 640
        width: halfSize.checked ? 320 : 640

        Rectangle {
            id: frame

            anchors.fill: parent
            color: "black"
            focus: true
            layer.enabled: roundCheckBox.checked
            Keys.onReturnPressed: watchfaceDisplayFrame.snapshot()

            Image {
                id: background

                visible: !approot.displayAmbient
                source: "background.jpg"
                anchors.fill: parent
            }

            Loader {
                id: watchfaceLoader

                anchors.fill: parent
                source: approot.testface + "/usr/share/asteroid-launcher/watchfaces/" + approot.testface + ".qml"
            }

            layer.effect: OpacityMask {
                anchors.fill: parent
                source: frame

                maskSource: Rectangle {
                    width: frame.width
                    height: frame.height
                    radius: frame.width / 2
                }

            }

        }

        Item {
            id: use12H

            property var value: twelveHourCheckBox.checked
        }

        Item {
            id: wallClock

            property var time: getDisplayTime()

            function getDisplayTime(statictime) {
                var displayTime = new Date();
                if (setStaticTimeCheckBox.checked) {
                    displayTime.setHours(hoursTumbler.currentIndex, minutesTumbler.currentIndex, secondsTumbler.currentIndex);
                    displayTime.setMonth(monthsTumbler.currentIndex, daysTumbler.currentIndex + 1);
                }
                return displayTime;
            }

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: wallClock.time = wallClock.getDisplayTime()
            }

        }

    }

    header: ToolBar {
        ColumnLayout {
            RowLayout {
                Layout.alignment: Qt.AlignCenter

                CheckBox {
                    id: roundCheckBox

                    text: qsTr("Round")
                    checked: true
                }

                CheckBox {
                    id: halfSize

                    text: qsTr("320x320")
                }

                CheckBox {
                    id: twelveHourCheckBox

                    text: qsTr("12h time")
                }

                CheckBox {
                    id: ambientCheckBox

                    text: qsTr("Dark")
                }

                Button {
                    id: screenshotButton

                    flat: false
                    text: qsTr("Screenshot")
                    onClicked: watchfaceDisplayFrame.snapshot()
                }

                Button {
                    id: reloadButton

                    flat: false
                    text: qsTr("Reload")
                    onClicked: {
                        watchfaceLoader.source = approot.testface + "/usr/share/asteroid-launcher/watchfaces/" + approot.testface + ".qml?" + Math.random();
                    }
                }

            }

            RowLayout {
                Layout.alignment: Qt.AlignCenter

                CheckBox {
                    id: setStaticTimeCheckBox

                    text: qsTr("Set Static Time")
                    checked: false
                }

                Frame {
                    padding: 0

                    Row {
                        Tumbler {
                            id: monthsTumbler

                            enabled: setStaticTimeCheckBox.checked
                            currentIndex: approot.initialStaticTime.getMonth()
                            model: 12

                            WheelHandler {
                                property: "currentIndex"
                                rotationScale: approot.mouseWheelScale
                            }

                            delegate: Label {
                                text: approot.locale.standaloneMonthName(index, Locale.ShortFormat)
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                        }

                        Tumbler {
                            id: daysTumbler

                            enabled: setStaticTimeCheckBox.checked
                            currentIndex: approot.initialStaticTime.getDate() - 1
                            model: 31

                            WheelHandler {
                                property: "currentIndex"
                                rotationScale: approot.mouseWheelScale
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

                            enabled: setStaticTimeCheckBox.checked
                            currentIndex: approot.initialStaticTime.getHours()
                            model: 24

                            WheelHandler {
                                property: "currentIndex"
                                rotationScale: approot.mouseWheelScale
                            }

                        }

                        Tumbler {
                            id: minutesTumbler

                            enabled: setStaticTimeCheckBox.checked
                            currentIndex: approot.initialStaticTime.getMinutes()
                            model: 60

                            WheelHandler {
                                property: "currentIndex"
                                rotationScale: approot.mouseWheelScale
                            }

                        }

                        Tumbler {
                            id: secondsTumbler

                            enabled: setStaticTimeCheckBox.checked
                            currentIndex: approot.initialStaticTime.getSeconds()
                            model: 60

                            WheelHandler {
                                property: "currentIndex"
                                rotationScale: approot.mouseWheelScale
                            }

                        }

                    }

                }

            }

            RowLayout {
                Text {
                    leftPadding: 100
                    text: qsTr("featureSlider")
                }

                Slider {
                    id: featureSlider

                    width: 700
                    from: 0
                    value: 0.5
                    to: 1
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Can be used to test a feature such as battery level.\nDevelopers can temporarily use 'featureSlider.value' in watchface code.")

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

        background: Rectangle {
            color: "lightblue"
        }

    }

}
