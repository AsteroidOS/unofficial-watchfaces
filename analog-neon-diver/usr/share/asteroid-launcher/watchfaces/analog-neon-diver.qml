// SPDX-FileCopyrightText: 2026 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import Qt5Compat.GraphicalEffects
import QtQuick

Item {
    id: root

    property string imgPath: "../watchfaces-img/analog-neon-diver-"
    property real maxSize: Math.min(width, height)

    anchors.fill: parent

    Item {
        id: faceBox

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        Image {
            id: backplate

            source: imgPath + "backplate.svg"
            antialiasing: true
            anchors.centerIn: parent
            width: parent.width
            height: parent.width
            opacity: 1
            layer.enabled: true

            Image {
                id: modeDisplay

                source: hourSVG.toggle24h ? imgPath + "backplate-24hindicator.svg" : imgPath + "backplate-12hindicator.svg"
                antialiasing: true
                anchors.centerIn: parent
                width: parent.width
                height: parent.width
                layer.enabled: true

                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 0
                    radius: 12
                    samples: 9
                    color: hourSVG.toggle24h ? Qt.rgba(0.01, 0.91, 0.14, 0.3) : Qt.rgba(0, 1, 1, 0.3)
                }

            }

            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 0
                radius: 12
                samples: 9
                color: Qt.rgba(0, 1, 1, 0.3)
            }

        }

        Repeater {
            model: 60

            Rectangle {
                id: minuteStrokes

                property real rotM: (index - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                visible: index % 5 != 0
                antialiasing: true
                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.465
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.465
                color: "white"
                opacity: displayAmbient ? 0.2 : 0.5
                width: parent.width * 0.006
                height: parent.height * 0.05

                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                    angle: index * 6
                }

            }

        }

        Repeater {
            model: 12

            Text {
                id: hourNumbers

                property real rotM: ((index * 5) - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                antialiasing: true
                font.pixelSize: parent.height * 0.066
                font.letterSpacing: parent.width * 0.004
                font.family: "Bebas Neue"
                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.458
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.458
                color: "white"
                opacity: displayAmbient ? 0.4 : 0.7
                text: hourSVG.toggle24h ? index === 0 ? 24 : index * 2 : index === 0 ? 12 : index

                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                    angle: index * 30
                }

            }

        }

        Image {
            id: asteroidLogo

            visible: !displayAmbient
            source: "../watchfaces-img/asteroid-logo.svg"
            antialiasing: true
            width: parent.width / 6.5
            height: parent.height / 6.5
            opacity: 0.7

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.height * 0.155
            }

            Text {
                id: asteroidSlogan

                visible: !displayAmbient
                font.pixelSize: parent.height * 0.315
                font.family: "Raleway"
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                text: "<b>AsteroidOS</b><br>Free Your Wrist"

                anchors {
                    centerIn: parent
                    verticalCenterOffset: -parent.height * 0.005
                }

            }

        }

        Text {
            id: dowDisplay

            antialiasing: true
            font.pixelSize: parent.height * 0.046
            font.family: "League Spartan"
            font.styleName: "Regular"
            font.letterSpacing: parent.width * 0.005
            color: "#444444"
            horizontalAlignment: Text.AlignHCenter
            text: wallClock.time.toLocaleString(Qt.locale(), "dd")
            layer.enabled: true

            anchors {
                centerIn: parent
                verticalCenterOffset: parent.width * 0.0075
                horizontalCenterOffset: parent.width / 2.76
            }

            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 0
                radius: 3
                samples: 6
                color: "#00ffff"
            }

        }

        Image {
            id: hourSVG

            property bool toggle24h: false

            source: hourSVG.toggle24h ? imgPath + "hour-24h.svg" : imgPath + "hour-12h.svg"
            antialiasing: true
            anchors.centerIn: parent
            width: parent.width
            height: parent.width
            layer.enabled: true

            MouseArea {
                anchors.fill: parent
                onDoubleClicked: hourSVG.toggle24h ? hourSVG.toggle24h = false : hourSVG.toggle24h = true
            }

            transform: Rotation {
                origin.x: hourSVG.width / 2
                origin.y: hourSVG.height / 2
                angle: hourSVG.toggle24h ? (wallClock.time.getHours() * 15) + (wallClock.time.getMinutes() * 0.25) : (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * 0.5)

                Behavior on angle {
                    RotationAnimation {
                        duration: 500
                        direction: RotationAnimation.Clockwise
                        easing.type: Easing.InOutQuad
                    }

                }

            }

            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 4
                verticalOffset: 4
                radius: 10
                samples: 9
                color: Qt.rgba(0, 0, 0, 0.4)
            }

        }

        Image {
            id: minuteSVG

            source: imgPath + "minute.svg"
            antialiasing: true
            anchors.centerIn: parent
            width: parent.width
            height: parent.width
            layer.enabled: true

            transform: Rotation {
                origin.x: minuteSVG.width / 2
                origin.y: minuteSVG.height / 2
                angle: (wallClock.time.getMinutes() * 6) + (wallClock.time.getSeconds() * 6 / 60)
            }

            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 5
                verticalOffset: 5
                radius: 11
                samples: 9
                color: Qt.rgba(0, 0, 0, 0.4)
            }

        }

        Image {
            id: secondSVG

            antialiasing: true
            visible: !displayAmbient
            source: imgPath + "second.svg"
            anchors.centerIn: parent
            width: parent.width
            height: parent.width
            layer.enabled: true

            transform: Rotation {
                origin.x: secondSVG.width / 2
                origin.y: secondSVG.height / 2
                angle: (wallClock.time.getSeconds() * 6)
            }

            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 8
                verticalOffset: 8
                radius: 10
                samples: 9
                color: Qt.rgba(0, 0, 0, 0.4)
            }

        }

    }

}
