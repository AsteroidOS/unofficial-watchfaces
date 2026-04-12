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

import QtQuick 2.1

Item {
    Component.onCompleted: {
        var hour = wallClock.time.getHours();
        var minute = wallClock.time.getMinutes();
        var second = wallClock.time.getSeconds();
        secondBar.second = second;
        secondBar.requestPaint();
        minuteBar.minute = minute;
        minuteBar.requestPaint();
        hourBar.hour = hour;
        hourBar.requestPaint();
    }

    // Static rainbow background — plain Rectangles replace former Canvas.
    Rectangle {
        z: 1
        x: parent.width / 6 * 0
        width: parent.width / 6
        height: parent.height
        color: Qt.rgba(1, 0.176, 0.188, 0.2)
    }

    Rectangle {
        z: 1
        x: parent.width / 6 * 1
        width: parent.width / 6
        height: parent.height
        color: Qt.rgba(0.996, 0.541, 0.098, 0.2)
    }

    Rectangle {
        z: 1
        x: parent.width / 6 * 2
        width: parent.width / 6
        height: parent.height
        color: Qt.rgba(0.922, 0.859, 0.047, 0.2)
    }

    Rectangle {
        z: 1
        x: parent.width / 6 * 3
        width: parent.width / 6
        height: parent.height
        color: Qt.rgba(0.694, 0.812, 0.051, 0.2)
    }

    Rectangle {
        z: 1
        x: parent.width / 6 * 4
        width: parent.width / 6
        height: parent.height
        color: Qt.rgba(0.055, 0.694, 0.91, 0.2)
    }

    Rectangle {
        z: 1
        x: parent.width / 6 * 5
        width: parent.width / 6
        height: parent.height
        color: Qt.rgba(0.51, 0, 0.427, 0.2)
    }

    Rectangle {
        z: 4
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: Qt.rgba(0, 0, 0, 0.7)
        width: parent.width
        height: parent.height * 0.24
    }

    Canvas {
        id: hourBar

        property int hour: 0

        z: 3
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            var h = hour / 24 * (-parent.height);
            ctx.reset();
            ctx.fillStyle = Qt.rgba(0.996, 0.282, 0.298, 0.7);
            ctx.fillRect(0, parent.height, parent.width / 6, h);
            ctx.fillStyle = Qt.rgba(1, 0.631, 0.188, 0.7);
            ctx.fillRect(parent.width / 6, parent.height, parent.width / 6, h);
        }
    }

    Canvas {
        id: minuteBar

        property int minute: 0

        z: 3
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            var m = minute / 60 * (-parent.height);
            ctx.reset();
            ctx.fillStyle = Qt.rgba(1, 0.933, 0.051, 0.7);
            ctx.fillRect(parent.width / 6 * 2, parent.height, parent.width / 6, m);
            ctx.fillStyle = Qt.rgba(0.855, 1, 0.047, 0.7);
            ctx.fillRect(parent.width / 6 * 3, parent.height, parent.width / 6, m);
        }
    }

    Canvas {
        id: secondBar

        property int second: 0

        z: 3
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            var s = second / 60 * (-parent.height);
            ctx.reset();
            ctx.fillStyle = Qt.rgba(0.133, 0.827, 1, 0.7);
            ctx.fillRect(parent.width / 6 * 4, parent.height, parent.width / 6, s);
            ctx.fillStyle = Qt.rgba(0.902, 0, 0.769, 0.7);
            ctx.fillRect(parent.width / 6 * 5, parent.height, parent.width / 6, s);
        }
    }

    Text {
        id: hourDisplay

        z: 6
        renderType: Text.NativeRendering
        font.pixelSize: parent.height * 0.25
        font.family: "Titillium"
        font.styleName: "Bold"
        lineHeight: parent.height / 330
        color: Qt.rgba(1, 1, 1, 1)
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.395
        x: parent.width / 6 - width / 2
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) : wallClock.time.toLocaleString(Qt.locale(), "HH")
    }

    Text {
        id: minuteDisplay

        z: 6
        renderType: Text.NativeRendering
        font.pixelSize: parent.height * 0.25
        font.family: "Titillium"
        font.styleName: "Regular"
        lineHeight: parent.height / 330
        color: Qt.rgba(1, 1, 1, 1)
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.395
        anchors.horizontalCenter: parent.horizontalCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    Text {
        id: secondDisplay

        z: 6
        renderType: Text.NativeRendering
        font.pixelSize: parent.height * 0.25
        font.family: "Titillium"
        font.styleName: "Thin"
        lineHeight: parent.height / 330
        color: Qt.rgba(1, 1, 1, 1)
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.395
        x: parent.width / 6 * 5 - width / 2
        text: wallClock.time.toLocaleString(Qt.locale(), "ss")
    }

    Connections {
        function onTimeChanged() {
            var hour = wallClock.time.getHours();
            var minute = wallClock.time.getMinutes();
            var second = wallClock.time.getSeconds();
            if (secondBar.second !== second) {
                secondBar.second = second;
                secondBar.requestPaint();
            }
            if (minuteBar.minute !== minute) {
                minuteBar.minute = minute;
                minuteBar.requestPaint();
                hourBar.hour = hour;
                hourBar.requestPaint();
            }
        }

        target: wallClock
    }

}
