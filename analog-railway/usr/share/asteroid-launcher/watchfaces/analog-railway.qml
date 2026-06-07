// SPDX-FileCopyrightText: 2018 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2017 Mario Kicherer <dev@kicherer.org>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later
// analog-railway — inspired by analog-precision by Mario Kicherer
// Homage to classic European railway service clocks. Canvas-drawn
// polygon hands with a signature red second arm carrying a circle arc.

import QtQuick

Item {
    id: root

    property real radian: 0.01745

    Component.onCompleted: {
        var hour = wallClock.time.getHours();
        var minute = wallClock.time.getMinutes();
        var second = wallClock.time.getSeconds();
        secondHand.second = second;
        secondHand.requestPaint();
        minuteHand.minute = minute;
        hourHand.minute = minute;
        minuteHand.requestPaint();
        hourHand.hour = hour;
        hourHand.requestPaint();
    }

    // background circle — static, paints once only
    Canvas {
        z: 0
        anchors.fill: parent
        antialiasing: true
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.75);
            ctx.shadowOffsetX = 0;
            ctx.shadowOffsetY = 0;
            ctx.shadowBlur = 12;
            ctx.fillStyle = Qt.rgba(1, 1, 1, 1);
            ctx.beginPath();
            ctx.arc(parent.height / 2, parent.width / 2, parent.width * 0.36, 0 * radian, 360 * radian, false);
            ctx.fill();
            ctx.closePath();
        }
    }

    // hour strokes — static, paints once only
    Canvas {
        z: 1
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            ctx.lineWidth = parent.width * 0.024;
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.9);
            ctx.translate(parent.width / 2, parent.height / 2);
            for (var i = 0; i < 4; i++) {
                ctx.beginPath();
                ctx.moveTo(0, height * 0.25);
                ctx.lineTo(0, height * 0.35);
                ctx.stroke();
                ctx.rotate(Math.PI / 2);
            }
        }
    }

    // 5min strokes — static, paints once only
    Canvas {
        z: 1
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            ctx.lineWidth = parent.width * 0.022;
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.9);
            ctx.translate(parent.width / 2, parent.height / 2);
            for (var i = 0; i < 12; i++) {
                ctx.beginPath();
                ctx.moveTo(0, height * 0.27);
                ctx.lineTo(0, height * 0.35);
                ctx.stroke();
                ctx.rotate(Math.PI / 6);
            }
        }
    }

    // minute strokes — static, paints once only
    Canvas {
        z: 1
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            ctx.lineWidth = parent.width * 0.015;
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.9);
            ctx.translate(parent.width / 2, parent.height / 2);
            for (var i = 0; i < 60; i++) {
                if ((i % 5) !== 0) {
                    ctx.beginPath();
                    ctx.moveTo(0, height * 0.315);
                    ctx.lineTo(0, height * 0.35);
                    ctx.stroke();
                }
                ctx.rotate(Math.PI / 30);
            }
        }
    }

    Canvas {
        id: hourHand

        property real hour: 0
        property real minute: 0

        z: 2
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.5);
            ctx.shadowOffsetX = 2;
            ctx.shadowOffsetY = 2;
            ctx.shadowBlur = 2;
            ctx.beginPath();
            ctx.fillStyle = Qt.rgba(0, 0, 0, 1);
            ctx.moveTo(parent.width / 2 + Math.cos(((hour - 3 + minute / 60) / 12) * 2 * Math.PI) * width * 0.2, parent.height / 2 + Math.sin(((hour - 3 + minute / 60) / 12) * 2 * Math.PI) * width * 0.2);
            ctx.lineTo(parent.width / 2 + Math.cos(((hour - 3.14 + minute / 60) / 12) * 2 * Math.PI) * width * 0.19, parent.height / 2 + Math.sin(((hour - 3.14 + minute / 60) / 12) * 2 * Math.PI) * width * 0.19);
            ctx.lineTo(parent.width / 2 + Math.cos(((hour - 8.43 + minute / 60) / 12) * 2 * Math.PI) * width * 0.05, parent.height / 2 + Math.sin(((hour - 8.43 + minute / 60) / 12) * 2 * Math.PI) * width * 0.05);
            ctx.lineTo(parent.width / 2 + Math.cos(((hour - 9.57 + minute / 60) / 12) * 2 * Math.PI) * width * 0.05, parent.height / 2 + Math.sin(((hour - 9.57 + minute / 60) / 12) * 2 * Math.PI) * width * 0.05);
            ctx.lineTo(parent.width / 2 + Math.cos(((hour - 2.86 + minute / 60) / 12) * 2 * Math.PI) * width * 0.19, parent.height / 2 + Math.sin(((hour - 2.86 + minute / 60) / 12) * 2 * Math.PI) * width * 0.19);
            ctx.lineTo(parent.width / 2 + Math.cos(((hour - 3 + minute / 60) / 12) * 2 * Math.PI) * width * 0.2, parent.height / 2 + Math.sin(((hour - 3 + minute / 60) / 12) * 2 * Math.PI) * width * 0.2);
            ctx.fill();
            ctx.closePath();
        }
    }

    Canvas {
        id: minuteHand

        property real minute: 0

        z: 3
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.5);
            ctx.shadowOffsetX = 1;
            ctx.shadowOffsetY = 1;
            ctx.shadowBlur = 2;
            ctx.beginPath();
            ctx.fillStyle = Qt.rgba(0, 0, 0, 1);
            ctx.moveTo(parent.width / 2 + Math.cos(((minute - 15) / 60) * 2 * Math.PI) * width * 0.315, parent.height / 2 + Math.sin(((minute - 15) / 60) * 2 * Math.PI) * width * 0.315);
            ctx.lineTo(parent.width / 2 + Math.cos(((minute - 15.4) / 60) * 2 * Math.PI) * width * 0.3, parent.height / 2 + Math.sin(((minute - 15.4) / 60) * 2 * Math.PI) * width * 0.3);
            ctx.lineTo(parent.width / 2 + Math.cos(((minute - 43.5) / 60) * 2 * Math.PI) * width * 0.08, parent.height / 2 + Math.sin(((minute - 43.5) / 60) * 2 * Math.PI) * width * 0.08);
            ctx.lineTo(parent.width / 2 + Math.cos(((minute - 46.5) / 60) * 2 * Math.PI) * width * 0.08, parent.height / 2 + Math.sin(((minute - 46.5) / 60) * 2 * Math.PI) * width * 0.08);
            ctx.lineTo(parent.width / 2 + Math.cos(((minute - 14.6) / 60) * 2 * Math.PI) * width * 0.3, parent.height / 2 + Math.sin(((minute - 14.6) / 60) * 2 * Math.PI) * width * 0.3);
            ctx.lineTo(parent.width / 2 + Math.cos(((minute - 15) / 60) * 2 * Math.PI) * width * 0.315, parent.height / 2 + Math.sin(((minute - 15) / 60) * 2 * Math.PI) * width * 0.315);
            ctx.fill();
            ctx.closePath();
        }
    }

    Canvas {
        id: secondHand

        property real second: 0

        z: 4
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.strokeStyle = "red";
            ctx.lineWidth = parent.height * 0.018;
            ctx.beginPath();
            ctx.moveTo(parent.width / 2, parent.height / 2);
            ctx.lineTo(parent.width / 2 + Math.cos((second - 45) / 60 * 2 * Math.PI) * width * 0.07, parent.height / 2 + Math.sin((second - 45) / 60 * 2 * Math.PI) * width * 0.07);
            ctx.stroke();
            ctx.closePath();
            ctx.beginPath();
            ctx.lineWidth = parent.height * 0.016;
            ctx.fillStyle = "red";
            ctx.arc(parent.width / 2, parent.height / 2, parent.height * 0.012, 0, 2 * Math.PI, false);
            ctx.fill();
            ctx.moveTo(parent.width / 2, parent.height / 2);
            ctx.lineTo(parent.width / 2 + Math.cos((second - 15) / 60 * 2 * Math.PI) * width * 0.14, parent.height / 2 + Math.sin((second - 15) / 60 * 2 * Math.PI) * width * 0.14);
            ctx.stroke();
            ctx.closePath();
            ctx.beginPath();
            ctx.lineWidth = parent.height * 0.02;
            ctx.arc(parent.width / 2 + Math.cos((second - 15) / 60 * 2 * Math.PI) * width * 0.175, parent.height / 2 + Math.sin((second - 15) / 60 * 2 * Math.PI) * width * 0.175, parent.height * 0.03, 0, 2 * Math.PI, false);
            ctx.stroke();
            ctx.closePath();
            ctx.beginPath();
            ctx.lineWidth = parent.height * 0.01;
            ctx.moveTo(parent.width / 2 + Math.cos((second - 15) / 60 * 2 * Math.PI) * width * 0.2, parent.height / 2 + Math.sin((second - 15) / 60 * 2 * Math.PI) * width * 0.2);
            ctx.lineTo(parent.width / 2 + Math.cos((second - 15) / 60 * 2 * Math.PI) * width * 0.31, parent.height / 2 + Math.sin((second - 15) / 60 * 2 * Math.PI) * width * 0.31);
            ctx.stroke();
            ctx.closePath();
        }
    }

    Connections {
        function onTimeChanged() {
            if (!visible)
                return ;

            var hour = wallClock.time.getHours();
            var minute = wallClock.time.getMinutes();
            var second = wallClock.time.getSeconds();
            if (secondHand.second !== second) {
                secondHand.second = second;
                secondHand.requestPaint();
            }
            if (minuteHand.minute !== minute) {
                minuteHand.minute = minute;
                hourHand.minute = minute;
                minuteHand.requestPaint();
                hourHand.hour = hour;
                hourHand.requestPaint();
            }
        }

        target: wallClock
    }

}
