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

    property real maxSize: Math.min(width, height)

    function updateMinute() {
        var m = wallClock.time.getMinutes();
        var angle = (m - 15) / 60 * 2 * Math.PI;
        var cx = root.maxSize / 2;
        var cy = root.maxSize / 2;
        var r = root.maxSize / 2.75;
        minuteCircle.minuteX = cx + Math.cos(angle) * r;
        minuteCircle.minuteY = cy + Math.sin(angle) * r;
        minuteDisplay.x = cx - minuteDisplay.width / 2 + Math.cos(angle) * root.maxSize * 0.364;
        minuteDisplay.y = cy - minuteDisplay.height / 2 + Math.sin(angle) * root.maxSize * 0.364;
    }

    anchors.fill: parent

    Timer {
        interval: 1
        repeat: false
        running: true
        onTriggered: {
            minuteArc.minute = wallClock.time.getMinutes();
            minuteArc.requestPaint();
            updateMinute();
        }
    }

    Canvas {
        id: minuteArc

        property int minute: 0

        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            var m = minute;
            var rot = (m - 15) * 6;
            ctx.reset();
            ctx.lineWidth = parent.width / 10;
            var gradient = ctx.createConicalGradient(parent.width / 2, parent.height / 2, 90 * 0.0174533);
            gradient.addColorStop(1 - (m / 60), Qt.rgba(0.318, 1, 0.051, 0.7));
            gradient.addColorStop(1 - (m / 60 / 2), Qt.rgba(0.318, 1, 0.051, 0));
            ctx.beginPath();
            ctx.arc(parent.width / 2, parent.height / 2, width / 2.75, -90 * 0.0174533, rot * 0.0174533, false);
            ctx.lineTo(parent.width / 2, parent.height / 2);
            ctx.fillStyle = gradient;
            ctx.fill();
        }
    }

    Text {
        id: hourDisplay

        property real offset: height * 0.42

        renderType: Text.NativeRendering
        color: Qt.rgba(1, 1, 1, 0.85)
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.4)
        horizontalAlignment: Text.AlignHCenter
        x: root.maxSize / 2 - width / 1.88
        y: root.maxSize / 2 - offset
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) : wallClock.time.toLocaleString(Qt.locale(), "HH")

        font {
            pixelSize: root.maxSize * 0.94
            family: "Bebas Neue"
            styleName: "Bold"
        }

    }

    // Minute circle — plain Rectangle replaces Canvas full-circle arc
    Rectangle {
        id: minuteCircle

        property real minuteX: 0
        property real minuteY: 0

        width: parent.width / 8.8 * 2
        height: width
        radius: width / 2
        x: minuteX - width / 2
        y: minuteY - height / 2
        color: Qt.rgba(0.184, 0.184, 0.184, 0.98)
    }

    Text {
        id: minuteDisplay

        color: "white"
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")

        font {
            pixelSize: root.maxSize / 5.6
            family: "BebasKai"
            styleName: "Condensed"
        }

    }

    Connections {
        function onTimeChanged() {
            if (!visible)
                return ;

            var minute = wallClock.time.getMinutes();
            if (minuteArc.minute !== minute) {
                minuteArc.minute = minute;
                minuteArc.requestPaint();
                updateMinute();
            }
        }

        target: wallClock
    }

}
