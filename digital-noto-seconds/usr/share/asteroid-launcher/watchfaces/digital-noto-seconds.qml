// SPDX-FileCopyrightText: 2022 Commenter25 <github.com/Commenter25>
// SPDX-FileCopyrightText: 2021 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: LGPL-2.1-or-later
// based off digital-shifted

import Qt5Compat.GraphicalEffects
import QtQuick

Item {
    id: root

    property real maxSize: Math.min(width, height)
    property real arcEnd: wallClock.time.getSeconds() * 6

    anchors.fill: parent
    onArcEndChanged: seconds.requestPaint()
    layer.enabled: true

    Canvas {
        id: seconds

        visible: !displayAmbient
        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent
        rotation: -90
        onPaint: {
            var ctx = getContext("2d");
            var x = width / 2;
            var y = height / 2;
            var start = 0;
            var end = Math.PI * (parent.arcEnd / 180);
            ctx.reset();
            ctx.beginPath();
            ctx.lineCap = "round";
            ctx.arc(x, y, (width / 2) - height * 0.124 / 2, start, end, false);
            ctx.lineWidth = height * 0.03;
            ctx.strokeStyle = "#CCC";
            ctx.stroke();
        }
    }

    Text {
        id: colon

        renderType: Text.NativeRendering
        horizontalAlignment: Text.AlignHCenter
        color: "#ffffff"
        text: ":"

        font {
            pixelSize: root.maxSize * 0.27
            family: "Noto Sans"
        }

        anchors {
            centerIn: root
            horizontalCenterOffset: root.width * 0.01
            verticalCenterOffset: root.width * -0.03
        }

    }

    Text {
        id: hourDisplay

        renderType: Text.NativeRendering
        horizontalAlignment: Text.AlignHCenter
        color: "#ffffff"
        // TODO: allow removal of leading zero
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) : wallClock.time.toLocaleString(Qt.locale(), "HH")

        font {
            pixelSize: root.maxSize * 0.24
            letterSpacing: root.maxSize * 0.004
            family: "Noto Sans"
        }

        anchors {
            right: colon.left
            bottom: colon.bottom
        }

    }

    Text {
        id: minDisplay

        renderType: Text.NativeRendering
        horizontalAlignment: Text.AlignHCenter
        color: "#ffffff"
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")

        font {
            pixelSize: root.maxSize * 0.24
            letterSpacing: root.maxSize * 0.004
            family: "Noto Sans"
        }

        anchors {
            left: colon.right
            bottom: colon.bottom
        }

    }

    Text {
        id: dateDisplay

        renderType: Text.NativeRendering
        horizontalAlignment: Text.AlignHCenter
        color: "#ffffff"
        text: wallClock.time.toLocaleString(Qt.locale(), "ddd, MMM dd").replace(".", "")

        font {
            pixelSize: root.maxSize * 0.07
            letterSpacing: root.maxSize * 0.006
            family: "Noto Sans"
        }

        anchors {
            horizontalCenter: root.horizontalCenter
            top: colon.bottom
            topMargin: root.maxSize * -0.04
        }

    }

    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 4
        verticalOffset: 4
        radius: 7
        samples: 9
        color: "#99000000"
    }

}
