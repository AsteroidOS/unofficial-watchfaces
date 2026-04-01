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

Item {
    id: root
    
    Canvas {
        id: minuteArc
        property int minute: 0
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d")
            var m   = minute
            var rot = (m - 15) * 6
            ctx.reset()
            ctx.lineWidth = parent.width / 10
            var gradient = ctx.createConicalGradient(parent.width / 2, parent.height / 2, 90 * 0.01745329252)
            gradient.addColorStop(1 - (m / 60),     Qt.rgba(0.318, 1, 0.051, 0.7))
            gradient.addColorStop(1 - (m / 60 / 2), Qt.rgba(0.318, 1, 0.051, 0.0))
            ctx.beginPath()
            ctx.arc(parent.width / 2, parent.height / 2, width / 2.75, -90 * 0.01745329252, rot * 0.01745329252, false)
            ctx.lineTo(parent.width / 2, parent.height / 2)
            ctx.fillStyle = gradient
            ctx.fill()
        }
    }
    
    Text {
        id: hourDisplay
        property real offset: height * 0.38
        renderType: Text.NativeRendering
        font.pixelSize: parent.height * 0.94
        font.family: "Bebas Neue"
        font.styleName: "Bold"
        color: Qt.rgba(1, 1, 1, 0.85)
        style: Text.Outline; styleColor: Qt.rgba(0, 0, 0, 0.4)
        horizontalAlignment: Text.AlignHCenter
        x: parent.width / 2 - width / 1.88
        y: parent.height / 2 - offset
        text: use12H.value ?
        wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) :
        wallClock.time.toLocaleString(Qt.locale(), "HH")
    }
    
    // Minute circle — plain Rectangle replaces Canvas full-circle arc
    Rectangle {
        id: minuteCircle
        property real minuteX: 0
        property real minuteY: 0
        width: parent.width / 8.8 * 2
        height: width
        radius: width / 2
        x: minuteX - width / 2
        y: minuteY - height / 2
        color: Qt.rgba(0.184, 0.184, 0.184, 0.98)
    }
    
    Text {
        id: minuteDisplay
        font.pixelSize: parent.height / 5.6
        font.family: "BebasKai"
        font.styleName: "Condensed"
        color: "white"
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }
    
    function updateMinute() {
        var m     = wallClock.time.getMinutes()
        var angle = (m - 15) / 60 * 2 * Math.PI
        var cx    = parent.width  / 2
        var cy    = parent.height / 2
        var r     = parent.width  / 2.75
        minuteCircle.minuteX = cx + Math.cos(angle) * r
        minuteCircle.minuteY = cy + Math.sin(angle) * r
        minuteDisplay.x = cx - minuteDisplay.width  / 2 + Math.cos(angle) * parent.width  * 0.364
        minuteDisplay.y = cy - minuteDisplay.height / 2 + Math.sin(angle) * parent.width  * 0.364
    }
    
    Connections {
        target: wallClock
        function onTimeChanged() {
            if (!visible) return
                var minute = wallClock.time.getMinutes()
                if (minuteArc.minute !== minute) {
                    minuteArc.minute = minute
                    minuteArc.requestPaint()
                    updateMinute()
                }
        }
    }
    
    Component.onCompleted: {
        minuteArc.minute = wallClock.time.getMinutes()
        minuteArc.requestPaint()
        updateMinute()
    }
}
