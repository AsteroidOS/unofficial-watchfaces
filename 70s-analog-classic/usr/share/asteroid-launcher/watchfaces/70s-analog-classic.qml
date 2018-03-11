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

import QtQuick 2.1

Item {
    property var radian: 0.01745329252


    // day
    Text {
        id: dayDisplay
        z: 0
        property var offset: height*0.4
        font.pixelSize: parent.height/24
        color: "white"
        opacity: 0.65
        font.family: "League Spartan"
        horizontalAlignment: Text.AlignHCenter
        style: Text.Outline; styleColor: Qt.rgba(0, 0, 0, 0.8)
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height/4-offset
        text: Qt.formatDate(wallClock.time, "dddd").toUpperCase()
    }

    Text {
        id: digitalDisplay
        z: 0
        property var offset: height*0.4
        font.pixelSize: parent.height/16
        color: "white"
        opacity: 0.65
        font.family: "League Spartan"
        horizontalAlignment: Text.AlignHCenter
        style: Text.Outline; styleColor: Qt.rgba(0, 0, 0, 0.8)
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height/4*1.3-offset
        text: wallClock.time.toLocaleString(Qt.locale(), "<b>HH</b>:mm")
    }

    // date
    Text {
        id: dateDisplay
        z: 0
        property var offset: height*0.4
        font.pixelSize: parent.height/12
        color: "white"
        opacity: 0.65
        font.family: "League Spartan"
        horizontalAlignment: Text.AlignHCenter
        style: Text.Outline; styleColor: Qt.rgba(0, 0, 0, 0.8)
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height/4*2.7-offset
        text: Qt.formatDate(wallClock.time, "d").toUpperCase()
    }

    Text {
        id: monthDisplay
        z: 0
        property var offset: height*0.4
        font.pixelSize: parent.height/24
        color: "white"
        opacity: 0.65
        font.family: "League Spartan"
        horizontalAlignment: Text.AlignHCenter
        style: Text.Outline; styleColor: Qt.rgba(0, 0, 0, 0.8)
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height/4*3-offset
        text: Qt.formatDate(wallClock.time, "MMMM").toUpperCase()
    }

    Canvas {
        z: 0
        id: hourHand
        property var hour: 0
        property var rotH: (hour-3 + wallClock.time.getMinutes()/60) / 12
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.lineCap="round"
            ctx.beginPath()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.8)
            ctx.shadowOffsetX = 2
            ctx.shadowOffsetY = 2
            ctx.shadowBlur = 3
            ctx.lineWidth = parent.width*0.034
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1)
            ctx.moveTo(parent.width/2,
                       parent.height/2)
            ctx.lineTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*width*0.227,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width*0.227)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 0
            ctx.lineWidth = parent.width*0.015
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 1)
            ctx.moveTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*width*0.10,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width*0.10)
            ctx.lineTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*width*0.224,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width*0.224)
            ctx.stroke()
            ctx.closePath()
        }
    }

    Canvas {
        z: 1
        id: minuteHand
        property var minute: 0
        property var rotM: (minute - 15)/60
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.lineCap="round"
            ctx.beginPath()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.8)
            ctx.shadowOffsetX = 1
            ctx.shadowOffsetY = 1
            ctx.shadowBlur = 3
            ctx.lineWidth = parent.width*0.034
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1)
            //circle in center
            ctx.arc(parent.width/2, parent.height/2, parent.height*0.014, 0, 2*Math.PI, false)
            ctx.moveTo(parent.width/2,
                       parent.height/2)
            //outer line
            ctx.lineTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*width*0.327,
                    parent.height/2+Math.sin(rotM * 2 * Math.PI)*width*0.327)
            ctx.stroke()
            ctx.closePath()
            ctx.lineWidth = parent.width*0.015
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 1)
            ctx.beginPath()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 0
            //inner line
            ctx.moveTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*width*0.17,
                       parent.height/2+Math.sin(rotM * 2 * Math.PI)*width*0.17)
            ctx.lineTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*width*0.324,
                    parent.height/2+Math.sin(rotM * 2 * Math.PI)*width*0.324)
            ctx.stroke()
            ctx.closePath()
        }
    }

    Canvas {
        z: 2
        id: secondHand
        property var second: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.7)
            ctx.shadowOffsetX = 1
            ctx.shadowOffsetY = 1
            ctx.shadowBlur = 2
            ctx.strokeStyle = "red"
            ctx.lineWidth = parent.height*0.008
            ctx.beginPath()
            ctx.moveTo(parent.width/2, parent.height/2)
            ctx.lineTo(parent.width/2+Math.cos((second - 45)/60 * 2 * Math.PI)*width*0.1,
                    parent.height/2+Math.sin((second - 45)/60 * 2 * Math.PI)*width*0.1)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()
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

    // dot acting as nail
    Canvas {
        z: 11
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.beginPath()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.8)
            ctx.shadowOffsetX = 1
            ctx.shadowOffsetY = 1
            ctx.shadowBlur = 1
            ctx.fillStyle = Qt.rgba(1, 1, 1, 1)
            ctx.arc(parent.width/2, parent.height/2, parent.height*0.006, 0, 2*Math.PI, false)
            ctx.fill()
            ctx.closePath()
        }
    }

    // hour strokes
    Canvas {
        z: 3
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")

            ctx.lineWidth = parent.width*0.025
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.65)
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.8)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 2
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 12; i++) {
                ctx.beginPath()
                ctx.moveTo(0, height*0.36)
                ctx.lineTo(0, height*0.46)
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
            ctx.lineWidth = parent.width*0.008
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.55)
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.8)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 1
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 60; i++) {
                // do not paint a minute stroke when there is an hour stroke
                if ((i%5) != 0) {
                    ctx.beginPath()
                    ctx.moveTo(0, height*0.41)
                    ctx.lineTo(0, height*0.46)
                    ctx.stroke()
                }
                ctx.rotate(Math.PI/30)
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
