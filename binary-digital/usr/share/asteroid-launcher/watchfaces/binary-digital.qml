/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
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
/* Based on binary-lcd watchface but stripped off the seconds and enlarged
 * the binary hour and minute displays for cleaner design and less noise.
 */

import QtQuick 2.1

Item {
    id: root

    property int radius: Math.min(root.width / 24, root.height / 16)

    width: parent.width
    height: width

    Component {
        id: draw_led_hour

        Rectangle {
            width: root.radius * 9.7
            height: root.radius * 1.5
            color: 1 << index & modelData ? Qt.rgba(0.98, 0.651, 0.196, 0.9) : Qt.rgba(0, 0, 0, 0.25)
        }

    }

    Component {
        id: draw_led_minute

        Rectangle {
            width: root.radius * 9.7
            height: root.radius * 1.5
            color: 1 << index & modelData ? Qt.rgba(0.016, 0.667, 0.988, 0.9) : Qt.rgba(0, 0, 0, 0.25)
        }

    }

    Item {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: parent.width * 0.235

        Row {
            anchors.centerIn: parent
            spacing: root.radius

            Column {
                spacing: root.radius * 0.33

                Repeater {
                    property int led: wallClock.time.getMinutes()

                    delegate: draw_led_minute
                    model: [led, led, led, led, led, led]
                }

            }

        }

        transform: Rotation {
            angle: 90

            axis {
                x: 0
                y: 0
                z: 1
            }

        }

    }

    Item {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -parent.height * 0.235

        Row {
            anchors.centerIn: parent
            spacing: root.radius

            Column {
                spacing: root.radius * 0.33

                Repeater {
                    property int led: wallClock.time.getHours()

                    delegate: draw_led_hour
                    model: [led, led, led, led, led, led]
                }

            }

        }

        transform: Rotation {
            angle: 90

            axis {
                x: 0
                y: 0
                z: 1
            }

        }

    }

    Item {
        id: digitalDisplay

        width: parent.width
        height: width

        Text {
            id: hourDisplay

            property real hoffset: parent.width * 0.022

            font.pixelSize: parent.height / 3
            font.family: 'Simpleness-Regular'
            color: "white"
            style: Text.Outline
            styleColor: Qt.rgba(0, 0, 0, 0.4)
            text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) : wallClock.time.toLocaleString(Qt.locale(), "HH")

            anchors {
                centerIn: parent
                verticalCenterOffset: parent.height * 0.038
                horizontalCenterOffset: -parent.height * 0.235 + hoffset
            }

        }

        Text {
            id: minuteDisplay

            property real hoffset: parent.width * 0.022

            font.pixelSize: parent.height / 3
            font.family: 'Simpleness-Regular'
            color: "white"
            style: Text.Outline
            styleColor: Qt.rgba(0, 0, 0, 0.4)
            text: wallClock.time.toLocaleString(Qt.locale(), "mm")

            anchors {
                centerIn: parent
                verticalCenterOffset: parent.height * 0.038
                horizontalCenterOffset: parent.height * 0.235 + hoffset
            }

        }

    }

    Connections {
        function onTimeChanged() {
            if (!visible)
                return ;

        }

        target: wallClock
    }

}
