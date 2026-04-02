/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
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
 * This watchface is based on the official analog watchface but comes
 * with a seconds hand, strokes for hours and minutes, correct
 * dropshadows for the hands and other small improvements.
 */

import QtQuick 2.9

Item {
    // Background circle
    Rectangle {
        anchors.centerIn: parent
        width: parent.width * 0.7
        height: parent.height * 0.7
        radius: width * 0.5
        opacity: 0.8
    }
    
    // Outer circle line — static, paints once only
    Canvas {
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = 2
            ctx.strokeStyle = "#ffffff"
            ctx.beginPath()
            ctx.arc(width / 2, height / 2, height / 2 * 0.7 + 2, 0, 2 * Math.PI, false)
            ctx.closePath()
            ctx.stroke()
        }
    }
    
    // Hour strokes — static, paints once only
    Canvas {
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = 1.5
            ctx.strokeStyle = "#888888"
            ctx.translate(parent.width / 2, parent.height / 2)
            for (var i = 0; i < 12; i++) {
                ctx.beginPath()
                ctx.moveTo(0, height * 0.32)
                ctx.lineTo(0, height * 0.35)
                ctx.stroke()
                ctx.rotate(Math.PI / 6)
            }
        }
    }
    
    // Minute strokes — static, paints once only
    Canvas {
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = 1.5
            ctx.strokeStyle = "#aaaaaa"
            ctx.translate(parent.width / 2, parent.height / 2)
            for (var i = 0; i < 60; i++) {
                if ((i % 5) !== 0) {
                    ctx.beginPath()
                    ctx.moveTo(0, height * 0.335)
                    ctx.lineTo(0, height * 0.35)
                    ctx.stroke()
                }
                ctx.rotate(Math.PI / 30)
            }
        }
    }
    
    // Date display
    Text {
        id: dateDisplay
        font {
            pixelSize: parent.height / 17
        }
        color: "black"
        opacity: 0.8
        horizontalAlignment: Text.AlignHCenter
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: parent.height / 4
        }
        text: Qt.formatDate(wallClock.time, "<b>ddd</b> d MMM")
    }
    
    Canvas {
        id: hourHand
        
        property int hour: 0
        property int minute: 0
        
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            var rot = (hour - 3 + minute / 60) / 12
            ctx.reset()
            ctx.lineWidth = 4
            ctx.strokeStyle = "white"
            ctx.shadowColor = "#80000000"
            ctx.shadowOffsetX = 4
            ctx.shadowOffsetY = 4
            ctx.shadowBlur = 4
            ctx.beginPath()
            ctx.moveTo(parent.width / 2, parent.height / 2)
            ctx.lineTo(parent.width / 2 + Math.cos(rot * 2 * Math.PI) * width * 0.25,
                       parent.height / 2 + Math.sin(rot * 2 * Math.PI) * width * 0.25)
            ctx.stroke()
        }
    }
    
    Canvas {
        id: minuteHand
        
        property int minute: 0
        
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.lineWidth = 2
            ctx.strokeStyle = "white"
            ctx.shadowColor = "#80000000"
            ctx.shadowOffsetX = 3
            ctx.shadowOffsetY = 3
            ctx.shadowBlur = 3
            ctx.beginPath()
            ctx.moveTo(parent.width / 2, parent.height / 2)
            ctx.lineTo(parent.width / 2 + Math.cos((minute - 15) / 60 * 2 * Math.PI) * width * 0.32,
                       parent.height / 2 + Math.sin((minute - 15) / 60 * 2 * Math.PI) * width * 0.32)
            ctx.stroke()
        }
    }
    
    Canvas {
        id: secondHand
        
        property int second: 0
        
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.fillStyle = "red"
            ctx.beginPath()
            ctx.arc(width / 2, height / 2, 3, 0, 2 * Math.PI, false)
            ctx.closePath()
            ctx.fill()
            ctx.lineWidth = 1
            ctx.strokeStyle = "red"
            ctx.shadowColor = "#80000000"
            ctx.shadowOffsetX = 3
            ctx.shadowOffsetY = 3
            ctx.shadowBlur = 3
            ctx.beginPath()
            ctx.moveTo(parent.width / 2, parent.height / 2)
            ctx.lineTo(parent.width / 2 + Math.cos((second - 15) / 60 * 2 * Math.PI) * width * 0.335,
                       parent.height / 2 + Math.sin((second - 15) / 60 * 2 * Math.PI) * width * 0.335)
            ctx.stroke()
        }
    }
    
    Connections {
        target: wallClock
        function onTimeChanged() {
            var hour = wallClock.time.getHours()
            var minute = wallClock.time.getMinutes()
            var second = wallClock.time.getSeconds()
            if (secondHand.second !== second) {
                secondHand.second = second
                secondHand.requestPaint()
            }
            if (minuteHand.minute !== minute) {
                minuteHand.minute = minute
                hourHand.minute = minute
                minuteHand.requestPaint()
                hourHand.requestPaint()
            }
            if (hourHand.hour !== hour) {
                hourHand.hour = hour
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
        hourHand.minute = minute
        hourHand.requestPaint()
    }
}
