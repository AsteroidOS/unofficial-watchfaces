/*
 * Copyright (C) 2021 - Timo Könnecke <el-t-mo@arcor.de>
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
    id: root
    clip: true
    width: parent.width
    height: parent.height

    property var radian: 0.01745

    Rectangle {
        z:0
        id: circleTransBack
        antialiasing : true
        property var toggle: 1
        x: root.width/2-width/2
        y: root.height/2-width/2
        color: Qt.rgba(0, 0, 0, 0.3)
        width: parent.width*0.65
        height: parent.height*0.65
        radius: width*0.5
    }

    Canvas {
        z: 1
        id: secondCanvas
        property var second: 0
        property var minute: 0
        property var colorctx: Qt.rgba(0, 0, 0, 0.6)
        anchors.fill: parent
        smooth: true
        renderStrategy: Canvas.Threaded
        onPaint: {
            var ctx = getContext("2d")
            var rot = (second - 15)*6
            var start1 = (minute)*5.9
            var start2 = (minute)*5.9
            ctx.reset()
            ctx.beginPath()
            ctx.arc(parent.width/2,
                    parent.height/2,
                    parent.width * 0.214,
                    (rot+start1-15) * radian,
                    (-90+start2-15) * radian, false
                    );
            ctx.lineWidth = parent.width * 0.22
            ctx.strokeStyle = colorctx
            ctx.stroke()
        }
    }

    Rectangle {
        z:2
        id: circlePulse
        antialiasing : true
        x: root.width/2-width/2
        y: root.height/2-width/2
        color: Qt.rgba(0, 0, 0, 1)
        width: if (wallClock.time.getSeconds() % 2) {parent.width*0.5} else {parent.width*0.65 }
        height: if (wallClock.time.getSeconds() % 2) {parent.height*0.5} else {parent.height*0.65}
        radius: width*0.5
        Behavior on width {
               NumberAnimation { easing.type: Easing.OutExpo; duration: 1000 }
        }
        Behavior on height {
               NumberAnimation { easing.type: Easing.OutExpo; duration: 1000 }
        }
    }

    Rectangle {
        z:3
        id: circleDoubleClickCover
        antialiasing : true
        property var toggle: 1
        x: root.width/2-width/2
        y: root.height/2-width/2
        color: "black"
        width: parent.width*0.5
        height: parent.height*0.5
        radius: width*0.5
        MouseArea {
            anchors.fill: parent
            onDoubleClicked: {
               if (circleDoubleClickCover.toggle === 1) {
                    grow.start()
                    fadeToWhiteBG.start()
                    secondCanvas.colorctx = Qt.rgba(1, 1, 1, 0.6);
                    secondCanvas.requestPaint();
                    shrink.start()
                    circleDoubleClickCover.toggle = 0
               } else {
                    grow.start()
                    fadeToBlackBG.start()
                    secondCanvas.colorctx = Qt.rgba(0, 0, 0, 0.6);
                    secondCanvas.requestPaint();
                    shrink.start()
                    circleDoubleClickCover.toggle = 1
                }
            }
        }
        ParallelAnimation { id: fadeToWhiteBG;
            PropertyAnimation {target: circleDoubleClickCover; properties: "color"; to: "white"; duration: 600}
            PropertyAnimation {target: circlePulse; properties: "color"; to: Qt.rgba(1, 1, 1, 1); duration: 600}
            PropertyAnimation {target: minuteDisplay; properties: "color"; to: "black"; duration: 600}
            PropertyAnimation {target: hourDisplay; properties: "color"; to: "black"; duration: 600}
            PropertyAnimation {target: circleTransBack; properties: "color"; to: Qt.rgba(1, 1, 1, 0.3); duration: 600}
            PropertyAnimation {target: minuteCircle; properties: "color"; to: "white"; duration: 600}
        }
        ParallelAnimation { id: fadeToBlackBG;
            PropertyAnimation {target: circleDoubleClickCover; properties: "color"; to: "black"; duration: 600}
            PropertyAnimation {target: circlePulse; properties: "color"; to: Qt.rgba(0, 0, 0, 1); duration: 600}
            PropertyAnimation {target: minuteDisplay; properties: "color"; to: "white"; duration: 600}
            PropertyAnimation {target: hourDisplay; properties: "color"; to: "white"; duration: 600}
            PropertyAnimation {target: circleTransBack; properties: "color"; to: Qt.rgba(0, 0, 0, 0.3); duration: 600}
            PropertyAnimation {target: minuteCircle; properties: "color"; to: "black"; duration: 600}
        }
        ParallelAnimation { id: grow;
            PropertyAnimation {target: circleDoubleClickCover; properties: "height"; to: parent.width*0.9; duration: 0}
            PropertyAnimation {target: circleDoubleClickCover; properties: "width"; to: parent.width*0.9; duration: 0}
        }
        ParallelAnimation { id: shrink;
            PropertyAnimation {target: circleDoubleClickCover; properties: "height"; to: parent.width*0.5; duration: 600}
            PropertyAnimation {target: circleDoubleClickCover; properties: "width"; to: parent.width*0.5; duration: 600}
        }
    }

    Rectangle {
        z: 4
        id: minuteCircle
        antialiasing : true
        property var rotM: (wallClock.time.getMinutes() - 15)/60
        property var centerX: parent.width/2-width/2
        property var centerY: parent.height/2-height/2
        x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.30
        y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.30
        color: "black"
        opacity: 1
        width: parent.width*0.24
        height: parent.height*0.24
        radius: width*0.5
        Behavior on x {
               NumberAnimation { easing.type: Easing.OutExpo; duration: 500 }
        }
        Behavior on y {
               NumberAnimation { easing.type: Easing.OutExpo; duration: 500 }
        }
    }

    Text {
        z: 5
        id: minuteDisplay
        property var rotM: (wallClock.time.getMinutes() - 15)/60
        property var centerX: parent.width/2-width/2
        property var centerY: parent.height/2-height/2
        font.pixelSize: parent.height/7.4
        font.family: "SourceSansPro"
        font.styleName:"Regular"
        color: "white"
        opacity: 1.00
        x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.30
        y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.30
        Behavior on text {
            SequentialAnimation {
                NumberAnimation { target: minuteDisplay; property: "opacity"; to: 0 }
                PropertyAction {}
                NumberAnimation { target: minuteDisplay; property: "opacity"; to: 1 }
            }
        }
        Behavior on x {
               NumberAnimation { easing.type: Easing.OutExpo; duration: 500 }
        }
        Behavior on y {
               NumberAnimation { easing.type: Easing.OutExpo; duration: 500 }
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    Text {
        z: 6
        id: hourDisplay
        property var hour: if (use12H.value) {if (wallClock.time.getHours() !== 12) wallClock.time.getHours() % 12; else 12} else wallClock.time.getHours()
        font.pixelSize: parent.height*0.36
        font.family: "SourceSansPro"
        font.styleName:"Semibold"
        font.letterSpacing: -parent.height*0.026
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "white"
        opacity: 1.0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: -parent.width*0.0010
        anchors.verticalCenterOffset: parent.width*0.0015
        Behavior on text {
            SequentialAnimation {
                NumberAnimation { target: hourDisplay; property: "opacity"; to: 0 }
                PropertyAction {}
                NumberAnimation { target: hourDisplay; property: "opacity"; to: 1 }
            }
        }
        text: hour
    }

    Connections {
        target: wallClock
        onTimeChanged: {
            var minute = wallClock.time.getMinutes()
            var second = wallClock.time.getSeconds()
            if(secondCanvas.second !== second) {
                secondCanvas.second = second
                secondCanvas.minute = minute
                secondCanvas.requestPaint()
            }
        }
    }

    Component.onCompleted: {
        var minute = wallClock.time.getMinutes()
        var second = wallClock.time.getSeconds()
        secondCanvas.second = second
        secondCanvas.minute = minute
        secondCanvas.requestPaint()
    }
}
