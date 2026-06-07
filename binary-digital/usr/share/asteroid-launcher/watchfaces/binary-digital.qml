// SPDX-FileCopyrightText: 2018 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later
// binary-digital — based on binary-lcd watchface
// Binary hour and minute bars rotated 90° with digital overlay.
// Seconds stripped and displays enlarged for cleaner design.

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
