// SPDX-FileCopyrightText: 2021 Timo Könnecke <github.com/eLtMosen>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import Nemo.Mce 1.0
import QtGraphicalEffects 1.15
import QtQuick 2.15
import QtQuick.Shapes 1.15 as Shapes

Item {
    id: root

    property string lowColor: !displayAmbient ? "#bbCFA526" : "#66CFA526"
    property string highColor: !displayAmbient ? "#FFEBAD" : "#aaFFEBAD"
    property string accColor: !displayAmbient ? "#D88C9A" : "#88D88C9A"
    property string imgPath: "../watchfaces-img/analog-goldie-"
    property real maxSize: Math.min(width, height)
    property int currentDayOfWeek: wallClock.time.getDay()
    property int currentMonth: Number(wallClock.time.toLocaleString(Qt.locale(), "MM"))

    anchors.fill: parent
    layer.enabled: true

    MceBatteryLevel {
        id: batteryChargePercentage
    }

    Image {
        id: backPlate

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent
        visible: !displayAmbient
        source: imgPath + "background.svg"
    }

    Image {
        id: hourMarks

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent
        source: imgPath + "hourmarks.svg"

        layer {
            enabled: true

            effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 0
                radius: 8
                samples: 9
                color: Qt.rgba(0, 0, 0, 1)
            }

        }

    }

    // faceBox constrained to maxSize square so all children using
    // parent.width/height automatically reference a square dimension.
    Item {
        id: faceBox

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        Repeater {
            model: 60

            Rectangle {
                property real rotM: (index - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                visible: index % 5
                antialiasing: true
                width: parent.width * 0.005
                height: parent.height * 0.04
                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.45
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.45
                color: lowColor

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

                x: index % 6 ? centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.348 : centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.326
                y: index % 6 ? centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.348 : centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.326
                color: "#ddffffff"
                text: index === 0 ? 12 : index

                font {
                    pixelSize: index % 3 ? parent.height * 0.06 : parent.height * 0.12
                    family: "Noto Sans"
                    styleName: index % 3 ? "SemiCondensed SemiBold" : "SemiCondensed Medium"
                }

                LinearGradient {
                    anchors.fill: parent
                    source: parent

                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#bf9b30"
                        }

                        GradientStop {
                            position: 0.4
                            color: "#ffcf40"
                        }

                        GradientStop {
                            position: 0.6
                            color: "#ffbf00"
                        }

                        GradientStop {
                            position: 1
                            color: "#ffdc73"
                        }

                    }

                }

            }

        }

        Item {
            id: dayBox

            width: parent.width * 0.24
            height: parent.height * 0.24

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.width * 0.044
                horizontalCenterOffset: -parent.width * 0.17
            }

            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.9
                height: width
                radius: width / 2
                color: "#22ffffff"
                border.width: root.maxSize * 0.002
                border.color: lowColor
                opacity: !displayAmbient ? 1 : 0.3
            }

            Shapes.Shape {
                anchors.fill: parent
                opacity: !displayAmbient ? 1 : 0.3

                Shapes.ShapePath {
                    fillColor: "transparent"
                    strokeColor: accColor
                    strokeWidth: root.maxSize * 0.005
                    capStyle: Shapes.ShapePath.RoundCap

                    PathAngleArc {
                        centerX: dayBox.width / 2
                        centerY: dayBox.height / 2
                        radiusX: dayBox.width * 0.456
                        radiusY: dayBox.height * 0.456
                        startAngle: 169
                        sweepAngle: root.currentDayOfWeek / 7 * 360
                        moveToStart: true
                    }

                }

            }

            Repeater {
                model: 7
                visible: !displayAmbient

                Text {
                    property real rotM: ((index * 8.7) - 15) / 60
                    property real centerX: parent.width / 2 - width / 2
                    property real centerY: parent.height / 2 - height / 2
                    property bool currentDayHighlight: root.currentDayOfWeek === new Date(2017, 1, index).getDay()

                    x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.35
                    y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.35
                    antialiasing: true
                    color: currentDayHighlight ? highColor : lowColor
                    text: new Date(2017, 1, index).toLocaleString(Qt.locale(), "ddd").slice(0, 2).toUpperCase()

                    font {
                        pixelSize: currentDayHighlight ? root.maxSize * 0.036 : root.maxSize * 0.03
                        letterSpacing: parent.width * 0.004
                        family: "Noto Sans"
                        styleName: currentDayHighlight ? "Black" : "SemiCondensed Bold"
                    }

                    transform: Rotation {
                        origin.x: width / 2
                        origin.y: height / 2
                        angle: index * 52
                    }

                }

            }

            Text {
                id: dayDisplay

                color: highColor
                text: wallClock.time.toLocaleString(Qt.locale(), "dd").slice(0, 2).toUpperCase()

                anchors {
                    centerIn: parent
                    verticalCenterOffset: -root.maxSize * 0.003
                }

                font {
                    pixelSize: parent.height * 0.39
                    family: "Noto Sans"
                    styleName: "Condensed"
                }

            }

        }

        Item {
            id: monthBox

            width: parent.width * 0.24
            height: parent.height * 0.24

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.width * 0.044
                horizontalCenterOffset: parent.width * 0.17
            }

            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.9
                height: width
                radius: width / 2
                color: "#22ffffff"
                border.width: root.maxSize * 0.002
                border.color: lowColor
                opacity: !displayAmbient ? 1 : 0.3
            }

            Shapes.Shape {
                anchors.fill: parent
                opacity: !displayAmbient ? 1 : 0.3

                Shapes.ShapePath {
                    fillColor: "transparent"
                    strokeColor: accColor
                    strokeWidth: root.maxSize * 0.005
                    capStyle: Shapes.ShapePath.RoundCap

                    PathAngleArc {
                        centerX: monthBox.width / 2
                        centerY: monthBox.height / 2
                        radiusX: monthBox.width * 0.456
                        radiusY: monthBox.height * 0.456
                        startAngle: 270
                        sweepAngle: root.currentMonth / 12 * 360
                        moveToStart: true
                    }

                }

            }

            Repeater {
                model: 12

                Text {
                    property real rotM: ((index * 5) - 15) / 60
                    property real centerX: parent.width / 2 - width / 2
                    property real centerY: parent.height / 2 - height / 2
                    property bool currentMonthHighlight: root.currentMonth === index || root.currentMonth === index + 12

                    x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.35
                    y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.35
                    antialiasing: true
                    color: currentMonthHighlight ? highColor : lowColor
                    text: index === 0 ? 12 : index

                    font {
                        pixelSize: currentMonthHighlight ? root.maxSize * 0.036 : root.maxSize * 0.03
                        letterSpacing: parent.width * 0.004
                        family: "Noto Sans"
                        styleName: currentMonthHighlight ? "Black" : "Condensed Bold"
                    }

                    transform: Rotation {
                        origin.x: width / 2
                        origin.y: height / 2
                        angle: index * 30
                    }

                }

            }

            Text {
                id: monthDisplay

                anchors.centerIn: parent
                renderType: Text.NativeRendering
                color: highColor
                text: wallClock.time.toLocaleString(Qt.locale(), "MMM").slice(0, 3).toUpperCase()

                font {
                    pixelSize: parent.height * 0.28
                    family: "Noto Sans"
                    styleName: "ExtraCondensed Medium"
                }

            }

        }

        Item {
            id: batteryBox

            width: parent.width * 0.22
            height: parent.height * 0.22

            anchors {
                centerIn: parent
                verticalCenterOffset: parent.width * 0.15
            }

            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.9
                height: width
                radius: width / 2
                color: "#22ffffff"
                border.width: root.maxSize * 0.002
                border.color: lowColor
                opacity: !displayAmbient ? 1 : 0.3
            }

            Shapes.Shape {
                anchors.fill: parent
                opacity: !displayAmbient ? 1 : 0.3

                Shapes.ShapePath {
                    fillColor: "transparent"
                    strokeColor: batteryChargePercentage.percent < 30 ? accColor : "#44BBA4"
                    strokeWidth: root.maxSize * 0.005
                    capStyle: Shapes.ShapePath.RoundCap

                    PathAngleArc {
                        centerX: batteryBox.width / 2
                        centerY: batteryBox.height / 2
                        radiusX: batteryBox.width * 0.456
                        radiusY: batteryBox.height * 0.456
                        startAngle: 270
                        sweepAngle: batteryChargePercentage.percent / 100 * 360
                        moveToStart: true
                    }

                }

            }

            Text {
                id: batteryDisplay

                anchors.centerIn: parent
                renderType: Text.NativeRendering
                color: highColor
                text: batteryChargePercentage.percent

                font {
                    pixelSize: parent.height * 0.48
                    family: "Noto Sans"
                    styleName: "Condensed Light"
                }

                Text {
                    id: batteryPercent

                    renderType: Text.NativeRendering
                    lineHeightMode: Text.FixedHeight
                    lineHeight: parent.height * 0.94
                    horizontalAlignment: Text.AlignHCenter
                    color: !displayAmbient ? highColor : lowColor
                    text: "BAT<br>%"

                    anchors {
                        centerIn: parent
                        verticalCenterOffset: parent.height * 0.34
                    }

                    font {
                        pixelSize: parent.height * 0.194
                        family: "Noto Sans"
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
                radius: 10
                samples: 13
                color: Qt.rgba(0, 0, 0, 0.8)
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
                color: Qt.rgba(0, 0, 0, 0.2)
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
                angle: (wallClock.time.getMinutes() * 6) + (wallClock.time.getSeconds() * 6 / 60)
            }

            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 3
                verticalOffset: 3
                radius: 6
                samples: 9
                color: Qt.rgba(0, 0, 0, 0.3)
            }

        }

        Image {
            id: secondSVG

            visible: !displayAmbient
            source: imgPath + "second.svg"
            anchors.fill: parent
            layer.enabled: true

            transform: Rotation {
                origin.x: secondSVG.width / 2
                origin.y: secondSVG.height / 2
                angle: wallClock.time.getSeconds() * 6
            }

            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 4
                verticalOffset: 4
                radius: 8
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
