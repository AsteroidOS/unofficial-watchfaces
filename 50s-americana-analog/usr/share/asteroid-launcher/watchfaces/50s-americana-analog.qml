/*
* Copyright (C) 2018 - Timo Könnecke <el-t-mo@arcor.de>
 *              2017 - Mario Kicherer <dev@kicherer.org>
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
 * This watchface is based on the official analog watchface and its successor analog-precision.
 * Most noticable change is the numbered hour strokes and the clock arms designed with
 * filled line-paths opposed to simple stroked lines in earlier variants.
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
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.5)
            ctx.shadowOffsetX = 2
            ctx.shadowOffsetY = 2
            ctx.shadowBlur = 2
            ctx.beginPath()
            ctx.fillStyle = Qt.rgba(0, 0, 0, 1)
            ctx.moveTo(parent.width/2+Math.cos(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.27,
                       parent.height/2+Math.sin(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.27)
            ctx.lineTo(parent.width/2+Math.cos(((hour-3.07 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.26,
                       parent.height/2+Math.sin(((hour-3.07 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.26)
            ctx.lineTo(parent.width/2+Math.cos(((hour-8.80 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.16,
                       parent.height/2+Math.sin(((hour-8.80 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.16)
            ctx.lineTo(parent.width/2+Math.cos(((hour-9.20 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.16,
                       parent.height/2+Math.sin(((hour-9.20 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.16)
            ctx.lineTo(parent.width/2+Math.cos(((hour-2.93 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.26,
                       parent.height/2+Math.sin(((hour-2.93 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.26)
            ctx.lineTo(parent.width/2+Math.cos(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.27,
                       parent.height/2+Math.sin(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.27)
            ctx.fill()
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
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.5)
            ctx.shadowOffsetX = 1
            ctx.shadowOffsetY = 1
            ctx.shadowBlur = 2
            ctx.beginPath()
            ctx.fillStyle = Qt.rgba(0, 0, 0, 1)
            ctx.moveTo(parent.width/2+Math.cos(((minute - 15)/60) * 2 * Math.PI)*width*0.44,
                       parent.height/2+Math.sin(((minute - 15)/60) * 2 * Math.PI)*width*0.44)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 15.2)/60) * 2 * Math.PI)*width*0.43,
                       parent.height/2+Math.sin(((minute - 15.2)/60) * 2 * Math.PI)*width*0.43)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 44)/60) * 2 * Math.PI)*width*0.16,
                       parent.height/2+Math.sin(((minute - 44)/60) * 2 * Math.PI)*width*0.16)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 46)/60) * 2 * Math.PI)*width*0.16,
                       parent.height/2+Math.sin(((minute - 46)/60) * 2 * Math.PI)*width*0.16)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 14.8)/60) * 2 * Math.PI)*width*0.43,
                       parent.height/2+Math.sin(((minute - 14.8)/60) * 2 * Math.PI)*width*0.43)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 15)/60) * 2 * Math.PI)*width*0.44,
                       parent.height/2+Math.sin(((minute - 15)/60) * 2 * Math.PI)*width*0.44)
            ctx.fill()
            ctx.closePath()
        }
    }

    // seconds
    Canvas {
        z: 4
        id: secondHand
        property var second: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.5)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 2
            ctx.strokeStyle = "red"
            ctx.lineWidth = parent.height*0.008
            ctx.beginPath()
            ctx.moveTo(parent.width/2, parent.height/2)
            ctx.lineTo(parent.width/2+Math.cos((second - 45)/60 * 2 * Math.PI)*width*0.07,
                    parent.height/2+Math.sin((second - 45)/60 * 2 * Math.PI)*width*0.07)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()
            ctx.lineWidth = parent.height*0.022
            ctx.moveTo(parent.width/2+Math.cos((second - 45)/60 * 2 * Math.PI)*width*0.07,
                       parent.height/2+Math.sin((second - 45)/60 * 2 * Math.PI)*width*0.07)
            ctx.lineTo(parent.width/2+Math.cos((second - 45)/60 * 2 * Math.PI)*width*0.16,
                    parent.height/2+Math.sin((second - 45)/60 * 2 * Math.PI)*width*0.16)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()
            ctx.lineWidth = parent.height*0.008
            ctx.fillStyle = "red"
            ctx.arc(parent.width/2, parent.height/2, parent.height*0.012, 0, 2*Math.PI, false)
            ctx.fill()
            ctx.moveTo(parent.width/2, parent.height/2)
            ctx.lineTo(parent.width/2+Math.cos((second - 15)/60 * 2 * Math.PI)*width*0.32,
                    parent.height/2+Math.sin((second - 15)/60 * 2 * Math.PI)*width*0.32)
            ctx.stroke()
            ctx.closePath()

        }
    }

    // background circle
    Canvas {
        z: 0
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.fillStyle = Qt.rgba(0.988, 0.98, 0.945, 0.4)
            ctx.beginPath()
            ctx.arc(parent.height/2, parent.width/2, parent.width*0.5, 0*radian, 360*radian, false);
            ctx.fill()
            ctx.closePath()
        }
    }

    // number strokes
    Canvas {
        z: 3
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject
        property var voffset: -parent.height*0.022
        property var hoffset: -parent.height*0.007
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.fillStyle = "black"
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.90)
            ctx.textAlign = "center"
            ctx.textBaseline = 'middle';
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=1; i < 13; i++) {
                ctx.beginPath()
                ctx.font = height*0.15 + "px Fyodor"
                ctx.fillText(i,
                             Math.cos((i-3)/12 * 2 * Math.PI)*height*0.37-hoffset,
                             (Math.sin((i-3)/12 * 2 * Math.PI)*height*0.37)-voffset)
                ctx.closePath()
            }
        }
    }

    // hour strokes
    Canvas {
        z: 3
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")

            ctx.lineWidth = parent.width*0.015
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.9)
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 12; i++) {
                ctx.beginPath()
                ctx.moveTo(0, height*0.45)
                ctx.lineTo(0, height*0.47)
                ctx.stroke()
                ctx.rotate(Math.PI/6)
            }
        }
    }

    // minute strokes
    Canvas {
        z: 3
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = parent.width*0.007
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.9)
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 60; i++) {
                // do not paint a minute stroke when there is an hour stroke
                if ((i%5) != 0) {
                    ctx.beginPath()
                    ctx.moveTo(0, height*0.45)
                    ctx.lineTo(0, height*0.47)
                    ctx.stroke()
                }
                ctx.rotate(Math.PI/30)
            }
        }
    }

    Text {
        id: monthDisplay
        z: 5
        renderType: Text.NativeRendering
        font.pixelSize: parent.height*0.08
        color: "black"
        font.family: "Fyodor"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: parent.width*0.015
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: parent.height*0.195
        text: Qt.formatDate(wallClock.time, "MMM dd")
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
