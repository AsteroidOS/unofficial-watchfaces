// SPDX-FileCopyrightText: 2018 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2017 Mario Kicherer <dev@kicherer.org>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later
// analog-tactical — inspired by analog-precision by Mario Kicherer
// Recreation of vintage 70s BRAUN clock arms with thick strokes.
// Main attraction is the seconds arm advancing over the clock centre.
// Hour and minute arms feature distinct outer and centre segments.

import QtQuick

Item {
    id: root

    property real maxSize: Math.min(width, height)

    anchors.fill: parent
    Component.onCompleted: {
        var hour = wallClock.time.getHours();
        var minute = wallClock.time.getMinutes();
        var second = wallClock.time.getSeconds();
        var date = wallClock.time.getDate();
        secondHand.second = second;
        secondHand.requestPaint();
        minuteHand.minute = minute;
        minuteHand.requestPaint();
        hourHand.hour = hour;
        hourHand.minute = minute;
        hourHand.requestPaint();
        dateCanvas.date = date;
        dateCanvas.dateText = wallClock.time.toLocaleString(Qt.locale(), "d");
        dateCanvas.requestPaint();
    }

    Item {
        id: faceBox

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        // Hour strokes — static, paints once only
        Canvas {
            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                ctx.lineCap = "round";
                ctx.lineWidth = parent.width * 0.1;
                ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.65);
                ctx.translate(parent.width / 2, parent.height / 2);
                for (var i = 0; i < 12; i++) {
                    ctx.beginPath();
                    ctx.moveTo(0, height * 0.398);
                    ctx.lineTo(0, height * 0.3981);
                    ctx.stroke();
                    ctx.rotate(Math.PI / 6);
                }
            }
        }

        // Number strokes — static, paints once only
        Canvas {
            property real voffset: -parent.height * 0.015
            property real hoffset: -parent.height * 0.003

            anchors.fill: parent
            antialiasing: true
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.fillStyle = Qt.rgba(1, 1, 1, 0.85);
                ctx.textAlign = "center";
                ctx.textBaseline = "middle";
                ctx.translate(parent.width / 2, parent.height / 2);
                for (var i = 1; i < 13; i++) {
                    ctx.beginPath();
                    ctx.font = "99 " + height / 13 + "px Fyodor";
                    ctx.fillText(i, i === 10 ? Math.cos((i - 3) / 12 * 2 * Math.PI) * height * 0.402 - hoffset : i === 1 || i === 12 ? Math.cos((i - 3) / 12 * 2 * Math.PI) * height * 0.39 - hoffset : Math.cos((i - 3) / 12 * 2 * Math.PI) * height * 0.398 - hoffset, (Math.sin((i - 3) / 12 * 2 * Math.PI) * height * 0.398) - voffset);
                    ctx.closePath();
                }
            }
        }

        Canvas {
            id: hourHand

            property int hour: 0
            property int minute: 0
            property real rotH: (hour - 3 + minute / 60) / 12

            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.beginPath();
                ctx.lineWidth = parent.width * 0.03;
                ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.75);
                ctx.moveTo(parent.width / 2 + Math.cos(rotH * 2 * Math.PI) * width * 0.0494, parent.height / 2 + Math.sin(rotH * 2 * Math.PI) * width * 0.0494);
                ctx.lineTo(parent.width / 2 + Math.cos(rotH * 2 * Math.PI) * width * 0.0855, parent.height / 2 + Math.sin(rotH * 2 * Math.PI) * width * 0.0855);
                ctx.stroke();
                ctx.closePath();
                ctx.beginPath();
                ctx.lineCap = "round";
                ctx.lineWidth = parent.width * 0.057;
                ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.75);
                ctx.moveTo(parent.width / 2 + Math.cos(rotH * 2 * Math.PI) * width * 0.11, parent.height / 2 + Math.sin(rotH * 2 * Math.PI) * width * 0.11);
                ctx.lineTo(parent.width / 2 + Math.cos(rotH * 2 * Math.PI) * width * 0.267, parent.height / 2 + Math.sin(rotH * 2 * Math.PI) * width * 0.267);
                ctx.stroke();
                ctx.closePath();
                ctx.beginPath();
                ctx.lineWidth = parent.width * 0.033;
                ctx.strokeStyle = Qt.rgba(1, 1, 1, 1);
                ctx.moveTo(parent.width / 2 + Math.cos(rotH * 2 * Math.PI) * width * 0.112, parent.height / 2 + Math.sin(rotH * 2 * Math.PI) * width * 0.112);
                ctx.lineTo(parent.width / 2 + Math.cos(rotH * 2 * Math.PI) * width * 0.265, parent.height / 2 + Math.sin(rotH * 2 * Math.PI) * width * 0.265);
                ctx.stroke();
                ctx.closePath();
                ctx.beginPath();
                ctx.lineWidth = parent.width * 0.008;
                ctx.moveTo(parent.width / 2 + Math.cos(rotH * 2 * Math.PI) * width * 0.05, parent.height / 2 + Math.sin(rotH * 2 * Math.PI) * width * 0.05);
                ctx.lineTo(parent.width / 2 + Math.cos(rotH * 2 * Math.PI) * width * 0.122, parent.height / 2 + Math.sin(rotH * 2 * Math.PI) * width * 0.122);
                ctx.stroke();
                ctx.closePath();
                ctx.beginPath();
                ctx.lineWidth = parent.width * 0.015;
                ctx.strokeStyle = Qt.rgba(0.945, 0.769, 0.059, 1);
                ctx.moveTo(parent.width / 2 + Math.cos(rotH * 2 * Math.PI) * width * 0.113, parent.height / 2 + Math.sin(rotH * 2 * Math.PI) * width * 0.113);
                ctx.lineTo(parent.width / 2 + Math.cos(rotH * 2 * Math.PI) * width * 0.264, parent.height / 2 + Math.sin(rotH * 2 * Math.PI) * width * 0.264);
                ctx.stroke();
                ctx.closePath();
            }
        }

        Canvas {
            id: minuteHand

            property int minute: 0
            property real rotM: (minute - 15) / 60

            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.beginPath();
                ctx.lineWidth = parent.width * 0.03;
                ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.75);
                ctx.moveTo(parent.width / 2 + Math.cos(rotM * 2 * Math.PI) * width * 0.0494, parent.height / 2 + Math.sin(rotM * 2 * Math.PI) * width * 0.0494);
                ctx.lineTo(parent.width / 2 + Math.cos(rotM * 2 * Math.PI) * width * 0.098, parent.height / 2 + Math.sin(rotM * 2 * Math.PI) * width * 0.098);
                ctx.stroke();
                ctx.closePath();
                ctx.beginPath();
                ctx.lineCap = "round";
                ctx.lineWidth = parent.width * 0.052;
                ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.75);
                ctx.moveTo(parent.width / 2 + Math.cos(rotM * 2 * Math.PI) * width * 0.12, parent.height / 2 + Math.sin(rotM * 2 * Math.PI) * width * 0.12);
                ctx.lineTo(parent.width / 2 + Math.cos(rotM * 2 * Math.PI) * width * 0.355, parent.height / 2 + Math.sin(rotM * 2 * Math.PI) * width * 0.355);
                ctx.stroke();
                ctx.closePath();
                ctx.lineWidth = parent.width * 0.028;
                ctx.strokeStyle = Qt.rgba(1, 1, 1, 1);
                ctx.beginPath();
                ctx.shadowBlur = 0;
                ctx.moveTo(parent.width / 2 + Math.cos(rotM * 2 * Math.PI) * width * 0.122, parent.height / 2 + Math.sin(rotM * 2 * Math.PI) * width * 0.122);
                ctx.lineTo(parent.width / 2 + Math.cos(rotM * 2 * Math.PI) * width * 0.357, parent.height / 2 + Math.sin(rotM * 2 * Math.PI) * width * 0.357);
                ctx.stroke();
                ctx.closePath();
                ctx.beginPath();
                ctx.shadowBlur = 0;
                ctx.lineWidth = parent.width * 0.008;
                ctx.moveTo(parent.width / 2 + Math.cos(rotM * 2 * Math.PI) * width * 0.05, parent.height / 2 + Math.sin(rotM * 2 * Math.PI) * width * 0.05);
                ctx.lineTo(parent.width / 2 + Math.cos(rotM * 2 * Math.PI) * width * 0.122, parent.height / 2 + Math.sin(rotM * 2 * Math.PI) * width * 0.122);
                ctx.stroke();
                ctx.closePath();
                ctx.strokeStyle = Qt.rgba(0.902, 0.494, 0.133, 1);
                ctx.lineWidth = parent.width * 0.01;
                ctx.beginPath();
                ctx.shadowBlur = 0;
                ctx.moveTo(parent.width / 2 + Math.cos(rotM * 2 * Math.PI) * width * 0.123, parent.height / 2 + Math.sin(rotM * 2 * Math.PI) * width * 0.123);
                ctx.lineTo(parent.width / 2 + Math.cos(rotM * 2 * Math.PI) * width * 0.356, parent.height / 2 + Math.sin(rotM * 2 * Math.PI) * width * 0.356);
                ctx.stroke();
                ctx.closePath();
            }
        }

        Canvas {
            id: secondHand

            property int second: 0

            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.shadowColor = Qt.rgba(0, 0, 0, 0.7);
                ctx.shadowOffsetX = 0;
                ctx.shadowOffsetY = 0;
                ctx.shadowBlur = 1;
                ctx.strokeStyle = Qt.rgba(0.871, 0.165, 0.102, 1);
                ctx.lineWidth = parent.height * 0.006;
                ctx.closePath();
                ctx.beginPath();
                ctx.moveTo(parent.width / 2 + Math.cos((second - 15) / 60 * 2 * Math.PI) * width * 0.05, parent.height / 2 + Math.sin((second - 15) / 60 * 2 * Math.PI) * width * 0.05);
                ctx.lineTo(parent.width / 2 + Math.cos((second - 15) / 60 * 2 * Math.PI) * width * 0.325, parent.height / 2 + Math.sin((second - 15) / 60 * 2 * Math.PI) * width * 0.325);
                ctx.stroke();
                ctx.closePath();
            }
        }

        Canvas {
            id: dateCanvas

            property int date: 0
            property string dateText: ""

            anchors.fill: parent
            antialiasing: true
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.beginPath();
                ctx.fillStyle = Qt.rgba(0, 0, 0, 0.75);
                ctx.arc(parent.width / 2, parent.height / 2, parent.height * 0.056, 0, 2 * Math.PI, false);
                ctx.fill();
                ctx.closePath();
                ctx.fillStyle = "white";
                ctx.textAlign = "center";
                ctx.textBaseline = "middle";
                ctx.font = "99 " + height / 14 + "px Noto Sans";
                ctx.fillText(dateText, width / 2, height / 1.975);
            }
        }

    }

    Connections {
        function onTimeChanged() {
            var hour = wallClock.time.getHours();
            var minute = wallClock.time.getMinutes();
            var second = wallClock.time.getSeconds();
            var date = wallClock.time.getDate();
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
            if (dateCanvas.date !== date) {
                dateCanvas.date = date;
                dateCanvas.dateText = wallClock.time.toLocaleString(Qt.locale(), "d");
                dateCanvas.requestPaint();
            }
        }

        target: wallClock
    }

}
