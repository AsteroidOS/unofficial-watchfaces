/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
 *               2016 - Sylvia van Os <iamsylvie@openmailbox.org>
 *               2015 - Florent Revest <revestflo@gmail.com>
 *               2012 - Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
 *                      Aleksey Mikhailichenko <a.v.mich@gmail.com>
 *                      Arto Jalkanen <ajalkane@gmail.com>
 *
 * All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.15
import QtGraphicalEffects 1.15
import QtQuick.Shapes 1.15
import Nemo.Mce 1.0

Item {
    id: root

    property string imgPath: "../watchfaces-img/analog-boombox-"

    anchors.fill: parent

    MceBatteryLevel {
        id: batteryChargePercentage
    }

    Item {
        id: handBox

        anchors.fill: parent

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
            textureSize: Qt.size(root.width * 2, root.height * 2)
            effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 0
                radius: 10.0
                samples: 9
                color: Qt.rgba(0, 0, 0, .4)
            }
        }
    }

    Text {
        id: hourDisplay
        
        font {
            pixelSize: parent.height * .114
            family: "Dangrek"
            letterSpacing: -parent.height * .003
        }
        color: "black"
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) :
        wallClock.time.toLocaleString(Qt.locale(), "HH")
    }
    
    Text {
        id: minuteDisplay
        
        font {
            pixelSize: parent.height * .114
            family: "Dangrek"
            letterSpacing: -parent.height * .003
        }
        color: "black"
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    Item {
        id: batterySegments

        anchors.fill: parent

        layer {
            enabled: true
            samples: 4
            smooth: true
            textureSize: Qt.size(root.width * 2, root.height * 2)
        }

        Repeater {
            id: segmentedArc

            property real inputValue: batteryChargePercentage.percent
            property int segmentAmount: 5
            property int start: 0
            property int gap: 28
            property int endFromStart: 360
            property bool clockwise: true
            property real arcStrokeWidth: .017
            property real scalefactor: .058 - (arcStrokeWidth / 2)

            model: segmentAmount

            Shape {
                id: segment

                visible: index === 0 ? true : (index / segmentedArc.segmentAmount) < segmentedArc.inputValue / 100

                ShapePath {
                    fillColor: "transparent"
                    strokeColor: "#26C485"
                    strokeWidth: parent.height * segmentedArc.arcStrokeWidth
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.MiterJoin
                    startX: parent.width / 2
                    startY: parent.height * ( .5 - segmentedArc.scalefactor)

                    PathAngleArc {
                        centerX: parent.width / 2
                        centerY: parent.height / 2
                        radiusX: segmentedArc.scalefactor * parent.width
                        radiusY: segmentedArc.scalefactor * parent.height
                        startAngle: -90 + index * (sweepAngle + (segmentedArc.clockwise ? +segmentedArc.gap : -segmentedArc.gap)) + segmentedArc.start
                        sweepAngle: segmentedArc.clockwise ? (segmentedArc.endFromStart / segmentedArc.segmentAmount) - segmentedArc.gap :
                                                             -(segmentedArc.endFromStart / segmentedArc.segmentAmount) + segmentedArc.gap
                        moveToStart: true
                    }
                }
            }
        }
    }
    
    Connections {
        target: wallClock
        onTimeChanged: {
            if (!visible) return
                var h = wallClock.time.getHours()
                var min = wallClock.time.getMinutes()
                var sec = wallClock.time.getSeconds()
                hourRot.angle = h * 30 + min * .5
                minuteRot.angle = min * 6 + sec * 6 / 60
                secondRot.angle = sec * 6
                var rotH = (h - 3 + min / 60) / 12
                var rotM = (min - 15 + sec / 60) / 60
                hourDisplay.x = root.width / 2 - hourDisplay.width / 2 + Math.cos(rotH * 2 * Math.PI) * root.height * .204
                hourDisplay.y = root.height / 2 - hourDisplay.height / 2.04 + Math.sin(rotH * 2 * Math.PI) * root.width * .204
                minuteDisplay.x = root.width / 2 - minuteDisplay.width / 2 + Math.cos(rotM * 2 * Math.PI) * root.height * .369
                minuteDisplay.y = root.height / 2 - minuteDisplay.height / 2.04 + Math.sin(rotM * 2 * Math.PI) * root.width * .369
        }
    }
    
    Component.onCompleted: {
        var h = wallClock.time.getHours()
        var min = wallClock.time.getMinutes()
        var sec = wallClock.time.getSeconds()
        hourRot.angle = h * 30 + min * .5
        minuteRot.angle = min * 6 + sec * 6 / 60
        secondRot.angle = sec * 6
        var rotH = (h - 3 + min / 60) / 12
        var rotM = (min - 15 + sec / 60) / 60
        hourDisplay.x = root.width / 2 - hourDisplay.width / 2 + Math.cos(rotH * 2 * Math.PI) * root.height * .204
        hourDisplay.y = root.height / 2 - hourDisplay.height / 2.04 + Math.sin(rotH * 2 * Math.PI) * root.width * .204
        minuteDisplay.x = root.width / 2 - minuteDisplay.width / 2 + Math.cos(rotM * 2 * Math.PI) * root.height * .369
        minuteDisplay.y = root.height / 2 - minuteDisplay.height / 2.04 + Math.sin(rotM * 2 * Math.PI) * root.width * .369
    }
}
