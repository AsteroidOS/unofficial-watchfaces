// SPDX-FileCopyrightText: 2023 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import Nemo.Mce 1.0
import QtGraphicalEffects 1.15
import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {
    id: root

    property string imgPath: "../watchfaces-img/analog-boombox-"
    property real maxSize: Math.min(width, height)
    property real hourHandAngle: (wallClock.time.getHours() * 30 + wallClock.time.getMinutes() * 0.5)
    property real minuteHandAngle: wallClock.time.getMinutes() * 6 + wallClock.time.getSeconds() * 0.1
    property real secondHandAngle: wallClock.time.getSeconds() * 6
    property real hourOrbitRad: (wallClock.time.getHours() - 3 + wallClock.time.getMinutes() / 60) / 12 * 2 * Math.PI
    property real minuteOrbitRad: (wallClock.time.getMinutes() - 15 + wallClock.time.getSeconds() / 60) / 60 * 2 * Math.PI

    anchors.fill: parent

    MceBatteryLevel {
        id: batteryChargePercentage
    }

    Item {
        id: handBox

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        Image {
            id: secondSVG

            visible: !displayAmbient
            source: imgPath + "second.svg"
            anchors.fill: parent

            transform: Rotation {
                angle: root.secondHandAngle
                origin.x: secondSVG.width / 2
                origin.y: secondSVG.height / 2
            }

        }

        Image {
            id: minuteSVG

            source: imgPath + "minute.svg"
            anchors.fill: parent

            transform: Rotation {
                angle: root.minuteHandAngle
                origin.x: minuteSVG.width / 2
                origin.y: minuteSVG.height / 2
            }

        }

        Image {
            id: hourSVG

            source: imgPath + "hour.svg"
            anchors.fill: parent

            transform: Rotation {
                angle: root.hourHandAngle
                origin.x: hourSVG.width / 2
                origin.y: hourSVG.height / 2
            }

        }

        layer {
            enabled: true
            samples: 4

            effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 0
                radius: 6
                samples: 13
                color: Qt.rgba(0, 0, 0, 0.4)
            }

        }

    }

    Text {
        id: hourDisplay

        x: root.width / 2 - width / 2 + Math.cos(root.hourOrbitRad) * root.maxSize * 0.204
        y: root.height / 2 - height / 2.04 + Math.sin(root.hourOrbitRad) * root.maxSize * 0.204
        color: "black"
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) : wallClock.time.toLocaleString(Qt.locale(), "HH")

        font {
            pixelSize: root.maxSize * 0.114
            family: "Dangrek"
            letterSpacing: -root.maxSize * 0.003
        }

    }

    Text {
        id: minuteDisplay

        x: root.width / 2 - width / 2 + Math.cos(root.minuteOrbitRad) * root.maxSize * 0.369
        y: root.height / 2 - height / 2.04 + Math.sin(root.minuteOrbitRad) * root.maxSize * 0.369
        color: "black"
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")

        font {
            pixelSize: root.maxSize * 0.114
            family: "Dangrek"
            letterSpacing: -root.maxSize * 0.003
        }

    }

    Item {
        id: batterySegments

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        layer {
            enabled: true
            samples: 4
        }

        Repeater {
            id: segmentedArc

            property real inputValue: batteryChargePercentage.percent
            property int segmentAmount: 5
            property int start: 0
            property int gap: 28
            property int endFromStart: 360
            property bool clockwise: true
            property real arcStrokeWidth: 0.017
            property real scalefactor: 0.058 - (arcStrokeWidth / 2)

            model: segmentAmount

            Shape {
                id: segment

                visible: index === 0 ? true : (index / segmentedArc.segmentAmount) < segmentedArc.inputValue / 100

                ShapePath {
                    fillColor: "transparent"
                    strokeColor: "#26C485"
                    strokeWidth: batterySegments.width * segmentedArc.arcStrokeWidth
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.MiterJoin
                    startX: batterySegments.width / 2
                    startY: batterySegments.height * (0.5 - segmentedArc.scalefactor)

                    PathAngleArc {
                        centerX: batterySegments.width / 2
                        centerY: batterySegments.height / 2
                        radiusX: segmentedArc.scalefactor * batterySegments.width
                        radiusY: segmentedArc.scalefactor * batterySegments.height
                        startAngle: -90 + index * (sweepAngle + (segmentedArc.clockwise ? +segmentedArc.gap : -segmentedArc.gap)) + segmentedArc.start
                        sweepAngle: segmentedArc.clockwise ? (segmentedArc.endFromStart / segmentedArc.segmentAmount) - segmentedArc.gap : -(segmentedArc.endFromStart / segmentedArc.segmentAmount) + segmentedArc.gap
                        moveToStart: true
                    }

                }

            }

        }

    }

}
