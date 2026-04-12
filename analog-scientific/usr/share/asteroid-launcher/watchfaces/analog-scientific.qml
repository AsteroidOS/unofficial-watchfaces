/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
 *               2021 - Timo Könnecke <el-t-mo@arcor.de>
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

    Component.onCompleted: {
        var hour = wallClock.time.getHours();
        var minute = wallClock.time.getMinutes();
        var second = wallClock.time.getSeconds();
        if (use12H.value) {
            hour = hour % 12;
            if (hour === 0)
                hour = 12;

        }
        numberStrokes.requestPaint();
        hourCanvas.hour = hour;
        hourCanvas.minute = minute;
        hourCanvas.requestPaint();
        minuteCanvas.minute = minute;
        minuteCanvas.requestPaint();
        secondCanvas.second = second;
        secondCanvas.requestPaint();
    }

    // ── Static hour tick marks ────────────────────────────────────────────────
    Repeater {
        model: 12

        Rectangle {
            property real angle: index / 12 * 2 * Math.PI

            x: root.width / 2 + Math.cos(angle) * root.height * 0.34 - width / 2
            y: root.height / 2 + Math.sin(angle) * root.height * 0.34 - height / 2
            width: root.width * 0.012
            height: root.height * 0.025
            color: Qt.rgba(1, 1, 1, 0.85)

            transform: Rotation {
                origin.x: width / 2
                origin.y: height / 2
                angle: index * 30
            }

        }

    }

    // ── Static minute tick marks (skip every 5th — hour mark position) ────────
    Repeater {
        model: 60

        Rectangle {
            property real angle: index / 60 * 2 * Math.PI

            visible: index % 5 !== 0
            x: root.width / 2 + Math.cos(angle) * root.height * 0.3425 - width / 2
            y: root.height / 2 + Math.sin(angle) * root.height * 0.3425 - height / 2
            width: root.width * 0.005
            height: root.height * 0.015
            color: Qt.rgba(1, 1, 1, 0.85)

            transform: Rotation {
                origin.x: width / 2
                origin.y: height / 2
                angle: index * 6
            }

        }

    }

    // ── Hour numerals — static Canvas, paint once only ────────────────────────
    Canvas {
        id: numberStrokes

        z: 0
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.fillStyle = Qt.rgba(1, 1, 1, 0.85);
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.4);
            ctx.lineWidth = parent.height * 0.004;
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.font = "80 " + parent.height * 0.09 + "px Reglo";
            ctx.translate(parent.width / 2, parent.height / 2);
            var voffset = -parent.height * 0.02;
            for (var i = 1; i < 13; i++) {
                var x = Math.cos((i - 3) / 12 * 2 * Math.PI) * parent.height * 0.42;
                var y = Math.sin((i - 3) / 12 * 2 * Math.PI) * parent.height * 0.42 - voffset;
                ctx.beginPath();
                ctx.fillText(i, x, y);
                ctx.strokeText(i, x, y);
                ctx.closePath();
            }
        }
    }

    Canvas {
        id: hourCanvas

        property int hour: 0
        property int minute: 0

        z: 1
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            var m = minute;
            ctx.reset();
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.8);
            ctx.shadowOffsetX = 1;
            ctx.shadowOffsetY = 1;
            ctx.shadowBlur = 3;
            ctx.fillStyle = Qt.rgba(1, 1, 1, 1);
            ctx.beginPath();
            ctx.arc(parent.width / 2, parent.height / 2, parent.height * 0.024, 0, 2 * Math.PI, false);
            ctx.moveTo(parent.width / 2 + Math.cos(((hour - 3.02 + m / 60) / 12) * 2 * Math.PI) * width * 0.31, parent.height / 2 + Math.sin(((hour - 3.02 + m / 60) / 12) * 2 * Math.PI) * width * 0.31);
            ctx.lineTo(parent.width / 2 + Math.cos(((hour - 3.22 + m / 60) / 12) * 2 * Math.PI) * width * 0.2, parent.height / 2 + Math.sin(((hour - 3.22 + m / 60) / 12) * 2 * Math.PI) * width * 0.2);
            ctx.lineTo(parent.width / 2 + Math.cos(((hour - 7 + m / 60) / 12) * 2 * Math.PI) * width * 0.01, parent.height / 2 + Math.sin(((hour - 7 + m / 60) / 12) * 2 * Math.PI) * width * 0.01);
            ctx.lineTo(parent.width / 2 + Math.cos(((hour - 11 + m / 60) / 12) * 2 * Math.PI) * width * 0.01, parent.height / 2 + Math.sin(((hour - 11 + m / 60) / 12) * 2 * Math.PI) * width * 0.01);
            ctx.lineTo(parent.width / 2 + Math.cos(((hour - 2.78 + m / 60) / 12) * 2 * Math.PI) * width * 0.2, parent.height / 2 + Math.sin(((hour - 2.78 + m / 60) / 12) * 2 * Math.PI) * width * 0.2);
            ctx.lineTo(parent.width / 2 + Math.cos(((hour - 2.98 + m / 60) / 12) * 2 * Math.PI) * width * 0.31, parent.height / 2 + Math.sin(((hour - 2.98 + m / 60) / 12) * 2 * Math.PI) * width * 0.31);
            ctx.fill();
            ctx.closePath();
        }
    }

    Canvas {
        id: minuteCanvas

        property int minute: 0

        z: 2
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            var m = minute;
            ctx.reset();
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.8);
            ctx.shadowOffsetX = 1;
            ctx.shadowOffsetY = 1;
            ctx.shadowBlur = 3;
            ctx.fillStyle = Qt.rgba(1, 1, 1, 1);
            ctx.beginPath();
            ctx.moveTo(parent.width / 2 + Math.cos(((m - 15.08) / 60) * 2 * Math.PI) * width * 0.41, parent.height / 2 + Math.sin(((m - 15.08) / 60) * 2 * Math.PI) * width * 0.41);
            ctx.lineTo(parent.width / 2 + Math.cos(((m - 15.7) / 60) * 2 * Math.PI) * width * 0.285, parent.height / 2 + Math.sin(((m - 15.7) / 60) * 2 * Math.PI) * width * 0.285);
            ctx.lineTo(parent.width / 2 + Math.cos(((m - 37) / 60) * 2 * Math.PI) * width * 0.01, parent.height / 2 + Math.sin(((m - 37) / 60) * 2 * Math.PI) * width * 0.01);
            ctx.lineTo(parent.width / 2 + Math.cos(((m - 53) / 60) * 2 * Math.PI) * width * 0.01, parent.height / 2 + Math.sin(((m - 53) / 60) * 2 * Math.PI) * width * 0.01);
            ctx.lineTo(parent.width / 2 + Math.cos(((m - 14.3) / 60) * 2 * Math.PI) * width * 0.285, parent.height / 2 + Math.sin(((m - 14.3) / 60) * 2 * Math.PI) * width * 0.285);
            ctx.lineTo(parent.width / 2 + Math.cos(((m - 14.92) / 60) * 2 * Math.PI) * width * 0.41, parent.height / 2 + Math.sin(((m - 14.92) / 60) * 2 * Math.PI) * width * 0.41);
            ctx.fill();
            ctx.closePath();
        }
    }

    // ── Second hand — only the line stays in Canvas, dots are Rectangles ──────
    Rectangle {
        id: secondDot

        z: 3
        visible: !displayAmbient
        anchors.centerIn: parent
        width: parent.height * 0.024 * 2
        height: width
        radius: width / 2
        color: "red"
    }

    Canvas {
        id: secondCanvas

        property int second: 0

        z: 4
        visible: !displayAmbient
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.shadowColor = Qt.rgba(0, 0, 0, 0.8);
            ctx.shadowOffsetX = 0;
            ctx.shadowOffsetY = 0;
            ctx.shadowBlur = 2;
            ctx.strokeStyle = "red";
            ctx.lineCap = "round";
            ctx.lineWidth = parent.height * 0.008;
            ctx.beginPath();
            ctx.moveTo(parent.width / 2, parent.height / 2);
            ctx.lineTo(parent.width / 2 + Math.cos((second - 15) / 60 * 2 * Math.PI) * width * 0.35, parent.height / 2 + Math.sin((second - 15) / 60 * 2 * Math.PI) * height * 0.35);
            ctx.stroke();
            ctx.closePath();
        }
    }

    Rectangle {
        id: secondCap

        z: 5
        visible: !displayAmbient
        anchors.centerIn: parent
        width: parent.height * 0.012 * 2
        height: width
        radius: width / 2
        color: "white"
    }

    // ── Day of week — plain Text replaces Canvas ──────────────────────────────
    Text {
        z: 3
        color: Qt.rgba(1, 1, 1, 0.85)
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.4)
        text: wallClock.time.toLocaleString(Qt.locale(), "ddd").slice(0, 2).toUpperCase()

        anchors {
            centerIn: parent
            horizontalCenterOffset: -parent.width * 0.175
            verticalCenterOffset: parent.height * 0.0125
        }

        font {
            pixelSize: parent.height * 0.05
            family: "Reglo"
        }

    }

    // ── AM/PM — plain Text replaces Canvas ───────────────────────────────────
    Text {
        z: 3
        visible: use12H.value
        color: Qt.rgba(1, 1, 1, 0.85)
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.4)
        text: wallClock.time.toLocaleString(Qt.locale(), "ap").slice(0, 2).toUpperCase()

        anchors {
            centerIn: parent
            horizontalCenterOffset: parent.width * 0.175
            verticalCenterOffset: parent.height * 0.0125
        }

        font {
            pixelSize: parent.height * 0.05
            family: "Reglo"
            styleName: "Bold"
        }

    }

    // ── Date — plain Text replaces Canvas ────────────────────────────────────
    Text {
        z: 3
        color: Qt.rgba(1, 1, 1, 0.85)
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.4)
        text: wallClock.time.toLocaleString(Qt.locale(), "dd")

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: parent.height * 0.265
        }

        font {
            pixelSize: parent.height * 0.075
            family: "Reglo"
        }

    }

    // ── Month — plain Text replaces Canvas ───────────────────────────────────
    Text {
        z: 3
        color: Qt.rgba(1, 1, 1, 0.85)
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.4)
        text: wallClock.time.toLocaleString(Qt.locale(), "MMMM").toUpperCase()

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: parent.height * 0.322
        }

        font {
            pixelSize: parent.height * 0.05
            family: "Reglo"
        }

    }

    Image {
        id: logoAsteroid

        source: "../watchfaces-img/asteroid-logo.svg"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: parent.height * 0.18
        width: parent.width / 8
        height: width
    }

    Connections {
        function onTimeChanged() {
            if (!visible)
                return ;

            var hour = wallClock.time.getHours();
            var minute = wallClock.time.getMinutes();
            var second = wallClock.time.getSeconds();
            if (use12H.value) {
                hour = hour % 12;
                if (hour === 0)
                    hour = 12;

            }
            if (minuteCanvas.minute !== minute) {
                minuteCanvas.minute = minute;
                minuteCanvas.requestPaint();
                hourCanvas.hour = hour;
                hourCanvas.minute = minute;
                hourCanvas.requestPaint();
            }
            if (secondCanvas.second !== second) {
                secondCanvas.second = second;
                secondCanvas.requestPaint();
            }
        }

        target: wallClock
    }

}
