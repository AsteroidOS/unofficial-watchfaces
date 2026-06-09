// SPDX-FileCopyrightText: 2026 Timo Könnecke <mo@mowerk.net>
// SPDX-FileCopyrightText: 2017 Mario Kicherer <dev@kicherer.org>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later
// This watchface is a fan recreation of Jolla Oy's Sailfish Watch concept designs from 2016.
// Visual design elements (e.g., hand styles, strokes, shadows, and layout) are derived from
// Jolla's intellectual property as shown at https://blog.jolla.com/watch/.
// Used and distributed with explicit permission from Jolla Oy (granted by CEO Sami Pienimäki
// in 2026, with witnesses at FOSDEM).
// Permission is for non-commercial, community-driven distribution within the AsteroidOS
// unofficial-watchfaces repository.

import QtQuick

Item {
    id: root

    Component.onCompleted: {
        var hour = wallClock.time.getHours();
        var minute = wallClock.time.getMinutes();
        var second = wallClock.time.getSeconds();
        secondHand.second = second;
        secondHand.requestPaint();
        minuteHand.minute = minute;
        minuteHand.requestPaint();
        hourHand.hour = hour;
        hourHand.rotH = (hour - 3 + minute / 60) / 12;
        hourHand.requestPaint();
    }

    Rectangle {
        z: 0
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.7)
    }

    Image {
        id: logoSailfish

        z: 1
        source: "../watchfaces-img/sailfish_logo.svg"
        opacity: 0.9
        width: parent.width / 6
        height: parent.height / 6

        anchors {
            bottomMargin: parent.height * 0.18
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

    }

    Canvas {
        id: hourHand

        property real hour: 0
        property real rotH: 0

        z: 2
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.lineCap = "round";
            ctx.beginPath();
            ctx.lineWidth = parent.width * 0.023;
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1);
            ctx.moveTo(parent.width / 2, parent.height / 2);
            ctx.lineTo(parent.width / 2 + Math.cos(rotH * 2 * Math.PI) * width * 0.227, parent.height / 2 + Math.sin(rotH * 2 * Math.PI) * width * 0.227);
            ctx.stroke();
            ctx.closePath();
        }
    }

    Canvas {
        id: minuteHand

        property real minute: 0
        property real rotM: (minute - 15) / 60

        z: 3
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.lineCap = "round";
            ctx.beginPath();
            ctx.lineWidth = parent.width * 0.016;
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1);
            ctx.moveTo(parent.width / 2, parent.height / 2);
            ctx.lineTo(parent.width / 2 + Math.cos(rotM * 2 * Math.PI) * width * 0.31, parent.height / 2 + Math.sin(rotM * 2 * Math.PI) * width * 0.31);
            ctx.stroke();
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
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.7);
            ctx.shadowOffsetX = 0;
            ctx.shadowOffsetY = 0;
            ctx.shadowBlur = 2;
            ctx.strokeStyle = Qt.rgba(0.592, 0.937, 0.937, 1);
            ctx.lineWidth = parent.height * 0.007;
            ctx.beginPath();
            ctx.moveTo(parent.width / 2, parent.height / 2);
            ctx.lineTo(parent.width / 2 + Math.cos((second - 15) / 60 * 2 * Math.PI) * width * 0.33, parent.height / 2 + Math.sin((second - 15) / 60 * 2 * Math.PI) * width * 0.33);
            ctx.stroke();
            ctx.closePath();
        }
    }

    // hour strokes — static, paints once only
    Canvas {
        z: 5
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            ctx.lineWidth = parent.width * 0.008;
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.6);
            ctx.translate(parent.width / 2, parent.height / 2);
            for (var i = 0; i < 12; i++) {
                ctx.beginPath();
                ctx.moveTo(0, height * 0.37);
                ctx.lineTo(0, height * 0.45);
                ctx.stroke();
                ctx.rotate(Math.PI / 2);
            }
        }
    }

    // minute strokes — static, paints once only
    Canvas {
        z: 6
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            ctx.lineWidth = parent.width * 0.007;
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.4);
            ctx.translate(parent.width / 2, parent.height / 2);
            for (var i = 0; i < 12; i++) {
                if ((i % 3) !== 0) {
                    ctx.beginPath();
                    ctx.moveTo(0, height * 0.4);
                    ctx.lineTo(0, height * 0.45);
                    ctx.stroke();
                }
                ctx.rotate(Math.PI / 6);
            }
        }
    }

    Connections {
        function onTimeChanged() {
            var hour = wallClock.time.getHours();
            var minute = wallClock.time.getMinutes();
            var second = wallClock.time.getSeconds();
            if (secondHand.second !== second) {
                secondHand.second = second;
                secondHand.requestPaint();
            }
            if (minuteHand.minute !== minute) {
                minuteHand.minute = minute;
                minuteHand.requestPaint();
            }
            if (hourHand.hour !== hour) {
                hourHand.hour = hour;
                hourHand.rotH = (hour - 3 + minute / 60) / 12;
                hourHand.requestPaint();
            }
        }

        target: wallClock
    }

}
