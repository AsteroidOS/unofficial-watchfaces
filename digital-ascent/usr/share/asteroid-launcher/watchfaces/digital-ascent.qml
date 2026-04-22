// SPDX-FileCopyrightText: 2026 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: BSD-3-Clause
// Ascent — AsteroidOS watchface
// HH stacked over MM, both right-aligned to an invisible vertical
// baseline about 4/5 across the dial. Left four-fifths is pure
// flatmesh wallpaper. Tiny weekday + date rotated 90° hugs the same
// vertical. Native QML only — no Canvas.
// Font: Lekton (SIL OFL 1.1)

import Qt5Compat.GraphicalEffects
import QtQuick

Item {
    id: root

    property string hhStr: ""
    property string mmStr: ""
    property string dateStr: ""
    readonly property color fg: Qt.rgba(1, 1, 1, displayAmbient ? 0.75 : 1)
    readonly property color dim: Qt.rgba(1, 1, 1, displayAmbient ? 0.45 : 0.55)
    readonly property string displayFont: "Lekton"

    function updateTime() {
        var t = wallClock.time;
        var h = t.getHours();
        var min = t.getMinutes();
        hhStr = (h < 10 ? "0" : "") + h;
        mmStr = (min < 10 ? "0" : "") + min;
        dateStr = t.toLocaleString(Qt.locale("en_US"), "ddd").toUpperCase() + " " + t.toLocaleString(Qt.locale("en_US"), "dd MMM").toUpperCase();
    }

    anchors.fill: parent
    Component.onCompleted: root.updateTime()
    layer.enabled: true

    Item {
        id: watchfaceRoot

        anchors.centerIn: parent
        height: Math.min(parent.width, parent.height)
        width: height

        // HH — dominant, top-right anchored, grows toward centre
        Text {
            id: hhText

            width: parent.width * 0.54
            horizontalAlignment: Text.AlignRight
            text: root.hhStr
            color: root.fg
            renderType: Text.NativeRendering

            anchors {
                top: parent.top
                topMargin: parent.height * 0.196
                right: parent.right
                rightMargin: parent.width * 0.2
            }

            font {
                family: root.displayFont
                weight: Font.DemiBold
                pixelSize: parent.height * 0.4
            }

        }

        // MM — lighter weight, right edge locked to HH right edge
        Text {
            id: mmText

            text: root.mmStr
            color: root.fg

            anchors {
                top: hhText.bottom
                right: hhText.right
                rightMargin: parent.width * 0.0026
            }

            font {
                family: root.displayFont
                weight: Font.Light
                pixelSize: parent.height * 0.19
            }

        }

        Text {
            id: dateText

            text: root.dateStr
            color: root.dim

            anchors {
                top: hhText.bottom
                topMargin: -parent.height * 0.056
                right: hhText.right
                rightMargin: parent.width * 0.008
            }

            font {
                family: root.displayFont
                weight: Font.Bold
                pixelSize: parent.height * 0.04
                letterSpacing: parent.height * 0.0074
            }

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
