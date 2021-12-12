import QtGraphicalEffects 1.12
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.2

ApplicationWindow {
    id: appRoot
    property bool displayAmbient: ambientCheckBox.checked
    property var nameOfWatchfaceToBeTested: Qt.application.arguments[1]
    readonly property var initialStaticTime: new Date('2021-12-02T13:37:42')
    readonly property var mouseWheelScale: 1 / 15

    minimumWidth: 640
    minimumHeight: 640 + header.height

    Rectangle {
        id: watchfaceDisplayFrame

        function snapshot() {
            watchfaceDisplayFrame.grabToImage(function(result) {
                result.saveToFile(appRoot.nameOfWatchfaceToBeTested 
                        + (roundCheckBox.checked ? "-round.jpg" : ".jpg"));
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

                visible: !appRoot.displayAmbient
                source: "background.jpg"
                anchors.fill: parent
            }

            Loader {
                id: watchfaceLoader

                anchors.fill: parent
                source: appRoot.nameOfWatchfaceToBeTested 
                        + "/usr/share/asteroid-launcher/watchfaces/" 
                        + appRoot.nameOfWatchfaceToBeTested + ".qml"
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

                    font.pixelSize: 30
                    text: "\u25EF"
                    ToolTip.visible: hovered
                    ToolTip.delay: 600
                    ToolTip.text: qsTr("Show the watchface as it would look on a round watch")
                    checked: true
                }

                CheckBox {
                    id: ambientCheckBox

                    font.pixelSize: 40
                    text: "\u263D"
                    ToolTip.visible: hovered
                    ToolTip.delay: 600
                    ToolTip.text: qsTr("Switch to AmbientMode on black background")
                }

                CheckBox {
                    id: halfSize

                    text: qsTr("320px")
                    ToolTip.visible: hovered
                    ToolTip.delay: 600
                    ToolTip.text: qsTr("Scale down view to 320x320px from 640px")
                }

                Button {
                    id: screenshotButton

                    flat: false
                    text: qsTr("Screenshot")
                    ToolTip.visible: hovered
                    ToolTip.delay: 600
                    ToolTip.text: qsTr("Take screenshot and store it named for use in /.thumbnail")
                    onClicked: watchfaceDisplayFrame.snapshot()
                }

                Button {
                    id: reloadButton

                    flat: false
                    text: "\u27f2"
                    ToolTip.visible: hovered
                    ToolTip.delay: 600
                    ToolTip.text: qsTr("Reload qml code")
                    onClicked: {
                        watchfaceLoader.source = appRoot.nameOfWatchfaceToBeTested 
                                + "/usr/share/asteroid-launcher/watchfaces/" 
                                + appRoot.nameOfWatchfaceToBeTested + ".qml?" 
                                + Math.random();
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignCenter

                CheckBox {
                    id: twelveHourCheckBox

                    text: qsTr("12h")
                    ToolTip.delay: 600
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Switch to 2x 12h day format with am/pm")
                }

                CheckBox {
                    id: setStaticTimeCheckBox

                    text: qsTr("Set Time")
                    ToolTip.delay: 600
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Set a custom time by draging the tumblers or use the mouse wheel above them")
                    checked: false
                }

                Frame {
                    padding: 0

                    Row {
                        Tumbler {
                            id: monthsTumbler

                            enabled: setStaticTimeCheckBox.checked
                            currentIndex: appRoot.initialStaticTime.getMonth()
                            model: 12

                            WheelHandler {
                                property: "currentIndex"
                                rotationScale: appRoot.mouseWheelScale
                            }

                            delegate: Label {
                                text: appRoot.locale.standaloneMonthName(index, Locale.ShortFormat)
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Tumbler {
                            id: daysTumbler

                            enabled: setStaticTimeCheckBox.checked
                            currentIndex: appRoot.initialStaticTime.getDate() - 1
                            model: 31

                            WheelHandler {
                                property: "currentIndex"
                                rotationScale: appRoot.mouseWheelScale
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
                            currentIndex: appRoot.initialStaticTime.getHours()
                            model: 24

                            WheelHandler {
                                property: "currentIndex"
                                rotationScale: appRoot.mouseWheelScale
                            }
                        }

                        Tumbler {
                            id: minutesTumbler

                            enabled: setStaticTimeCheckBox.checked
                            currentIndex: appRoot.initialStaticTime.getMinutes()
                            model: 60

                            WheelHandler {
                                property: "currentIndex"
                                rotationScale: appRoot.mouseWheelScale
                            }
                        }

                        Tumbler {
                            id: secondsTumbler

                            enabled: setStaticTimeCheckBox.checked
                            currentIndex: appRoot.initialStaticTime.getSeconds()
                            model: 60

                            WheelHandler {
                                property: "currentIndex"
                                rotationScale: appRoot.mouseWheelScale
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
                    ToolTip.delay: 600
                    ToolTip.text: qsTr("Can be used to test a feature such as battery level.\nDevelopers can temporarily use 'featureSlider.value' in watchface code.")

                    Repeater {
                        model: 25

                        delegate: Rectangle {
                            anchors.bottom: parent.bottom
                            x: parent.horizontalPadding + parent.availableWidth * index / 24
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
