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

    Canvas {
        z: 0
        id: backBars
        anchors.fill: parent
        anchors.bottom: parent.bottom
        smooth: true
        renderTarget: Canvas.FramebufferObject
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.beginPath()
            ctx.fillStyle = Qt.rgba(0, 0, 0, 0.5)
            ctx.fillRect(0,
                         parent.height/2,
                         parent.width,
                         -parent.height*0.2)
            ctx.closePath()
        }
    }

    Canvas {
        z: 3
        id: hourBar
        property var hour: 0
        anchors.fill: parent
        anchors.bottom: parent.bottom
        smooth: true
        renderTarget: Canvas.FramebufferObject
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.beginPath()
            ctx.fillStyle = Qt.rgba(1, 0, 0, 0.6)
            ctx.fillRect(parent.width/12*1.3,
                         parent.height/2,
                         parent.width/3*0.7,
                         hour/24*100*(parent.height*0.2/100))
            ctx.closePath()
            ctx.beginPath()
            ctx.shadowColor = Qt.rgba(1, 0, 0, 1)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 5
            ctx.lineWidth = parent.width*0.008
            ctx.strokeStyle = Qt.rgba(1, 0, 0, 1)
            ctx.moveTo(parent.width/12*1.3,
                       parent.height/2+(hour/24*100*(parent.height*0.2/100)))
            ctx.lineTo(parent.width/2.94,
                       parent.height/2+(hour/24*100*(parent.height*0.2/100)))
            ctx.stroke()
            ctx.closePath()
        }
    }

    Canvas {
        z: 3
        id: minuteBar
        property var minute: 0
        anchors.fill: parent
        anchors.bottom: parent.bottom
        smooth: true
        renderTarget: Canvas.FramebufferObject
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.beginPath()
            ctx.lineWidth = parent.width/42
            ctx.fillStyle = Qt.rgba(1, 1, 0, 0.6)
            ctx.fillRect(parent.width/6*2.3,
                         parent.height/2,
                         parent.width/3*0.7,
                         minute/60*100*(parent.height*0.2/100))
            ctx.closePath()
            ctx.beginPath()
            ctx.shadowColor = Qt.rgba(1, 1, 0, 1)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 5
            ctx.lineWidth = parent.width*0.008
            ctx.strokeStyle = Qt.rgba(1, 1, 0, 1)
            ctx.moveTo(parent.width/6*2.3,
                       parent.height/2+(minute/60*100*(parent.height*0.2/100)))
            ctx.lineTo(parent.width*0.617,
                       parent.height/2+(minute/60*100*(parent.height*0.2/100)))
            ctx.stroke()
            ctx.closePath()

        }
    }

    Canvas {
        z: 3
        id: secondBar
        property var second: 0
        anchors.fill: parent
        anchors.bottom: parent.bottom
        smooth: true
        renderTarget: Canvas.FramebufferObject
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.beginPath()
            ctx.lineWidth = parent.width/42
            ctx.fillStyle = Qt.rgba(0, 1, 1, 0.6)
            ctx.fillRect(parent.width/6.5*4*1.07,
                         parent.height/2,
                         parent.width/3*0.7,
                         second/60*100*(parent.height*0.2/100))
            ctx.closePath()
            ctx.beginPath()
            ctx.shadowColor = Qt.rgba(0, 1, 1, 1)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 5
            ctx.lineWidth = parent.width*0.008
            ctx.strokeStyle = Qt.rgba(0, 1, 1, 1)
            ctx.moveTo(parent.width/6.5*4*1.07,
                       parent.height/2+(second/60*100*(parent.height*0.2/100)))
            ctx.lineTo(parent.width*0.892,
                       parent.height/2+(second/60*100*(parent.height*0.2/100)))
            ctx.stroke()
            ctx.closePath()
        }
    }

    Text {
        z: 6
        id: hourDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height*0.2
        font.family: "CPMono_v07"
        font.styleName:"Bold"
        color: Qt.rgba(1, 1, 1, 1)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            bottomMargin: -parent.height*0.029
            bottom: parent.verticalCenter
        }
        x: parent.width/4.5-width/2
        text: wallClock.time.toLocaleString(Qt.locale(), "HH")
    }

    Text {
        z: 6
        id: minuteDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height*0.2
        font.family: "CPMono_v07"
        font.styleName:"Plain"
        color: Qt.rgba(1, 1, 1, 1)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            bottomMargin: -parent.height*0.029
            bottom: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    Text {
        z: 6
        id: secondDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height*0.2
        font.family: "CPMono_v07"
        font.styleName:"Light"
        color: Qt.rgba(1, 1, 1, 1)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            bottomMargin: -parent.height*0.029
            bottom: parent.verticalCenter
        }
        x: parent.width/6.5*5-width/2
        text: wallClock.time.toLocaleString(Qt.locale(), "ss")
    }

    Connections {
        target: wallClock
        onTimeChanged: {
            var hour = wallClock.time.getHours()
            var minute = wallClock.time.getMinutes()
            var second = wallClock.time.getSeconds()
            if(secondBar.second != second) {
                secondBar.second = second
                secondBar.requestPaint()
            }if(minuteBar.minute != minute) {
                minuteBar.minute = minute
                minuteBar.requestPaint()
            }if(hourBar.hour != hour) {
                hourBar.hour = hour
                hourBar.requestPaint()
            }
        }
    }

    Component.onCompleted: {
        var hour = wallClock.time.getHours()
        var minute = wallClock.time.getMinutes()
        var second = wallClock.time.getSeconds()
        secondBar.second = second
        secondBar.requestPaint()
        minuteBar.minute = minute
        minuteBar.requestPaint()
        hourBar.hour = hour
        hourBar.requestPaint()
    }
}
