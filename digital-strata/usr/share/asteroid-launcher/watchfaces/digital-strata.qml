// SPDX-FileCopyrightText: 2026 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: BSD-3-Clause
// Strata — AsteroidOS watchface
// Two vertical time tapes scrolling in opposite directions: hour on the
// left moves downward, minute on the right moves upward. Both columns
// share identical visual tokens. Only the current value is white;
// neighbours dim at two independently tunable opacity levels. Item
// spacing uses separate primary (+-1) and secondary (+-2) values to
// suggest circular depth. At each minute boundary the active white
// cross-fades between outgoing and incoming items over 400 ms. The
// outgoing hour scales down smoothly over 600 ms after the hour flips.

import Qt5Compat.GraphicalEffects
import QtQuick

Item {
    id: root

    readonly property string displayFont: "Noto Sans"
    readonly property real scaleFactor: 1.2
    readonly property real tapeFontSize: height * 0.18 * scaleFactor
    readonly property real itemSpacingPrimary: height * 0.14 * scaleFactor
    readonly property real itemSpacingSecondary: height * 0.12 * scaleFactor
    readonly property real colWidth: parent.width * 0.32 * scaleFactor
    readonly property real edgeMargin: parent.width * 0.1
    readonly property real itemOpacityPrimary: 0.3
    readonly property real itemOpacitySecondary: 0.15
    property int currentMinute: 0
    property int rawHour: 0
    property real minuteTapePos: 0
    property real hourTapePos: 0
    // 1.0 at the boundary moment, animated to 0 over the transition duration.
    // Delegate opacity/scale expressions read these to drive cross-fades.
    property real minuteTransitionPhase: 0
    property real hourTransitionPhase: 0

    // Piecewise linear: primary spacing for the +-1 slot, secondary for +-2.
    function tapeYOffset(tapeOff) {
        var sign = tapeOff >= 0 ? 1 : -1;
        var abs = Math.abs(tapeOff);
        if (abs <= 1)
            return sign * abs * root.itemSpacingPrimary;

        return sign * (root.itemSpacingPrimary + (abs - 1) * root.itemSpacingSecondary);
    }

    anchors.fill: parent
    Component.onCompleted: {
        root.currentMinute = wallClock.time.getMinutes();
        root.rawHour = wallClock.time.getHours();
        var ms = new Date().getMilliseconds();
        root.minuteTapePos = (wallClock.time.getSeconds() * 1000 + ms) / 60000;
        root.hourTapePos = (wallClock.time.getMinutes() * 60000 + wallClock.time.getSeconds() * 1000 + ms) / 3.6e+06;
    }
    layer.enabled: true

    NumberAnimation {
        id: minutePhaseAnim

        target: root
        property: "minuteTransitionPhase"
        from: 1
        to: 0
        duration: 400
    }

    NumberAnimation {
        id: hourPhaseAnim

        target: root
        property: "hourTransitionPhase"
        from: 1
        to: 0
        duration: 600
    }

    Timer {
        interval: 200
        running: !displayAmbient
        repeat: true
        onTriggered: {
            var ms = new Date().getMilliseconds();
            root.minuteTapePos = (wallClock.time.getSeconds() * 1000 + ms) / 60000;
            root.hourTapePos = (wallClock.time.getMinutes() * 60000 + wallClock.time.getSeconds() * 1000 + ms) / 3.6e+06;
        }
    }

    // Hour tape: left column, scrolls downward — future hours enter from above.
    Item {
        id: hourCol

        width: root.colWidth
        height: parent.height

        anchors {
            left: parent.left
            leftMargin: root.edgeMargin
        }

        Repeater {
            model: 5

            Text {
                readonly property int itemOffset: index - 2
                readonly property real tapeOff: itemOffset - root.hourTapePos
                readonly property real absDist: Math.abs(tapeOff)
                readonly property real naturalSize: Math.max(root.tapeFontSize * 0.5, root.tapeFontSize * (1.2 - absDist * 0.55))
                readonly property int displayVal: {
                    var h = (root.rawHour + itemOffset + 24) % 24;
                    if (use12H) {
                        h = h % 12;
                        return h === 0 ? 12 : h;
                    }
                    return h;
                }

                width: parent.width
                height: root.tapeFontSize * 1.5
                y: parent.height / 2 - root.tapeYOffset(tapeOff) - height / 2
                text: (displayVal < 10 ? "0" : "") + displayVal
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                color: "white"
                opacity: itemOffset === 0 ? 1 : Math.abs(itemOffset) === 1 ? root.itemOpacityPrimary : root.itemOpacitySecondary

                font {
                    family: root.displayFont
                    pixelSize: itemOffset === 0 ? root.tapeFontSize * 1.2 : itemOffset === -1 ? root.tapeFontSize * 1.2 * root.hourTransitionPhase + naturalSize * (1 - root.hourTransitionPhase) : naturalSize
                }

            }

        }

    }

    // Minute tape: right column, scrolls upward — future minutes enter from below.
    Item {
        id: minuteCol

        width: root.colWidth
        height: parent.height

        anchors {
            right: parent.right
            rightMargin: root.edgeMargin
        }

        Repeater {
            model: 5

            Text {
                readonly property int itemOffset: index - 2
                readonly property real tapeOff: itemOffset - root.minuteTapePos
                readonly property real absDist: Math.abs(tapeOff)
                readonly property real naturalSize: Math.max(root.tapeFontSize * 0.5, root.tapeFontSize * (1.2 - absDist * 0.55))
                readonly property int displayVal: (root.currentMinute + itemOffset + 60) % 60

                width: parent.width
                height: root.tapeFontSize * 1.5
                y: parent.height / 2 + root.tapeYOffset(tapeOff) - height / 2
                text: (displayVal < 10 ? "0" : "") + displayVal
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: "white"
                opacity: {
                    if (itemOffset === -1)
                        return root.itemOpacityPrimary + (1 - root.itemOpacityPrimary) * root.minuteTransitionPhase;

                    if (itemOffset === 0)
                        return 1 - (1 - root.itemOpacityPrimary) * root.minuteTransitionPhase;

                    return Math.abs(itemOffset) === 1 ? root.itemOpacityPrimary : root.itemOpacitySecondary;
                }

                font {
                    family: root.displayFont
                    pixelSize: itemOffset === 0 ? root.tapeFontSize * 1.2 : naturalSize
                }

            }

        }

    }

    Connections {
        function onTimeChanged() {
            var newMinute = wallClock.time.getMinutes();
            var newHour = wallClock.time.getHours();
            if (newMinute !== root.currentMinute) {
                root.currentMinute = newMinute;
                root.minuteTransitionPhase = 1;
                minutePhaseAnim.restart();
            }
            if (newHour !== root.rawHour) {
                root.rawHour = newHour;
                root.hourTransitionPhase = 1;
                hourPhaseAnim.restart();
            }
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
