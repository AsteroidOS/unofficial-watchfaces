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
// yellow	Qt.rgba(0.945, 0.769, 0.059, 0.25)
// Orange	Qt.rgba(1, 0.549, 0.149, 0.25)
// red		Qt.rgba(0.871, 0.165, 0.102, 0.7)

import QtQuick 2.1

Item {
    property var radian: 0.01745329252

    Canvas {
        id: secondCanvas
        property var second: 0
        anchors.fill: parent
        smooth: true
        renderTarget: Canvas.FramebufferObject 
        onPaint: {
            var ctx = getContext("2d")
            var rot = (wallClock.time.getSeconds() - 15)*6
            var rot_half = (wallClock.time.getSeconds() - 22)*6
            ctx.reset()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 2.15, (rot_half-35)* radian, rot* radian, false);
            ctx.lineWidth = parent.width/42
            ctx.strokeStyle = Qt.rgba(0.945, 0.769, 0.059, 0.7)
            ctx.stroke()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 2.25, (rot_half-120)* radian, rot* radian, false);
            ctx.lineWidth = parent.width/42
            ctx.strokeStyle = Qt.rgba(0.945, 0.769, 0.059, 0.45)
            ctx.stroke()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 2.35, (rot_half-230)* radian, rot* radian, false);
            ctx.lineWidth = parent.width/42
            ctx.strokeStyle = Qt.rgba(0.945, 0.769, 0.059, 0.20)
            ctx.stroke()
        }
    }

    Canvas {
        id: minuteCanvas
        property var minute: 0
        anchors.fill: parent
        smooth: true4
        renderTarget: Canvas.FramebufferObject 
        onPaint: {
            var ctx = getContext("2d")
            var rot = (wallClock.time.getMinutes() -15 )*6
            var rot_half = (wallClock.time.getMinutes() -42 )*6
            ctx.reset()
            ctx.beginPath()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 2.63, (rot_half+35)* radian, rot* radian, false);
            ctx.lineWidth = parent.width/42
            ctx.strokeStyle = Qt.rgba(1, 0.549, 0.149, 0.7)
            ctx.stroke()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 2.77, (rot_half-40)* radian, rot* radian, false);
            ctx.lineWidth = parent.width/42
            ctx.strokeStyle = Qt.rgba(1, 0.549, 0.149, 0.51)
            ctx.stroke()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 2.92, (rot_half-95)* radian, rot* radian, false);
            ctx.lineWidth = parent.width/42
            ctx.strokeStyle = Qt.rgba(1, 0.549, 0.149, 0.38)
            ctx.stroke()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 3.08, (rot_half-130)* radian, rot* radian, false);
            ctx.lineWidth = parent.width/42
            ctx.strokeStyle = Qt.rgba(1, 0.549, 0.149, 0.20)
            ctx.stroke()
        }
    }

    Canvas {
        id: hourCanvas
        property var hour: 0
        anchors.fill: parent
        smooth: true
        renderTarget: Canvas.FramebufferObject 
        onPaint: {
            var ctx = getContext("2d")
            var rot = 0.5 * (60 * (wallClock.time.getHours()-3) + wallClock.time.getMinutes())
            var rot_half = 0.5 * (60 * (wallClock.time.getHours()-7.5) + wallClock.time.getMinutes())
            ctx.reset()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 3.57,  (rot_half+35)* radian, rot* radian, false);
            ctx.lineWidth = parent.width/42
            ctx.strokeStyle = Qt.rgba(0.871, 0.165, 0.102, 0.7)
            ctx.stroke()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 3.87, (rot_half-20)* radian, rot* radian, false);
            ctx.lineWidth = parent.width/42
            ctx.strokeStyle = Qt.rgba(0.871, 0.165, 0.102, 0.55)
            ctx.stroke()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 4.17, (rot_half-70)* radian, rot* radian, false);
            ctx.lineWidth = parent.width/42
            ctx.strokeStyle = Qt.rgba(0.871, 0.165, 0.102, 0.4)
            ctx.stroke()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 4.47, (rot_half-125)* radian, rot* radian, false);
            ctx.lineWidth = parent.width/42
            ctx.strokeStyle = Qt.rgba(0.871, 0.165, 0.102, 0.25)
            ctx.stroke()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 4.77, (rot_half-190)* radian, rot* radian, false);
            ctx.lineWidth = parent.width/42
            ctx.strokeStyle = Qt.rgba(0.871, 0.165, 0.102, 0.2)
            ctx.stroke()
        }
    }

    Image {
        id: secondAsteroid
        property var rotS: (wallClock.time.getSeconds() - 15)/60
        property var centerX: parent.width/2-width/2
        property var centerY: parent.height/2-height/2 
        source: "asteroid_second.png"
        x: centerX+Math.cos(rotS * 2 * Math.PI)*width*5.78
        y: centerY+Math.sin(rotS * 2 * Math.PI)*width*5.78
    width: parent.width/13
    height: parent.width/13
    }

    Image {
        id: minuteAsteroid
        property var rotM: (wallClock.time.getMinutes() - 15)/60
        property var centerX: parent.width/2-width/2
        property var centerY: parent.height/2-height/2
        source: "asteroid_minute.png"
        x: centerX+Math.cos(rotM * 2 * Math.PI)*width*3.9
        y: centerY+Math.sin(rotM * 2 * Math.PI)*width*3.9
	width: parent.width/11
	height: parent.width/11
    }

    Image {
        id: hourAsteroid
        property var rotH: (wallClock.time.getHours()-3 + wallClock.time.getMinutes()/60) / 12
        property var centerX: parent.width/2-width/2
        property var centerY: parent.height/2-height/2 
        source: "asteroid_hour.png"
        x: (centerX+Math.cos(rotH * 2 * Math.PI)*width*2.23)
        y: (centerY+Math.sin(rotH * 2 * Math.PI)*width*2.23)
        width: parent.width/9
        height: parent.width/9
    }

    Text {
        id: hourDisplay
        font.pixelSize: parent.height/4
        font.family: "OpenSans"
        color: "white"
        opacity: 0.8
        style: Text.Outline; styleColor: "#80000000"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "<b>HH</b>")
    }

    Text {
        id: minuteDisplay
        property var rotM: (wallClock.time.getMinutes() - 12.2)/60
        property var centerX: parent.width/2-width/2
        property var centerY: parent.height/2-height/2
        font.pixelSize: parent.height/12.7
        font.family: "OpenSans"
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.9
        x: centerX+Math.cos(rotM * 2 * Math.PI)*width*4.1
        y: centerY+Math.sin(rotM * 2 * Math.PI)*width*4.1
        text: wallClock.time.toLocaleString(Qt.locale(), "<b>mm</b>")
    }

    Text {
        id: secondDisplay
        property var rotS: (wallClock.time.getSeconds() - 13.05)/60
        property var centerX: parent.width/2-width/2
        property var centerY: parent.height/2-height/2
        font.pixelSize: parent.height/14
        font.family: "OpenSans"
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.95
        x: centerX+Math.cos(rotS * 2 * Math.PI)*height*4.54
        y: centerY+Math.sin(rotS * 2 * Math.PI)*height*4.54
        text: wallClock.time.toLocaleString(Qt.locale(), "ss")
    }

    Connections {
        target: wallClock
        onTimeChanged: {
            var hour = wallClock.time.getHours()
            var minute = wallClock.time.getMinutes()
            var second = wallClock.time.getSeconds()
            var date = wallClock.time.getDate()
            if(secondCanvas.second != second) {
                secondCanvas.second = second
                secondCanvas.requestPaint()
            }if(minuteCanvas.minute != minute) {
                minuteCanvas.minute = minute
                minuteCanvas.requestPaint()
            } if(hourCanvas.hour != hour) {
                hourCanvas.hour = hour
                hourCanvas.requestPaint()
            }
        }
    }

    Component.onCompleted: {
        var hour = wallClock.time.getHours()
        var minute = wallClock.time.getMinutes()
        var second = wallClock.time.getSeconds()
        var date = wallClock.time.getDate()
        secondCanvas.second = second
        secondCanvas.requestPaint()
        minuteCanvas.minute = minute
        minuteCanvas.requestPaint()
        hourCanvas.hour = hour
        hourCanvas.requestPaint()
    }

    Connections {
        target: localeManager
        onChangesObserverChanged: {
            secondCanvas.requestPaint()
            minuteCanvas.requestPaint()
            hourCanvas.requestPaint()
        }
    }
}
