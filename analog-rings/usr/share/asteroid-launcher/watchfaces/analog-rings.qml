// SPDX-FileCopyrightText: 2018 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {
    id: root

    Component.onCompleted: {
        var h = wallClock.time.getHours();
        var min = wallClock.time.getMinutes();
        var rotH = (h - 3 + min / 60) / 12;
        var rotM = (min - 15) / 60;
        var cx = root.width / 2;
        var cy = root.height / 2;
        var dotR = root.width / 5.75 / 2;
        minuteDot.x = cx + Math.cos(rotM * 2 * Math.PI) * root.width * 0.36 - dotR;
        minuteDot.y = cy + Math.sin(rotM * 2 * Math.PI) * root.width * 0.36 - dotR;
        hourDot.x = cx + Math.cos(rotH * 2 * Math.PI) * root.width * 0.185 - dotR;
        hourDot.y = cy + Math.sin(rotH * 2 * Math.PI) * root.width * 0.185 - dotR;
        hourDisplay.x = cx - hourDisplay.width / 2 - root.height * 0.0015 + Math.cos(rotH * 2 * Math.PI) * (hourDisplay.height * 1.32 - root.height * 0.007);
        hourDisplay.y = cy - hourDisplay.height / 2 + Math.sin(rotH * 2 * Math.PI) * (hourDisplay.height * 1.32 - root.height * 0.007) - root.height * 0.006;
        minuteDisplay.x = cx - minuteDisplay.width / 2 - root.height * 0.0015 + Math.cos(rotM * 2 * Math.PI) * (minuteDisplay.height * 2.535 - root.height * 0.007);
        minuteDisplay.y = cy - minuteDisplay.height / 2 + Math.sin(rotM * 2 * Math.PI) * (minuteDisplay.height * 2.535 - root.height * 0.007) - root.height * 0.006;
    }

    Image {
        id: logoAsteroid

        source: "../watchfaces-img/asteroid-logo.svg"
        anchors.centerIn: parent
        width: parent.width / 5.7
        height: parent.height / 5.7
    }

    // Minute ring background track
    Shape {
        anchors.fill: parent

        ShapePath {
            strokeColor: Qt.rgba(0, 0, 0, 0.5)
            strokeWidth: parent.width / 80
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: parent.width / 2
                centerY: parent.height / 2
                radiusX: parent.width / 2.75
                radiusY: parent.height / 2.75
                startAngle: -90
                sweepAngle: 360
            }

        }

    }

    // Minute progress arc — sweepAngle binding drives redraw automatically
    Shape {
        anchors.fill: parent

        ShapePath {
            strokeColor: Qt.rgba(1, 1, 1, 0.7)
            strokeWidth: parent.width / 20
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: parent.width / 2
                centerY: parent.height / 2
                radiusX: parent.width / 2.75
                radiusY: parent.height / 2.75
                startAngle: -90
                sweepAngle: (wallClock.time.getMinutes() / 60) * 360
            }

        }

    }

    // Dot at minute hand tip — positioned imperatively from Connections
    Rectangle {
        id: minuteDot

        width: root.width / 5.75
        height: width
        radius: width / 2
        color: Qt.rgba(0.184, 0.184, 0.184, 0.9)
    }

    // Hour ring background track
    Shape {
        anchors.fill: parent

        ShapePath {
            strokeColor: Qt.rgba(0, 0, 0, 0.5)
            strokeWidth: parent.width / 80
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: parent.width / 2
                centerY: parent.height / 2
                radiusX: parent.width / 5.3
                radiusY: parent.height / 5.3
                startAngle: -90
                sweepAngle: 360
            }

        }

    }

    // Hour progress arc — 0° at 12:00, full 360° at 12:00 again
    Shape {
        anchors.fill: parent

        ShapePath {
            strokeColor: Qt.rgba(1, 1, 1, 0.7)
            strokeWidth: parent.width / 20
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: parent.width / 2
                centerY: parent.height / 2
                radiusX: parent.width / 5.3
                radiusY: parent.height / 5.3
                startAngle: -90
                sweepAngle: ((wallClock.time.getHours() % 12) * 60 + wallClock.time.getMinutes()) / 720 * 360
            }

        }

    }

    // Dot at hour hand tip — positioned imperatively from Connections
    Rectangle {
        id: hourDot

        width: root.width / 5.75
        height: width
        radius: width / 2
        color: Qt.rgba(0.184, 0.184, 0.184, 0.9)
    }

    Text {
        id: hourDisplay

        color: "white"
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "<b>hh</b> ap").slice(0, 9) : wallClock.time.toLocaleString(Qt.locale(), "<b>HH</b>")

        font {
            pixelSize: parent.height / 8
            family: "SlimSans"
            styleName: "Bold"
        }

    }

    Text {
        id: minuteDisplay

        font.pixelSize: parent.height / 8
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
            var dotR = root.width / 5.75 / 2;
            minuteDot.x = cx + Math.cos(rotM * 2 * Math.PI) * root.width * 0.36 - dotR;
            minuteDot.y = cy + Math.sin(rotM * 2 * Math.PI) * root.width * 0.36 - dotR;
            hourDot.x = cx + Math.cos(rotH * 2 * Math.PI) * root.width * 0.185 - dotR;
            hourDot.y = cy + Math.sin(rotH * 2 * Math.PI) * root.width * 0.185 - dotR;
            hourDisplay.x = cx - hourDisplay.width / 2 - root.height * 0.0015 + Math.cos(rotH * 2 * Math.PI) * (hourDisplay.height * 1.32 - root.height * 0.007);
            hourDisplay.y = cy - hourDisplay.height / 2 + Math.sin(rotH * 2 * Math.PI) * (hourDisplay.height * 1.32 - root.height * 0.007) - root.height * 0.006;
            minuteDisplay.x = cx - minuteDisplay.width / 2 - root.height * 0.0015 + Math.cos(rotM * 2 * Math.PI) * (minuteDisplay.height * 2.535 - root.height * 0.007);
            minuteDisplay.y = cy - minuteDisplay.height / 2 + Math.sin(rotM * 2 * Math.PI) * (minuteDisplay.height * 2.535 - root.height * 0.007) - root.height * 0.006;
        }

        target: wallClock
    }

}
