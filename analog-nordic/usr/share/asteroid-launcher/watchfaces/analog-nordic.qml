/*
* Copyright (C) 2018 - Timo Könnecke <el-t-mo@arcor.de>
*               2017 - Mario Kicherer <dev@kicherer.org>
*               2016 - Sylvia van Os <iamsylvie@openmailbox.org>
*               2015 - Florent Revest <revestflo@gmail.com>
*               2012 - Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
*                      Aleksey Mikhailichenko <a.v.mich@gmail.com>
*                      Arto Jalkanen <ajalkane@gmail.com>
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

/*
 * This watchface is based on the official analog watchface and analog-precision.
 * Main attraction of this watchface is the number strokes and complicated clock-hands
 * Both hands have golden finish with gradients.
 */

import QtQuick 2.1

Item {
    property var radian: 0.01745

    // hours
    Canvas {
        z: 1
        id: hourHand
        property var hour: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.6)
            ctx.shadowOffsetX = 3
            ctx.shadowOffsetY = 3
            ctx.shadowBlur = 4
            ctx.beginPath()
            ctx.lineWidth = parent.height*0.0045
            var gradient = ctx.createRadialGradient (parent.width/2,
                                                     parent.height/2,
                                                     0,
                                                     parent.width/2,
                                                     parent.height/2,
                                                     parent.width *0.35)
            gradient.addColorStop(0.1, Qt.rgba(0.298, 0.251, 0, 1)) // darker gold
            gradient.addColorStop(0.3, Qt.rgba(0.898, 0.757, 0, 1)) // light gold center
            gradient.addColorStop(0.6, Qt.rgba(0.6, 0.506, 0, 1)) // dark gold tip

            ctx.strokeStyle = gradient

            var gradient2 = ctx.createLinearGradient (parent.width/2+Math.cos(((hour-6 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.033,
                                                      parent.height/2+Math.sin(((hour-6 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.033,
                                                      parent.width/2+Math.cos(((hour+0 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.033,
                                                      parent.height/2+Math.sin(((hour+0 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.033)
            gradient2.addColorStop(0.3, Qt.rgba(0.8, 0.675, 0, 1)) // darker gold
            gradient2.addColorStop(0.5, Qt.rgba(1, 0.906, 0.4, 1)) // light gold center
            gradient2.addColorStop(0.7, Qt.rgba(0.8, 0.675, 0, 1)) // dark gold tip
            ctx.fillStyle = gradient2
            ctx.moveTo(parent.width/2+Math.cos(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.285,
                       parent.height/2+Math.sin(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.285)
            ctx.lineTo(parent.width/2+Math.cos(((hour-3.12 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.275,
                       parent.height/2+Math.sin(((hour-3.12 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.275)
            ctx.lineTo(parent.width/2+Math.cos(((hour-6 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.033,
                       parent.height/2+Math.sin(((hour-6 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.033)
            ctx.lineTo(parent.width/2+Math.cos(((hour+0 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.033,
                       parent.height/2+Math.sin(((hour+0 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.033)

            ctx.lineTo(parent.width/2+Math.cos(((hour-2.88 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.275,
                       parent.height/2+Math.sin(((hour-2.88 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.275)
            ctx.lineTo(parent.width/2+Math.cos(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.285,
                       parent.height/2+Math.sin(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.285)
            ctx.fill()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.0)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.5)
            ctx.moveTo(parent.width/2,
                       parent.height/2)
            ctx.lineTo(parent.width/2+Math.cos(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.284,
                       parent.height/2+Math.sin(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.284)
            ctx.stroke()
            ctx.closePath()


        }
    }

    // minutes
    Canvas {
        z: 2
        id: minuteHand
        property var minute: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.6)
            ctx.shadowOffsetX = 3
            ctx.shadowOffsetY = 3
            ctx.shadowBlur = 4
            ctx.beginPath()
            ctx.lineWidth = parent.height*0.0045
            var gradient = ctx.createRadialGradient (parent.width/2,
                                                     parent.height/2,
                                                     0,
                                                     parent.width/2,
                                                     parent.height/2,
                                                     parent.width *0.29)
            gradient.addColorStop(0.1, Qt.rgba(0.298, 0.251, 0, 1)) // darker gold
            gradient.addColorStop(0.3, Qt.rgba(0.898, 0.757, 0, 1)) // light gold center
            gradient.addColorStop(0.6, Qt.rgba(0.6, 0.506, 0, 1)) // dark gold tip

            ctx.strokeStyle = gradient
            var gradient2 = ctx.createLinearGradient (parent.width/2+Math.cos(((minute - 30)/60) * 2 * Math.PI)*width*0.03,
                                                      parent.height/2+Math.sin(((minute - 30)/60) * 2 * Math.PI)*width*0.03,
                                                      parent.width/2+Math.cos(((minute + 0)/60) * 2 * Math.PI)*width*0.03,
                                                      parent.height/2+Math.sin(((minute + 0)/60) * 2 * Math.PI)*width*0.03)
            gradient2.addColorStop(0.3, Qt.rgba(0.8, 0.675, 0, 1)) // darker gold
            gradient2.addColorStop(0.5, Qt.rgba(1, 0.906, 0.4, 1)) // light gold center
            gradient2.addColorStop(0.7, Qt.rgba(0.8, 0.675, 0, 1)) // dark gold tip

            ctx.fillStyle = gradient2
            ctx.moveTo(parent.width/2+Math.cos(((minute - 15)/60) * 2 * Math.PI)*width*0.45,
                       parent.height/2+Math.sin(((minute - 15)/60) * 2 * Math.PI)*width*0.45)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 15.3)/60) * 2 * Math.PI)*width*0.445,
                       parent.height/2+Math.sin(((minute - 15.3)/60) * 2 * Math.PI)*width*0.445)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 30)/60) * 2 * Math.PI)*width*0.03,
                       parent.height/2+Math.sin(((minute - 30)/60) * 2 * Math.PI)*width*0.03)
            ctx.lineTo(parent.width/2+Math.cos(((minute + 0)/60) * 2 * Math.PI)*width*0.03,
                       parent.height/2+Math.sin(((minute + 0)/60) * 2 * Math.PI)*width*0.03)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 14.7)/60) * 2 * Math.PI)*width*0.445,
                       parent.height/2+Math.sin(((minute - 14.7)/60) * 2 * Math.PI)*width*0.445)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 15)/60) * 2 * Math.PI)*width*0.45,
                       parent.height/2+Math.sin(((minute - 15)/60) * 2 * Math.PI)*width*0.45)
            ctx.fill()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.0)
            ctx.stroke()
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.5)
            ctx.moveTo(parent.width/2,
                       parent.height/2)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 15)/60) * 2 * Math.PI)*width*0.448,
                       parent.height/2+Math.sin(((minute - 15)/60) * 2 * Math.PI)*width*0.448)
            ctx.stroke()
            ctx.closePath()
        }
    }

    Canvas {
        z: 3
        id: secondHand
        property var second: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.7)
            ctx.shadowOffsetX = 5
            ctx.shadowOffsetY = 5
            ctx.shadowBlur = 3
            ctx.strokeStyle = "red"
            ctx.lineWidth = parent.height*0.01
            ctx.beginPath()
            ctx.moveTo(parent.width/2, parent.height/2)
            ctx.lineTo(parent.width/2+Math.cos((second - 45)/60 * 2 * Math.PI)*width*0.15,
                       parent.height/2+Math.sin((second - 45)/60 * 2 * Math.PI)*width*0.15)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()
            ctx.lineWidth = parent.height*0.006
            ctx.arc(parent.width/2, parent.height/2, parent.height*0.012, 0, 2*Math.PI, false)
            ctx.fill()
            ctx.moveTo(parent.width/2, parent.height/2)
            ctx.lineTo(parent.width/2+Math.cos((second - 15)/60 * 2 * Math.PI)*width*0.45,
                       parent.height/2+Math.sin((second - 15)/60 * 2 * Math.PI)*width*0.45)
            ctx.stroke()
            ctx.closePath()

        }
    }

    // dot
    Canvas {
        z: 11
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.beginPath()
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 1)
            ctx.lineWidth = parent.height*0.0185
            ctx.arc(parent.width/2, parent.height/2, parent.height*0.024, 0, 2*Math.PI, false)
            ctx.stroke()
            ctx.closePath()
        }
    }

    // hour strokes
    Canvas {
        z: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")

            ctx.lineWidth = parent.width*0.0093
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1)
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.7)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 2
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 12; i++) {
                if ( i%3 != 0) {
                    ctx.beginPath()
                    ctx.moveTo(0, height*0.3)
                    ctx.lineTo(0, height*0.42)
                    ctx.stroke()
                }
                ctx.rotate(Math.PI/6)
            }
        }
    }

    // minute strokes
    Canvas {
        z: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = parent.width*0.014
            ctx.lineCap = "round"
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1)
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.7)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 2
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 60; i++) {

                ctx.beginPath()
                ctx.moveTo(0, height*0.46)
                ctx.lineTo(0, height*0.461)
                ctx.stroke()

                ctx.rotate(Math.PI/30)
            }
        }
    }

    // number strokes
    Canvas {
        z: 0
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject
        property var voffset: -parent.height*0.025
        property var hoffset: parent.height*0.0
        onPaint: {
            var ctx = getContext("2d")
            ctx.fillStyle = Qt.rgba(1, 1, 1, 0.9)
            ctx.lineWidth = parent.height*0.0124
            ctx.font = "0 " + height*0.18 + "px FatCow"
            ctx.textAlign = "center"
            ctx.textBaseline = 'middle';
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.3)
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 12; i=i+3) {
                ctx.beginPath()
                ctx.strokeText(i != 0 ? i: 12,
                                        Math.cos((i-3)/12 * 2 * Math.PI)*height*0.346-hoffset,
                                        Math.sin((i-3)/12 * 2 * Math.PI)*height*0.346-voffset)
                ctx.fillText(i != 0 ? i: 12,
                                      Math.cos((i-3)/12 * 2 * Math.PI)*height*0.34-hoffset,
                                      Math.sin((i-3)/12 * 2 * Math.PI)*height*0.34-voffset)

                ctx.closePath()
            }
        }
    }

    Connections {
        target: wallClock
        onTimeChanged: {
            var hour = wallClock.time.getHours()
            var minute = wallClock.time.getMinutes()
            var second = wallClock.time.getSeconds()
            if(secondHand.second != second) {
                secondHand.second = second
                secondHand.requestPaint()
            }if(minuteHand.minute != minute) {
                minuteHand.minute = minute
                minuteHand.requestPaint()
            }if(hourHand.hour != hour) {
                hourHand.hour = hour
                hourHand.requestPaint()
            }
        }
    }

    Component.onCompleted: {
        var hour = wallClock.time.getHours()
        var minute = wallClock.time.getMinutes()
        var second = wallClock.time.getSeconds()
        secondHand.second = second
        secondHand.requestPaint()
        minuteHand.minute = minute
        minuteHand.requestPaint()
        hourHand.hour = hour
        hourHand.requestPaint()
    }
}
