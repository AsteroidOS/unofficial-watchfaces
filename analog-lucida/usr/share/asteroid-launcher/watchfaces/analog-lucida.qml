/*
 * Lucida — AsteroidOS watchface
 *
 * Painting on glass. 12 hairline hour indices + 60 minute dots.
 * A single italic Roman XII marks 12. Hour and minute hands are
 * hollow outlines — the wallpaper fills them; they are windows, not
 * objects. A single red hairline second hand with a small balance
 * ring is the only warm accent. No numerals, no date, no logo.
 *
 * Ambient: second hand + minute dots hidden. Just twelve indices,
 * two outlined hands, one italic XII.
 *
 * Font: EB Garamond (SIL OFL 1.1)
 */
// SPDX-FileCopyrightText: 2026 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: BSD-3-Clause

import QtQuick 2.15

Item {
    id: root

    property real hrAngle: 0
    property real minAngle: 0
    property real secAngle: 0
    // Hand geometry — tune after hardware testing
    readonly property real dialRadius: watchfaceRoot.width / 2
    readonly property real hourHandWidth: dialRadius * 0.12
    readonly property real hourHandLength: dialRadius * 0.53
    readonly property real hourHandStroke: Math.max(2.2, dialRadius * 0.018)
    readonly property real minuteHandWidth: dialRadius * 0.085
    readonly property real minuteHandLength: dialRadius * 0.78
    readonly property real minuteHandStroke: Math.max(2.2, dialRadius * 0.018)
    readonly property real secondHandStroke: Math.max(2, dialRadius * 0.018)
    readonly property real balanceRingRadius: dialRadius * 0.03
    readonly property real secondTipRadius: dialRadius * 0.017
    readonly property real ringStroke: Math.max(1.8, dialRadius * 0.018)
    readonly property real indexCardinalStroke: Math.max(2.6, dialRadius * 0.028)
    readonly property real indexMinorStroke: Math.max(1.9, dialRadius * 0.018)
    readonly property real minuteDotRadius: Math.max(1.1, dialRadius * 0.009)
    readonly property real pinRadius: dialRadius * 0.018
    readonly property real pinDotRadius: dialRadius * 0.008
    readonly property real pinStroke: Math.max(1.6, dialRadius * 0.012)
    readonly property color fg: Qt.rgba(0.98, 0.98, 0.98, displayAmbient ? 0.55 : 0.92)
    readonly property color fgDim: Qt.rgba(0.98, 0.98, 0.98, displayAmbient ? 0.3 : 0.55)
    readonly property color accent: "#d94a3a"

    anchors.fill: parent
    Component.onCompleted: {
        var d = new Date();
        var sec = d.getSeconds() + d.getMilliseconds() / 1000;
        var min = d.getMinutes() + sec / 60;
        var hr = (d.getHours() % 12) + min / 60;
        root.secAngle = (sec / 60) * 360 - 90;
        root.minAngle = (min / 60) * 360 - 90;
        root.hrAngle = (hr / 12) * 360 - 90;
    }

    Item {
        id: watchfaceRoot

        anchors.centerIn: parent
        height: Math.min(parent.width, parent.height)
        width: height

        // Outer hairline ring
        Rectangle {
            anchors.centerIn: parent
            width: root.dialRadius * 1.81
            height: width
            radius: width / 2
            color: "transparent"
            border.color: root.fg
            border.width: root.ringStroke
        }

        // 12 hour indices
        Repeater {
            model: 12

            delegate: Item {
                anchors.centerIn: parent
                width: 0
                height: 0
                rotation: (index / 12) * 360 - 90

                Rectangle {
                    property bool cardinal: index % 3 === 0
                    property real indexInner: cardinal ? root.dialRadius * 0.82 : root.dialRadius * 0.845
                    property real indexStroke: cardinal ? root.indexCardinalStroke : root.indexMinorStroke

                    x: indexInner
                    y: -indexStroke / 2
                    width: root.dialRadius * 0.9 - indexInner
                    height: indexStroke
                    radius: indexStroke / 2
                    color: root.fg
                }

            }

        }

        // 60 minute dots — skip 5-minute positions covered by hour indices
        Repeater {
            model: 60

            delegate: Item {
                anchors.centerIn: parent
                width: 0
                height: 0
                rotation: (index / 60) * 360 - 90
                visible: !displayAmbient && index % 5 !== 0

                Rectangle {
                    x: root.dialRadius * 0.88 - root.minuteDotRadius
                    y: -root.minuteDotRadius
                    width: root.minuteDotRadius * 2
                    height: root.minuteDotRadius * 2
                    radius: root.minuteDotRadius
                    color: root.fgDim
                }

            }

        }

        // Hollow hour hand — tail capped to minute hand tail so both extend equally behind centre
        Item {
            anchors.centerIn: parent
            width: 0
            height: 0
            rotation: root.hrAngle

            Rectangle {
                property real handTail: root.minuteHandWidth * 1.2

                x: -handTail
                y: -root.hourHandWidth / 2
                width: root.hourHandLength + handTail
                height: root.hourHandWidth
                radius: root.hourHandWidth / 2
                color: "transparent"
                border.color: root.fg
                border.width: root.hourHandStroke
            }

        }

        // Hollow minute hand
        Item {
            anchors.centerIn: parent
            width: 0
            height: 0
            rotation: root.minAngle

            Rectangle {
                property real handTail: root.minuteHandWidth * 1.2 + root.minuteHandStroke

                x: -handTail
                y: -root.minuteHandWidth / 2
                width: root.minuteHandLength + handTail
                height: root.minuteHandWidth
                radius: root.minuteHandWidth / 2
                color: "transparent"
                border.color: root.fg
                border.width: root.minuteHandStroke
            }

        }

        // Second hand — line, balance ring, tip dot
        Item {
            anchors.centerIn: parent
            width: 0
            height: 0
            rotation: root.secAngle
            visible: !displayAmbient

            Rectangle {
                x: -root.dialRadius * 0.18
                y: -root.secondHandStroke / 2
                width: root.dialRadius * 1
                height: root.secondHandStroke
                radius: root.secondHandStroke / 2
                color: root.accent
            }

            Rectangle {
                x: -root.dialRadius * 0.18 - root.balanceRingRadius
                y: -root.balanceRingRadius
                width: root.balanceRingRadius * 2
                height: root.balanceRingRadius * 2
                radius: root.balanceRingRadius
                color: "transparent"
                border.color: root.accent
                border.width: root.secondHandStroke
            }

            Rectangle {
                x: root.dialRadius * 0.82 - root.secondTipRadius
                y: -root.secondTipRadius
                width: root.secondTipRadius * 2
                height: root.secondTipRadius * 2
                radius: root.secondTipRadius
                color: root.accent
            }

        }

        // Centre pin — hollow ring + accent fill dot
        Rectangle {
            anchors.centerIn: parent
            width: root.pinRadius * 2
            height: root.pinRadius * 2
            radius: root.pinRadius
            color: "transparent"
            border.color: root.fg
            border.width: root.pinStroke
        }

        Rectangle {
            anchors.centerIn: parent
            width: root.pinDotRadius * 2
            height: root.pinDotRadius * 2
            radius: root.pinDotRadius
            color: root.accent
            visible: !displayAmbient
        }

        // Italic Roman XII — the one piece of type on the whole dial
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height * 0.09
            text: "XII"
            color: root.fg

            font {
                family: "EB Garamond"
                italic: true
                weight: Font.Medium
                pixelSize: parent.height * 0.075
                letterSpacing: parent.width * 0.005
            }

        }

    }

    // Smooth hand rotation — wallClock base + ms fraction keeps qmlscene in sync
    Timer {
        interval: 16
        repeat: true
        running: !displayAmbient && visible
        onTriggered: {
            var d = new Date();
            var sec = d.getSeconds() + d.getMilliseconds() / 1000;
            var min = d.getMinutes() + sec / 60;
            var hr = (d.getHours() % 12) + min / 60;
            root.secAngle = (sec / 60) * 360 - 90;
            root.minAngle = (min / 60) * 360 - 90;
            root.hrAngle = (hr / 12) * 360 - 90;
        }
    }

    Connections {
        function onTimeChanged() {
            var t = wallClock.time;
            var sec = t.getSeconds();
            var min = t.getMinutes() + sec / 60;
            var hr = (t.getHours() % 12) + min / 60;
            root.minAngle = (min / 60) * 360 - 90;
            root.hrAngle = (hr / 12) * 360 - 90;
        }

        target: wallClock
    }

}
