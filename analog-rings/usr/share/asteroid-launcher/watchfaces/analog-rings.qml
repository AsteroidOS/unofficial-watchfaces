// SPDX-FileCopyrightText: 2018 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property real maxSize: Math.min(width, height)
    readonly property real fontBaselineNudge: maxSize * 0.011

    anchors.fill: parent

    Timer {
        interval: 1
        repeat: false
        running: true
        onTriggered: {
            var h = wallClock.time.getHours();
            var min = wallClock.time.getMinutes();
            var rotH = (h - 3 + min / 60) / 12;
            var rotM = (min - 15) / 60;
            var cx = root.width / 2;
            var cy = root.height / 2;
            var dotR = root.maxSize / 5.75 / 2;
            minuteDot.x = cx + Math.cos(rotM * 2 * Math.PI) * root.maxSize * 0.36 - dotR;
            minuteDot.y = cy + Math.sin(rotM * 2 * Math.PI) * root.maxSize * 0.36 - dotR;
            hourDot.x = cx + Math.cos(rotH * 2 * Math.PI) * root.maxSize * 0.185 - dotR;
            hourDot.y = cy + Math.sin(rotH * 2 * Math.PI) * root.maxSize * 0.185 - dotR;
            hourDisplay.x = cx - hourDisplay.width / 2 - root.maxSize * 0.0015 + Math.cos(rotH * 2 * Math.PI) * (hourDisplay.height * 1.32 - root.maxSize * 0.007);
            hourDisplay.y = cy - hourDisplay.height / 2 + Math.sin(rotH * 2 * Math.PI) * (hourDisplay.height * 1.32 - root.maxSize * 0.007) - root.maxSize * 0.006 + root.fontBaselineNudge;
            minuteDisplay.x = cx - minuteDisplay.width / 2 - root.maxSize * 0.0015 + Math.cos(rotM * 2 * Math.PI) * (minuteDisplay.height * 2.535 - root.maxSize * 0.007);
            minuteDisplay.y = cy - minuteDisplay.height / 2 + Math.sin(rotM * 2 * Math.PI) * (minuteDisplay.height * 2.535 - root.maxSize * 0.007) - root.maxSize * 0.006 + root.fontBaselineNudge;
        }
    }

    Image {
        id: logoAsteroid

        source: "../watchfaces-img/asteroid-logo.svg"
        anchors.centerIn: parent
        width: root.maxSize / 5.7
        height: root.maxSize / 5.7
    }

    // Minute ring background track
    Shape {
        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        ShapePath {
            strokeColor: Qt.rgba(0, 0, 0, 0.5)
            strokeWidth: root.maxSize / 80
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: root.maxSize / 2
                centerY: root.maxSize / 2
                radiusX: root.maxSize / 2.75
                radiusY: root.maxSize / 2.75
                startAngle: -90
                sweepAngle: 360
            }

        }

    }

    // Minute progress arc — sweepAngle binding drives redraw automatically
    Shape {
        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        ShapePath {
            strokeColor: Qt.rgba(1, 1, 1, 0.7)
            strokeWidth: root.maxSize / 20
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: root.maxSize / 2
                centerY: root.maxSize / 2
                radiusX: root.maxSize / 2.75
                radiusY: root.maxSize / 2.75
                startAngle: -90
                sweepAngle: (wallClock.time.getMinutes() / 60) * 360
            }

        }

    }

    // Hour ring background track
    Shape {
        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        ShapePath {
            strokeColor: Qt.rgba(0, 0, 0, 0.5)
            strokeWidth: root.maxSize / 80
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: root.maxSize / 2
                centerY: root.maxSize / 2
                radiusX: root.maxSize / 5.3
                radiusY: root.maxSize / 5.3
                startAngle: -90
                sweepAngle: 360
            }

        }

    }

    // Hour progress arc — 0° at 12:00, full 360° at 12:00 again
    Shape {
        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        ShapePath {
            strokeColor: Qt.rgba(1, 1, 1, 0.7)
            strokeWidth: root.maxSize / 20
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: root.maxSize / 2
                centerY: root.maxSize / 2
                radiusX: root.maxSize / 5.3
                radiusY: root.maxSize / 5.3
                startAngle: -90
                sweepAngle: ((wallClock.time.getHours() % 12) * 60 + wallClock.time.getMinutes()) / 720 * 360
            }

        }

    }

    // Dot at hour hand tip — positioned imperatively from Connections
    Rectangle {
        id: hourDot

        width: root.maxSize / 5.75
        height: width
        radius: width / 2
        color: Qt.rgba(0.184, 0.184, 0.184, 0.9)
    }

    Text {
        id: hourDisplay

        color: "white"
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "<b>hh</b> ap").slice(0, 9) : wallClock.time.toLocaleString(Qt.locale(), "<b>HH</b>")

        font {
            pixelSize: root.maxSize / 8
            family: "SlimSans"
            styleName: "Bold"
        }

    }

    // Dot at minute hand tip — positioned imperatively from Timer and Connections
    Rectangle {
        id: minuteDot

        width: root.maxSize / 5.75
        height: width
        radius: width / 2
        color: Qt.rgba(0.184, 0.184, 0.184, 0.9)
    }

    Text {
        id: minuteDisplay

        font.pixelSize: root.maxSize / 8
        font.family: "SlimSans"
        color: "white"
        style: Text.Outline
        styleColor: "#80000000"
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    Connections {
        function onTimeChanged() {
            if (!visible)
                return ;

            var h = wallClock.time.getHours();
            var min = wallClock.time.getMinutes();
            var rotH = (h - 3 + min / 60) / 12;
            var rotM = (min - 15) / 60;
            var cx = root.width / 2;
            var cy = root.height / 2;
            var dotR = root.maxSize / 5.75 / 2;
            minuteDot.x = cx + Math.cos(rotM * 2 * Math.PI) * root.maxSize * 0.36 - dotR;
            minuteDot.y = cy + Math.sin(rotM * 2 * Math.PI) * root.maxSize * 0.36 - dotR;
            hourDot.x = cx + Math.cos(rotH * 2 * Math.PI) * root.maxSize * 0.185 - dotR;
            hourDot.y = cy + Math.sin(rotH * 2 * Math.PI) * root.maxSize * 0.185 - dotR;
            hourDisplay.x = cx - hourDisplay.width / 2 - root.maxSize * 0.0015 + Math.cos(rotH * 2 * Math.PI) * (hourDisplay.height * 1.32 - root.maxSize * 0.007);
            hourDisplay.y = cy - hourDisplay.height / 2 + Math.sin(rotH * 2 * Math.PI) * (hourDisplay.height * 1.32 - root.maxSize * 0.007) - root.maxSize * 0.006 + root.fontBaselineNudge;
            minuteDisplay.x = cx - minuteDisplay.width / 2 - root.maxSize * 0.0015 + Math.cos(rotM * 2 * Math.PI) * (minuteDisplay.height * 2.535 - root.maxSize * 0.007);
            minuteDisplay.y = cy - minuteDisplay.height / 2 + Math.sin(rotM * 2 * Math.PI) * (minuteDisplay.height * 2.535 - root.maxSize * 0.007) - root.maxSize * 0.006 + root.fontBaselineNudge;
        }

        target: wallClock
    }

}
