/*
* Copyright (C) 2018 - Timo Könnecke <el-t-mo@arcor.de>
 *              2017 - Mario Kicherer <dev@kicherer.org>
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
 * This watchface is based on the official analog watchface but comes
 * with a seconds hand, strokes for hours and minutes, correct
 * dropshadows for the hands and other small improvements.
 */

import QtQuick 2.1

Item {
    property var radian: 0.01745

    function generateTime(time) {
        var quotes = ["we all<br>are one",
                      "get up<br>stand up",
                      "never<br>give<br>up",
                      "You can.<br>Period.",
                      "you<br>are<br>awesome",
                      "win<br>or<br>learn.",
                      "earn<br>Respect",
                      "keep on<br>keepin on",
                      "believe<br>yourself",
                      "just<br>do<br>it!",
                      "excuses<br>are<br>invalid",
                      "if not<br>you,<br>who?",
                      "respect<br>yourself",
                      "now<br>is the<br>time",
                      "never<br>grow<br>up",
                      "screw it,<br>do it!",
                      "all you<br>need is<br>love",
                      "you can<br>kick it",
                      "live<br>what you<br>love",
                      "dream<br>bigger",
                      "strive<br>for<br>greatness",
                      "aspire<br>to<br>inspire",
                      "never<br>regret",
                      "No guts<br>no story",
                      "You<br>are<br>enough",
                      "nobody<br>is<br>perfect",
                      "different<br>is not<br>wrong",
                      "smile<br>is free<br>therapy",
                      "kindness<br>is<br>wisdom",
                      "expect<br>nothing",
                      "you are<br>your<br>choices",
                      "own less<br>do more",
                      "few things<br>more peace",
                      "need less<br>have more",
                      "Courage<br>dear<br>heart",
                      "be brave<br>be free",
                      "steady<br>wins<br>the race",
                      "confidence<br>is<br>sexy",
                      "creativity<br>takes<br>courage",
                      "The doer<br>learneth",
                      "be curious<br>don't<br>judge",
                      "don’t be<br>busy be<br>productive",
                      "We rise<br>by lifting<br>others",
                      "true men<br>hate<br>no one",
                      "change<br>before you<br>have to",
                      "Don't<br>worry be<br>happy.",
                      "Worry less<br>smile more",
                      "worries<br>master<br>you",
                      "Stumbling<br>is not<br>falling",
                      "never<br>regret<br>being kind",
                      "enjoy<br>today",
                      "choose<br>happy",
                      "do<br>it with<br>love",
                      "you<br>only live<br>once",
                      "work hard<br>stay<br>humble",
                      "you<br>matter",
                      "shine<br>like the<br>stars",
                      "Be a<br>voice Not<br>an echo",
                      "pressure<br>makes<br>diamonds",
                      "live<br>for<br>yourself"]

        var start = "<p style=\"text-align:center\">"
        var newline = "<br>"
        var end = "</p>"

        return start + quotes[time.getMinutes()] + end
    }

    Text {
        z: 4
        id: timeDisplay
        textFormat: Text.RichText
        font.pixelSize: parent.height*0.15
        font.family: "Lobster"
        font.styleName:"Regular"
        font.capitalization: Font.Capitalize
        lineHeight: 0.8
        font.letterSpacing: 0.83
        color: Qt.rgba(1, 1, 1, 0.95)
        style: Text.Outline; styleColor: Qt.rgba(1, 0.502, 0.502, 0.85)
        horizontalAlignment: Text.AlignHCenter
        Behavior on text {
            SequentialAnimation {
                NumberAnimation { target: timeDisplay; property: "opacity"; to: 0 }
                PropertyAction {}
                NumberAnimation { target: timeDisplay; property: "opacity"; to: 1 }
            }
        }
        anchors {
            left: parent.left
            right: parent.right
        }
        y: parent.height/2-height/1.8

        text: generateTime(wallClock.time)
        transform: Rotation {origin.x: timeDisplay.width/2; origin.y: timeDisplay.height/2; angle: -4}
    }

    Text {
        z: 3
        id: timeShadow
        textFormat: Text.RichText
        font.pixelSize: parent.height*0.16
        font.family: "Lobster"
        font.styleName:"Regular"
        font.capitalization: Font.Capitalize
        lineHeight: 0.8
        font.letterSpacing: 0.83
        color: Qt.rgba(1, 0.667, 0.667, 0.80)
        horizontalAlignment: Text.AlignHCenter
        Behavior on text {
            SequentialAnimation {
                NumberAnimation { target: timeDisplay; property: "opacity"; to: 0 }
                PropertyAction {}
                NumberAnimation { target: timeDisplay; property: "opacity"; to: 1 }
            }
        }
        anchors {
            left: parent.left
            right: parent.right
        }
        y: parent.height/2-height/1.8

        text: "<b>" + generateTime(wallClock.time) + "</b>"
        transform: Rotation {origin.x: timeDisplay.width/2; origin.y: timeDisplay.height/2; angle: -8}
    }

    Text {
        z: 2
        id: timeShadow2
        textFormat: Text.RichText
        font.pixelSize: parent.height*0.17
        font.family: "Lobster"
        font.styleName:"Regular"
        font.capitalization: Font.Capitalize
        lineHeight: 0.8
        font.letterSpacing: 0.83
        color: Qt.rgba(1, 0.667, 0.667, 0.50)
        horizontalAlignment: Text.AlignHCenter
        Behavior on text {
            SequentialAnimation {
                NumberAnimation { target: timeDisplay; property: "opacity"; to: 0 }
                PropertyAction {}
                NumberAnimation { target: timeDisplay; property: "opacity"; to: 1 }
            }
        }
        anchors {
            left: parent.left
            right: parent.right
        }
        y: parent.height/2-height/1.8

        text: "<b>" + generateTime(wallClock.time) + "</b>"
        transform: Rotation {origin.x: timeDisplay.width/2; origin.y: timeDisplay.height/2; angle: -12}
    }

    Canvas {
        z: 0
        id: hourHand
        property var hour: 0
        property var rotH: (wallClock.time.getHours()-3 + wallClock.time.getMinutes()/60) / 12
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.lineCap="round"
            ctx.beginPath()
            ctx.lineWidth = parent.width*0.08
            var gradient = ctx.createRadialGradient (parent.width/2, parent.height/2, 0, parent.width/2, parent.height/2, parent.width)
            gradient.addColorStop(0.10, Qt.rgba(0.243, 1, 0.984, 0.05))
            gradient.addColorStop(0.60, Qt.rgba(0.243, 1, 0.984, 1.0))
            ctx.strokeStyle = gradient
            ctx.shadowColor = Qt.rgba(1, 1, 1, 0.7)
            ctx.shadowOffsetX = 1
            ctx.shadowOffsetY = 1
            ctx.shadowBlur = 4
            ctx.moveTo(parent.width/2,
                       parent.height/2)
            ctx.lineTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*height,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()
            ctx.lineWidth = parent.width*0.016
            ctx.strokeStyle = gradient
            ctx.moveTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*height*0.35,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width*0.35)
            ctx.lineTo(parent.width/2+Math.cos(rotH * 2 * Math.PI)*height,
                       parent.height/2+Math.sin(rotH * 2 * Math.PI)*width)
            ctx.stroke()
            ctx.closePath()
        }
    }

    Canvas {
        z: 1
        id: minuteHand
        property var minute: 0
        property var rotM: (wallClock.time.getMinutes() - 15)/60
        anchors.fill: parent
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.lineCap="round"
            ctx.lineWidth = parent.width*0.06
            var gradient = ctx.createRadialGradient (parent.width/2, parent.height/2, 0, parent.width/2, parent.height/2, parent.width)
            gradient.addColorStop(0.10, Qt.rgba(0.416, 1, 0.416, 0.05))
            gradient.addColorStop(0.60, Qt.rgba(0.416, 1, 0.416, 1.0))
            ctx.strokeStyle = gradient
            ctx.shadowColor = Qt.rgba(1, 1, 1, 0.7)
            ctx.shadowOffsetX = 1
            ctx.shadowOffsetY = 1
            ctx.shadowBlur = 3
            ctx.beginPath()
            ctx.moveTo(parent.width/2,
                       parent.height/2)
            ctx.lineTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*height,
                       parent.height/2+Math.sin(rotM * 2 * Math.PI)*width)
            ctx.stroke()
            ctx.closePath()
            ctx.beginPath()
            ctx.lineWidth = parent.width*0.016
            ctx.strokeStyle = gradient
            ctx.moveTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*height*0.35,
                       parent.height/2+Math.sin(rotM * 2 * Math.PI)*width*0.35)
            ctx.lineTo(parent.width/2+Math.cos(rotM * 2 * Math.PI)*height,
                       parent.height/2+Math.sin(rotM * 2 * Math.PI)*width)
            ctx.stroke()
            ctx.closePath()
        }
    }

    // number strokes
    Canvas {
        z: 3
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject
        property var voffset: -parent.height*0.017
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.fillStyle = "white"
            ctx.strokeStyle = Qt.rgba(1, 0.667, 0.667, 0.80)
            ctx.textAlign = "center"
            ctx.textBaseline = 'middle';
            ctx.translate(parent.width/2, parent.height/2)
            for (var i=1; i < 13; i++) {
                ctx.beginPath()
                ctx.font = "bold "+ height*0.13 + "px Lobster"
                ctx.fillText(i,
                             Math.cos((i-3)/12 * 2 * Math.PI)*height*0.42,
                             (Math.sin((i-3)/12 * 2 * Math.PI)*height*0.42)-voffset)
                ctx.strokeText(i,
                             Math.cos((i-3)/12 * 2 * Math.PI)*height*0.42,
                             (Math.sin((i-3)/12 * 2 * Math.PI)*height*0.42)-voffset)
                ctx.closePath()
            }
        }
    }

    Connections {
        target: wallClock
        onTimeChanged: {
            minuteHand.requestPaint()
            hourHand.requestPaint()
        }
    }

    Component.onCompleted: {
        minuteHand.requestPaint()
        hourHand.requestPaint()
    }
}
