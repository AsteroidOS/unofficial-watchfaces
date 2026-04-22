/*
 * Typographic joke. Big Bungee HH, smaller MM wedged against it. Every
 * second the digits visibly shove sideways (NumberAnimation easing)
 * — time as a kerning problem. Seconds progress bar runs beneath.
 * Weekday stands vertical in the left margin.
 *
 * Fonts: Bungee (OFL), Space Mono (OFL)
 */
// SPDX-FileCopyrightText: 2026 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: BSD-3-Clause

import QtQuick 2.15

Item {
    id: root

    property real secFill: 0

    function pad(n) {
        return n < 10 ? "0" + n : "" + n;
    }

    anchors.fill: parent
    Component.onCompleted: {
        var h = wallClock.time.getHours();
        var min = wallClock.time.getMinutes();
        var sec = wallClock.time.getSeconds();
        hh.text = root.pad(h);
        mm.text = root.pad(min);
        hh.wobbleOffset = Math.sin(sec * Math.PI / 30) * (root.width * 0.018);
        mm.wobbleOffset = hh.wobbleOffset;
        dowText.text = wallClock.time.toLocaleString(Qt.locale(), "dddd").toUpperCase();
        dateText.text = root.pad(wallClock.time.getDate()) + " " + wallClock.time.toLocaleString(Qt.locale(), "MMM").toUpperCase();
    }

    Item {
        id: watchfaceRoot

        anchors.centerIn: parent
        height: Math.min(parent.width, parent.height)
        width: height

        // Vertical weekday label
        Text {
            id: dowText

            color: "white"
            opacity: displayAmbient ? 0.4 : 0.8
            rotation: -90
            transformOrigin: Item.Center

            anchors {
                left: parent.left
                leftMargin: -parent.width * 0.008
                verticalCenter: parent.verticalCenter
            }

            font {
                family: "Space Mono"
                pixelSize: root.height * 0.05
                letterSpacing: root.width * 0.018
            }

        }

        // Time block — HH and MM jostle for kerning space each second
        Item {
            id: timeBlock

            width: parent.width * 0.7
            height: parent.height * 0.55

            anchors {
                centerIn: parent
                horizontalCenterOffset: -parent.width * 0.02
            }

            // HH — anchored bottom to vertical centre, wobbles left
            Text {
                id: hh

                property real wobbleOffset: 0

                color: displayAmbient ? "#cccccc" : "#ffffff"

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: parent.width * 0.02 - wobbleOffset
                    bottom: parent.verticalCenter
                    bottomMargin: -parent.height * 0.17
                }

                font {
                    family: "Bungee"
                    pixelSize: root.height * 0.32
                }

                Behavior on wobbleOffset {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.OutCubic
                    }

                }

            }

            // MM — anchored top to vertical centre, wobbles right
            Text {
                id: mm

                property real wobbleOffset: 0

                color: displayAmbient ? "#888888" : "#ffb347"

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: parent.width * 0.18 + wobbleOffset
                    top: parent.verticalCenter
                    topMargin: -parent.height * 0.12
                }

                font {
                    family: "Bungee"
                    pixelSize: root.height * 0.32
                }

                Behavior on wobbleOffset {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.OutCubic
                    }

                }

            }

        }

        // Seconds progress bar
        Rectangle {
            height: parent.height * 0.004
            color: "#26ffffff"
            visible: !displayAmbient

            anchors {
                left: parent.left
                leftMargin: parent.width * 0.2
                right: parent.right
                rightMargin: parent.width * 0.2
                bottom: parent.bottom
                bottomMargin: parent.height * 0.2
            }

            Rectangle {
                height: parent.height
                width: parent.width * root.secFill
                color: "#ffb347"
            }

        }

        // Date chip — bottom right
        Text {
            id: dateText

            color: "white"
            opacity: 0.75

            anchors {
                right: parent.right
                rightMargin: parent.width * 0.2
                bottom: parent.bottom
                bottomMargin: parent.height * 0.118
            }

            font {
                family: "Space Mono"
                pixelSize: root.height * 0.05
                letterSpacing: 2
            }

        }

    }

    // 16ms timer drives smooth seconds bar and wobble offset
    Timer {
        interval: 16
        repeat: true
        running: !displayAmbient && visible
        onTriggered: {
            var d = new Date();
            root.secFill = (d.getSeconds() + d.getMilliseconds() / 1000) / 60;
        }
    }

    Connections {
        function onTimeChanged() {
            var h = wallClock.time.getHours();
            var min = wallClock.time.getMinutes();
            var sec = wallClock.time.getSeconds();
            var wobble = displayAmbient ? 0 : Math.sin(sec * Math.PI / 30) * (root.width * 0.04);
            hh.text = root.pad(h);
            mm.text = root.pad(min);
            hh.wobbleOffset = wobble;
            mm.wobbleOffset = wobble;
            dowText.text = wallClock.time.toLocaleString(Qt.locale(), "dddd").toUpperCase();
            dateText.text = root.pad(wallClock.time.getDate()) + " " + wallClock.time.toLocaleString(Qt.locale(), "MMM").toUpperCase();
        }

        target: wallClock
    }

}
