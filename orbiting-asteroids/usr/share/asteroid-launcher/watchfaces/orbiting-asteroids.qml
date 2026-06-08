// SPDX-FileCopyrightText: 2018 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick 2.1

Item {
    id: root

    property real radian: 0.0174533
    property string imgPath: "../watchfaces-img/orbiting-asteroids-"

    function updatePositions() {
        var w = root.width;
        var h = root.height;
        var hour = wallClock.time.getHours();
        var minute = wallClock.time.getMinutes();
        var second = wallClock.time.getSeconds();
        var rotS = (second - 15) / 60;
        var rotM = (minute - 15) / 60;
        var rotH = (hour - 3 + minute / 60) / 12;
        var saW = secondAsteroid.width;
        secondAsteroid.x = w / 2 - saW / 2 + Math.cos(rotS * 2 * Math.PI) * saW * 5.78;
        secondAsteroid.y = h / 2 - saW / 2 + Math.sin(rotS * 2 * Math.PI) * saW * 5.78;
        var maW = minuteAsteroid.width;
        minuteAsteroid.x = w / 2 - maW / 2 + Math.cos(rotM * 2 * Math.PI) * maW * 3.9;
        minuteAsteroid.y = h / 2 - maW / 2 + Math.sin(rotM * 2 * Math.PI) * maW * 3.9;
        var haW = hourAsteroid.width;
        hourAsteroid.x = w / 2 - haW / 2 + Math.cos(rotH * 2 * Math.PI) * haW * 2.23;
        hourAsteroid.y = h / 2 - haW / 2 + Math.sin(rotH * 2 * Math.PI) * haW * 2.23;
        var rotMt = (minute - 12.2) / 60;
        var mdW = minuteDisplay.width;
        var mdH = minuteDisplay.height;
        minuteDisplay.x = w / 2 - mdW / 2 + Math.cos(rotMt * 2 * Math.PI) * mdW * 4.1;
        minuteDisplay.y = h / 2 - mdH / 2 + Math.sin(rotMt * 2 * Math.PI) * mdW * 4.1;
        var rotSt = (second - 13.05) / 60;
        var sdH = secondDisplay.height;
        secondDisplay.x = w / 2 - secondDisplay.width / 2 + Math.cos(rotSt * 2 * Math.PI) * sdH * 4.54;
        secondDisplay.y = h / 2 - sdH / 2 + Math.sin(rotSt * 2 * Math.PI) * sdH * 4.54;
    }

    Component.onCompleted: {
        var hour = wallClock.time.getHours();
        var minute = wallClock.time.getMinutes();
        var second = wallClock.time.getSeconds();
        updatePositions();
        secondCanvas.second = second;
        secondCanvas.requestPaint();
        minuteCanvas.minute = minute;
        minuteCanvas.requestPaint();
        hourCanvas.hour = hour;
        hourCanvas.minute = minute;
        hourCanvas.requestPaint();
    }

    Canvas {
        id: secondCanvas

        property int second: 0

        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            var rot = (second - 15) * 6;
            var rot_half = (second - 22) * 6;
            ctx.reset();
            ctx.lineWidth = parent.width / 42;
            ctx.beginPath();
            ctx.arc(parent.width / 2, parent.height / 2, width / 2.15, (rot_half - 35) * radian, rot * radian, false);
            ctx.strokeStyle = Qt.rgba(0.945, 0.769, 0.059, 0.7);
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(parent.width / 2, parent.height / 2, width / 2.25, (rot_half - 120) * radian, rot * radian, false);
            ctx.strokeStyle = Qt.rgba(0.945, 0.769, 0.059, 0.45);
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(parent.width / 2, parent.height / 2, width / 2.35, (rot_half - 230) * radian, rot * radian, false);
            ctx.strokeStyle = Qt.rgba(0.945, 0.769, 0.059, 0.2);
            ctx.stroke();
        }
    }

    Canvas {
        id: minuteCanvas

        property int minute: 0

        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            var rot = (minute - 15) * 6;
            var rot_half = (minute - 42) * 6;
            ctx.reset();
            ctx.lineWidth = parent.width / 42;
            ctx.beginPath();
            ctx.arc(parent.width / 2, parent.height / 2, width / 2.63, (rot_half + 35) * radian, rot * radian, false);
            ctx.strokeStyle = Qt.rgba(1, 0.549, 0.149, 0.7);
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(parent.width / 2, parent.height / 2, width / 2.77, (rot_half - 40) * radian, rot * radian, false);
            ctx.strokeStyle = Qt.rgba(1, 0.549, 0.149, 0.51);
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(parent.width / 2, parent.height / 2, width / 2.92, (rot_half - 95) * radian, rot * radian, false);
            ctx.strokeStyle = Qt.rgba(1, 0.549, 0.149, 0.38);
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(parent.width / 2, parent.height / 2, width / 3.08, (rot_half - 130) * radian, rot * radian, false);
            ctx.strokeStyle = Qt.rgba(1, 0.549, 0.149, 0.2);
            ctx.stroke();
        }
    }

    Canvas {
        id: hourCanvas

        property int hour: 0
        property int minute: 0

        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            var rot = 0.5 * (60 * (hour - 3) + minute);
            var rot_half = 0.5 * (60 * (hour - 7.5) + minute);
            ctx.reset();
            ctx.lineWidth = parent.width / 42;
            ctx.beginPath();
            ctx.arc(parent.width / 2, parent.height / 2, width / 3.57, (rot_half + 35) * radian, rot * radian, false);
            ctx.strokeStyle = Qt.rgba(0.871, 0.165, 0.102, 0.7);
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(parent.width / 2, parent.height / 2, width / 3.87, (rot_half - 20) * radian, rot * radian, false);
            ctx.strokeStyle = Qt.rgba(0.871, 0.165, 0.102, 0.55);
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(parent.width / 2, parent.height / 2, width / 4.17, (rot_half - 70) * radian, rot * radian, false);
            ctx.strokeStyle = Qt.rgba(0.871, 0.165, 0.102, 0.4);
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(parent.width / 2, parent.height / 2, width / 4.47, (rot_half - 125) * radian, rot * radian, false);
            ctx.strokeStyle = Qt.rgba(0.871, 0.165, 0.102, 0.25);
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(parent.width / 2, parent.height / 2, width / 4.77, (rot_half - 190) * radian, rot * radian, false);
            ctx.strokeStyle = Qt.rgba(0.871, 0.165, 0.102, 0.2);
            ctx.stroke();
        }
    }

    Image {
        id: secondAsteroid

        source: imgPath + "second.png"
        width: parent.width / 13
        height: width
    }

    Image {
        id: minuteAsteroid

        source: imgPath + "minute.png"
        width: parent.width / 11
        height: width
    }

    Image {
        id: hourAsteroid

        source: imgPath + "hour.png"
        width: parent.width / 9
        height: width
    }

    Text {
        id: hourDisplay

        font.pixelSize: parent.height / 4
        font.family: "OpenSans"
        font.styleName: "Bold"
        color: "white"
        opacity: 0.8
        style: Text.Outline
        styleColor: "#80000000"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) : wallClock.time.toLocaleString(Qt.locale(), "HH")
    }

    Text {
        id: minuteDisplay

        font.pixelSize: parent.height / 12.7
        font.family: "OpenSans"
        color: "white"
        style: Text.Outline
        styleColor: "#80000000"
        opacity: 0.9
        text: wallClock.time.toLocaleString(Qt.locale(), "<b>mm</b>")
    }

    Text {
        id: secondDisplay

        font.pixelSize: parent.height / 14
        font.family: "OpenSans"
        color: "white"
        style: Text.Outline
        styleColor: "#80000000"
        opacity: 0.95
        text: wallClock.time.toLocaleString(Qt.locale(), "ss")
    }

    Connections {
        function onTimeChanged() {
            var hour = wallClock.time.getHours();
            var minute = wallClock.time.getMinutes();
            var second = wallClock.time.getSeconds();
            updatePositions();
            if (secondCanvas.second !== second) {
                secondCanvas.second = second;
                secondCanvas.requestPaint();
            }
            if (minuteCanvas.minute !== minute) {
                minuteCanvas.minute = minute;
                minuteCanvas.requestPaint();
                hourCanvas.hour = hour;
                hourCanvas.minute = minute;
                hourCanvas.requestPaint();
            }
        }

        target: wallClock
    }

}
