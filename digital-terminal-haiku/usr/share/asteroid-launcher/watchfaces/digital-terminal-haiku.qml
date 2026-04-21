/*
 * Terminal Haiku — AsteroidOS watchface
 *
 * Time rendered as if a terminal just printed `date +%T`.
 * Cursor blinks at 1 Hz. Ambient-aware.
 *
 * Font: VT323 (SIL OFL 1.1)
 */
// SPDX-FileCopyrightText: 2026 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: BSD-3-Clause

import QtGraphicalEffects 1.15
import QtQuick 2.15

Item {
    id: root

    property bool cursorOn: true
    property string timeStr: ""
    property string secStr: ""
    property string dateStr: ""
    readonly property color termGreen: "#8affc1"
    readonly property color termDim: "#598a74"

    function pad(n) {
        return n < 10 ? "0" + n : "" + n;
    }

    anchors.fill: parent
    Component.onCompleted: {
        var t = wallClock.time;
        var h = t.getHours();
        var min = t.getMinutes();
        var sec = t.getSeconds();
        root.timeStr = root.pad(h) + ":" + root.pad(min);
        root.secStr = ":" + root.pad(sec);
        root.dateStr = t.toLocaleString(Qt.locale(), "dddd, dd MMM").toLowerCase();
    }

    // Cursor blink — independent of wallClock, standard 1 Hz terminal rate
    Timer {
        interval: 500
        repeat: true
        running: !displayAmbient && visible
        onTriggered: root.cursorOn = !root.cursorOn
    }

    // Column auto-sizes to its widest child (the HH:MM Row).
    // anchors.centerIn then centres that width on screen so all rows
    // left-align to the HH:MM left edge rather than a fixed wide container.
    Column {
        id: stack

        anchors.centerIn: parent
        spacing: parent.height * 0.008

        layer {
            enabled: !displayAmbient

            effect: Glow {
                color: root.termGreen
                radius: 3
                samples: 7
                spread: 0
            }

        }

        // Prompt line
        Text {
            text: "$ date +%T"
            color: root.termDim
            visible: !displayAmbient

            font {
                family: "VT323"
                pixelSize: root.height * 0.085
            }

        }

        // HH:MM large + :SS dim, baseline-aligned
        Row {
            spacing: 0

            Text {
                id: bigTime

                text: root.timeStr
                color: root.termGreen

                font {
                    family: "VT323"
                    pixelSize: root.height * 0.26
                    letterSpacing: root.height * 0.006
                }

            }

            Text {
                id: secText

                text: root.secStr
                color: root.termDim
                visible: !displayAmbient
                anchors.baseline: bigTime.baseline

                font {
                    family: "VT323"
                    pixelSize: root.height * 0.17
                }

            }

        }

        // Date line
        Text {
            text: root.dateStr
            color: root.termDim

            font {
                family: "VT323"
                pixelSize: root.height * 0.085
            }

        }

        // Cursor block
        Row {
            spacing: root.width * 0.012
            visible: !displayAmbient

            Text {
                text: "$"
                color: root.termGreen

                font {
                    family: "VT323"
                    pixelSize: root.height * 0.085
                }

            }

            Rectangle {
                width: root.width * 0.045
                height: root.height * 0.08
                color: root.cursorOn ? root.termGreen : "transparent"
                anchors.verticalCenter: parent.verticalCenter
            }

        }

    }

    Connections {
        function onTimeChanged() {
            var t = wallClock.time;
            var h = t.getHours();
            var min = t.getMinutes();
            var sec = t.getSeconds();
            root.timeStr = root.pad(h) + ":" + root.pad(min);
            root.secStr = ":" + root.pad(sec);
            root.dateStr = t.toLocaleString(Qt.locale(), "dddd, dd MMM").toLowerCase();
        }

        target: wallClock
    }

}
