/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
 *               2018 - Timo Könnecke <el-t-mo@arcor.de>
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
import Nemo.Mce 1.0
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0

Item {
    
    Canvas {
        z: 0
        id: hourArc
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            var rot = 0.5 * (60 * (wallClock.time.getHours()-3) + wallClock.time.getMinutes())
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0.996, 0.259, 0.051, 0.7)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 5
            ctx.lineWidth = parent.height / 36
            ctx.lineCap = "round"
            ctx.beginPath()
            var gradient = ctx.createRadialGradient(parent.width/2, parent.height/2, 0, parent.width/2, parent.height/2, parent.width * 0.39)
            gradient.addColorStop(0.4,  Qt.rgba(0.996, 0.259, 0.051, 0.0))
            gradient.addColorStop(0.95, Qt.rgba(0.996, 0.259, 0.051, 0.9))
            ctx.strokeStyle = gradient
            ctx.arc(parent.width/2, parent.height/2, parent.width * 0.39, 268 * 0.01745, rot * 0.01745, false)
            ctx.lineTo(parent.width/2, parent.height/2)
            ctx.stroke()
            ctx.closePath()
        }
    }
    
    // Circular dark overlay replacing the former ShaderEffect mask.
    Rectangle {
        z: 1
        anchors.centerIn: parent
        width: parent.width * 0.79
        height: width
        radius: width * 0.5
        color: Qt.rgba(0, 0, 0, 0.75)
    }
    
    Canvas {
        z: 2
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = parent.width * 0.012
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.55)
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.8)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 2
            ctx.translate(parent.width/2, parent.height/2)
            for (var i = 0; i < 12; i++) {
                ctx.beginPath()
                ctx.moveTo(0, height * 0.46)
                ctx.lineTo(0, height * 0.50)
                ctx.stroke()
                ctx.rotate(Math.PI / 6)
            }
        }
    }
    
    Canvas {
        z: 2
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = parent.height * 0.008
            ctx.strokeStyle = Qt.rgba(0.784, 0.784, 0.784, 0.3)
            ctx.translate(parent.width/2, parent.height/2)
            for (var i = 0; i < 60; i++) {
                ctx.beginPath()
                ctx.moveTo(0, height * 0.46)
                ctx.lineTo(0, height * 0.50)
                ctx.stroke()
                ctx.rotate(Math.PI / 30)
            }
        }
    }
    
    Canvas {
        z: 5
        id: secondDisplay
        property int second: 0
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            var s = second
            ctx.reset()
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 5
            ctx.lineWidth = parent.width * 0.010
            ctx.translate(parent.width/2, parent.height/2)
            ctx.rotate(Math.PI)
            for (var i = 0; i <= s; i++) {
                var alpha = s > 0 ? i / s : 0
                ctx.strokeStyle = Qt.rgba(0, 0.937, 0.937, alpha)
                ctx.shadowColor  = Qt.rgba(0, 0.937, 0.937, alpha)
                ctx.beginPath()
                ctx.moveTo(0, height * 0.46)
                ctx.lineTo(0, height * 0.50)
                ctx.stroke()
                ctx.rotate(Math.PI / 30)
            }
        }
    }
    
    Canvas {
        z: 5
        id: secondHand
        property int second: 0
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0, 0.937, 0.937, 0.9)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 4
            ctx.lineWidth = parent.height / 200
            ctx.beginPath()
            var gradient = ctx.createRadialGradient(parent.width/2, parent.height/2, 0, parent.width/2, parent.height/2, parent.width * 0.46)
            gradient.addColorStop(0.38, Qt.rgba(0, 0.937, 0.937, 0.0))
            gradient.addColorStop(0.95, Qt.rgba(0, 0.937, 0.937, 1.0))
            ctx.strokeStyle = gradient
            ctx.moveTo(parent.width/2, parent.height/2)
            ctx.lineTo(parent.width/2 + Math.cos((second - 15) / 60 * 2 * Math.PI) * width * 0.46,
                       parent.height/2 + Math.sin((second - 15) / 60 * 2 * Math.PI) * width * 0.46)
            ctx.stroke()
            ctx.closePath()
        }
    }
    
    Canvas {
        z: 4
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = parent.height / 32
            ctx.strokeStyle = Qt.rgba(0.384, 0.384, 0.384, 0.55)
            ctx.translate(parent.width/2, parent.height/2)
            for (var i = 0; i < 60; i++) {
                ctx.beginPath()
                ctx.moveTo(0, height * 0.405)
                ctx.lineTo(0, height * 0.445)
                ctx.stroke()
                ctx.rotate(Math.PI / 30)
            }
        }
    }
    
    Canvas {
        z: 4
        id: minuteDisplay
        property int minute: 0
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            var m = minute
            ctx.reset()
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 5
            ctx.lineWidth = parent.height / 34
            ctx.translate(parent.width/2, parent.height/2)
            ctx.rotate(Math.PI)
            for (var i = 0; i <= m; i++) {
                var alpha = m > 0 ? i / m : 0
                ctx.strokeStyle = Qt.rgba(0.996, 0.969, 0.051, alpha)
                ctx.shadowColor  = Qt.rgba(0.996, 0.969, 0.051, alpha)
                ctx.beginPath()
                ctx.moveTo(0, height * 0.41)
                ctx.lineTo(0, height * 0.44)
                ctx.stroke()
                ctx.rotate(Math.PI / 30)
            }
        }
    }
    
    Canvas {
        z: 4
        id: minuteHand
        property int minute: 0
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.lineWidth = parent.height / 80
            ctx.shadowColor = Qt.rgba(0.996, 0.969, 0.051, 1)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 4
            ctx.beginPath()
            var gradient = ctx.createRadialGradient(parent.width/2, parent.height/2, 0, parent.width/2, parent.height/2, parent.width * 0.41)
            gradient.addColorStop(0.39, Qt.rgba(0.996, 0.969, 0.051, 0.0))
            gradient.addColorStop(0.95, Qt.rgba(0.996, 0.969, 0.051, 1.0))
            ctx.strokeStyle = gradient
            ctx.moveTo(parent.width/2, parent.height/2)
            ctx.lineTo(parent.width/2 + Math.cos((minute - 15) / 60 * 2 * Math.PI) * width * 0.41,
                       parent.height/2 + Math.sin((minute - 15) / 60 * 2 * Math.PI) * width * 0.41)
            ctx.stroke()
            ctx.closePath()
        }
    }
    
    Canvas {
        z: 2
        id: batteryArc
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0.361, 1, 0.824, 0.7)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 2
            var low = batteryChargePercentage.percent < 30
            var gradient = ctx.createRadialGradient(parent.width/2, parent.height/2, 0, parent.width/2, parent.height/2, parent.width * 0.46)
            gradient.addColorStop(0.39, low ? Qt.rgba(1, 0, 0, 0.0) : Qt.rgba(0.318, 1, 0.051, 0.0))
            gradient.addColorStop(0.95, low ? Qt.rgba(1, 0, 0, 0.9) : Qt.rgba(0.318, 1, 0.051, 0.9))
            ctx.lineWidth = parent.height * 0.007
            ctx.lineCap = "round"
            ctx.strokeStyle = gradient
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, parent.width * 0.46, 270 * 0.01745, ((batteryChargePercentage.percent / 100 * 360) + 270) * 0.01745, false)
            ctx.lineTo(parent.width/2, parent.height/2)
            ctx.stroke()
            ctx.closePath()
        }
    }
    
    Text {
        z: 9
        id: batteryDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height / 16
        font.family: "SlimSans"
        font.styleName: "Bold"
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        text: "<b>" + batteryChargePercentage.percent + "</b>"
    }
    
    Text {
        z: 9
        id: hourDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height * 0.25
        font.family: "SlimSans"
        font.styleName: "Regular"
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.95
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        text: use12H.value ?
        wallClock.time.toLocaleString(Qt.locale(), "<b>hh</b> ap").slice(0, 9) + wallClock.time.toLocaleString(Qt.locale(), ":mm") :
        wallClock.time.toLocaleString(Qt.locale(), "<b>HH</b>") + wallClock.time.toLocaleString(Qt.locale(), ":mm")
    }
    
    Text {
        z: 9
        id: dayofweekDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height * 0.085
        font.family: "SlimSans"
        font.styleName: "light"
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.9
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: hourDisplay.top
        anchors.bottomMargin: -parent.height * 0.03
        text: wallClock.time.toLocaleString(Qt.locale(), "dddd")
    }
    
    Text {
        z: 9
        id: dateDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height * 0.085
        font.family: "SlimSans"
        font.styleName: "Regular"
        lineHeight: parent.height * 0.0025
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.9
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: hourDisplay.bottom
        anchors.topMargin: -parent.height * 0.036
        text: wallClock.time.toLocaleString(Qt.locale(), "dd MMMM")
    }
    
    MceBatteryLevel {
        id: batteryChargePercentage
        onPercentChanged: batteryArc.requestPaint()
    }
    
    Connections {
        target: wallClock
        onTimeChanged: {
            var hour   = wallClock.time.getHours()
            var minute = wallClock.time.getMinutes()
            var second = wallClock.time.getSeconds()
            // Update orbiting battery label position imperatively to avoid
            // per-frame trig binding evaluation.
            var rotB = (batteryChargePercentage.percent - 25) / 100
            var cx = parent.width  / 2 - batteryDisplay.width  / 2
            var cy = parent.height / 2 - batteryDisplay.height / 2
            batteryDisplay.x = cx + Math.cos(rotB * 2 * Math.PI) * batteryDisplay.height * 4.5
            batteryDisplay.y = cy + Math.sin(rotB * 2 * Math.PI) * batteryDisplay.height * 4.5
            
            if (secondHand.second !== second) {
                secondHand.second = second
                secondHand.requestPaint()
                secondDisplay.second = second
                secondDisplay.requestPaint()
            }
            if (minuteHand.minute !== minute) {
                minuteHand.minute = minute
                minuteHand.requestPaint()
                minuteDisplay.minute = minute
                minuteDisplay.requestPaint()
                hourArc.requestPaint()
            }
        }
    }
    
    Component.onCompleted: {
        var hour   = wallClock.time.getHours()
        var minute = wallClock.time.getMinutes()
        var second = wallClock.time.getSeconds()
        var rotB = (batteryChargePercentage.percent - 25) / 100
        var cx = parent.width  / 2 - batteryDisplay.width  / 2
        var cy = parent.height / 2 - batteryDisplay.height / 2
        batteryDisplay.x = cx + Math.cos(rotB * 2 * Math.PI) * batteryDisplay.height * 4.5
        batteryDisplay.y = cy + Math.sin(rotB * 2 * Math.PI) * batteryDisplay.height * 4.5
        batteryArc.requestPaint()
        secondHand.second = second
        secondHand.requestPaint()
        secondDisplay.second = second
        secondDisplay.requestPaint()
        minuteHand.minute = minute
        minuteHand.requestPaint()
        minuteDisplay.minute = minute
        minuteDisplay.requestPaint()
        hourArc.requestPaint()
    }
}
