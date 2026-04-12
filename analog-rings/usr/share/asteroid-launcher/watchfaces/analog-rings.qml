/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
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
