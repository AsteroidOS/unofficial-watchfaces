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
        z: 3
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = parent.height/48
            ctx.lineCap="round"
            ctx.strokeStyle = Qt.rgba(0.1, 0.1, 0.1, 0.95)

            ctx.translate(parent.width/2, parent.height/2)
            for (var i=0; i < 60; i++) {
                // do not paint a minute stroke when there is an hour stroke
                //if ((i%5) != 0) {
                    ctx.beginPath()
                    ctx.moveTo(0, height*0.365)
                    ctx.lineTo(0, height*0.405)
                    ctx.stroke()
                //}
                ctx.rotate(Math.PI/30)
            }
        }
    }

    Canvas {
        z: 6
        id: secondDisplay
        property var second: 0
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.shadowColor = Qt.rgba(0.541, 0.796, 0.243, 0.85)
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 5
            ctx.lineWidth = parent.height/58
            ctx.lineCap="round"
            ctx.strokeStyle = Qt.rgba(0.541, 0.796, 0.243, 1)
            ctx.translate(parent.width/2, parent.height/2)
            ctx.rotate(Math.PI)
            for (var i=0; i <= wallClock.time.getSeconds(); i++) {
                ctx.beginPath()
                ctx.moveTo(0, height*0.367)
                ctx.lineTo(0, height*0.402)
                ctx.stroke()
                ctx.rotate(Math.PI/30)
            }
        }
    }

    Text {
        z: 6
        id: hourDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height*0.3
        font.family: "Titillium"
        font.styleName:"Bold"
        color: "white"
        style: Text.Outline;
        styleColor: Qt.rgba(0.1, 0.1, 0.1, 0.95)
        opacity: 0.98
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 4
        text: wallClock.time.toLocaleString(Qt.locale(), "HH")
    }
    /*minute text*/
    Text {
        z: 6
        id: minuteDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height*0.3
        font.family: "Titillium"
        font.styleName:"Light"
        color: "white"
        style: Text.Outline;
        styleColor: Qt.rgba(0.1, 0.1, 0.1, 0.95)
        opacity: 0.98
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 1.95
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    Connections {
        target: wallClock
        onTimeChanged: {
            var second = wallClock.time.getSeconds()
            if(secondDisplay.second != second) {
                secondDisplay.second = second
                secondDisplay.requestPaint()
            }
        }
     }

     Component.onCompleted: {
        var second = wallClock.time.getSeconds()
        secondDisplay.second = second
        secondDisplay.requestPaint()
        secondDisplay.requestPaint()

     }

}
