/*
 * Horizon line across the center; big JetBrains Mono HH:MM sits above it.
 * A gnomon shadow arm sweeps with the seconds, tinted by time of day
 * (amber at noon, indigo at midnight). Date below the horizon.
 *
 * Ambient: shadow hidden; time and date remain.
 *
 * Font: JetBrains Mono (OFL)
 */
// SPDX-FileCopyrightText: 2026 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: BSD-3-Clause

import QtQuick 2.15

Item {
    id: root

    // Time-of-day tint — amber at noon, indigo at midnight
    // Updated on minute change only — second granularity not needed for color
    property real tod: 0
    property real warmth: 0
    property color shadowColor: "white"
    property real smoothSeconds: 0

    function pad(n) {
        return n < 10 ? "0" + n : "" + n;
    }

    function updateColor(h, min) {
        tod = h + min / 60;
        warmth = Math.cos(((tod - 13) / 24) * 2 * Math.PI);
        var hue = warmth > 0 ? (30 + warmth * 10) : (230 + (-warmth) * 20);
        var lit = Math.max(0.72, 0.58 + warmth * 0.12);
        shadowColor = Qt.hsla(hue / 360, 0.75, lit, 1);
    }

    anchors.fill: parent
    Component.onCompleted: {
        var h = wallClock.time.getHours();
        var min = wallClock.time.getMinutes();
        hhText.text = root.pad(h);
        mmText.text = root.pad(min);
        dateText.text = wallClock.time.toLocaleString(Qt.locale(), "dddd · dd. MMM").toUpperCase();
        root.updateColor(h, min);
        shadow.requestPaint();
    }

    Item {
        id: watchfaceRoot

        anchors.centerIn: parent
        height: Math.min(parent.width, parent.height)
        width: height

        // Horizon line
        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 0.84
            height: 2
            color: "#60ffffff"
        }

        // Gnomon shadow arm — sweeps once per minute, tinted by time of day
        Canvas {
            id: shadow

            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            visible: !displayAmbient
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                var cx = width / 2;
                var cy = height / 2;
                var a = (root.smoothSeconds / 60) * 360 - 90;
                var r = a * Math.PI / 180;
                var tip = width * 0.42;
                ctx.strokeStyle = root.shadowColor;
                ctx.lineWidth = width * 0.022;
                ctx.lineCap = "round";
                ctx.beginPath();
                ctx.moveTo(cx, cy);
                ctx.lineTo(cx + tip * Math.cos(r), cy + tip * Math.sin(r));
                ctx.stroke();
                ctx.fillStyle = root.shadowColor;
                ctx.beginPath();
                ctx.arc(cx + tip * Math.cos(r), cy + tip * Math.sin(r), width * 0.028, 0, Math.PI * 2);
                ctx.fill();
            }
        }

        // Gnomon centre pin
        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 0.032
            height: width
            radius: width / 2
            color: "white"
            opacity: displayAmbient ? 0.4 : 0.9
        }

        // HH:MM above the horizon
        Row {
            id: timeRow

            spacing: 0

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.verticalCenter
                bottomMargin: parent.height * 0.02
            }

            Text {
                id: hhText

                color: "white"
                opacity: displayAmbient ? 0.75 : 1

                font {
                    family: "JetBrains Mono"
                    weight: Font.Light
                    pixelSize: watchfaceRoot.height * 0.2
                }

            }

            Text {
                text: ":"
                color: root.shadowColor
                opacity: displayAmbient ? 0.4 : 1

                font {
                    family: "JetBrains Mono"
                    weight: Font.Light
                    pixelSize: watchfaceRoot.height * 0.2
                }

            }

            Text {
                id: mmText

                color: "white"
                opacity: displayAmbient ? 0.75 : 1

                font {
                    family: "JetBrains Mono"
                    weight: Font.Light
                    pixelSize: watchfaceRoot.height * 0.2
                }

            }

        }

        // Date below the horizon
        Text {
            id: dateText

            color: "#a6ffffff"
            opacity: displayAmbient ? 0.5 : 1

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.verticalCenter
                topMargin: parent.height * 0.12
            }

            font {
                family: "JetBrains Mono"
                pixelSize: watchfaceRoot.height * 0.036
                letterSpacing: 4
            }

        }

    }

    Timer {
        interval: 16
        running: !displayAmbient && visible
        repeat: true
        onTriggered: {
            var d = new Date();
            root.smoothSeconds = d.getSeconds() + d.getMilliseconds() / 1000;
            shadow.requestPaint();
        }
    }

    Connections {
        function onTimeChanged() {
            var h = wallClock.time.getHours();
            var min = wallClock.time.getMinutes();
            hhText.text = root.pad(h);
            mmText.text = root.pad(min);
            dateText.text = wallClock.time.toLocaleString(Qt.locale(), "dddd · dd. MMM").toUpperCase();
            root.updateColor(h, min);
        }

        target: wallClock
    }

}
