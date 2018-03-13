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

/*
 * Based on analog-precison by Mario Kicherer. Remodeled the arms to arcs
 * and tried hard on font centering and anchor alignment.
 */

import QtQuick 2.1
import org.freedesktop.contextkit 1.0
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0

Item {
    property var radian: 0.01745

    Rectangle {
        z: 0
        x: parent.width/2-width/2
        y: parent.height/2-width/2
        color: Qt.rgba(0, 0, 0, 0.30)
        width: parent.width/1.478
        height: parent.height/1.48
        radius: width*0.5
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
            ctx.lineCap="round"
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 2.2, -90* radian, rot* radian, false);
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
            var rot = (minute -15 )*6
            ctx.reset()
            ctx.lineCap="round"
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 2.35, -88.8* radian, rot* radian, false);
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
            var rot = 0.5 * (60 * (hour-3) + wallClock.time.getMinutes())
            ctx.reset()
            ctx.lineCap="round"
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, width / 2.6,  271.5* radian, rot* radian, false);
            ctx.lineWidth = parent.width/30
            ctx.strokeStyle = Qt.rgba(0.945, 0.769, 0.059, 0.9)
            ctx.stroke()
            ctx.beginPath()
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
            ctx.lineCap="round"
            ctx.lineWidth = parent.width/72
            ctx.strokeStyle = batteryChargePercentage.value < 30 ? 'red': Qt.rgba(0.263, 0.682, 0.098, 0.9)
            ctx.beginPath()
            ctx.arc(parent.width/2, parent.height/2, parent.width / 2.835, 270* 0.01745329252, ((batteryChargePercentage.value/100*360)+270)* 0.01745329252, false);
            ctx.stroke()
            ctx.closePath()
        }
    }

    Text {
        id: hourDisplay
        font.pixelSize: parent.height/2.6
        font.family: "Titillium"
        font.styleName:'Regular'
        font.letterSpacing: -parent.width*0.01
        color: Qt.rgba(1, 1, 1, 1)
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.25)
        anchors {
            right: parent.horizontalCenter
            rightMargin: -parent.height/10.3
            top: parent.verticalCenter
            topMargin: -parent.height*0.166
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "HH")
    }

    Text {
        id: minuteDisplay
        property var rotM: (wallClock.time.getMinutes() - 12.1)/60
        font.pixelSize: parent.height/6.2
        font.family: "Titillium"
        font.styleName:'Regular'
        font.letterSpacing: -parent.width*0.01
        color: Qt.rgba(1, 1, 1, 1)
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.25)
        anchors {
            top: hourDisplay.top;
            topMargin: parent.height*0.023
            leftMargin: parent.width*0.0175
            left: hourDisplay.right;
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    Text {
        id: secondDisplay
        font.pixelSize: parent.height/6.3
        font.family: "Titillium"
        font.styleName:'Thin'
        font.letterSpacing: -parent.width*0.01
        color: Qt.rgba(1, 1, 1, 1)
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.2)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            bottom: hourDisplay.bottom;
            bottomMargin: parent.height*0.055
            leftMargin: parent.width*0.0175
            left: hourDisplay.right;
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "ss")
    }

    Text {
        id: dowDisplay
        font.pixelSize: parent.height*0.065
        font.family: "Titillium"
        font.styleName:'Thin'
        color: Qt.rgba(1, 1, 1, 1)
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.2)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            bottomMargin: parent.height*0.025
            bottom: hourDisplay.top
            left: parent.left
            right: parent.right
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "dddd")
    }

    Text {
        id: dateDisplay
        font.pixelSize: parent.height*0.06
        font.family: "Titillium"
        font.styleName:'Thin'
        color: Qt.rgba(1, 1, 1, 1)
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.2)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            topMargin: -parent.height*0.05
            top: hourDisplay.bottom
            left: parent.left
            right: parent.right
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "yyyy MM <b>dd</b>")
    }

    Text {
        id: batteryDisplay
        font.pixelSize: parent.height*0.045
        font.family: "Titillium"
        font.styleName:'Regular'
        color: batteryChargePercentage.value < 30 ? 'red': Qt.rgba(0.263, 0.682, 0.098, 1)
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.2)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            top: dateDisplay.bottom
            topMargin: parent.height*0.014
            left: parent.left
            right: parent.right
        }
        text: "charged <b>" + batteryChargePercentage.value +"</b>%"
    }

    ContextProperty {
        id: batteryChargePercentage
        key: "Battery.ChargePercentage"
        value: "100"
        Component.onCompleted: batteryChargePercentage.subscribe()
    }

    Connections {
        target: wallClock //wallClock.time
        onTimeChanged: {
            var hour = wallClock.time.getHours()
            var minute = wallClock.time.getMinutes()
            var second = wallClock.time.getSeconds()
            batteryArc.requestPaint()
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
        batteryArc.requestPaint()
        secondCanvas.second = second
        secondCanvas.requestPaint()
        minuteCanvas.minute = minute
        minuteCanvas.requestPaint()
        hourCanvas.hour = hour
        hourCanvas.requestPaint()
    }
}
