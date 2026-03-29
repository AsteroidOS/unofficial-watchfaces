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

import QtQuick 2.1

Item {

    Rectangle {
        z: 0
        x: 0; y: 0
        color: Qt.rgba(0, 0, 0, 0.7)
        width: parent.width
        height: parent.height
    }

    Text {
        z: 1
        id: hourDisplay
        font.pixelSize: parent.height*0.33
        font.family: "Source Sans Pro"
        font.styleName:'ExtraLight'
        color: Qt.rgba(0.592, 0.937, 0.937, 1.0)
        anchors {
            topMargin: parent.height*0.11
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "HH:mm")
    }

    Text {
        id: dowDisplay
        font.pixelSize: parent.height*0.11
        font.family: "Sail Sans Pro"
        font.styleName:'ExtraLight'
        color: Qt.rgba(0.592, 0.937, 0.937, 0.9)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            topMargin: -parent.height*0.015
            top: hourDisplay.bottom
            left: hourDisplay.left
        }
        text: Qt.formatDate(wallClock.time, "dddd")
    }

    Text {
        id: dayDisplay
        font.pixelSize: parent.height*0.28
        font.family: "Source Sans Pro"
        font.styleName:'ExtraLight'
        color: Qt.rgba(1, 1, 1, 1.0)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            topMargin: -parent.height*0.075
            top: hourDisplay.bottom
            right: hourDisplay.right
        }
        text: Qt.formatDate(wallClock.time, "dd")
    }

    Text {
        id: monthDisplay
        font.pixelSize: parent.height*0.10
        font.family: "Sail Sans Pro"
        font.styleName:'ExtraLight'
        color: Qt.rgba(0.592, 0.937, 0.937, 0.6)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            topMargin: -parent.height*0.03
            top: dowDisplay.bottom
            left: dowDisplay.left
        }
        text: Qt.formatDate(wallClock.time, "MMMM")
    }
}
