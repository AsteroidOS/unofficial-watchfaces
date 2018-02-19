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
    id: root
    width: parent.width
    height: parent.height

    Canvas {
        z: 1
        id: secondCanvas
        property var second: 0
        anchors.fill: parent
        smooth: true
        renderTarget: Canvas.FramebufferObject
        onPaint: {
            var ctx = getContext("2d")
            var date = wallClock.time.getDate()
            var rot = (wallClock.time.getSeconds() - 15)*6
            ctx.reset()
            ctx.beginPath()
            ctx.lineWidth = parent.width/42
            ctx.fillStyle = Qt.rgba(1, 0.549, 0.149, 0.7)
            ctx.arc(parent.width/2, parent.height/2, width / 2.1, -90*0.01745329252, rot*0.01745329252, false);
            ctx.lineTo(parent.width/2, parent.height/2)
            ctx.fill()
        }
    }

    Rectangle {
        z: 2
        x: root.width/2-width/2
        y: root.height/2-width/2
        color: Qt.rgba(0.184, 0.184, 0.184, 0.7)
        width: parent.width*0.465
        height: parent.height*0.465
        radius: width*0.5
    }

    Text {
        z: 3
        id: hourDisplay
        font.pixelSize: parent.height*0.16
        font.family: "Raleway"
        font.styleName:"Regular"
        color: "white"
        opacity: 1.0
        style: Text.Outline; styleColor: "#80000000"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "<b>HH</b>:mm")
    }

    Connections {
        target: wallClock
        onTimeChanged: {
            var second = wallClock.time.getSeconds()
            if(secondCanvas.second != second) {
                secondCanvas.second = second
                secondCanvas.requestPaint()
            }
        }
    }

    Component.onCompleted: {
        var second = wallClock.time.getSeconds()
        secondCanvas.second = second
        secondCanvas.requestPaint()
    }
}
