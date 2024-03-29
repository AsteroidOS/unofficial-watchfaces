/*
 * Copyright (C) 2021 - Timo Könnecke <el-t-mo@arcor.de>
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

import QtQuick 2.1

Item {

    function prepareContext(ctx) {
        ctx.reset()
        ctx.fillStyle = Qt.rgba(1, 1, 1, 0.85)
        ctx.textAlign = "center"
        ctx.textBaseline = 'middle';
        ctx.shadowColor = Qt.rgba(0, 0, 0, 0.7)
        ctx.shadowOffsetX = 0
        ctx.shadowOffsetY = 0
        ctx.shadowBlur = 2
    }

    Canvas {
        id: hourStrokes
        z: 3
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative

        onPaint: {
            var ctx = getContext("2d")

            ctx.lineWidth = parent.width*0.012
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.85)
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 12; i++) {
                ctx.beginPath()
                ctx.moveTo(0, height*0.355)
                ctx.lineTo(0, height*0.33)
                ctx.stroke()
                ctx.rotate(Math.PI/6)
            }
        }
    }

    Canvas {
        id: minuteStrokes

        z: 3
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative

        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = parent.width*0.005
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.85)
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 60; i++) {
                // do not paint a minute stroke when there is an hour stroke
                if ((i%5) != 0) {
                    ctx.beginPath()
                    ctx.moveTo(0, height*0.35)
                    ctx.lineTo(0, height*0.335)
                    ctx.stroke()
                }
                ctx.rotate(Math.PI/30)
            }
        }
    }

    Canvas {
        id: numberStrokes

        property real voffset: -parent.height*0.020
        property real hoffset: -parent.height*0.00

        z: 0
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderStrategy: Canvas.Cooperative

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.fillStyle = Qt.rgba(1, 1, 1, 0.85)
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.4)
            ctx.lineWidth = parent.height*0.004
            ctx.textAlign = "center"
            ctx.textBaseline = 'middle';
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=1; i < 13; i++) {
                ctx.beginPath()
                ctx.font = "80 " + height*0.09 + "px Reglo"
                ctx.fillText(i,
                             Math.cos((i-3)/12 * 2 * Math.PI)*height*0.42-hoffset,
                             (Math.sin((i-3)/12 * 2 * Math.PI)*height*0.42)-voffset)
                ctx.strokeText(i,
                             Math.cos((i-3)/12 * 2 * Math.PI)*height*0.42-hoffset,
                             (Math.sin((i-3)/12 * 2 * Math.PI)*height*0.42)-voffset)
                ctx.closePath()
            }
        }
    }

    Canvas {
        id: hourCanvas

        property int hour: 0

        z: 1
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.8)
            ctx.shadowOffsetX = 1
            ctx.shadowOffsetY = 1
            ctx.shadowBlur = 3
            ctx.beginPath()
            ctx.fillStyle = Qt.rgba(1, 1, 1, 1)
            ctx.arc(parent.width/2, parent.height/2, parent.height*0.024, 0, 2*Math.PI, false)
            ctx.moveTo(parent.width/2+Math.cos(((hour-3.02 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.31,
                       parent.height/2+Math.sin(((hour-3.02 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.31)
            ctx.lineTo(parent.width/2+Math.cos(((hour-3.22 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.2,
                       parent.height/2+Math.sin(((hour-3.22 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.2)
            ctx.lineTo(parent.width/2+Math.cos(((hour-7.00 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.01,
                       parent.height/2+Math.sin(((hour-7.00 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.01)
            ctx.lineTo(parent.width/2+Math.cos(((hour-11 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.01,
                       parent.height/2+Math.sin(((hour-11 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.01)
            ctx.lineTo(parent.width/2+Math.cos(((hour-2.78 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.2,
                       parent.height/2+Math.sin(((hour-2.78 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.2)
            ctx.lineTo(parent.width/2+Math.cos(((hour-2.98 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.31,
                       parent.height/2+Math.sin(((hour-2.98 + wallClock.time.getMinutes()/60) / 12) * 2 * Math.PI)*width*0.31)
            ctx.fill()
            ctx.closePath()
        }
    }

    // minutes
    Canvas {
        id: minuteCanvas

        property int minute: 0

        z: 2
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.8)
            ctx.shadowOffsetX = 1
            ctx.shadowOffsetY = 1
            ctx.shadowBlur = 3
            ctx.beginPath()
            ctx.fillStyle = Qt.rgba(1, 1, 1, 1)
            ctx.moveTo(parent.width/2+Math.cos(((minute - 15.08)/60) * 2 * Math.PI)*width*0.41,
                       parent.height/2+Math.sin(((minute - 15.08)/60) * 2 * Math.PI)*width*0.41)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 15.7)/60) * 2 * Math.PI)*width*0.285,
                       parent.height/2+Math.sin(((minute - 15.7)/60) * 2 * Math.PI)*width*0.285)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 37)/60) * 2 * Math.PI)*width*0.01,
                       parent.height/2+Math.sin(((minute - 37)/60) * 2 * Math.PI)*width*0.01)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 53)/60) * 2 * Math.PI)*width*0.01,
                       parent.height/2+Math.sin(((minute - 53)/60) * 2 * Math.PI)*width*0.01)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 14.3)/60) * 2 * Math.PI)*width*0.285,
                       parent.height/2+Math.sin(((minute - 14.3)/60) * 2 * Math.PI)*width*0.285)
            ctx.lineTo(parent.width/2+Math.cos(((minute - 14.92)/60) * 2 * Math.PI)*width*0.41,
                       parent.height/2+Math.sin(((minute - 14.92)/60) * 2 * Math.PI)*width*0.41)
            ctx.fill()
            ctx.closePath()
        }
    }

    Canvas {
        id: secondCanvas

        property int second: 0

        z: 4
        visible: !displayAmbient
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.8)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 2
            ctx.strokeStyle = "red"
            ctx.lineCap="round"
            ctx.beginPath()
            ctx.lineWidth = parent.height*0.008
            ctx.fillStyle = "red"
            ctx.arc(parent.width/2, parent.height/2, parent.height*0.012, 0, 2*Math.PI, false)
            ctx.fill()
            ctx.moveTo(parent.width/2, parent.height/2)
            ctx.lineTo(parent.width/2+Math.cos((second - 15)/60 * 2 * Math.PI)*width*0.35,
                    parent.height/2+Math.sin((second - 15)/60 * 2 * Math.PI)*width*0.35)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.0)
            ctx.fillStyle = "white"
            ctx.arc(parent.width/2, parent.height/2, parent.height*0.006, 0, 2*Math.PI, false)
            ctx.fill()
            ctx.closePath()
        }
    }

    Image {
        id: logoAsteroid
        source: "../watchfaces-img/asteroid-logo.svg"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: parent.height*0.18
        width: parent.width/8
        height: width
    }

    Canvas {
        id: dowCanvas

        anchors.fill: parent
        renderStrategy: Canvas.Cooperative

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"

            var bold = "0 "
            var px = "px "

            var centerX = width/10*3.25
            var centerY = height/2
            var verticalOffset = height*0.0125

            var text;
            text = wallClock.time.toLocaleString(Qt.locale(), "ddd").slice(0, 2).toUpperCase()

            var fontSize = height*0.05
            var fontFamily = "Reglo"
            ctx.font = bold + fontSize + px + fontFamily;
            ctx.fillText(text, centerX, centerY+verticalOffset);
        }
    }

    Canvas {
        id: amPmCanvas

        property bool am: false

        anchors.fill: parent
        renderStrategy: Canvas.Cooperative

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)

            var bold = "64 "
            var px = "px "

            var centerX = width/10*6.75
            var centerY = height/2
            var verticalOffset = height*0.0125

            var text;
            text = wallClock.time.toLocaleString(Qt.locale(), "ap").slice(0, 2).toUpperCase()

            var fontSize = height*0.05
            var fontFamily = "Reglo"
            ctx.font = bold + fontSize + px + fontFamily;
            ctx.fillText(text, centerX, centerY+verticalOffset);
        }
    }

    Canvas {
        id: dateCanvas

        property int date: 0

        anchors.fill: parent
        antialiasing: true
        renderStrategy: Canvas.Cooperative


        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.font = "60 " + height*0.075 + "px Reglo"
            ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "dd"),
                         width/2,
                         height*0.315);
        }
    }

    Canvas {
        id: monthCanvas
        anchors.fill: parent
        antialiasing: true
        renderStrategy: Canvas.Cooperative

        property int month: 0

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.font = "40 " + height*0.05 + "px Reglo"
            ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "MMMM").toUpperCase(),
                         width/2,
                         height*0.372);
        }
    }

    Connections {
        target: wallClock
        function onTimeChanged() {
            var hour = wallClock.time.getHours()
            var minute = wallClock.time.getMinutes()
            var second = wallClock.time.getSeconds()
            var date = wallClock.time.getDate()
            var am = hour < 12
            if(use12H.value) {
                hour = hour % 12
                if (hour === 0) hour = 12;
            }
            if(minuteCanvas.minute !== minute) {
                minuteCanvas.minute = minute
                minuteCanvas.requestPaint()
                hourCanvas.hour = hour
                hourCanvas.requestPaint()
            } if(secondCanvas.second !== second) {
                secondCanvas.second = second
                secondCanvas.requestPaint()
            } if(dateCanvas.date !== date) {
                dateCanvas.date = date
                dateCanvas.requestPaint()
                monthCanvas.requestPaint()
                dowCanvas.requestPaint()
            } if(amPmCanvas.am != am) {
                amPmCanvas.am = am
                amPmCanvas.requestPaint()
            }
        }
    }

    Component.onCompleted: {
        var hour = wallClock.time.getHours()
        var minute = wallClock.time.getMinutes()
        var second = wallClock.time.getSeconds()
        var date = wallClock.time.getDate()
        var am = hour < 12
        if(use12H.value) {
            hour = hour % 12
            if (hour === 0) hour = 12
        }
        hourCanvas.hour = hour
        hourCanvas.requestPaint()
        minuteCanvas.minute = minute
        minuteCanvas.requestPaint()
        secondCanvas.second = second
        secondCanvas.requestPaint()
        dateCanvas.date = date
        dateCanvas.requestPaint()
        dowCanvas.requestPaint()
        monthCanvas.requestPaint()
        amPmCanvas.am = am
        amPmCanvas.requestPaint()
    }
}
