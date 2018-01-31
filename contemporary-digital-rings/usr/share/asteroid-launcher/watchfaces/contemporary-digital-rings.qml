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
        anchors.fill: parent
        smooth: true
        renderTarget: Canvas.FramebufferObject 
        onPaint: {
            var ctx = getContext("2d")
            var rot1 = (0 -15 )*6 * radian
            var rot2 = (60 -15 )*6 * radian
            ctx.lineWidth = 3
            ctx.fillStyle = Qt.rgba(0.184, 0.184, 0.184, 0.3)
            ctx.beginPath()
            ctx.moveTo(parent.width/2, parent.height/2)
            ctx.arc(parent.width/2, parent.height/2, width / 2.85, rot1, rot2, false);
            ctx.lineTo(parent.width/2, parent.height/2);
            ctx.fill();
        }
    }

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
            ctx.arc(parent.width/2, parent.height/2, width / 2.3, -90* radian, rot* radian, false);
            ctx.lineWidth = parent.width/100
            ctx.strokeStyle = Qt.rgba(0.871, 0.165, 0.102, 0.9)
            ctx.stroke()
        }
    }

    Canvas {
        id: minuteCanvas
        property var minute: 0
        anchors.fill: parent
        smooth: true
        renderTarget: Canvas.FramebufferObject 
        onPaint: {
            var ctx = getContext("2d")
            var rot = (wallClock.time.getMinutes() -15 )*6
            var rot_half = (wallClock.time.getMinutes() -42 )*6
            ctx.reset()
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 2.475, -90* radian, rot* radian, false);
            ctx.lineWidth = parent.width/32
            ctx.strokeStyle = Qt.rgba(1, 0.549, 0.149, 0.9)
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
            ctx.arc(parent.width/2, parent.height/2, width / 2.7,  270* radian, rot* radian, false);
            ctx.lineWidth = parent.width/60
            ctx.strokeStyle = Qt.rgba(0.945, 0.769, 0.059, 0.9)
            ctx.stroke()
            ctx.beginPath()
        }
    }

    Text {
        id: hourDisplay
        font.pixelSize: parent.height/3
        font.family: "Exo2"
        font.styleName:'Extra Light'
        color: "white"
        opacity: 0.9
        anchors.right: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: -parent.height/11
        text: wallClock.time.toLocaleString(Qt.locale(), "<b>HH</b>")
    }

    Text {
        id: minuteDisplay
        property var rotM: (wallClock.time.getMinutes() - 12.1)/60
        font.pixelSize: parent.height/7
        font.family: "Exo2"
        font.styleName:'Regular'
        color: "white"
        opacity: 0.9
        anchors.bottomMargin: -parent.height/54
        anchors.leftMargin: + parent.width/72
        anchors.bottom: hourDisplay.verticalCenter;
        anchors.left: hourDisplay.right;
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    Text {
        id: secondDisplay
        font.pixelSize: parent.height/7
        font.family: "Exo2"
        font.styleName:'Extra Light'
        color: "white"
        opacity: 0.95
        horizontalAlignment: Text.AlignHCenter
        anchors.topMargin: -parent.height/56
        anchors.leftMargin: + parent.width/72
        anchors.top: hourDisplay.verticalCenter;
        anchors.left: hourDisplay.right;
        text: wallClock.time.toLocaleString(Qt.locale(), "ss")
    }

    Text {
        id: dateDisplay
        font.pixelSize: parent.height*0.09
        font.family: "Exo2"
        font.styleName:'Extra Light'
        color: "white"
        opacity: 0.9
        horizontalAlignment: Text.AlignHCenter
        anchors {
            topMargin: -parent.height*0.055
            top: hourDisplay.bottom
            left: parent.left
            right: parent.right
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "yyyy <b>MM</b> dd")
    }

    Connections {
        target: wallClock //wallClock.time
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
