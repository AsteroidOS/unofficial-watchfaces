// Font: Inter Tight (SIL OFL 1.1)
// SPDX-FileCopyrightText: 2026 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: BSD-3-Clause
// Nutty Null — AsteroidOS watchface
// The minute is dead-centre and huge. The hour is a single small
// numeral placed at its own clock position on the inner rim —
// 3 at the 3 o'clock mark, 9 at the 9 o'clock mark. You read the
// hour as position, the minute as number.
// Native QML only — no Canvas.

import QtGraphicalEffects
import QtQuick

Item {
    id: root

    property string mmStr: ""
    property string dateStr: ""
    property int h12: 12
    property real angleRad: 0
    readonly property real rootRadius: Math.min(width, height) * 0.41
    readonly property color fg: Qt.rgba(1, 1, 1, displayAmbient ? 0.75 : 1)
    readonly property color dim: Qt.rgba(1, 1, 1, displayAmbient ? 0.45 : 0.7)

    function updateTime() {
        var t = wallClock.time;
        var h = t.getHours() % 12;
        h12 = h === 0 ? 12 : h;
        angleRad = (h12 / 12 * 360 - 90) * Math.PI / 180;
        mmStr = (t.getMinutes() < 10 ? "0" : "") + t.getMinutes();
        dateStr = t.toLocaleString(Qt.locale("en_US"), "dd MMM").toUpperCase();
    }

    anchors.fill: parent
    Component.onCompleted: root.updateTime()
    layer.enabled: true

    // Giant centred minute — NativeRendering critical for thin strokes at large size
    Text {
        id: minText

        text: root.mmStr
        color: root.fg
        renderType: Text.NativeRendering
        anchors.centerIn: parent

        font {
            family: "Inter Tight"
            weight: Font.Thin
            pixelSize: root.height * 0.5
            letterSpacing: -root.height * 0.03
        }

    }

    // Hour numerals on inner rim — current at full opacity, neighbours fading
    Repeater {
        model: 12

        delegate: Text {
            property int hVal: (index + 1)
            property int dist: Math.min(Math.abs(hVal - root.h12), 12 - Math.abs(hVal - root.h12))
            property real a: (hVal / 12 * 360 - 90) * Math.PI / 180

            text: hVal
            color: root.fg
            opacity: dist === 0 ? 1 : dist === 1 ? 0.4 : dist === 2 ? 0.2 : 0
            visible: dist <= 2
            x: root.width / 2 + root.rootRadius * Math.cos(a) - width / 2
            y: root.height / 2 + root.rootRadius * Math.sin(a) - height / 2

            font {
                family: "Inter Tight"
                weight: dist === 0 ? Font.Medium : Font.Light
                pixelSize: root.height * 0.1
            }

        }

    }

    // Date — whisper below the minute
    Text {
        id: dateText

        text: root.dateStr
        color: root.dim

        anchors {
            bottom: parent.bottom
            bottomMargin: parent.height * 0.18
            horizontalCenter: parent.horizontalCenter
        }

        font {
            family: "Inter Tight"
            weight: Font.Light
            pixelSize: root.height * 0.054
            letterSpacing: root.height * 0.012
        }

    }

    Connections {
        function onTimeChanged() {
            root.updateTime();
        }

        target: wallClock
    }

    layer.effect: DropShadow {
        horizontalOffset: 0
        verticalOffset: 0
        radius: 4
        samples: 9
        color: "#80000000"
    }

}
