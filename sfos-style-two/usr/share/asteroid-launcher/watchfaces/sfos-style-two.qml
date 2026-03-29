/*
 * Copyright (C) 2026 - Timo Könnecke <mo@mowerk.net>
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
 * This watchface is a fan recreation of Jolla Oy's Sailfish Watch concept designs from 2016.
 * Visual design elements (e.g., hand styles, strokes, shadows, and layout) are derived from Jolla's intellectual property as shown at https://blog.jolla.com/watch/.
 * Used and distributed with explicit permission from Jolla Oy (granted by CEO Sami Pienimäki in 2026, with witnesses at FOSDEM).
 * Permission is for non-commercial, community-driven distribution within the AsteroidOS unofficial-watchfaces repository.
 */

import QtQuick 2.1

Item {

    Rectangle {
        z: 0
        x: 0; y: 0
        color: Qt.rgba(0, 0, 0, 0.7)
        width: parent.width
        height: parent.height
    }

    Image {
        z: 1
        id: logoSailfish
        source: "../watchfaces-img/sailfish_logo.svg"
        opacity: 0.9
        anchors {
            bottomMargin: parent.height*0.18
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width/6
        height: parent.height/6
    }

    Canvas {
        z: 2
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
            ctx.lineWidth = parent.width*0.023
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1)
            ctx.moveTo(parent.width/2,
                       parent.height/2)
            ctx.lineTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*width*0.227,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width*0.227)
            ctx.stroke()
            ctx.closePath()
        }
    }

    Canvas {
        z: 3
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
            ctx.lineWidth = parent.width*0.016
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1)
            ctx.moveTo(parent.width/2,
                       parent.height/2)
            ctx.lineTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*width*0.31,
                       parent.height/2+Math.sin(rotM * 2 * Math.PI)*width*0.31)
            ctx.stroke()
            ctx.closePath()
        }
    }

    Canvas {
        z: 4
        id: secondHand
        property var second: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.7)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 2
            ctx.strokeStyle = Qt.rgba(0.592, 0.937, 0.937, 1.0)
            ctx.lineWidth = parent.height*0.007
            ctx.beginPath()
            ctx.moveTo(parent.width/2, parent.height/2)
            ctx.lineTo(parent.width/2+Math.cos((second - 15)/60 * 2 * Math.PI)*width*0.33,
                       parent.height/2+Math.sin((second - 15)/60 * 2 * Math.PI)*width*0.33)
            ctx.stroke()
            ctx.closePath()
        }
    }

    Canvas {
        z: 5
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")

            ctx.lineWidth = parent.width*0.008
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.60)
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 12; i++) {
                ctx.beginPath()
                ctx.moveTo(0, height*0.37)
                ctx.lineTo(0, height*0.45)
                ctx.stroke()
                ctx.rotate(Math.PI/2)
            }
        }
    }

    Canvas {
        z: 6
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = parent.width*0.007
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.4)
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 12; i++) {
                if ((i%3) != 0) {
                    ctx.beginPath()
                    ctx.moveTo(0, height*0.40)
                    ctx.lineTo(0, height*0.45)
                    ctx.stroke()
                }
                ctx.rotate(Math.PI/6)
            }
        }
    }


    Connections {
        target: wallClock
        onTimeChanged: {
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
        var date = wallClock.time.getDate()
        secondHand.second = second
        secondHand.requestPaint()
        minuteHand.minute = minute
        minuteHand.requestPaint()
        hourHand.hour = hour
        hourHand.requestPaint()
    }

}
