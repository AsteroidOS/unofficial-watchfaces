// SPDX-FileCopyrightText: 2018 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick 2.9

Rectangle {
    id: root

    property int ledRadius: Math.min(root.width / 24, root.height / 16)

    color: "transparent"
    anchors.fill: parent

    Component {
        id: draw_led_hour

        Rectangle {
            width: root.ledRadius * 2
            height: root.ledRadius * 2
            radius: root.ledRadius / 2
            color: 1 << index & modelData ? Qt.rgba(0.871, 0.165, 0.102, 1) : Qt.rgba(0.184, 0.184, 0.184, 0.5)
        }

    }

    Component {
        id: draw_led_minute

        Rectangle {
            width: root.ledRadius * 2
            height: root.ledRadius * 2
            radius: root.ledRadius / 2
            color: 1 << index & modelData ? Qt.rgba(1, 0.549, 0.149, 1) : Qt.rgba(0.184, 0.184, 0.184, 0.5)
        }

    }

    Component {
        id: draw_led_second

        Rectangle {
            width: root.ledRadius * 2
            height: root.ledRadius * 2
            radius: root.ledRadius / 2
            color: 1 << index & modelData ? Qt.rgba(0.945, 0.769, 0.059, 1) : Qt.rgba(0.184, 0.184, 0.184, 0.5)
        }

    }

    Item {
        anchors.fill: parent

        Text {
            id: hourDisplay

            color: "white"
            opacity: 0.9
            style: Text.Outline
            styleColor: "#80000000"
            horizontalAlignment: Text.AlignHCenter
            x: parent.width * 0.148
            y: parent.height * 0.63
            text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) + wallClock.time.toLocaleString(Qt.locale(), "mmss") : wallClock.time.toLocaleString(Qt.locale(), "HH") + wallClock.time.toLocaleString(Qt.locale(), "mmss")

            font {
                pixelSize: parent.height / 3.9
                family: "Digital-7 Mono"
            }

        }

    }

    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 2.62

        Row {
            anchors.centerIn: parent
            spacing: root.ledRadius

            Column {
                spacing: root.ledRadius

                Repeater {
                    property int led: wallClock.time.getHours() / 10

                    delegate: draw_led_hour
                    model: [led, led]
                }

            }

            Column {
                spacing: root.ledRadius

                Repeater {
                    property int led: wallClock.time.getHours() % 10

                    delegate: draw_led_hour
                    model: [led, led, led, led]
                }

            }

            Column {
                spacing: root.ledRadius

                Repeater {
                    property int led: wallClock.time.getMinutes() / 10

                    delegate: draw_led_minute
                    model: [led, led, led]
                }

            }

            Column {
                spacing: root.ledRadius

                Repeater {
                    property int led: wallClock.time.getMinutes() % 10

                    delegate: draw_led_minute
                    model: [led, led, led, led]
                }

            }

            Column {
                spacing: root.ledRadius

                Repeater {
                    property int led: wallClock.time.getSeconds() / 10

                    delegate: draw_led_second
                    model: [led, led, led]
                }

            }

            Column {
                spacing: root.ledRadius

                Repeater {
                    property int led: wallClock.time.getSeconds() % 10

                    delegate: draw_led_second
                    model: [led, led, led, led]
                }

            }

        }

        // flip layout vertically
        transform: Rotation {
            angle: 180

            axis {
                x: 1
                y: 0
                z: 0
            }

        }

    }

}
