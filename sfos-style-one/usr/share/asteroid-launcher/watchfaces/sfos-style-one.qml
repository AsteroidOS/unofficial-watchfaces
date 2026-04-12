/*
 * Copyright (C) 2026 - Timo Könnecke <mo@mowerk.net>
 *               2016 - Sylvia van Os <iamsylvie@openmailbox.org>
 *               2015 - Florent Revest <revestflo@gmail.com>
 *               2012 - Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
 *                      Aleksey Mikhailichenko <a.v.mich@gmail.com>
 *                      Arto Jalkanen <ajalkane@gmail.com>
 * All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
/*
 * This watchface is a fan recreation of Jolla Oy's Sailfish Watch concept designs from 2016.
 * Visual design elements (e.g., hand styles, strokes, shadows, and layout) are derived from Jolla's intellectual property as shown at https://blog.jolla.com/watch/.
 * Used and distributed with explicit permission from Jolla Oy (granted by CEO Sami Pienimäki in 2026, with witnesses at FOSDEM).
 * Permission is for non-commercial, community-driven distribution within the AsteroidOS unofficial-watchfaces repository.
 */

import QtQuick 2.9

Item {
    Rectangle {
        z: 0
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.7)
    }

    Text {
        id: hourDisplay

        z: 1
        color: Qt.rgba(0.592, 0.937, 0.937, 1)
        text: wallClock.time.toLocaleString(Qt.locale(), "HH:mm")

        font {
            pixelSize: parent.height * 0.33
            family: "Source Sans Pro"
            styleName: "ExtraLight"
        }

        anchors {
            topMargin: parent.height * 0.11
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
            pixelSize: parent.height * 0.11
            family: "Sail Sans Pro"
            styleName: "ExtraLight"
        }

        anchors {
            topMargin: -parent.height * 0.015
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
            pixelSize: parent.height * 0.28
            family: "Source Sans Pro"
            styleName: "ExtraLight"
        }

        anchors {
            topMargin: -parent.height * 0.075
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
            pixelSize: parent.height * 0.1
            family: "Sail Sans Pro"
            styleName: "ExtraLight"
        }

        anchors {
            topMargin: -parent.height * 0.03
            top: dowDisplay.bottom
            left: dowDisplay.left
        }

    }

}
