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
 * Main attraction of this watchface is the seconds arm advancing over the center
 * of the clock. Also the hour and minute arms got an advanced outer and center part.
 * Overall design is a recreation of vintage 70s BRAUN clock arms with thick strokes.
 */

import QtQuick 2.9

Item {
    property real radian: 0.01745

    // hour strokes
    Canvas {
        z: 0
        anchors.fill: parent
        smooth: true
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineCap="round"
            ctx.lineWidth = parent.width*0.10
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.65)
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 12; i++) {
                ctx.beginPath()
                ctx.moveTo(0, height*0.398)
                ctx.lineTo(0, height*0.3981)
                ctx.stroke()
                ctx.rotate(Math.PI/6)
            }
        }
    }

    // number strokes
    Canvas {
        z: 1
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderStrategy: Canvas.Cooperative
        property real voffset: -parent.height*0.015
        property real hoffset: -parent.height*0.003
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.fillStyle = Qt.rgba(1, 1, 1, 0.85)
            ctx.textAlign = "center"
            ctx.textBaseline = 'middle';
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=1; i < 13; i++) {
                ctx.beginPath()
                ctx.font = "99 " + height/13 + "px Fyodor"
                ctx.fillText(i,
                             i === 10 ? Math.cos((i-3)/12 * 2 * Math.PI)*height*0.402-hoffset :
                                        i === 1 || i === 12 ? Math.cos((i-3)/12 * 2 * Math.PI)*height*0.390-hoffset :
                                                              Math.cos((i-3)/12 * 2 * Math.PI)*height*0.398-hoffset,
                             (Math.sin((i-3)/12 * 2 * Math.PI)*height*0.398)-voffset)
                ctx.closePath()
            }
        }
    }

    Canvas {
        z: 0
        id: hourHand
        property int hour: 0
        property real rotH: (hour-3 + wallClock.time.getMinutes()/60) / 12
        anchors.fill: parent
        smooth: true
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.beginPath()
            ctx.lineWidth = parent.width*0.030
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.75)
            ctx.moveTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*width*0.0494,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width*0.0494)
            ctx.lineTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*width*0.0855,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width*0.0855)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()
            ctx.lineCap="round"
            ctx.lineWidth = parent.width*0.057
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.75)
            ctx.moveTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*width*0.11,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width*0.11)
            ctx.lineTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*width*0.267,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width*0.267)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()
            ctx.lineWidth = parent.width*0.033
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1)
            ctx.moveTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*width*0.112,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width*0.112)
            ctx.lineTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*width*0.265,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width*0.265)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()
            ctx.lineWidth = parent.width*0.008
            ctx.moveTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*width*0.05,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width*0.05)
            ctx.lineTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*width*0.122,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width*0.122)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()
            ctx.lineWidth = parent.width*0.015
            ctx.strokeStyle = Qt.rgba(0.945, 0.769, 0.059, 1)
            ctx.moveTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*width*0.113,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width*0.113)
            ctx.lineTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*width*0.264,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width*0.264)
            ctx.stroke()
            ctx.closePath()
        }
    }

    Canvas {
        z: 1
        id: minuteHand
        property int minute: 0
        property real rotM: (minute - 15)/60
        anchors.fill: parent
        smooth: true
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.beginPath()
            ctx.lineWidth = parent.width*0.030
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.75)
            ctx.moveTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*width*0.0494,
                       parent.height/2+Math.sin(rotM * 2 * Math.PI)*width*0.0494)
            //outer line
            ctx.lineTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*width*0.098,
                       parent.height/2+Math.sin(rotM * 2 * Math.PI)*width*0.098)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()
            ctx.lineCap="round"
            ctx.lineWidth = parent.width*0.052
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.75)
            ctx.moveTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*width*0.12,
                       parent.height/2+Math.sin(rotM * 2 * Math.PI)*width*0.12)
            //outer line
            ctx.lineTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*width*0.355,
                       parent.height/2+Math.sin(rotM * 2 * Math.PI)*width*0.355)
            ctx.stroke()
            ctx.closePath()
            ctx.lineWidth = parent.width*0.028
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1)
            ctx.beginPath()
            ctx.shadowBlur = 0
            //inner line
            ctx.moveTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*width*0.122,
                       parent.height/2+Math.sin(rotM * 2 * Math.PI)*width*0.122)
            ctx.lineTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*width*0.357,
                       parent.height/2+Math.sin(rotM * 2 * Math.PI)*width*0.357)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()
            ctx.shadowBlur = 0
            //inner line
            ctx.lineWidth = parent.width*0.008
            ctx.moveTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*width*0.05,
                       parent.height/2+Math.sin(rotM * 2 * Math.PI)*width*0.05)
            ctx.lineTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*width*0.122,
                       parent.height/2+Math.sin(rotM * 2 * Math.PI)*width*0.122)
            ctx.stroke()
            ctx.closePath()
            ctx.strokeStyle = Qt.rgba(0.902, 0.494, 0.133, 1)
            ctx.lineWidth = parent.width*0.01

            ctx.beginPath()
            ctx.shadowBlur = 0
            //inner line
            ctx.moveTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*width*0.123,
                       parent.height/2+Math.sin(rotM * 2 * Math.PI)*width*0.123)
            ctx.lineTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*width*0.356,
                       parent.height/2+Math.sin(rotM * 2 * Math.PI)*width*0.356)
            ctx.stroke()
            ctx.closePath()
        }
    }

    Canvas {
        z: 2
        id: secondHand
        property int second: 0
        anchors.fill: parent
        smooth: true
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.7)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 1
            ctx.strokeStyle = Qt.rgba(0.871, 0.165, 0.102, 1)
            ctx.lineWidth = parent.height*0.006
            ctx.closePath()
            ctx.beginPath()

            ctx.moveTo(parent.width/2+Math.cos((second - 15)/60 * 2 * Math.PI)*width*0.05,
                       parent.height/2+Math.sin((second - 15)/60 * 2 * Math.PI)*width*0.05)
            ctx.lineTo(parent.width/2+Math.cos((second - 15)/60 * 2 * Math.PI)*width*0.325,
                       parent.height/2+Math.sin((second - 15)/60 * 2 * Math.PI)*width*0.325)
            ctx.stroke()
            ctx.closePath()
        }
    }

    Canvas {
        z: 4
        id: dateCanvas
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderStrategy: Canvas.Cooperative

        property var date: 0

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.beginPath()
            ctx.fillStyle = Qt.rgba(0, 0, 0, 0.75)
            ctx.arc(parent.width/2, parent.height/2, parent.height*0.056, 0, 2*Math.PI, false)
            ctx.fill()
            ctx.closePath()
            ctx.fillStyle = "white"
            ctx.textAlign = "center"
            ctx.textBaseline = 'middle';
            ctx.font = "99 " + height/14 + "px Noto Sans"
            ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "d"),
                         width/2,
                         height/1.975);
        }
    }


    Connections {
        target: wallClock
        function onTimeChanged() {
            var hour = wallClock.time.getHours()
            var minute = wallClock.time.getMinutes()
            var second = wallClock.time.getSeconds()
            var date = wallClock.time.getDate()
            if(secondHand.second != second) {
                secondHand.second = second
                secondHand.requestPaint()
            }if(minuteHand.minute != minute) {
                minuteHand.minute = minute
                minuteHand.requestPaint()
                hourHand.hour = hour
                hourHand.requestPaint()
            }if(dateCanvas.date != date) {
                dateCanvas.date = date
                dateCanvas.requestPaint()
            }
        }
    }

    Component.onCompleted: {
        var hour = wallClock.time.getHours()
        var minute = wallClock.time.getMinutes()
        var second = wallClock.time.getSeconds()
        var date = wallClock.time.getDate()
        secondHand.second = second
        secondHand.requestPaint()
        minuteHand.minute = minute
        minuteHand.requestPaint()
        hourHand.hour = hour
        hourHand.requestPaint()
        dateCanvas.date = date
        dateCanvas.requestPaint()
    }
}
