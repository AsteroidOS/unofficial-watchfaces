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
import org.freedesktop.contextkit 1.0
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0

Item {

    Canvas {
        z: 0
        id: hourArc
        property var hour: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            var rot = 0.5 * (60 * (wallClock.time.getHours()-3) + wallClock.time.getMinutes())
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0.996, 0.259, 0.051, 0.7)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 5
            ctx.lineWidth = parent.height/36
            ctx.lineCap="round"
            ctx.beginPath()
            var gradient = ctx.createRadialGradient (parent.width/2, parent.height/2, 0, parent.width/2, parent.height/2, parent.width *0.39)
            gradient.addColorStop(0.4, Qt.rgba(0.996, 0.259, 0.051, 0.0))
            gradient.addColorStop(0.95, Qt.rgba(0.996, 0.259, 0.051, 0.9))
            ctx.strokeStyle = gradient
            ctx.arc(parent.width/2, parent.height/2, parent.width *0.39, 268* 0.01745, rot* 0.01745, false);
            ctx.lineTo(parent.width/2,
                       parent.height/2)
            ctx.stroke()
            ctx.closePath()

        }
    }

    Rectangle {
        id: layer2mask
        width: parent.width; height: parent.height
        color: Qt.rgba(0, 0, 0, 0.7)
        visible: true
        opacity: 0.0
        layer.enabled: true
        layer.smooth: true
    }

    Rectangle {
        z: 1
        id: _mask
        anchors.fill: layer2mask
        color: Qt.rgba(0, 1, 0, 0)
        visible: true

        Rectangle {
            z: 0
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
            color: Qt.rgba(0, 0, 0, 0.75)
            width: parent.width *0.79
            height: parent.width *0.79
            radius: width*0.5
        }

        layer.enabled: true
        layer.samplerName: "maskSource"
        layer.effect: ShaderEffect {
            property variant source: layer2mask
            fragmentShader: "
                    varying highp vec2 qt_TexCoord0;
                    uniform highp float qt_Opacity;
                    uniform lowp sampler2D source;
                    uniform lowp sampler2D maskSource;
                    void main(void) {
                        gl_FragColor = texture2D(source, qt_TexCoord0.st) * (1.0-texture2D(maskSource, qt_TexCoord0.st).a) * qt_Opacity;
                    }
                "
        }
    }

    // hour strokes
    Canvas {
        z: 2
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")

            ctx.lineWidth = parent.width*0.012
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.55)
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.8)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 2
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 12; i++) {
                ctx.beginPath()
                ctx.moveTo(0, height*0.46)
                ctx.lineTo(0, height*0.50)
                ctx.stroke()
                ctx.rotate(Math.PI/6)
            }
        }
    }

    // second stroke
    Canvas {
        z: 2
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = parent.height*0.008
            ctx.strokeStyle = Qt.rgba(0.784, 0.784, 0.784, 0.3)
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 60; i++) {
                ctx.beginPath()
                ctx.moveTo(0, height*0.46)
                ctx.lineTo(0, height*0.50)
                ctx.stroke()
                ctx.rotate(Math.PI/30)
            }
        }
    }

    Canvas {
        z: 5
        id: secondDisplay
        property var second: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 5
            ctx.lineWidth =  parent.width*0.010
            ctx.translate(parent.width/2, parent.height/2)
            ctx.rotate(Math.PI)
            for (var i=0; i <= wallClock.time.getSeconds(); i++) {
                ctx.strokeStyle = Qt.rgba(0, 0.937, 0.937, i/(wallClock.time.getSeconds()))
                ctx.shadowColor = Qt.rgba(0, 0.937, 0.937, i/(wallClock.time.getSeconds()))
                ctx.beginPath()
                ctx.moveTo(0, height*0.46)
                ctx.lineTo(0, height*0.50)
                ctx.stroke()
                ctx.rotate(Math.PI/30)
            }
        }
    }

    Canvas {
        z: 5
        id: secondHand
        property var second: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0, 0.937, 0.937, 0.9)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 4
            ctx.lineWidth = parent.height/200
            ctx.beginPath()
            var gradient = ctx.createRadialGradient (parent.width/2, parent.height/2, 0, parent.width/2, parent.height/2, parent.width *0.46)
            gradient.addColorStop(0.38, Qt.rgba(0, 0.937, 0.937, 0.0))
            gradient.addColorStop(0.95, Qt.rgba(0, 0.937, 0.937, 1.0))
            ctx.strokeStyle = gradient
            ctx.moveTo(parent.width/2,
                       parent.height/2)
            ctx.lineTo(parent.width/2+Math.cos((second - 15)/60 * 2 * Math.PI)*width*0.46,
                       parent.height/2+Math.sin((second - 15)/60 * 2 * Math.PI)*width*0.46)
            ctx.stroke()
            ctx.closePath()
        }
    }

    // minute strokes
    Canvas {
        z: 4
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = parent.height/32
            ctx.strokeStyle = Qt.rgba(0.384, 0.384, 0.384, 0.55)
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 60; i++) {
                ctx.beginPath()
                ctx.moveTo(0, height*0.405)
                ctx.lineTo(0, height*0.445)
                ctx.stroke()
                ctx.rotate(Math.PI/30)
            }
        }
    }

    Canvas {
        z: 4
        id: minuteDisplay
        property var minute: 0
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
            for (var i=0; i <= minute; i++) {
                ctx.strokeStyle = Qt.rgba(0.996, 0.969, 0.051, i/minute)
                ctx.shadowColor = Qt.rgba(0.996, 0.969, 0.051, i/minute)
                ctx.beginPath()
                ctx.moveTo(0, height*0.41)
                ctx.lineTo(0, height*0.44)
                ctx.stroke()
                ctx.rotate(Math.PI/30)
            }
        }
    }

    Canvas {
        z: 4
        id: minuteHand
        property var minute: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.lineWidth = parent.height/80
            ctx.shadowColor = Qt.rgba(0.996, 0.969, 0.051, 1)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 4
            ctx.beginPath()
            var gradient = ctx.createRadialGradient (parent.width/2, parent.height/2, 0, parent.width/2, parent.height/2, parent.width *0.41)
            gradient.addColorStop(0.39, Qt.rgba(0.996, 0.969, 0.051, 0.0))
            gradient.addColorStop(0.95, Qt.rgba(0.996, 0.969, 0.051, 1.0))
            ctx.strokeStyle = gradient
            ctx.moveTo(parent.width/2,
                       parent.height/2)
            ctx.lineTo(parent.width/2+Math.cos((minute - 15)/60 * 2 * Math.PI)*width*0.41,
                       parent.height/2+Math.sin((minute - 15)/60 * 2 * Math.PI)*width*0.41)
            ctx.stroke()
            ctx.closePath()
        }
    }

    Canvas {
        z: 2
        id: batteryArc
        property var hour: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0.361, 1, 0.824, 0.7)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 2
            var gradient = ctx.createRadialGradient (parent.width/2, parent.height/2, 0, parent.width/2, parent.height/2, parent.width *0.46)
            gradient.addColorStop(0.39, batteryChargePercentage.value < 30 ? 'red': Qt.rgba(0.318, 1, 0.051, 0.0))
            gradient.addColorStop(0.95, batteryChargePercentage.value < 30 ? 'red': Qt.rgba(0.318, 1, 0.051, 0.9))
            ctx.lineWidth = parent.height*0.007
            ctx.lineCap="round"
            ctx.strokeStyle = gradient
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, parent.width *0.46, 270* 0.01745, ((batteryChargePercentage.value/100*360)+270)* 0.01745, false);
            ctx.lineTo(parent.width/2,
                       parent.height/2)
            ctx.stroke()
            ctx.closePath()
        }
    }

    Text {
        z: 9
        id: batteryDisplay
        renderType: Text.NativeRendering
        property var rotB: (batteryChargePercentage.value-25)/100
        property var centerX: parent.width/2-width/2
        property var centerY: parent.height/2-height/2
        font.pixelSize: parent.height/16
        font.family: "SlimSans"
        font.styleName:"Bold"
        color: "white"
        opacity: 1.00
        style: Text.Outline; styleColor: "#80000000"
        x: centerX+Math.cos(rotB * 2 * Math.PI)*height*4.5
        y: centerY+Math.sin(rotB * 2 * Math.PI)*height*4.5
        text: "<b>" + batteryChargePercentage.value + "</b>"
    }

    Text {
        z: 9
        id: hourDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height*0.25
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
        z: 9
        id: dayofweekDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height*0.085
        font.family: "SlimSans"
        font.styleName:"light"
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.9
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: hourDisplay.top
        anchors.bottomMargin: -parent.height*0.03
        text: wallClock.time.toLocaleString(Qt.locale(), "dddd")
    }

    Text {
        z: 9
        id: dateDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height*0.085
        font.family: "SlimSans"
        font.styleName:"Regular"
        lineHeight: parent.height*0.0025
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.9
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: hourDisplay.bottom
        anchors.topMargin: -parent.height*0.036

        text: wallClock.time.toLocaleString(Qt.locale(), "dd MMMM")
    }

    ContextProperty {
        id: batteryChargePercentage
        key: "Battery.ChargePercentage"
        value: "100"
        Component.onCompleted: batteryChargePercentage.subscribe()
    }

    Connections {
        target: wallClock
        onTimeChanged: {
            var hour = wallClock.time.getHours()
            var minute = wallClock.time.getMinutes()
            var second = wallClock.time.getSeconds()
            var date = wallClock.time.getDate()
            batteryArc.requestPaint()
            if(secondHand.second != second) {
                secondHand.second = second
                secondHand.requestPaint()
                secondDisplay.second = second
                secondDisplay.requestPaint()
                secondArc.requestPaint()
            }if(minuteHand.minute != minute) {
                minuteHand.minute = minute
                minuteHand.requestPaint()
                minuteDisplay.minute = minute
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
        var date = wallClock.time.getDate()
        batteryArc.requestPaint()
        secondHand.second = second
        secondHand.requestPaint()
        secondDisplay.second = second
        secondDisplay.requestPaint()
        secondArc.requestPaint()
        minuteHand.minute = minute
        minuteHand.requestPaint()
        minuteDisplay.minute = minute
        minuteDisplay.requestPaint()
        hourArc.hour = hour
        hourArc.requestPaint()
    }
}
