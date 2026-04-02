/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
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

import QtQuick 2.9

Item {

    Canvas {
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = parent.height / 48
            ctx.lineCap = "round"
            ctx.strokeStyle = Qt.rgba(0.1, 0.1, 0.1, 0.95)
            ctx.translate(parent.width / 2, parent.height / 2)
            for (var i = 0; i < 60; i++) {
                ctx.beginPath()
                ctx.moveTo(0, height * 0.365)
                ctx.lineTo(0, height * 0.405)
                ctx.stroke()
                ctx.rotate(Math.PI / 30)
            }
        }
    }

    Canvas {
        id: secondDisplay
        property int second: 0
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0.541, 0.796, 0.243, 0.85)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 5
            ctx.lineWidth = parent.height / 58
            ctx.lineCap = "round"
            ctx.strokeStyle = Qt.rgba(0.541, 0.796, 0.243, 1)
            ctx.translate(parent.width / 2, parent.height / 2)
            ctx.rotate(Math.PI)
            for (var i = 0; i <= second; i++) {
                ctx.beginPath()
                ctx.moveTo(0, height * 0.367)
                ctx.lineTo(0, height * 0.402)
                ctx.stroke()
                ctx.rotate(Math.PI / 30)
            }
        }
    }

    Text {
        id: hourDisplay
        renderType: Text.NativeRendering
        font {
            pixelSize: parent.height * 0.3
            family: "Titillium"
            styleName: "Bold"
        }
        color: "white"
        style: Text.Outline
        styleColor: Qt.rgba(0.1, 0.1, 0.1, 0.95)
        opacity: 0.98
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 4
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) :
        wallClock.time.toLocaleString(Qt.locale(), "HH")
    }
    
    Text {
        id: minuteDisplay
        renderType: Text.NativeRendering
        font {
            pixelSize: parent.height * 0.3
            family: "Titillium"
            styleName: "Light"
        }
        color: "white"
        style: Text.Outline
        styleColor: Qt.rgba(0.1, 0.1, 0.1, 0.95)
        opacity: 0.98
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 1.95
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    Connections {
        target: wallClock
        function onTimeChanged() {
            secondDisplay.second = wallClock.time.getSeconds()
            secondDisplay.requestPaint()
        }
    }
    
    Component.onCompleted: {
        secondDisplay.second = wallClock.time.getSeconds()
        secondDisplay.requestPaint()
    }
}
