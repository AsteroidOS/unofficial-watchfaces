/*
 * Copyright (C) 2021 - Ed Beroset <github.com/beroset>
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
    function getTimeDigit(t, index) {
        var timestring = t.toLocaleString(Qt.locale(), (use12H.value ? "hhmmss ap" : "HHmmss"));
        return timestring[index]
    }

    Repeater{
        id: digits
        model: 4
        Item {
            id: digitHolder
            property var sizefactor: parent.width / 2 / 289
            width: parent.width / 6
            height: parent.width / 3
            x: parent.width / 5 * index + parent.width / 8
            y: parent.height / 3

            Image {
                id: nixieBackground
                visible: !displayAmbient
                scale: sizefactor
                anchors {
                    centerIn: parent
                    verticalCenterOffset: parent.height * 0.15
                }
                opacity: displayAmbient ? 0.6 : 1.0
                source: "../watchface-img/nixie-delight-nixie.png"
            }

            Text {
                id: digit
                anchors.centerIn: parent
                font.pixelSize: nixieBackground.height*0.35 * sizefactor
                font.family: "Montserrat"
                font.weight: Font.Light
                color: "orange"
                visible: !displayAmbient
                horizontalAlignment: Text.AlignHCenter
                text: getTimeDigit(wallClock.time, index)
            }
            Glow {
                anchors.fill: digit
                radius: displayAmbient ? 10 : 20
                samples: 19
                color: "darkorange"
                source: digit
            }
        }
    }

    Text {
        visible: !displayAmbient
        font.pixelSize: parent.height*0.10
        font.family: "Feronia"
        color: "brown"
        style: Text.Outline
        styleColor: "darkorange"
        horizontalAlignment: Text.AlignHCenter
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width*0.30
        }
        text: "Asteroid OS"
    }

    Repeater{
        id: secondMarks
        model: 60
        Rectangle {
            id: second
            visible: !displayAmbient
            antialiasing : true
            color: "black"
            width: parent.width * 0.04
            height: parent.height * 0.04
            radius: parent.height * 0.02
            transform: [
                Rotation { 
                    origin.x: second.width/2
                    origin.y: second.height + parent.height*0.45
                    angle: (index)*360/secondMarks.count 
                },
                Translate { 
                    x: (parent.width - second.width)/2
                    y: parent.height/2 - (second.height + parent.height * 0.45)
                }
            ]
            Rectangle {
                anchors.centerIn: parent
                height: parent.height * 0.8 
                width: parent.width * 0.8
                radius: parent.width * 0.4
                color: "orange"
                opacity: wallClock.time.getSeconds() == index ? 1 : 0
                layer.enabled: wallClock.time.getSeconds() == index
                layer.effect: Glow {
                    radius: 7
                    samples: 15
                    color: "darkorange"
                }
            }
        }
    }

}
