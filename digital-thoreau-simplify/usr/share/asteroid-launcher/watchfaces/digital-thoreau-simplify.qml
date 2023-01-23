/*
 * Copyright (C) 2022 - Ed Beroset <github.com/beroset>
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

import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {

    Rectangle {
        id: logoArea
        color: "transparent"
        anchors {
            centerIn: parent
            verticalCenterOffset: -parent.height * 0.272
        }
        width: parent.width * 0.12
        height: parent.height * 0.12


        Image {
            z: 1
            id: asteroidLogo
            visible: !displayAmbient
            source: "../watchfaces-img/asteroid-logo.svg"
            antialiasing: true
            anchors.fill: parent
            opacity: 0.7

            Text {
                z: 2
                id: asteroidSlogan
                visible: !displayAmbient
                font {
                    family: "Raleway"
                    pixelSize: parent.height * 0.31
                }
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                anchors {
                    centerIn: parent
                    verticalCenterOffset: -parent.height * 0.005
                }
                text: "<b>AsteroidOS</b><br>Free Your Wrist"
            }
        }
        MouseArea {
            anchors.fill: parent
            onPressAndHold: asteroidLogo.visible ?
                                asteroidLogo.visible = false :
                                asteroidLogo.visible = true
        }
    }

    Text {
        id: datetext
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.height * 0.25 
        }
        font {
            family: "Titillium"
            weight: Font.Thin
            pixelSize: parent.height * 0.06
        }
        color: "white"
        text: wallClock.time.toLocaleString(Qt.locale(), "ddd dd");
    }

    Text {
        id: time
        anchors.centerIn: parent
        font {
            family: "Titillium"
            weight: Font.Thin
            pixelSize: parent.height * 0.30
        }
        color: "white"
        text: wallClock.time.toLocaleString(Qt.locale(), (use12H.value ? "hhmm ap" : "HHmm")).slice(0,4);
    }

    Text {
        id: ampm
        visible: use12H.value
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.height * 0.143
        }
        font {
            family: "Titillium"
            weight: Font.Bold
            pixelSize: parent.height * 0.05
        }
        color: "white"
        text: wallClock.time.toLocaleString(Qt.locale(), "ap");
    }

    Repeater{
        id: secondMarks
        model: 60
        Rectangle {
            id: second
            visible: !displayAmbient
            antialiasing : true
            color: "transparent"
            width: parent.width * 0.01
            height: parent.height * 0.125
            transform: [
                Rotation { 
                    origin.x: second.width / 2
                    origin.y: parent.height * 0.48
                    angle: (index) * 360 / secondMarks.count 
                },
                Translate { 
                    x: (parent.width - second.width) / 2
                    y: parent.height / 2 - parent.height * 0.48
                }
            ]
            Rectangle {
                anchors.centerIn: parent
                anchors.fill: parent
                opacity: wallClock.time.getSeconds() == index ? 1 : 0
                layer.enabled: wallClock.time.getSeconds() == index
                antialiasing : true
                gradient : Gradient {
                    GradientStop { position: 0.0; color: "yellow" }
                    GradientStop { position: 1.0; color: "darkorange" }
                }
            }
        }
    }
}
