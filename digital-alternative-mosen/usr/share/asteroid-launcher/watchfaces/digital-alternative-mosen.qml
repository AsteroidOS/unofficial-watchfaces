// SPDX-FileCopyrightText: 2019 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2014 Aleksi Suomalainen <suomalainen.aleksi@gmail.com>
// SPDX-License-Identifier: BSD-3-Clause
// Based on Florent's 002-alternative-digital stock watchface.
// Bigger monotype font (GeneraleMono) and fixed am/pm display by slicing to two chars.
// Calculated ctx.shadows with variable px size for better display in watchface-settings.

import QtQuick

Item {
    function prepareContext(ctx) {
        ctx.reset();
        ctx.fillStyle = "white";
        ctx.textAlign = "center";
        ctx.textBaseline = 'middle';
        ctx.shadowColor = Qt.rgba(0, 0, 0, 0.8);
        ctx.shadowOffsetX = faceBox.height * 0.00625;
        ctx.shadowOffsetY = faceBox.height * 0.00625;
        ctx.shadowBlur = faceBox.height * 0.0156;
    }

    anchors.fill: parent
    Component.onCompleted: {
        hourMinuteCanvas.requestPaint();
        dateCanvas.requestPaint();
        amPmCanvas.requestPaint();
    }

    Item {
        id: faceBox

        width: Math.min(parent.width, parent.height)
        height: width
        anchors.centerIn: parent

        Canvas {
            id: hourMinuteCanvas

            anchors.fill: parent
            antialiasing: true
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                prepareContext(ctx);
                var text;
                if (use12H.value)
                    text = wallClock.time.toLocaleString(Qt.locale(), "hh:mm ap").substring(0, 5);
                else
                    text = wallClock.time.toLocaleString(Qt.locale(), "HH:mm");
                ctx.font = "500 " + parent.height * 0.25 + "px GeneraleMono";
                ctx.fillText(text, parent.width * 0.5, parent.height * 0.546);
            }
        }

        Canvas {
            id: amPmCanvas

            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                prepareContext(ctx);
                var px = "px ";
                var centerX = parent.width / 2;
                var centerY = parent.height * 0.382;
                var verticalOffset = -parent.height * 0.003;
                var text;
                text = wallClock.time.toLocaleString(Qt.locale(), "AP");
                var fontSize = parent.height * 0.072;
                var fontFamily = "GeneraleMono";
                ctx.font = "300 " + fontSize + px + fontFamily;
                if (use12H.value)
                    ctx.fillText(text, centerX, centerY + verticalOffset);

            }
        }

        Canvas {
            id: dateCanvas

            anchors.fill: parent
            antialiasing: true
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                prepareContext(ctx);
                ctx.font = "300 " + parent.height * 0.0725 + "px GeneraleMono";
                ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "ddd dd MMM"), parent.width * 0.5, parent.height * 0.692);
            }
        }

    }

    Connections {
        function onTimeChanged() {
            if (!visible)
                return ;

            hourMinuteCanvas.requestPaint();
            dateCanvas.requestPaint();
            amPmCanvas.requestPaint();
        }

        target: wallClock
    }

    Connections {
        function onChangesObserverChanged() {
            hourMinuteCanvas.requestPaint();
            dateCanvas.requestPaint();
            amPmCanvas.requestPaint();
        }

        target: localeManager
    }

}
