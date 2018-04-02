/*
 * Copyright (C) 2018 - Timo Könnecke <el-t-mo@arcor.de>
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
 * Based on 002-analog stock watchface.
 * emulated image/png shadow by redrawing path in canvas.
 */

import QtQuick 2.1

Item {

    function prepareContext(ctx) {
        ctx.reset()
        ctx.fillStyle = Qt.rgba(1, 1, 1, 0.85)
        ctx.textAlign = "center"
        ctx.textBaseline = 'middle';
        ctx.shadowColor = Qt.rgba(0, 0, 0, 0.75)
        ctx.shadowOffsetX = parent.height * 0.00625
        ctx.shadowOffsetY = parent.height * 0.00625 //2 px on 320x320
        ctx.shadowBlur = parent.height * 0.01875  //6 px on 320x320
    }

    Image {
        z: 10
        id: logo
        source: "asteroid_logo.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width/2.5
        height: parent.height/2.5
    }

    Canvas {
        z: 9
        id: logoShadowPath
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.75)
            ctx.shadowOffsetX = 4
            ctx.shadowOffsetY = 4
            ctx.shadowBlur = 12
            ctx.lineWidth = parent.width*0.05
            ctx.beginPath()
            ctx.fillStyle = Qt.rgba(1, 1, 1, 5)
            ctx.moveTo(parent.width/3.3,
                       parent.height/2)
            ctx.lineTo(parent.width/2,
                       parent.height/3.3)
            ctx.lineTo(parent.width/1.44,
                       parent.height/2)
            ctx.lineTo(parent.width/2,
                       parent.height/1.44)
            ctx.lineTo(parent.width/2,
                       parent.height/1.60)
            ctx.lineTo(parent.width/1.6,
                       parent.height/2)
            ctx.lineTo(parent.width/1.85,
                       parent.height/2.4)
            ctx.lineTo(parent.width/2,
                       parent.height/2.2)
            ctx.lineTo(parent.width/2.18,
                       parent.height/2.4)
            ctx.lineTo(parent.width/2.42,
                       parent.height/2.16)
            ctx.lineTo(parent.width/2.18,
                       parent.height/1.98)
            ctx.lineTo(parent.width/2,
                       parent.height/2.14)
            ctx.lineTo(parent.width/1.88,
                       parent.height/2)
            ctx.lineTo(parent.width/2.20,
                       parent.height/1.73)
            ctx.lineTo(parent.width/2,
                       parent.height/1.60)
            ctx.lineTo(parent.width/2,
                       parent.height/1.44)
            ctx.fill()
            ctx.closePath()
        }
    }

    // hour strokes
    Canvas {
        z: 1
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.shadowBlur = parent.height * 0.01875  //6 px on 320x320
            ctx.lineWidth = parent.width*0.012
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.85)
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 12; i++) {
                // do not paint main hour strokes
                //if ( i%3 != 0) {

                ctx.beginPath()
                ctx.moveTo(0, height*0.42)
                ctx.lineTo(-height*0.0096, height*0.43)

                ctx.lineTo(0, height*0.44)
                ctx.lineTo(+height*0.0096, height*0.43)
                ctx.lineTo(0, height*0.42)


                ctx.stroke()
                //}
                ctx.rotate(Math.PI/6)

            }
        }
    }

    // hours
    Canvas {
        z: 3
        id: hourCanvas
        property var hour: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.beginPath()
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1)
            ctx.fillStyle = Qt.rgba(1, 1, 1, 1)

            ctx.lineWidth = parent.width*0.048
            ctx.moveTo(parent.width/2+Math.cos(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.13,
                       parent.height/2+Math.sin(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.13)
            ctx.lineTo(parent.width/2+Math.cos(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.255,
                       parent.height/2+Math.sin(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.255)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()


            ctx.lineWidth = parent.width*0.024
            ctx.moveTo(parent.width/2+Math.cos(((hour-3.35 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.336,
                       parent.height/2+Math.sin(((hour-3.35 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.336)
            ctx.lineTo(parent.width/2+Math.cos(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.388,
                       parent.height/2+Math.sin(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.388)
            ctx.lineTo(parent.width/2+Math.cos(((hour-2.65 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.336,
                       parent.height/2+Math.sin(((hour-2.65 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.336)
            ctx.lineTo(parent.width/2+Math.cos(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.27,
                       parent.height/2+Math.sin(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.27)
            ctx.lineTo(parent.width/2+Math.cos(((hour-3.35 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.336,
                       parent.height/2+Math.sin(((hour-3.35 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.336)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()

            ctx.lineWidth = parent.width*0.05
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.0)
            ctx.moveTo(parent.width/2+Math.cos(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.13,
                       parent.height/2+Math.sin(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.13)
            ctx.lineTo(parent.width/2+Math.cos(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.28,
                       parent.height/2+Math.sin(((hour-3 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.28)
            ctx.stroke()
            ctx.closePath()
        }
    }

    // minutes
    Canvas {
        z: 4
        id: minuteCanvas
        property var minute: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.lineWidth = parent.width*0.03
            ctx.beginPath()
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1)
            ctx.moveTo(parent.width/2+Math.cos(((minute - 15)/60) * 2 * Math.PI)*width*0.13,
                       parent.height/2+Math.sin(((minute - 15)/60) * 2 * Math.PI)*width*0.13)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 15)/60) * 2 * Math.PI)*width*0.395,
                       parent.height/2+Math.sin(((minute - 15)/60) * 2 * Math.PI)*width*0.395)
            ctx.stroke()
            ctx.closePath()
            ctx.lineWidth = parent.width*0.014
            ctx.beginPath()
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1)
            ctx.moveTo(parent.width/2+Math.cos(((minute - 15.75)/60) * 2 * Math.PI)*width*0.432,
                       parent.height/2+Math.sin(((minute - 15.75)/60) * 2 * Math.PI)*width*0.432)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 15)/60) * 2 * Math.PI)*width*0.464,
                       parent.height/2+Math.sin(((minute - 15)/60) * 2 * Math.PI)*width*0.464)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 14.25)/60) * 2 * Math.PI)*width*0.432,
                       parent.height/2+Math.sin(((minute - 14.25)/60) * 2 * Math.PI)*width*0.432)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 15)/60) * 2 * Math.PI)*width*0.395,
                       parent.height/2+Math.sin(((minute - 15)/60) * 2 * Math.PI)*width*0.395)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 15.75)/60) * 2 * Math.PI)*width*0.432,
                       parent.height/2+Math.sin(((minute - 15.75)/60) * 2 * Math.PI)*width*0.432)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1)
            ctx.lineWidth = parent.width*0.03
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.0)
            ctx.moveTo(parent.width/2+Math.cos(((minute - 15)/60) * 2 * Math.PI)*width*0.13,
                       parent.height/2+Math.sin(((minute - 15)/60) * 2 * Math.PI)*width*0.13)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 15)/60) * 2 * Math.PI)*width*0.405,
                       parent.height/2+Math.sin(((minute - 15)/60) * 2 * Math.PI)*width*0.405)
            ctx.stroke()
            ctx.closePath()
        }
    }

    // seconds
    Canvas {
        z: 5
        id: secondCanvas
        property var second: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.strokeStyle = "red"
            ctx.beginPath()
            ctx.lineWidth = parent.height*0.008
            ctx.moveTo(parent.width/2+Math.cos((second - 15)/60 * 2 * Math.PI)*width*0.13,
                       parent.height/2+Math.sin((second - 15)/60 * 2 * Math.PI)*width*0.13)
            ctx.lineTo(parent.width/2+Math.cos((second - 15)/60 * 2 * Math.PI)*width*0.432,
                    parent.height/2+Math.sin((second - 15)/60 * 2 * Math.PI)*width*0.432)
            ctx.stroke()
            ctx.closePath()

        }
    }

    Connections {
        target: wallClock
        onTimeChanged: {
            var hour = wallClock.time.getHours()
            var minute = wallClock.time.getMinutes()
            var second = wallClock.time.getSeconds()

            if(hourCanvas.hour != hour) {
                hourCanvas.hour = hour
                hourCanvas.requestPaint()
            } if(minuteCanvas.minute != minute) {
                minuteCanvas.minute = minute
                minuteCanvas.requestPaint()
            } if(secondCanvas.second != second) {
                secondCanvas.second = second
                secondCanvas.requestPaint()
            }
        }
    }

    Component.onCompleted: {
        var hour = wallClock.time.getHours()
        var minute = wallClock.time.getMinutes()
        var second = wallClock.time.getSeconds()
        hourCanvas.hour = hour
        hourCanvas.requestPaint()
        minuteCanvas.minute = minute
        minuteCanvas.requestPaint()
        secondCanvas.second = second
        secondCanvas.requestPaint()
    }
}
