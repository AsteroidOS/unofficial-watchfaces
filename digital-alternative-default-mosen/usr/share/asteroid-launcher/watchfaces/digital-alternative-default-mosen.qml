// SPDX-FileCopyrightText: 2018 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2017 Florent Revest <revestflo@gmail.com>
// SPDX-License-Identifier: BSD-3-Clause
// Based on Florent's 000-default-digital stock watchface with added seconds.
// Heavily quantised to geometric proportions.
// Fixed am/pm display by slicing to two chars.
// Calculated ctx.shadows with variable px size for better display in watchface-settings.

import QtQuick

Item {
    id: root

    function twoDigits(x) {
        if (x < 10)
            return "0" + x;
        else
            return x;
    }

    function prepareContext(ctx) {
        ctx.reset();
        ctx.fillStyle = "white";
        ctx.textAlign = "center";
        ctx.textBaseline = "middle";
        ctx.shadowColor = Qt.rgba(0, 0, 0, 0.8);
        ctx.shadowOffsetX = faceBox.height * 0.00625;
        ctx.shadowOffsetY = faceBox.height * 0.00625;
        ctx.shadowBlur = faceBox.height * 0.0156;
    }

    anchors.fill: parent
    Component.onCompleted: {
        var hour = wallClock.time.getHours();
        var minute = wallClock.time.getMinutes();
        var second = wallClock.time.getSeconds();
        var date = wallClock.time.getDate();
        var am = hour < 12;
        if (use12H.value) {
            hour = hour % 12;
            if (hour == 0)
                hour = 12;

        }
        hourCanvas.hour = hour;
        hourCanvas.requestPaint();
        minuteCanvas.minute = minute;
        minuteCanvas.requestPaint();
        secondCanvas.second = second;
        secondCanvas.requestPaint();
        dateCanvas.date = date;
        dateCanvas.requestPaint();
        monthCanvas.date = date;
        monthCanvas.requestPaint();
        amPmCanvas.am = am;
        amPmCanvas.requestPaint();
    }

    Item {
        id: faceBox

        width: Math.min(parent.width, parent.height)
        height: width
        anchors.centerIn: parent

        Canvas {
            id: hourCanvas

            property real hour: 0

            anchors.fill: parent
            antialiasing: true
            smooth: true
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                prepareContext(ctx);
                ctx.font = "bold " + height * 0.385 + "px Roboto";
                ctx.fillText(twoDigits(hour), width * 0.3, height * 0.54);
            }
        }

        Canvas {
            id: minuteCanvas

            property real minute: 0

            anchors.fill: parent
            antialiasing: true
            smooth: true
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                prepareContext(ctx);
                ctx.shadowBlur = parent.height * 0.00937; //3 px on 320x320
                ctx.font = "300 " + height * 0.222 + "px Roboto";
                ctx.fillText(twoDigits(minute), width * 0.642, height * 0.47);
            }
        }

        Canvas {
            id: secondCanvas

            property real second: 0

            anchors.fill: parent
            antialiasing: true
            smooth: true
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                prepareContext(ctx);
                ctx.shadowBlur = parent.height * 0.00625; //2 px on 320x320
                ctx.textAlign = "right";
                ctx.textBaseline = "right";
                ctx.font = "300 " + height * 0.111 + "px Roboto";
                ctx.fillText(twoDigits(second), width * 0.902, height * 0.419);
            }
        }

        Canvas {
            id: amPmCanvas

            property bool am: false

            anchors.fill: parent
            antialiasing: true
            smooth: true
            renderStrategy: Canvas.Cooperative
            visible: use12H.value
            onPaint: {
                var ctx = getContext("2d");
                prepareContext(ctx);
                ctx.shadowBlur = parent.height * 0.00625; //2 px on 320x320
                ctx.textAlign = "right";
                ctx.textBaseline = "right";
                ctx.font = "300 " + height * 0.08 + "px Raleway";
                ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "AP").slice(0, 2), width * 0.902, height * 0.5135);
            }
        }

        Canvas {
            id: monthCanvas

            property real date: 0

            anchors.fill: parent
            antialiasing: true
            smooth: true
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                prepareContext(ctx);
                ctx.shadowBlur = parent.height * 0.00625; //2 px on 320x320
                ctx.textAlign = "center";
                ctx.textBaseline = "middle";
                var ctx = getContext("2d");
                ctx.font = "300 " + height * 0.111 + "px Raleway";
                ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "MMM").slice(0, 3).toUpperCase(), width * 0.642, height * 0.615);
            }
        }

        Canvas {
            id: dateCanvas

            property real date: 0

            anchors.fill: parent
            antialiasing: true
            smooth: true
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                prepareContext(ctx);
                ctx.shadowBlur = parent.height * 0.00625; //2 px on 320x320
                ctx.textAlign = "right";
                ctx.textBaseline = "right";
                var ctx = getContext("2d");
                ctx.font = "500 " + height * 0.112 + "px Roboto";
                ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "dd"), width * 0.902, height * 0.612);
            }
        }

    }

    Connections {
        function onTimeChanged() {
            if (!visible)
                return ;

            var hour = wallClock.time.getHours();
            var minute = wallClock.time.getMinutes();
            var second = wallClock.time.getSeconds();
            var date = wallClock.time.getDate();
            var am = hour < 12;
            if (use12H.value) {
                hour = hour % 12;
                if (hour === 0)
                    hour = 12;

            }
            if (minuteCanvas.minute !== minute) {
                minuteCanvas.minute = minute;
                minuteCanvas.requestPaint();
                hourCanvas.hour = hour;
                hourCanvas.requestPaint();
            }
            if (secondCanvas.second !== second) {
                secondCanvas.second = second;
                secondCanvas.requestPaint();
            }
            if (dateCanvas.date !== date) {
                dateCanvas.date = date;
                dateCanvas.requestPaint();
            }
            if (monthCanvas.date !== date) {
                monthCanvas.date = date;
                monthCanvas.requestPaint();
            }
            if (amPmCanvas.am !== am) {
                amPmCanvas.am = am;
                amPmCanvas.requestPaint();
            }
        }

        target: wallClock
    }

}
