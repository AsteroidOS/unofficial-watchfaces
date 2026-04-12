/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
 *               2018 - Timo Könnecke <el-t-mo@arcor.de>
 *               2017 - Mario Kicherer <dev@kicherer.org>
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

    readonly property var quotes: ["we all<br>are one", "get up<br>stand up", "never<br>give<br>up", "You can.<br>Period.", "you<br>are<br>awesome", "win<br>or<br>learn.", "earn<br>Respect", "keep on<br>keepin on", "believe<br>yourself", "just<br>do<br>it!", "excuses<br>are<br>invalid", "if not<br>you,<br>who?", "respect<br>yourself", "now<br>is the<br>time", "never<br>grow<br>up", "screw it,<br>do it!", "all you<br>need is<br>love", "you can<br>kick it", "live<br>what you<br>love", "dream<br>bigger", "strive<br>for<br>greatness", "aspire<br>to<br>inspire", "never<br>regret", "No guts<br>no story", "You<br>are<br>enough", "nobody<br>is<br>perfect", "different<br>is not<br>wrong", "smile<br>is free<br>therapy", "kindness<br>is<br>wisdom", "expect<br>nothing", "you are<br>your<br>choices", "own less<br>do more", "few things<br>more peace", "need less<br>have more", "Courage<br>dear<br>heart", "be brave<br>be free", "steady<br>wins<br>the race", "confidence<br>is<br>sexy", "creativity<br>takes<br>courage", "The doer<br>learneth", "be curious<br>don't<br>judge", "don't be<br>busy be<br>productive", "We rise<br>by lifting<br>others", "true men<br>hate<br>no one", "change<br>before you<br>have to", "Don't<br>worry be<br>happy.", "Worry less<br>smile more", "worries<br>master<br>you", "Stumbling<br>is not<br>falling", "never<br>regret<br>being kind", "enjoy<br>today", "choose<br>happy", "do<br>it with<br>love", "you<br>only live<br>once", "work hard<br>stay<br>humble", "you<br>matter", "shine<br>like the<br>stars", "Be a<br>voice Not<br>an echo", "pressure<br>makes<br>diamonds", "live<br>for<br>yourself"]

    function quoteText(minute) {
        return "<p style=\"text-align:center\">" + quotes[minute] + "</p>";
    }

    Component.onCompleted: {
        var hour = wallClock.time.getHours();
        var minute = wallClock.time.getMinutes();
        minuteHand.rotM = (minute - 15) / 60;
        minuteHand.requestPaint();
        hourHand.rotH = (hour - 3 + minute / 60) / 12;
        hourHand.requestPaint();
        var q = quoteText(minute);
        timeDisplay.text = q;
        timeShadow.text = "<b>" + q + "</b>";
        timeShadow2.text = "<b>" + q + "</b>";
    }

    Text {
        id: timeDisplay

        z: 4
        textFormat: Text.RichText
        font.pixelSize: parent.height * 0.15
        font.family: "Lobster"
        font.styleName: "Regular"
        font.capitalization: Font.Capitalize
        lineHeight: 0.8
        font.letterSpacing: 0.83
        color: Qt.rgba(1, 1, 1, 0.95)
        style: Text.Outline
        styleColor: Qt.rgba(1, 0.502, 0.502, 0.85)
        horizontalAlignment: Text.AlignHCenter
        y: parent.height / 2 - height / 1.8

        anchors {
            left: parent.left
            right: parent.right
        }

        transform: Rotation {
            origin.x: timeDisplay.width / 2
            origin.y: timeDisplay.height / 2
            angle: -4
        }

        Behavior on text {
            SequentialAnimation {
                NumberAnimation {
                    target: timeDisplay
                    property: "opacity"
                    to: 0
                    duration: 150
                }

                PropertyAction {
                }

                NumberAnimation {
                    target: timeDisplay
                    property: "opacity"
                    to: 1
                    duration: 150
                }

            }

        }

    }

    Text {
        id: timeShadow

        z: 3
        textFormat: Text.RichText
        font.pixelSize: parent.height * 0.16
        font.family: "Lobster"
        font.styleName: "Regular"
        font.capitalization: Font.Capitalize
        lineHeight: 0.8
        font.letterSpacing: 0.83
        color: Qt.rgba(1, 0.667, 0.667, 0.8)
        horizontalAlignment: Text.AlignHCenter
        y: parent.height / 2 - height / 1.8

        anchors {
            left: parent.left
            right: parent.right
        }

        transform: Rotation {
            origin.x: timeDisplay.width / 2
            origin.y: timeDisplay.height / 2
            angle: -8
        }

    }

    Text {
        id: timeShadow2

        z: 2
        textFormat: Text.RichText
        font.pixelSize: parent.height * 0.17
        font.family: "Lobster"
        font.styleName: "Regular"
        font.capitalization: Font.Capitalize
        lineHeight: 0.8
        font.letterSpacing: 0.83
        color: Qt.rgba(1, 0.667, 0.667, 0.5)
        horizontalAlignment: Text.AlignHCenter
        y: parent.height / 2 - height / 1.8

        anchors {
            left: parent.left
            right: parent.right
        }

        transform: Rotation {
            origin.x: timeDisplay.width / 2
            origin.y: timeDisplay.height / 2
            angle: -12
        }

    }

    Canvas {
        id: hourHand

        property real rotH: 0

        z: 0
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.lineCap = "round";
            ctx.lineWidth = parent.width * 0.08;
            var angle = rotH * 2 * Math.PI;
            var gradient = ctx.createRadialGradient(parent.width / 2, parent.height / 2, 0, parent.width / 2, parent.height / 2, parent.width);
            gradient.addColorStop(0.1, Qt.rgba(0.243, 1, 0.984, 0.05));
            gradient.addColorStop(0.6, Qt.rgba(0.243, 1, 0.984, 1));
            ctx.strokeStyle = gradient;
            ctx.shadowColor = Qt.rgba(1, 1, 1, 0.7);
            ctx.shadowOffsetX = 1;
            ctx.shadowOffsetY = 1;
            ctx.shadowBlur = 4;
            ctx.beginPath();
            ctx.moveTo(parent.width / 2, parent.height / 2);
            ctx.lineTo(parent.width / 2 + Math.cos(angle) * height, parent.height / 2 + Math.sin(angle) * width);
            ctx.stroke();
            ctx.closePath();
            ctx.beginPath();
            ctx.lineWidth = parent.width * 0.016;
            ctx.moveTo(parent.width / 2 + Math.cos(angle) * height * 0.35, parent.height / 2 + Math.sin(angle) * width * 0.35);
            ctx.lineTo(parent.width / 2 + Math.cos(angle) * height, parent.height / 2 + Math.sin(angle) * width);
            ctx.stroke();
            ctx.closePath();
        }
    }

    Canvas {
        id: minuteHand

        property real rotM: 0

        z: 1
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.lineCap = "round";
            ctx.lineWidth = parent.width * 0.06;
            var angle = rotM * 2 * Math.PI;
            var gradient = ctx.createRadialGradient(parent.width / 2, parent.height / 2, 0, parent.width / 2, parent.height / 2, parent.width);
            gradient.addColorStop(0.1, Qt.rgba(0.416, 1, 0.416, 0.05));
            gradient.addColorStop(0.6, Qt.rgba(0.416, 1, 0.416, 1));
            ctx.strokeStyle = gradient;
            ctx.shadowColor = Qt.rgba(1, 1, 1, 0.7);
            ctx.shadowOffsetX = 1;
            ctx.shadowOffsetY = 1;
            ctx.shadowBlur = 3;
            ctx.beginPath();
            ctx.moveTo(parent.width / 2, parent.height / 2);
            ctx.lineTo(parent.width / 2 + Math.cos(angle) * height, parent.height / 2 + Math.sin(angle) * width);
            ctx.stroke();
            ctx.closePath();
            ctx.beginPath();
            ctx.lineWidth = parent.width * 0.016;
            ctx.moveTo(parent.width / 2 + Math.cos(angle) * height * 0.35, parent.height / 2 + Math.sin(angle) * width * 0.35);
            ctx.lineTo(parent.width / 2 + Math.cos(angle) * height, parent.height / 2 + Math.sin(angle) * width);
            ctx.stroke();
            ctx.closePath();
        }
    }

    Canvas {
        property real voffset: -parent.height * 0.017

        z: 3
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.fillStyle = "white";
            ctx.strokeStyle = Qt.rgba(1, 0.667, 0.667, 0.8);
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.font = "bold " + height * 0.13 + "px Lobster";
            ctx.translate(parent.width / 2, parent.height / 2);
            for (var i = 1; i < 13; i++) {
                var x = Math.cos((i - 3) / 12 * 2 * Math.PI) * height * 0.42;
                var y = Math.sin((i - 3) / 12 * 2 * Math.PI) * height * 0.42 - voffset;
                ctx.beginPath();
                ctx.fillText(i, x, y);
                ctx.strokeText(i, x, y);
                ctx.closePath();
            }
        }
    }

    Connections {
        function onTimeChanged() {
            if (!visible)
                return ;

            var hour = wallClock.time.getHours();
            var minute = wallClock.time.getMinutes();
            minuteHand.rotM = (minute - 15) / 60;
            minuteHand.requestPaint();
            hourHand.rotH = (hour - 3 + minute / 60) / 12;
            hourHand.requestPaint();
            var q = quoteText(minute);
            if (timeDisplay.text !== q) {
                timeDisplay.text = q;
                timeShadow.text = "<b>" + q + "</b>";
                timeShadow2.text = "<b>" + q + "</b>";
            }
        }

        target: wallClock
    }

}
