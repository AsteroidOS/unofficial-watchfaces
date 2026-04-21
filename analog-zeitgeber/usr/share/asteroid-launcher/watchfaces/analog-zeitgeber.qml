/*
 * Zeitgeber — AsteroidOS watchface
 *
 * 60 ticks around the rim. A golden comet sweeps continuously to the current
 * fractional-minute position via a 16 ms timer. Non-glow ticks render as
 * 5-minute major / minor pairs. Seconds pulse a faint outer ring.
 * A giant hour digit in Major Mono Display sits centred behind.
 *
 * Ambient: current-minute tick + quarter marks + hour digit only.
 *
 * Fonts: Major Mono Display (OFL), Space Mono (OFL)
 */
// SPDX-FileCopyrightText: 2026 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: BSD-3-Clause

import QtQuick 2.15

Item {
    id: root

    // Tick geometry — one place to tune after hardware testing
    readonly property real tickLineWidth: 0.007
    readonly property real glowLineWidth: 0.009
    readonly property real tickDepth: 0.018
    readonly property real majorTickDepth: 0.026
    readonly property real glowDepth: 0.08
    readonly property var weekdays: ["SO", "MO", "DI", "MI", "DO", "FR", "SA"]
    property real secondsPulse: 0
    property string hourStr: ""
    property string minuteStr: ""
    property string dateStr: ""
    property string decimalStr: ""

    function pad(n) {
        return n < 10 ? "0" + n : "" + n;
    }

    anchors.fill: parent
    Component.onCompleted: {
        var t = wallClock.time;
        var h = t.getHours();
        var min = t.getMinutes();
        var sec = t.getSeconds();
        root.hourStr = root.pad(h);
        root.minuteStr = ":" + root.pad(min);
        root.dateStr = root.weekdays[t.getDay()] + " · " + root.pad(t.getDate()) + "." + root.pad(t.getMonth() + 1);
        var dayFrac = (h * 3600 + min * 60 + sec) / 86400;
        root.decimalStr = root.pad(Math.floor(dayFrac * 10)) + ":" + root.pad(Math.floor(dayFrac * 1000) % 100) + ":" + root.pad(Math.floor(dayFrac * 100000) % 100);
        ticks.requestPaint();
    }

    Item {
        id: watchfaceRoot

        anchors.centerIn: parent
        height: Math.min(parent.width, parent.height)
        width: height

        // Seconds-pulse ring
        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 0.906
            height: width
            radius: width / 2
            color: "transparent"
            border.color: "#ffd166"
            border.width: watchfaceRoot.width * root.tickLineWidth
            opacity: displayAmbient ? 0 : root.secondsPulse

            Behavior on opacity {
                NumberAnimation {
                    duration: 50
                }

            }

        }

        // Tick ring — comet sweeps via 16 ms timer
        Canvas {
            id: ticks

            anchors.fill: parent
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                var cx = width / 2;
                var cy = height / 2;
                var ringR = width * 0.445;
                var d = new Date();
                ctx.lineCap = "round";
                // Ambient: minimal draw — current-minute tick + quarter marks only
                if (displayAmbient) {
                    var curMin = d.getMinutes();
                    for (var i = 0; i < 60; i++) {
                        if (i !== curMin && i % 15 !== 0)
                            continue;

                        var aAmb = (i / 60) * 360 - 90;
                        var rAmb = aAmb * Math.PI / 180;
                        var tlenA = width * root.majorTickDepth;
                        ctx.strokeStyle = "#ffd166";
                        ctx.globalAlpha = (i === curMin) ? 1 : 0.35;
                        ctx.lineWidth = width * root.tickLineWidth;
                        ctx.beginPath();
                        ctx.moveTo(cx + (ringR - tlenA) * Math.cos(rAmb), cy + (ringR - tlenA) * Math.sin(rAmb));
                        ctx.lineTo(cx + ringR * Math.cos(rAmb), cy + ringR * Math.sin(rAmb));
                        ctx.stroke();
                    }
                    ctx.globalAlpha = 1;
                    return ;
                }
                // Active: comet centred on fractional minute position
                var fracMin = d.getMinutes() + d.getSeconds() / 60 + d.getMilliseconds() / 60000;
                var glowR = 2.5;
                var a, rad, dist, near, glow, op, tlen, col, lw;
                for (var j = 0; j < 60; j++) {
                    a = (j / 60) * 360 - 90;
                    rad = a * Math.PI / 180;
                    dist = (j - fracMin + 60) % 60;
                    near = Math.min(dist, 60 - dist);
                    glow = near < glowR ? 1 - near / glowR : 0;
                    if (glow > 0) {
                        col = "#ffd166";
                        op = 0.15 + 0.85 * glow;
                        lw = width * (root.tickLineWidth + (root.glowLineWidth - root.tickLineWidth) * glow);
                        tlen = width * (root.tickDepth + (root.glowDepth - root.tickDepth) * glow);
                    } else {
                        col = "#ffffff";
                        if (j % 5 === 0) {
                            op = 0.3;
                            tlen = width * root.majorTickDepth;
                        } else {
                            op = 0.14;
                            tlen = width * root.tickDepth;
                        }
                        lw = width * root.tickLineWidth;
                    }
                    ctx.strokeStyle = col;
                    ctx.globalAlpha = op;
                    ctx.lineWidth = lw;
                    ctx.beginPath();
                    ctx.moveTo(cx + (ringR - tlen) * Math.cos(rad), cy + (ringR - tlen) * Math.sin(rad));
                    ctx.lineTo(cx + ringR * Math.cos(rad), cy + ringR * Math.sin(rad));
                    ctx.stroke();
                }
                ctx.globalAlpha = 1;
            }
        }

        // Date — German weekday abbreviations intentional (Zeitgeber theme)
        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            y: parent.height * 0.19
            text: root.dateStr
            color: "#99ffffff"
            opacity: displayAmbient ? 0.4 : 1

            font {
                family: "Space Mono"
                pixelSize: parent.height * 0.056
                letterSpacing: 4
            }

        }

        // Giant hour digit — width + AlignHCenter avoids anchor drift from negative letterSpacing
        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            y: parent.height * 0.28
            text: root.hourStr
            color: "white"
            opacity: displayAmbient ? 0.55 : 0.92

            font {
                family: "Major Mono Display"
                pixelSize: parent.height * 0.38
                letterSpacing: -parent.width * 0.04
            }

        }

        // Minute readout
        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            y: parent.height * 0.65
            text: root.minuteStr
            color: "#ffd166"
            visible: !displayAmbient
            opacity: 0.9

            font {
                family: "Space Mono"
                pixelSize: parent.height * 0.07
                letterSpacing: 3
            }

        }

        // French Revolutionary decimal time
        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            y: parent.height * 0.76
            text: root.decimalStr
            color: "#99ffffff"
            opacity: displayAmbient ? 0.4 : 1

            font {
                family: "Space Mono"
                pixelSize: parent.height * 0.05
                letterSpacing: 4
            }

        }

    }

    // 32 ms timer — comet sweep + seconds pulse
    Timer {
        interval: 32
        repeat: true
        running: !displayAmbient && visible
        onTriggered: {
            var d = new Date();
            var sec = d.getSeconds() + d.getMilliseconds() / 1000;
            root.secondsPulse = 0.2 + 0.8 * Math.pow(Math.max(0, Math.cos(sec * Math.PI)), 2);
            ticks.requestPaint();
        }
    }

    Connections {
        function onDisplayAmbientEntered() {
            ticks.requestPaint();
        }

        function onDisplayAmbientLeft() {
            ticks.requestPaint();
        }

        target: compositor
    }

    Connections {
        function onTimeChanged() {
            var t = wallClock.time;
            var h = t.getHours();
            var min = t.getMinutes();
            var sec = t.getSeconds();
            root.hourStr = root.pad(h);
            root.minuteStr = ":" + root.pad(min);
            root.dateStr = root.weekdays[t.getDay()] + " · " + root.pad(t.getDate()) + "." + root.pad(t.getMonth() + 1);
            var dayFrac = (h * 3600 + min * 60 + sec) / 86400;
            root.decimalStr = root.pad(Math.floor(dayFrac * 10)) + ":" + root.pad(Math.floor(dayFrac * 1000) % 100) + ":" + root.pad(Math.floor(dayFrac * 100000) % 100);
            ticks.requestPaint();
        }

        target: wallClock
    }

}
