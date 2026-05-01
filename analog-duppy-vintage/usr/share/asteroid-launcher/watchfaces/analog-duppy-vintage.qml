// SPDX-FileCopyrightText: 2022 Timo Könnecke <github.com/eLtMosen>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import Nemo.Mce 1.0
import QtGraphicalEffects 1.15
import QtQuick 2.15

Item {
    id: root

    property string lowColor: !displayAmbient ? "#aab8bcc8" : "#44b8bcc8"
    property string highColor: !displayAmbient ? "#E5E5E5" : "#aaE5E5E5"
    property string accColor2: !displayAmbient ? "#DB5461" : "#88DB5461"
    property real verticalFontOffset: root.maxSize * 0.018
    property string imgPath: "../watchfaces-img/analog-duppy-vintage-"
    property real rad: 0.01745
    property real maxSize: Math.min(width, height)

    anchors.fill: parent
    layer.enabled: true

    MceBatteryLevel {
        id: batteryChargePercentage
    }

    // faceBox is constrained to a maxSize square so all children using
    // parent.width/height automatically reference a square dimension.
    Item {
        id: faceBox

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent
        layer.enabled: true

        Repeater {
            model: 60

            Rectangle {
                property real rotM: (index - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                antialiasing: true
                width: index % 5 ? parent.width * 0.003 : parent.width * 0.0064
                height: parent.height * 0.028
                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.484
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.484
                color: highColor

                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                    angle: index * 6
                }

            }

        }

        Repeater {
            model: 12

            Text {
                property real rotM: ((index * 5) - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                // Both branches were identical — simplified to single expression
                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.395
                y: verticalFontOffset + centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.395
                opacity: index % 3 ? 0.9 : 1
                text: index === 0 ? 12 : index

                font {
                    pixelSize: index % 3 ? parent.height * 0.074 : parent.height * 0.126
                    family: index % 3 ? "Kumar One" : "Kumar One Outline"
                    styleName: index % 3 ? "Condensed" : "SemiCondensed Medium"
                    letterSpacing: index % 3 ? -root.maxSize * 0.004 : -root.maxSize * 0.008
                }

                LinearGradient {
                    anchors.fill: parent
                    source: parent

                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#CDCBD1"
                        }

                        GradientStop {
                            position: 0.4
                            color: "#B8BCC8"
                        }

                        GradientStop {
                            position: 0.6
                            color: "#E5E5E5"
                        }

                        GradientStop {
                            position: 1
                            color: "#E1E6E8"
                        }

                    }

                }

            }

        }

        Item {
            id: dayBox

            width: parent.width * 0.6
            height: parent.height * 0.6
            anchors.centerIn: parent

            Repeater {
                model: 7
                visible: !displayAmbient

                Text {
                    property real rotM: ((index * 4.89) + 30.6) / 60
                    property real centerX: parent.width / 2 - width / 2
                    property real centerY: parent.height / 2 - height / 2
                    property bool currentDayHighlight: new Date(2017, 1, index).toLocaleString(Qt.locale(), "ddd") === wallClock.time.toLocaleString(Qt.locale(), "ddd")

                    x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.35
                    y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.35
                    antialiasing: true
                    color: currentDayHighlight ? highColor : lowColor
                    text: new Date(2017, 1, index).toLocaleString(Qt.locale(), "ddd").slice(0, 2).toUpperCase()

                    font {
                        pixelSize: currentDayHighlight ? root.maxSize * 0.07 : root.maxSize * 0.06
                        letterSpacing: parent.width * 0.004
                        family: "Varieté"
                        styleName: currentDayHighlight ? "Black" : "SemiCondensed Bold"
                    }

                    transform: Rotation {
                        origin.x: width / 2
                        origin.y: height / 2
                        angle: -90 + (index * 30)
                    }

                }

            }

        }

        Item {
            id: batteryBox

            property int value: batteryChargePercentage.percent

            width: parent.width * 0.5
            height: parent.height * 0.5
            anchors.centerIn: parent

            Repeater {
                model: 3

                Rectangle {
                    anchors.centerIn: parent
                    width: (parent.width * 0.78) + (index * (parent.width * 0.08))
                    height: width
                    radius: width / 2
                    color: "transparent"
                    border.width: root.maxSize * 0.004
                    border.color: lowColor
                    opacity: !displayAmbient ? 1 - (index / 5) : 0.3
                }

            }

            // Canvas retained intentionally: the arc angle formula produces a
            // carefully tuned visual layout that has no direct QtShapes equivalent
            // without risking subtle rendering differences. Not an example to follow
            // — prefer PathAngleArc for new battery arc implementations.
            Repeater {
                model: 3

                Canvas {
                    property int value: batteryBox.value
                    property int arcStart: 110
                    property int arcEnd: 250

                    onValueChanged: requestPaint()
                    anchors.fill: parent
                    opacity: !displayAmbient ? 1 - (index / 5) : 0.3
                    renderStrategy: Canvas.Cooperative
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.reset();
                        ctx.lineWidth = root.maxSize * 0.005;
                        ctx.lineCap = "round";
                        ctx.strokeStyle = batteryBox.value < 30 ? accColor2 : "#2E933C";
                        ctx.beginPath();
                        ctx.arc(parent.width / 2, parent.height / 2, parent.width * 0.39 + (index * (parent.width * 0.04)), (arcStart + 270) * rad, (((batteryBox.value / (36000 / (arcEnd - arcStart))) * (arcStart + arcEnd)) + (arcEnd + arcStart + (arcStart - 90))) * rad, false);
                        ctx.stroke();
                        ctx.closePath();
                    }
                }

            }

            Text {
                id: batteryDisplay

                renderType: Text.NativeRendering
                color: highColor
                opacity: 0.9
                text: batteryBox.value

                anchors {
                    centerIn: parent
                    verticalCenterOffset: parent.height * 0.3
                }

                font {
                    pixelSize: parent.height * 0.12
                    family: "Kumar One"
                    styleName: "Condensed Light"
                }

                Text {
                    id: batteryPercent

                    renderType: Text.NativeRendering
                    horizontalAlignment: Text.AlignHCenter
                    color: !displayAmbient ? highColor : lowColor
                    text: "%"

                    anchors {
                        left: batteryDisplay.right
                        leftMargin: parent.height * 0.034
                        verticalCenter: batteryDisplay.verticalCenter
                    }

                    font {
                        pixelSize: parent.height * 0.24
                        family: "Kumar One Outline"
                        styleName: "Bold"
                    }

                }

            }

        }

        layer {
            enabled: true

            effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 2
                verticalOffset: 2
                radius: 6
                samples: 13
                color: Qt.rgba(0, 0, 0, 0.7)
            }

        }

    }

    Item {
        id: handBox

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        Image {
            id: hourSVG

            source: imgPath + "hour.svg"
            anchors.fill: parent
            layer.enabled: true

            transform: Rotation {
                origin.x: hourSVG.width / 2
                origin.y: hourSVG.height / 2
                angle: (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * 0.5)
            }

            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 2
                verticalOffset: 2
                radius: 5
                samples: 9
                color: Qt.rgba(0, 0, 0, 0.4)
            }

        }

        Image {
            id: minuteSVG

            source: imgPath + "minute.svg"
            anchors.fill: parent
            layer.enabled: true

            transform: Rotation {
                origin.x: minuteSVG.width / 2
                origin.y: minuteSVG.height / 2
                angle: wallClock.time.getMinutes() * 6
            }

            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 4
                verticalOffset: 4
                radius: 6
                samples: 9
                color: Qt.rgba(0, 0, 0, 0.3)
            }

        }

    }

    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 2
        verticalOffset: 2
        radius: 8
        samples: 9
        color: Qt.rgba(0, 0, 0, 0.3)
    }

}
