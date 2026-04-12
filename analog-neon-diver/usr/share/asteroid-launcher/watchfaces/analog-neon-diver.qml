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

import QtGraphicalEffects 1.15
import QtQuick 2.9

Item {
    property string imgPath: "../watchfaces-img/analog-neon-diver-"

    Image {
        id: backplate

        z: 0
        source: imgPath + "backplate.svg"
        antialiasing: true
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        opacity: 1
        layer.enabled: true

        Image {
            id: modeDisplay

            z: 0
            source: hourSVG.toggle24h ? imgPath + "backplate-24hindicator.svg" : imgPath + "backplate-12hindicator.svg"
            antialiasing: true
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
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

            z: 1
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

            z: 1
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

        z: 0
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

            z: 1
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

        z: 1
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

        z: 2
        source: hourSVG.toggle24h ? imgPath + "hour-24h.svg" : imgPath + "hour-12h.svg"
        antialiasing: true
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        layer.enabled: true

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: hourSVG.toggle24h ? hourSVG.toggle24h = false : hourSVG.toggle24h = true
        }

        transform: Rotation {
            origin.x: parent.width / 2
            origin.y: parent.height / 2
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

        z: 3
        source: imgPath + "minute.svg"
        antialiasing: true
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        layer.enabled: true

        transform: Rotation {
            origin.x: parent.width / 2
            origin.y: parent.height / 2
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

        z: 4
        antialiasing: true
        visible: !displayAmbient
        source: imgPath + "second.svg"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        layer.enabled: true

        transform: Rotation {
            origin.x: parent.width / 2
            origin.y: parent.height / 2
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

    Connections {
        function onTimeChanged() {
            if (!visible)
                return ;

        }

        target: wallClock
    }

}
