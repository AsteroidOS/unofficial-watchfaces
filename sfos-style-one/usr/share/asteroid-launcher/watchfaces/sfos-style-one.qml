// SPDX-FileCopyrightText: 2026 Timo Könnecke <mo@mowerk.net>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later
// This watchface is a fan recreation of Jolla Oy's Sailfish Watch concept designs from 2016.
// Visual design elements (e.g., hand styles, strokes, shadows, and layout) are derived from
// Jolla's intellectual property as shown at https://blog.jolla.com/watch/.
// Used and distributed with explicit permission from Jolla Oy (granted by CEO Sami Pienimäki
// in 2026, with witnesses at FOSDEM).
// Permission is for non-commercial, community-driven distribution within the AsteroidOS
// unofficial-watchfaces repository.

import QtQuick

Item {
    id: root

    property real maxSize: Math.min(width, height)

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.7)
    }

    Item {
        id: faceBox

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        Text {
            id: hourDisplay

            color: Qt.rgba(0.592, 0.937, 0.937, 1)
            text: wallClock.time.toLocaleString(Qt.locale(), "HH:mm")

            font {
                pixelSize: root.maxSize * 0.33
                family: "Source Sans Pro"
                styleName: "ExtraLight"
            }

            anchors {
                topMargin: root.maxSize * 0.11
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }

        }

        Text {
            id: dowDisplay

            color: Qt.rgba(0.592, 0.937, 0.937, 0.9)
            horizontalAlignment: Text.AlignHCenter
            text: Qt.formatDate(wallClock.time, "dddd")

            font {
                pixelSize: root.maxSize * 0.11
                family: "Sail Sans Pro"
                styleName: "ExtraLight"
            }

            anchors {
                topMargin: -root.maxSize * 0.015
                top: hourDisplay.bottom
                left: hourDisplay.left
            }

        }

        Text {
            id: dayDisplay

            color: Qt.rgba(1, 1, 1, 1)
            horizontalAlignment: Text.AlignHCenter
            text: Qt.formatDate(wallClock.time, "dd")

            font {
                pixelSize: root.maxSize * 0.28
                family: "Source Sans Pro"
                styleName: "ExtraLight"
            }

            anchors {
                topMargin: -root.maxSize * 0.075
                top: hourDisplay.bottom
                right: hourDisplay.right
            }

        }

        Text {
            id: monthDisplay

            color: Qt.rgba(0.592, 0.937, 0.937, 0.6)
            horizontalAlignment: Text.AlignHCenter
            text: Qt.formatDate(wallClock.time, "MMMM")

            font {
                pixelSize: root.maxSize * 0.1
                family: "Sail Sans Pro"
                styleName: "ExtraLight"
            }

            anchors {
                topMargin: -root.maxSize * 0.03
                top: dowDisplay.bottom
                left: dowDisplay.left
            }

        }

    }

}
