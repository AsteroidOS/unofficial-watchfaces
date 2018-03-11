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

import QtQuick 2.1

Item {

    // outer circle line
    Canvas {
        z: 1
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")

            ctx.lineWidth = parent.height/38
            ctx.strokeStyle = Qt.rgba(0.169, 0.169, 0.169, 0.85)
            ctx.beginPath()
            ctx.arc(width/2, height/2, height*0.44, 0, 2*Math.PI, false)
            ctx.closePath()
            ctx.stroke()
        }
    }

    // second stroke
    Canvas {
        z: 2
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = parent.height/200
            ctx.strokeStyle = Qt.rgba(0.784, 0.784, 0.784, 0.5)

            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 60; i++) {
                // do not paint a minute stroke when there is an hour stroke
                //if ((i%5) != 0) {
                    ctx.beginPath()
                    ctx.moveTo(0, height*0.43)
                    ctx.lineTo(0, height*0.475)
                    ctx.stroke()
                //}
                ctx.rotate(Math.PI/30)
            }
        }
    }

    // second display
    Canvas {
        z: 3
        id: secondDisplay
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 4
            ctx.lineWidth = parent.height/200
            ctx.translate(parent.width/2, parent.height/2)
            ctx.rotate(Math.PI)
            for (var i=0; i <= wallClock.time.getSeconds(); i++) {
                ctx.strokeStyle = Qt.rgba(0.361, 1, 0.824, i/(wallClock.time.getSeconds()))
                ctx.shadowColor = Qt.rgba(0.361, 1, 0.824, i/(wallClock.time.getSeconds()))
                ctx.beginPath()
                ctx.moveTo(0, height*0.43)
                ctx.lineTo(0, height*0.475)
                ctx.stroke()
                ctx.rotate(Math.PI/30)
            }
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
            ctx.lineWidth = parent.height / 200
            ctx.strokeStyle = Qt.rgba(0.361, 1, 0.824, 1)
            ctx.shadowColor = Qt.rgba(0.361, 1, 0.824, 0.9)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 4
            ctx.beginPath()
            ctx.moveTo(parent.width / 2 + Math.cos((second - 15) / 60 * 2 * Math.PI)*width * 0.28,
                    parent.height / 2 + Math.sin((second - 15) / 60 * 2 * Math.PI)*width * 0.28)
            ctx.lineTo(parent.width / 2 + Math.cos((second - 15) / 60 * 2 * Math.PI)*width * 0.43,
                    parent.height / 2 + Math.sin((second - 15) / 60 * 2 * Math.PI)*width * 0.43)
            ctx.stroke()
        }
    }

    // minute strokes
    Canvas {
        z: 3
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = parent.height/32
            ctx.strokeStyle = Qt.rgba(0.384, 0.384, 0.384, 0.8)

            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 60; i++) {
                ctx.beginPath()
                ctx.moveTo(0, height*0.355)
                ctx.lineTo(0, height*0.395)
                ctx.stroke()
                ctx.rotate(Math.PI/30)
            }
        }
    }

    // minute display
    Canvas {
        z: 6
        id: minuteDisplay
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 5
            ctx.lineWidth = parent.height/34
            ctx.translate(parent.width/2, parent.height/2)
            ctx.rotate(Math.PI)
            for (var i=0; i <= wallClock.time.getMinutes(); i++) {
                ctx.strokeStyle = Qt.rgba(0.992, 0.988, 0.039, i/wallClock.time.getMinutes())
                ctx.shadowColor = Qt.rgba(0.992, 0.988, 0.039, i/wallClock.time.getMinutes())
                ctx.beginPath()
                ctx.moveTo(0, height*0.36)
                ctx.lineTo(0, height*0.39)
                ctx.stroke()
                ctx.rotate(Math.PI/30)
            }
        }
    }

    Canvas {
        z: 5
        id: minuteHand
        property var minute: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.lineWidth = parent.height/100
            ctx.strokeStyle = Qt.rgba(0.992, 0.988, 0.039, 1)
            ctx.shadowColor = Qt.rgba(0.992, 0.988, 0.039, 1)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 5
            ctx.beginPath()
            ctx.moveTo(parent.width / 2 + Math.cos((minute - 15) / 60 * 2 * Math.PI) * width * 0.285,
                    parent.height / 2 + Math.sin((minute - 15) / 60 * 2 * Math.PI) * width * 0.285)
            ctx.lineTo(parent.width / 2 + Math.cos((minute - 15) / 60 * 2 * Math.PI) * width * 0.36,
                    parent.height / 2 + Math.sin((minute - 15) / 60 * 2 * Math.PI) * width * 0.36)
            ctx.stroke()
        }
    }

    // Hour Arc
    Canvas {
        z: 1
        id: hourArc
        property var hour: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            var rot = 0.5 * (60 * (hour-3) + wallClock.time.getMinutes())
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0.996, 0, 0.031, 0.7)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 4
            ctx.lineWidth = parent.height/82
            ctx.lineCap="round"
            ctx.strokeStyle = Qt.rgba(0.996, 0, 0.031, 0.9)
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width *0.32, 270* 0.01745, rot* 0.01745, false);
            ctx.stroke()

        }
    }

    /*hour text*/
    Text {
        z: 6
        id: hourDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height*0.23
        font.family: "SlimSans"
        font.styleName:"Regular"
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.95
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "<b>HH</b>:mm")
    }

    Text {
        z: 7
        id: dayofweekDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height*0.065
        font.family: "SlimSans"
        font.styleName:"light"
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.9
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height/1.45
        text: wallClock.time.toLocaleString(Qt.locale(), "dddd")
    }

    Text {
        z: 8
        id: dateDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height*0.065
        font.family: "SlimSans"
        font.styleName:"Regular"
        lineHeight: parent.height*0.0025
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.9
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height/1.65
        text: wallClock.time.toLocaleString(Qt.locale(), "dd MMMM yyyy")
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
                secondDisplay.requestPaint()
                secondArc.requestPaint()
            }if(minuteHand.minute != minute) {
                minuteHand.minute = minute
                minuteHand.requestPaint()
                minuteDisplay.requestPaint()
            }if(hourArc.hour != hour) {
                hourArc.hour = hour
                hourArc.requestPaint()
            }
        }
     }

     Component.onCompleted: {
        var hour = wallClock.time.getHours()
        var minute = wallClock.time.getMinutes()
        var second = wallClock.time.getSeconds()
        secondHand.second = second
        secondHand.requestPaint()
        secondDisplay.requestPaint()
        secondArc.requestPaint()
        minuteHand.minute = minute
        minuteHand.requestPaint()
        minuteDisplay.requestPaint()
        hourArc.hour = hour
        hourArc.requestPaint()
     }
}
