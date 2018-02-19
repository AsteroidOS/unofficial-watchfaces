/*
 * Copyright (C) 2018 - Timo Könnecke <el-t-mo@arcor.de>
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

import QtQuick 2.2

Rectangle {
    id: root
    color:"transparent"
    width: parent.width
    height: parent.height
    property int radius: Math.min(root.width / 24, root.height / 16)

    Component {
        id: draw_led_hour
        Rectangle {
            width: root.radius * 2
            height: root.radius * 2
            radius: root.radius / 2
            color: 1 << index & modelData ? Qt.rgba(0.871, 0.165, 0.102, 1) : Qt.rgba(0.184, 0.184, 0.184, 0.5)
        }
    }

    Component {
        id: draw_led_minute
        Rectangle {
            width: root.radius * 2
            height: root.radius * 2
            radius: root.radius / 2
            color: 1 << index & modelData ? Qt.rgba(1, 0.549, 0.149, 1) : Qt.rgba(0.184, 0.184, 0.184, 0.5)
        }
    }

    Component {
        id: draw_led_second
        Rectangle {
            width: root.radius * 2
            height: root.radius * 2
            radius: root.radius / 2
            color: 1 << index & modelData ? Qt.rgba(0.945, 0.769, 0.059, 1) : Qt.rgba(0.184, 0.184, 0.184, 0.5)
        }
    }

    Item {
        width: parent.width
        height: parent.height

        Text {
            id: hourDisplay
            font.pixelSize: parent.height/3.9
            font.family: 'Digital-7 Mono'
            color: "white"
            opacity: 0.9
            style: Text.Outline; styleColor: "#80000000"
            horizontalAlignment: Text.AlignHCenter
            x: parent.width*0.148
            y: parent.height*0.63
            text: wallClock.time.toLocaleString(Qt.locale(), "HHmmss")
        }
    }

    Item {
        anchors.topMargin: parent.height/8
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height/2.62

        transform: Rotation { axis { x: 1; y: 0; z: 0 } angle: 180 } // flip layout vertically
        Row {
            anchors.centerIn: parent
            spacing: root.radius
            Column {
                spacing: root.radius
                Repeater {
                    property int led: wallClock.time.getHours() / 10
                    delegate: draw_led_hour; model: [led, led]
                }
            }
            Column {
                spacing: root.radius
                Repeater {
                    property int led: wallClock.time.getHours() % 10
                    delegate: draw_led_hour; model: [led, led, led, led]
                }
            }
            Column {
                spacing: root.radius
                Repeater {
                    property int led: wallClock.time.getMinutes() / 10
                    delegate: draw_led_minute; model: [led, led, led]
                }
            }
            Column {
                spacing: root.radius
                Repeater {
                    property int led: wallClock.time.getMinutes() % 10
                    delegate: draw_led_minute; model: [led, led, led, led]
                }
            }
            Column {
                spacing: root.radius
                Repeater {
                    property int led: wallClock.time.getSeconds() / 10
                    delegate: draw_led_second; model: [led, led, led]
                }
            }
            Column {
                spacing: root.radius
                Repeater {
                    property int led: wallClock.time.getSeconds() % 10
                    delegate: draw_led_second; model: [led, led, led, led]
                }
            }
        }
    }
}
