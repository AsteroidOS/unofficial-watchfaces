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
        secondDisplay.second = wallClock.time.getSeconds();
        secondDisplay.requestPaint();
    }

    Item {
        id: faceBox

        width: Math.min(parent.width, parent.height)
        height: width
        anchors.centerIn: parent
        Component.onCompleted: {
            secondDisplay.second = wallClock.time.getSeconds();
            secondDisplay.requestPaint();
        }

        Canvas {
            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                ctx.lineWidth = parent.height / 48;
                ctx.lineCap = "round";
                ctx.strokeStyle = Qt.rgba(0.1, 0.1, 0.1, 0.95);
                ctx.translate(parent.width / 2, parent.height / 2);
                for (var i = 0; i < 60; i++) {
                    ctx.beginPath();
                    ctx.moveTo(0, height * 0.365);
                    ctx.lineTo(0, height * 0.405);
                    ctx.stroke();
                    ctx.rotate(Math.PI / 30);
                }
            }
        }

        Canvas {
            id: secondDisplay

            property int second: 0

            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.shadowColor = Qt.rgba(0.541, 0.796, 0.243, 0.85);
                ctx.shadowOffsetX = 0;
                ctx.shadowOffsetY = 0;
                ctx.shadowBlur = 5;
                ctx.lineWidth = parent.height / 58;
                ctx.lineCap = "round";
                ctx.strokeStyle = Qt.rgba(0.541, 0.796, 0.243, 1);
                ctx.translate(parent.width / 2, parent.height / 2);
                ctx.rotate(Math.PI);
                for (var i = 0; i <= second; i++) {
                    ctx.beginPath();
                    ctx.moveTo(0, height * 0.367);
                    ctx.lineTo(0, height * 0.402);
                    ctx.stroke();
                    ctx.rotate(Math.PI / 30);
                }
            }
        }

        Text {
            id: hourDisplay

            renderType: Text.NativeRendering
            color: "white"
            style: Text.Outline
            styleColor: Qt.rgba(0.1, 0.1, 0.1, 0.95)
            opacity: 0.98
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height / 4
            text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) : wallClock.time.toLocaleString(Qt.locale(), "HH")

            font {
                pixelSize: parent.height * 0.3
                family: "Titillium"
                styleName: "Bold"
            }

        }

        Text {
            id: minuteDisplay

            renderType: Text.NativeRendering
            color: "white"
            style: Text.Outline
            styleColor: Qt.rgba(0.1, 0.1, 0.1, 0.95)
            opacity: 0.98
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height / 1.95
            text: wallClock.time.toLocaleString(Qt.locale(), "mm")

            font {
                pixelSize: parent.height * 0.3
                family: "Titillium"
                styleName: "Light"
            }

        }

    }

    Connections {
        function onTimeChanged() {
            secondDisplay.second = wallClock.time.getSeconds();
            secondDisplay.requestPaint();
        }

        target: wallClock
    }

}
