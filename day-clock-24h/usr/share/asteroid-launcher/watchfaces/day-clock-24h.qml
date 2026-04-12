/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
 *               2018 - Timo Könnecke <el-t-mo@arcor.de>
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
/*
 * Based on kitt by velox/jgibbon regarding arcs and image embedding.
 */

import QtGraphicalEffects 1.15
import QtQuick 2.9

Item {
    id: root

    Component.onCompleted: {
        var h = wallClock.time.getHours();
        var min = wallClock.time.getMinutes();
        twentyfourhourArc.hour = h;
        twentyfourhourArc.minute = min;
        twentyfourhourArc.requestPaint();
        dayDisplay.text = Math.round(((0.25 * (60 * (h + 6) + min) - 90) / 360) * 100);
    }

    Canvas {
        id: twentyfourhourArc

        property real hour: 0
        property real minute: 0

        z: 1
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            // arc sweeps full 360° over 24h — offset +6h so midnight is at left (9 o'clock position)
            var rot = 0.25 * (60 * (hour + 6) + minute);
            ctx.reset();
            ctx.beginPath();
            ctx.lineWidth = parent.width / 42;
            ctx.fillStyle = Qt.rgba(0, 0, 0, 0.5);
            ctx.arc(parent.width / 2, parent.height / 2, width, 90 * 0.01745, rot * 0.01745, false);
            ctx.lineTo(parent.width / 2, parent.height / 2);
            ctx.fill();
        }
    }

    Image {
        id: backGround

        z: 2
        source: "../watchfaces-img/day-clock-center.svg"
        anchors.centerIn: parent
        width: parent.width / 3
        height: parent.height / 3

        Image {
            id: backStars

            z: 2
            source: "../watchfaces-img/day-clock-center-stars.svg"
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            layer.enabled: true

            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 0
                radius: 12
                samples: 9
                color: "#ccffcc00"
            }

        }

    }

    Text {
        id: hourDisplay

        property real offset: height * 0.5

        z: 3
        color: "white"
        style: Text.Outline
        styleColor: "#80000000"
        opacity: 0.9
        horizontalAlignment: Text.AlignHCenter
        x: parent.width / 14
        y: parent.height / 2.5 - offset
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) : wallClock.time.toLocaleString(Qt.locale(), "HH")

        font {
            pixelSize: parent.height * 0.22
            family: "Vollkorn"
            styleName: "Regular"
        }

    }

    Text {
        id: minuteDisplay

        property real offset: height * 0.5

        z: 3
        color: "white"
        style: Text.Outline
        styleColor: "#80000000"
        opacity: 0.9
        horizontalAlignment: Text.AlignHCenter
        x: parent.width / 14
        y: parent.height / 1.65 - offset
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")

        font {
            pixelSize: parent.height * 0.22
            family: "Vollkorn"
            styleName: "Regular"
        }

    }

    Text {
        id: dayDisplay

        property real offset: height * 0.5

        z: 4
        color: "white"
        style: Text.Outline
        styleColor: "#80000000"
        opacity: 0.5
        x: parent.width * 0.7
        y: parent.height / 2.5 - offset

        font {
            pixelSize: parent.height * 0.2
            family: "Vollkorn"
            styleName: "Regular"
        }

    }

    Text {
        id: percentDisplay

        property real offset: height * 0.5

        z: 4
        color: "white"
        style: Text.Outline
        styleColor: "#80000000"
        opacity: 0.5
        x: parent.width * 0.73
        y: parent.height / 1.58 - offset
        text: "%"

        font {
            pixelSize: parent.height * 0.2
            family: "Vollkorn"
            styleName: "Regular"
        }

    }

    Text {
        id: dayofweekDisplay

        z: 5
        lineHeight: parent.height * 0.0025
        color: "white"
        style: Text.Outline
        styleColor: "#80000000"
        opacity: 0.7
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 9
        text: wallClock.time.toLocaleString(Qt.locale(), "dddd")

        font {
            pixelSize: parent.height * 0.1
            family: "Vollkorn"
            styleName: "Regular"
        }

    }

    Text {
        id: dateDisplay

        z: 6
        lineHeight: parent.height * 0.0025
        color: "white"
        style: Text.Outline
        styleColor: "#80000000"
        opacity: 0.8
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 1.32
        text: wallClock.time.toLocaleString(Qt.locale(), "yyyy MM dd")

        font {
            pixelSize: parent.height * 0.1
            family: "Vollkorn"
            styleName: "Regular"
        }

    }

    Connections {
        function onTimeChanged() {
            if (!visible)
                return ;

            var h = wallClock.time.getHours();
            var min = wallClock.time.getMinutes();
            twentyfourhourArc.hour = h;
            twentyfourhourArc.minute = min;
            twentyfourhourArc.requestPaint();
            // day percentage: how far through the 24h cycle, shown as 0-100
            dayDisplay.text = Math.round(((0.25 * (60 * (h + 6) + min) - 90) / 360) * 100);
        }

        target: wallClock
    }

}
