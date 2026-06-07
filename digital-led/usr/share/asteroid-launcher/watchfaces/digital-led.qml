// SPDX-FileCopyrightText: 2026 ncaat <github.com/ncaat>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick 2.9

Rectangle {
    id: root

    property int hours: use12H.value ? wallClock.time.getHours() % 12 : wallClock.time.getHours()
    property int mins: wallClock.time.getMinutes()
    property int secs: wallClock.time.getSeconds()
    property real dotSize: width * 0.01
    property real dotSpacing: dotSize * 0.8

    color: "transparent"
    anchors.fill: parent

    Component {
        id: dot

        Rectangle {
            width: dotSize
            height: width
            radius: width * 0.5
            color: "red"
        }

    }

    Component {
        id: dotCols

        Column {
            spacing: dotSize + dotSpacing * 2

            Repeater {
                model: nums

                Column {
                    opacity: !modelData.includes(n)
                    spacing: dotSpacing

                    Repeater {
                        model: 5
                        delegate: dot
                    }

                }

            }

        }

    }

    Component {
        id: digit

        Row {
            width: 7 * dotSize + 6 * dotSpacing
            height: 11 * dotSize + 10 * dotSpacing
            spacing: dotSpacing

            Loader {
                property var nums: [[1, 2, 3, 7], [1, 3, 4, 5, 7, 9]]
                property int n: num

                sourceComponent: dotCols
            }

            Column {
                spacing: 4 * dotSize + 5 * dotSpacing

                Repeater {
                    model: [[1, 4], [0, 1, 7], [1, 4, 7]]

                    Row {
                        opacity: !modelData.includes(num)
                        spacing: dotSpacing

                        Repeater {
                            model: 5
                            delegate: dot
                        }

                    }

                }

            }

            Loader {
                property var nums: [[5, 6], [2]]
                property int n: num

                sourceComponent: dotCols
            }

        }

    }

    Component {
        id: colon

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5 * dotSize + 6 * dotSpacing

            Repeater {
                model: 2
                delegate: dot
            }

        }

    }

    Row {
        spacing: dotSpacing * 3
        anchors.centerIn: parent

        Loader {
            property int num: hours / 10

            opacity: num > 0
            sourceComponent: digit
        }

        Loader {
            property int num: hours % 10

            sourceComponent: digit
        }

        Loader {
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: colon
        }

        Loader {
            property int num: mins / 10

            sourceComponent: digit
        }

        Loader {
            property int num: mins % 10

            sourceComponent: digit
        }

        Loader {
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: colon
        }

        Loader {
            property int num: secs / 10

            sourceComponent: digit
        }

        Loader {
            property int num: secs % 10

            sourceComponent: digit
        }

    }

}
