/*
 * Magnetic Field — AsteroidOS watchface
 *
 * Iron-filings field in three rings, each stroke tilted toward the
 * hour-hand angle with influence decaying by cos(angular distance).
 * Minute hand sweeps smoothly via 16 ms timer.
 *
 * Font: Space Mono (OFL)
 */
// SPDX-FileCopyrightText: 2026 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: BSD-3-Clause

import QtQuick 2.15

Item {
    id: root

    property real minAngle: 0
    property string arcDateStr: ""
    property real arcRadius: watchfaceRoot.width * 0.114
    property real arcFontSize: watchfaceRoot.height * 0.04
    property real arcCharStep: (arcFontSize * 0.82) / arcRadius * (180 / Math.PI)
    property real arcTotalAngle: arcDateStr.length * arcCharStep
    property real arcStartAngle: root.minAngle + (375 - arcTotalAngle) / 2
    readonly property color fg: "#dfe4ff"
    readonly property color accent: "#ff5a6a"

    function pad(n) {
        return n < 10 ? "0" + n : "" + n;
    }

    anchors.fill: parent
    Component.onCompleted: {
        var t = wallClock.time;
        var h = t.getHours();
        var min = t.getMinutes();
        root.minAngle = ((min + t.getSeconds() / 60) / 60) * 360 - 90;
        field.hrA = (((h % 12) + min / 60) / 12) * 360 - 90;
        root.arcDateStr = t.toLocaleString(Qt.locale(), "ddd · dd · MMM").toUpperCase();
        field.requestPaint();
    }

    Item {
        id: watchfaceRoot

        anchors.centerIn: parent
        height: Math.min(parent.width, parent.height)
        width: height

        // Iron-filings field — Canvas justified: 132 strokes with individually
        // computed influence angles, opacities and lengths; not reducible to
        // static QML shapes. Repaints once per minute via wallClock Connections.
        Canvas {
            id: field

            property real hrA: 0

            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                var cx = width / 2;
                var cy = height / 2;
                var rings = [{
                    "r": width * 0.21,
                    "n": 36
                }, {
                    "r": width * 0.29,
                    "n": 44
                }, {
                    "r": width * 0.37,
                    "n": 52
                }];
                ctx.lineCap = "round";
                for (var k = 0; k < rings.length; k++) {
                    var ring = rings[k];
                    for (var i = 0; i < ring.n; i++) {
                        var a = (i / ring.n) * 360;
                        var rad = a * Math.PI / 180;
                        var x = cx + ring.r * Math.cos(rad);
                        var y = cy + ring.r * Math.sin(rad);
                        var diff = ((field.hrA - a + 540) % 360) - 180;
                        var influence = Math.max(0, Math.cos(diff * Math.PI / 180) * 0.7 + 0.3);
                        var tilt = a + 90 + diff * 0.4 * influence;
                        var len = width * (0.017 + influence * 0.022);
                        var op = displayAmbient ? (0.22 + influence * 0.55) * 0.4 : (0.22 + influence * 0.55);
                        var lw = displayAmbient ? Math.max(1.4, width * 0.008) : Math.max(2.4, width * 0.012);
                        var tr = tilt * Math.PI / 180;
                        ctx.strokeStyle = Qt.rgba(0.87, 0.89, 1, op);
                        ctx.lineWidth = lw;
                        ctx.beginPath();
                        ctx.moveTo(x - (len / 2) * Math.cos(tr), y - (len / 2) * Math.sin(tr));
                        ctx.lineTo(x + (len / 2) * Math.cos(tr), y + (len / 2) * Math.sin(tr));
                        ctx.stroke();
                    }
                }
            }
        }

        // Minute hand — zero-size pivot at centre, rotated by 16 ms timer
        Item {
            id: minuteHandPivot

            anchors.centerIn: parent
            width: 0
            height: 0
            rotation: root.minAngle

            Rectangle {
                x: watchfaceRoot.width * 0.055
                y: -watchfaceRoot.width * 0.0095
                width: watchfaceRoot.width * 0.365
                height: watchfaceRoot.width * 0.019
                radius: height / 2
                color: displayAmbient ? "#aa5060" : root.accent
            }

            Rectangle {
                x: watchfaceRoot.width * 0.42 - watchfaceRoot.width * 0.018
                y: -watchfaceRoot.width * 0.018
                width: watchfaceRoot.width * 0.036
                height: width
                radius: width / 2
                color: root.accent
                visible: !displayAmbient
            }

        }

        // Centre pin
        Rectangle {
            anchors.centerIn: parent
            width: watchfaceRoot.width * 0.026
            height: width
            radius: width / 2
            color: root.fg
        }

        // Date arc — delegates follow the minute hand angle via arcStartAngle
        Repeater {
            model: root.arcDateStr.length

            delegate: Text {
                property real charAngle: (root.arcStartAngle + index * root.arcCharStep) * Math.PI / 180

                x: watchfaceRoot.width / 2 + root.arcRadius * Math.cos(charAngle) - width / 2
                y: watchfaceRoot.height / 2 + root.arcRadius * Math.sin(charAngle) - height / 2
                rotation: root.arcStartAngle + index * root.arcCharStep + 90
                text: root.arcDateStr.charAt(index)
                color: root.fg
                opacity: displayAmbient ? 0.45 : 0.85

                font {
                    family: "Space Mono"
                    pixelSize: root.arcFontSize
                }

            }

        }

    }

    // 16ms timer — smooth minute hand sweep
    Timer {
        interval: 16
        repeat: true
        running: !displayAmbient && visible
        onTriggered: {
            var d = new Date();
            root.minAngle = ((d.getMinutes() + d.getSeconds() / 60 + d.getMilliseconds() / 60000) / 60) * 360 - 90;
        }
    }

    Connections {
        function onDisplayAmbientEntered() {
            field.requestPaint();
        }

        function onDisplayAmbientLeft() {
            field.requestPaint();
        }

        target: compositor
    }

    Connections {
        function onTimeChanged() {
            var t = wallClock.time;
            var h = t.getHours();
            var min = t.getMinutes();
            var sec = t.getSeconds();
            root.minAngle = ((min + sec / 60) / 60) * 360 - 90;
            field.hrA = (((h % 12) + min / 60) / 12) * 360 - 90;
            field.requestPaint();
            root.arcDateStr = t.toLocaleString(Qt.locale(), "ddd · dd · MMM").toUpperCase();
        }

        target: wallClock
    }

}
