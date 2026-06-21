// SPDX-FileCopyrightText: 2022 Ed Beroset <github.com/beroset>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick

Item {
    id: root

    function getTimeDigit(t, index) {
        var timestring = t.toLocaleString(Qt.locale(), (use12H.value ? "hhmmss ap" : "HHmmss"));
        return timestring[index];
    }

    anchors.fill: parent

    Item {
        id: faceBox

        width: Math.min(parent.width, parent.height)
        height: width
        anchors.centerIn: parent

        Rectangle {
            id: logoArea

            color: "transparent"
            width: parent.width * 0.12
            height: parent.height * 0.12

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.height * 0.272
            }

            Image {
                id: asteroidLogo

                visible: !displayAmbient
                source: "../watchfaces-img/asteroid-logo.svg"
                antialiasing: true
                anchors.fill: parent
                opacity: 0.7

                Text {
                    id: asteroidSlogan

                    visible: !displayAmbient
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    text: "<b>AsteroidOS</b><br>Free Your Wrist"

                    font {
                        family: "Raleway"
                        pixelSize: parent.height * 0.31
                    }

                    anchors {
                        centerIn: parent
                        verticalCenterOffset: -parent.height * 0.005
                    }

                }

            }

            MouseArea {
                anchors.fill: parent
                onPressAndHold: asteroidLogo.visible = !asteroidLogo.visible
            }

        }

        Text {
            id: datetext

            color: "white"
            text: wallClock.time.toLocaleString(Qt.locale(), "ddd dd")

            anchors {
                centerIn: parent
                verticalCenterOffset: parent.height * 0.25
            }

            font {
                family: "Titillium"
                weight: Font.Thin
                pixelSize: parent.height * 0.06
            }

        }

        Rectangle {
            id: time

            color: displayAmbient ? "#371102" : "#6e2304"
            anchors.centerIn: parent
            height: parent.height * 0.3
            width: parent.width

            Repeater {
                id: digits

                model: 4

                Rectangle {
                    color: ["black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "gray", "white"][getTimeDigit(wallClock.time, index)]
                    opacity: displayAmbient ? 0.7 : 1
                    height: parent.height
                    width: parent.width * 0.1
                    x: parent.width / 5 * index + parent.width / 10
                }

            }

        }

        Text {
            id: ampm

            visible: use12H.value
            color: "white"
            text: wallClock.time.toLocaleString(Qt.locale(), "ap")

            anchors {
                centerIn: parent
                horizontalCenterOffset: parent.width * 0.4
            }

            font {
                family: "Titillium"
                weight: Font.Bold
                pixelSize: parent.height * 0.05
            }

        }

        Image {
            id: resistorImage

            antialiasing: true
            opacity: displayAmbient ? 0.6 : 1
            source: "../watchfaces-img/resistor.svg"
            width: parent.width * 0.0625
            height: parent.height * 0.125
            transform: [
                Rotation {
                    origin.x: resistorImage.width / 2
                    origin.y: resistorImage.height + parent.height * 0.369
                    angle: wallClock.time.getSeconds() * 6
                },
                Translate {
                    x: (parent.width - resistorImage.width) / 2
                    y: parent.height / 2 - (resistorImage.height + parent.height * 0.369)
                }
            ]
        }

    }

}
