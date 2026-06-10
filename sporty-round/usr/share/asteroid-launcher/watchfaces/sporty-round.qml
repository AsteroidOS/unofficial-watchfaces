// SPDX-FileCopyrightText: 2018 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick

Item {
    id: root

    anchors.fill: parent
    Component.onCompleted: {
        var hour = wallClock.time.getHours();
        var minute = wallClock.time.getMinutes();
        var second = wallClock.time.getSeconds();
        secondHand.second = second;
        secondHand.requestPaint();
        secondDisplay.requestPaint();
        minuteHand.minute = minute;
        minuteHand.requestPaint();
        minuteDisplay.requestPaint();
        hourArc.hour = hour;
        hourArc.requestPaint();
    }

    Item {
        id: faceBox

        width: Math.min(parent.width, parent.height)
        height: width
        anchors.centerIn: parent

        Canvas {
            z: 1
            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                ctx.lineWidth = parent.height / 38;
                ctx.strokeStyle = Qt.rgba(0.169, 0.169, 0.169, 0.85);
                ctx.beginPath();
                ctx.arc(width / 2, height / 2, height * 0.44, 0, 2 * Math.PI, false);
                ctx.closePath();
                ctx.stroke();
            }
        }

        Canvas {
            z: 2
            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                ctx.lineWidth = parent.height / 200;
                ctx.strokeStyle = Qt.rgba(0.784, 0.784, 0.784, 0.5);
                ctx.translate(parent.width / 2, parent.height / 2);
                for (var i = 0; i < 60; i++) {
                    ctx.beginPath();
                    ctx.moveTo(0, height * 0.43);
                    ctx.lineTo(0, height * 0.475);
                    ctx.stroke();
                    ctx.rotate(Math.PI / 30);
                }
            }
        }

        Canvas {
            id: secondDisplay

            z: 3
            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                var s = wallClock.time.getSeconds();
                ctx.reset();
                ctx.shadowOffsetX = 0;
                ctx.shadowOffsetY = 0;
                ctx.shadowBlur = 4;
                ctx.lineWidth = parent.height / 200;
                ctx.translate(parent.width / 2, parent.height / 2);
                ctx.rotate(Math.PI);
                for (var i = 0; i <= s; i++) {
                    var alpha = s > 0 ? i / s : 0;
                    ctx.strokeStyle = Qt.rgba(0.361, 1, 0.824, alpha);
                    ctx.shadowColor = Qt.rgba(0.361, 1, 0.824, alpha);
                    ctx.beginPath();
                    ctx.moveTo(0, height * 0.43);
                    ctx.lineTo(0, height * 0.475);
                    ctx.stroke();
                    ctx.rotate(Math.PI / 30);
                }
            }
        }

        Canvas {
            id: secondHand

            property int second: 0

            z: 4
            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.lineWidth = parent.height / 200;
                ctx.strokeStyle = Qt.rgba(0.361, 1, 0.824, 1);
                ctx.shadowColor = Qt.rgba(0.361, 1, 0.824, 0.9);
                ctx.shadowOffsetX = 0;
                ctx.shadowOffsetY = 0;
                ctx.shadowBlur = 4;
                var angle = (second - 15) / 60 * 2 * Math.PI;
                ctx.beginPath();
                ctx.moveTo(parent.width / 2 + Math.cos(angle) * width * 0.28, parent.height / 2 + Math.sin(angle) * width * 0.28);
                ctx.lineTo(parent.width / 2 + Math.cos(angle) * width * 0.43, parent.height / 2 + Math.sin(angle) * width * 0.43);
                ctx.stroke();
            }
        }

        Canvas {
            z: 3
            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                ctx.lineWidth = parent.height / 32;
                ctx.strokeStyle = Qt.rgba(0.384, 0.384, 0.384, 0.8);
                ctx.translate(parent.width / 2, parent.height / 2);
                for (var i = 0; i < 60; i++) {
                    ctx.beginPath();
                    ctx.moveTo(0, height * 0.355);
                    ctx.lineTo(0, height * 0.395);
                    ctx.stroke();
                    ctx.rotate(Math.PI / 30);
                }
            }
        }

        Canvas {
            id: minuteDisplay

            z: 6
            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                var m = wallClock.time.getMinutes();
                ctx.reset();
                ctx.shadowOffsetX = 0;
                ctx.shadowOffsetY = 0;
                ctx.shadowBlur = 5;
                ctx.lineWidth = parent.height / 34;
                ctx.translate(parent.width / 2, parent.height / 2);
                ctx.rotate(Math.PI);
                for (var i = 0; i <= m; i++) {
                    var alpha = m > 0 ? i / m : 0;
                    ctx.strokeStyle = Qt.rgba(0.992, 0.988, 0.039, alpha);
                    ctx.shadowColor = Qt.rgba(0.992, 0.988, 0.039, alpha);
                    ctx.beginPath();
                    ctx.moveTo(0, height * 0.36);
                    ctx.lineTo(0, height * 0.39);
                    ctx.stroke();
                    ctx.rotate(Math.PI / 30);
                }
            }
        }

        Canvas {
            id: minuteHand

            property int minute: 0

            z: 5
            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.lineWidth = parent.height / 100;
                ctx.strokeStyle = Qt.rgba(0.992, 0.988, 0.039, 1);
                ctx.shadowColor = Qt.rgba(0.992, 0.988, 0.039, 1);
                ctx.shadowOffsetX = 0;
                ctx.shadowOffsetY = 0;
                ctx.shadowBlur = 5;
                var angle = (minute - 15) / 60 * 2 * Math.PI;
                ctx.beginPath();
                ctx.moveTo(parent.width / 2 + Math.cos(angle) * width * 0.285, parent.height / 2 + Math.sin(angle) * width * 0.285);
                ctx.lineTo(parent.width / 2 + Math.cos(angle) * width * 0.36, parent.height / 2 + Math.sin(angle) * width * 0.36);
                ctx.stroke();
            }
        }

        Canvas {
            id: hourArc

            property int hour: 0

            z: 1
            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                var rot = 0.5 * (60 * (hour - 3) + wallClock.time.getMinutes());
                ctx.reset();
                ctx.shadowColor = Qt.rgba(0.996, 0, 0.031, 0.7);
                ctx.shadowOffsetX = 0;
                ctx.shadowOffsetY = 0;
                ctx.shadowBlur = 4;
                ctx.lineWidth = parent.height / 82;
                ctx.lineCap = "round";
                ctx.strokeStyle = Qt.rgba(0.996, 0, 0.031, 0.9);
                ctx.beginPath();
                ctx.arc(parent.width / 2, parent.height / 2, width * 0.32, 270 * 0.01745, rot * 0.01745, false);
                ctx.stroke();
            }
        }

        Text {
            id: hourDisplay

            z: 6
            renderType: Text.NativeRendering
            color: "white"
            style: Text.Outline
            styleColor: "#80000000"
            opacity: 0.95
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "<b>hh</b> ap").slice(0, 9) + wallClock.time.toLocaleString(Qt.locale(), ":mm") : wallClock.time.toLocaleString(Qt.locale(), "<b>HH</b>") + wallClock.time.toLocaleString(Qt.locale(), ":mm")

            font {
                pixelSize: parent.height * 0.23
                family: "SlimSans"
                styleName: "Regular"
            }

        }

        Text {
            id: dayofweekDisplay

            z: 7
            renderType: Text.NativeRendering
            color: "white"
            style: Text.Outline
            styleColor: "#80000000"
            opacity: 0.9
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height / 1.45
            text: wallClock.time.toLocaleString(Qt.locale(), "dddd")

            font {
                pixelSize: parent.height * 0.065
                family: "SlimSans"
                styleName: "Light"
            }

        }

        Text {
            id: dateDisplay

            z: 8
            renderType: Text.NativeRendering
            color: "white"
            style: Text.Outline
            styleColor: "#80000000"
            opacity: 0.9
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height / 1.65
            text: wallClock.time.toLocaleString(Qt.locale(), "dd MMMM yyyy")

            font {
                pixelSize: parent.height * 0.065
                family: "SlimSans"
                styleName: "Regular"
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
                secondDisplay.requestPaint();
            }
            if (minuteHand.minute !== minute) {
                minuteHand.minute = minute;
                minuteHand.requestPaint();
                minuteDisplay.requestPaint();
                hourArc.hour = hour;
                hourArc.requestPaint();
            }
        }

        target: wallClock
    }

}
