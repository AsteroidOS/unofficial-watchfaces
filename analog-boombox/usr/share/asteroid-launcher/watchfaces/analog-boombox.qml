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
    property real squareEdge: Math.min(width, height)

    anchors.fill: parent
    Component.onCompleted: {
        var h = wallClock.time.getHours();
        var min = wallClock.time.getMinutes();
        var sec = wallClock.time.getSeconds();
        hourRot.angle = h * 30 + min * 0.5;
        minuteRot.angle = min * 6 + sec * 6 / 60;
        secondRot.angle = sec * 6;
        var rotH = (h - 3 + min / 60) / 12;
        var rotM = (min - 15 + sec / 60) / 60;
        hourDisplay.x = root.width / 2 - hourDisplay.width / 2 + Math.cos(rotH * 2 * Math.PI) * root.squareEdge * 0.204;
        hourDisplay.y = root.height / 2 - hourDisplay.height / 2.04 + Math.sin(rotH * 2 * Math.PI) * root.squareEdge * 0.204;
        minuteDisplay.x = root.width / 2 - minuteDisplay.width / 2 + Math.cos(rotM * 2 * Math.PI) * root.squareEdge * 0.369;
        minuteDisplay.y = root.height / 2 - minuteDisplay.height / 2.04 + Math.sin(rotM * 2 * Math.PI) * root.squareEdge * 0.369;
    }

    MceBatteryLevel {
        id: batteryChargePercentage
    }

    Item {
        id: handBox

        width: root.squareEdge
        height: root.squareEdge
        anchors.centerIn: parent

        Image {
            id: secondSVG

            visible: !displayAmbient
            source: imgPath + "second.svg"
            anchors.fill: parent

            transform: Rotation {
                id: secondRot

                origin.x: parent.width / 2
                origin.y: parent.height / 2
            }

        }

        Image {
            id: minuteSVG

            source: imgPath + "minute.svg"
            anchors.fill: parent

            transform: Rotation {
                id: minuteRot

                origin.x: parent.width / 2
                origin.y: parent.height / 2
            }

        }

        Image {
            id: hourSVG

            source: imgPath + "hour.svg"
            anchors.fill: parent

            transform: Rotation {
                id: hourRot

                origin.x: parent.width / 2
                origin.y: parent.height / 2
            }

        }

        layer {
            enabled: true
            samples: 4
            smooth: true
            textureSize: Qt.size(root.squareEdge * 2, root.squareEdge * 2)

            effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 0
                radius: 10
                samples: 9
                color: Qt.rgba(0, 0, 0, 0.4)
            }

        }

    }

    Text {
        id: hourDisplay

        color: "black"
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) : wallClock.time.toLocaleString(Qt.locale(), "HH")

        font {
            pixelSize: root.squareEdge * 0.114
            family: "Dangrek"
            letterSpacing: -root.squareEdge * 0.003
        }

    }

    Text {
        id: minuteDisplay

        color: "black"
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")

        font {
            pixelSize: root.squareEdge * 0.114
            family: "Dangrek"
            letterSpacing: -root.squareEdge * 0.003
        }

    }

    Item {
        id: batterySegments

        width: root.squareEdge
        height: root.squareEdge
        anchors.centerIn: parent

        layer {
            enabled: true
            samples: 4
            smooth: true
            textureSize: Qt.size(root.squareEdge * 2, root.squareEdge * 2)
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
                    strokeWidth: root.squareEdge * segmentedArc.arcStrokeWidth
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.MiterJoin
                    startX: root.squareEdge / 2
                    startY: root.squareEdge * (0.5 - segmentedArc.scalefactor)

                    PathAngleArc {
                        centerX: root.squareEdge / 2
                        centerY: root.squareEdge / 2
                        radiusX: segmentedArc.scalefactor * root.squareEdge
                        radiusY: segmentedArc.scalefactor * root.squareEdge
                        startAngle: -90 + index * (sweepAngle + (segmentedArc.clockwise ? +segmentedArc.gap : -segmentedArc.gap)) + segmentedArc.start
                        sweepAngle: segmentedArc.clockwise ? (segmentedArc.endFromStart / segmentedArc.segmentAmount) - segmentedArc.gap : -(segmentedArc.endFromStart / segmentedArc.segmentAmount) + segmentedArc.gap
                        moveToStart: true
                    }

                }

            }

        }

    }

    Connections {
        target: wallClock
        onTimeChanged: {
            var h = wallClock.time.getHours();
            var min = wallClock.time.getMinutes();
            var sec = wallClock.time.getSeconds();
            hourRot.angle = h * 30 + min * 0.5;
            minuteRot.angle = min * 6 + sec * 6 / 60;
            secondRot.angle = sec * 6;
            var rotH = (h - 3 + min / 60) / 12;
            var rotM = (min - 15 + sec / 60) / 60;
            hourDisplay.x = root.width / 2 - hourDisplay.width / 2 + Math.cos(rotH * 2 * Math.PI) * root.squareEdge * 0.204;
            hourDisplay.y = root.height / 2 - hourDisplay.height / 2.04 + Math.sin(rotH * 2 * Math.PI) * root.squareEdge * 0.204;
            minuteDisplay.x = root.width / 2 - minuteDisplay.width / 2 + Math.cos(rotM * 2 * Math.PI) * root.squareEdge * 0.369;
            minuteDisplay.y = root.height / 2 - minuteDisplay.height / 2.04 + Math.sin(rotM * 2 * Math.PI) * root.squareEdge * 0.369;
        }
    }

}
