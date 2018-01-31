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

// Asteroid theme colors
// yellow	Qt.rgba(0.945, 0.769, 0.059, 1)
// Orange	Qt.rgba(1, 0.549, 0.149, 1)
// red		Qt.rgba(0.871, 0.165, 0.102, 1)

import QtQuick 2.1

Item {
    property var radian: 0.01745329252

    Image {
        id: logoAsteroid
        source: "asteroid_logo.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
	width: parent.width/5.2
	height: parent.height/5.2
    }

    Canvas {
        id: minuteArc
        property var minute: 0
        anchors.fill: parent
        smooth: true
        renderTarget: Canvas.FramebufferObject 
        onPaint: {
            var ctx = getContext("2d")
            var rot = (wallClock.time.getMinutes() -15 )*6
            ctx.reset()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 2.75, -90* radian, 450* radian, false);
            ctx.lineWidth = parent.width/80
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.5)
            ctx.stroke()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 2.75, -90* radian, rot* radian, false);
            ctx.lineWidth = parent.width/20
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.7)
            ctx.stroke()
        }
    }

    Canvas {
        id: minuteCircle
        property var minute: 0
        property var rotM: (wallClock.time.getMinutes() - 15)/60
        property var centerX: parent.width/2
        property var centerY: parent.height/2
        property var minuteX: centerX+Math.cos(rotM * 2 * Math.PI)*width*0.36
        property var minuteY: centerY+Math.sin(rotM * 2 * Math.PI)*width*0.36
        anchors.fill: parent
        smooth: true
        renderTarget: Canvas.FramebufferObject 
        onPaint: {
            var ctx = getContext("2d")
            var rot1 = (0 -15 )*6 * radian
            var rot2 = (60 -15 )*6 * radian
            ctx.reset()
            ctx.lineWidth = 3
            ctx.fillStyle = Qt.rgba(0.184, 0.184, 0.184, 0.9)
            ctx.beginPath()
            ctx.moveTo(minuteX, minuteY)
            ctx.arc(minuteX, minuteY, width / 11.5, rot1, rot2, false);
            ctx.lineTo(minuteX, minuteY);
            ctx.fill();
        }
    }

    Canvas {
        id: hourArc
        property var hour: 0
        anchors.fill: parent
        smooth: true
        renderTarget: Canvas.FramebufferObject 
        onPaint: {
            var ctx = getContext("2d")
            var rot = 0.5 * (60 * (wallClock.time.getHours()-3) + wallClock.time.getMinutes())
            ctx.reset()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 5.3, 270* radian, 630* radian, false);
            ctx.lineWidth = parent.width/80
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.5)
            ctx.stroke()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 5.3, 270* radian, rot* radian, false);
            ctx.lineWidth = parent.width/20
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.7)
            ctx.stroke()
        }
    }

    Canvas {
        id: hourCircle
        property var hour: 0
        property var rotH: (wallClock.time.getHours()-3 + wallClock.time.getMinutes()/60) / 12
        property var centerX: parent.width/2
        property var centerY: parent.height/2
        property var hourX: (centerX+Math.cos(rotH * 2 * Math.PI)*width*0.185)
        property var hourY: (centerY+Math.sin(rotH * 2 * Math.PI)*width*0.185)
        anchors.fill: parent
        smooth: true
        renderTarget: Canvas.FramebufferObject 
        onPaint: {
            var ctx = getContext("2d")
            var rot1 = (0 -15 )*6 * radian
            var rot2 = (60 -15 )*6 * radian
            ctx.reset()
            ctx.lineWidth = 3
            ctx.fillStyle = Qt.rgba(0.184, 0.184, 0.184, 0.9)
            ctx.beginPath()
            ctx.moveTo(hourX, hourY)
            ctx.arc(hourX, hourY, width / 11.5, rot1, rot2, false);
            ctx.lineTo(hourX, hourY);
            ctx.fill();
        }
    }

    Text {
        id: hourDisplay
        property var rotH: (wallClock.time.getHours()-3 + wallClock.time.getMinutes()/60) / 12
        property var centerX: parent.width/2-width/2
        property var centerY: parent.height/2-height/2
        font.pixelSize: parent.height/9
        font.family: "OpenSans"
        color: "white"
        opacity: 1.0
        style: Text.Outline; styleColor: "#80000000"
        horizontalAlignment: Text.AlignHCenter
        x: centerX+Math.cos(rotH * 2 * Math.PI)*height*1.18
        y: centerY+Math.sin(rotH * 2 * Math.PI)*height*1.18
        text: wallClock.time.toLocaleString(Qt.locale(), "<b>HH</b>")
    }

    Text {
        id: minuteDisplay
        property var rotM: (wallClock.time.getMinutes() - 15)/60
        property var centerX: parent.width/2-width/2
        property var centerY: parent.height/2-height/2
        font.pixelSize: parent.height/10
        font.family: "OpenSans"
        color: "white"
        opacity: 1.00
        style: Text.Outline; styleColor: "#80000000"
        x: centerX+Math.cos(rotM * 2 * Math.PI)*height*2.585
        y: centerY+Math.sin(rotM * 2 * Math.PI)*height*2.585
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    Connections {
        target: wallClock
        onTimeChanged: {
            var hour = wallClock.time.getHours()
            var minute = wallClock.time.getMinutes()
            var second = wallClock.time.getSeconds()
            var date = wallClock.time.getDate()
            if(minuteArc.minute != minute) {
                minuteArc.minute = minute
                minuteCircle.requestPaint()
                minuteArc.requestPaint()
                hourArc.hour = hour
                hourCircle.requestPaint()
                hourArc.requestPaint()
            }
        }
    }

    Component.onCompleted: {
        var hour = wallClock.time.getHours()
        var minute = wallClock.time.getMinutes()
        var date = wallClock.time.getDate()
        minuteArc.minute = minute
        minuteCircle.requestPaint()
        minuteArc.requestPaint()
        hourArc.hour = hour
        hourCircle.requestPaint()
        hourArc.requestPaint()
    }

    Connections {
        target: localeManager
        onChangesObserverChanged: {
            minuteCircle.requestPaint()
            minuteArc.requestPaint()
            hourCircle.requestPaint()
            hourArc.requestPaint()
        }
    }
}
