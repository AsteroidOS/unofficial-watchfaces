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

    Component.onCompleted: {
        var second = wallClock.time.getSeconds();
        secondCanvas.second = second;
        secondCanvas.requestPaint();
    }

    Canvas {
        id: secondCanvas

        property int second: 0

        z: 1
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            var rot = (second - 15) * 6;
            ctx.reset();
            ctx.beginPath();
            ctx.lineWidth = parent.width / 42;
            ctx.fillStyle = Qt.rgba(1, 0.549, 0.149, 0.7);
            ctx.arc(parent.width / 2, parent.height / 2, width / 2.1, -90 * 0.0174533, rot * 0.0174533, false);
            ctx.lineTo(parent.width / 2, parent.height / 2);
            ctx.fill();
        }
    }

    Rectangle {
        z: 2
        x: root.width / 2 - width / 2
        y: root.height / 2 - width / 2
        color: Qt.rgba(0.184, 0.184, 0.184, 0.7)
        width: parent.width * 0.465
        height: parent.height * 0.465
        radius: width * 0.5
    }

    Text {
        id: hourDisplay

        z: 3
        font.pixelSize: parent.height * 0.16
        font.family: "Raleway"
        font.styleName: "Regular"
        color: "white"
        opacity: 1
        style: Text.Outline
        styleColor: "#80000000"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "<b>hh</b> ap").slice(0, 9) + wallClock.time.toLocaleString(Qt.locale(), ":mm") : wallClock.time.toLocaleString(Qt.locale(), "<b>HH</b>") + wallClock.time.toLocaleString(Qt.locale(), ":mm")
    }

    Connections {
        function onTimeChanged() {
            var second = wallClock.time.getSeconds();
            if (secondCanvas.second !== second) {
                secondCanvas.second = second;
                secondCanvas.requestPaint();
            }
        }

        target: wallClock
    }

}
