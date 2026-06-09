// SPDX-FileCopyrightText: 2018 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick

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
