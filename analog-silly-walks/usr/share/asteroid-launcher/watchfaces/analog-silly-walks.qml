/*
 * Copyright (C) 2021 - Timo Könnecke <github.com/eLtMosen>
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

import QtQuick 2.9

Item {
    id: root

    property string currentColor: ""
    property string userColor: ""
    property string imgPath: "../watchfaces-img/analog-silly-walks-"

    Repeater {
        model: 12
        Text {
            z: 1
            id: hourNumbers
            font.pixelSize: root.height*0.15
            font.family: "Varieté"
            property var rotM: ((index * 5 ) - 15)/60
            property var centerX: root.width/2-width/2
            property var centerY: root.height/2-height/2
            x: centerX+Math.cos(rotM * 2 * Math.PI)*root.width*0.383
            y: centerY+Math.sin(rotM * 2 * Math.PI)*root.width*0.383
            color: "white"
            text: index
            opacity: (index === 0) ? 0 : 1
            state: currentColor
            states: State { name: "black";
                PropertyChanges { target: hourNumbers; color: "black" }
            }
            transitions: Transition {
                from: ""; to: "black"; reversible: true
                    ColorAnimation { duration: 300 }
            }
        }
    }

    Repeater {
        model: 12
        Text {
            z: 0
            id: hourNumbersShadow
            font.pixelSize: root.height*0.155
            font.family: "Varieté"
            property var rotM: ((index * 5 ) - 15)/60
            property var centerX: root.width/2-width/2
            property var centerY: root.height/2-height/2
            x: centerX+Math.cos(rotM * 2 * Math.PI)*root.width*0.370
            y: centerY+Math.sin(rotM * 2 * Math.PI)*root.width*0.370
            color: "black"
            text: index
            opacity: (index === 0) ? 0 : 1
            state: currentColor
            states: State { name: "black";
                PropertyChanges { target: hourNumbersShadow; color: "white" }
            }
            transitions: Transition {
                from: ""; to: "black"; reversible: true
                    ColorAnimation { duration: 300 }
            }
        }
    }

    Image {
        id: backgound
        z: 2
        source: !displayAmbient ? imgPath + "bg.svg" : imgPath + "bg-white.svg"
        anchors.horizontalCenter: root.horizontalCenter
        anchors.verticalCenter: root.verticalCenter
        width: root.width
        height: root.height
    }

    Image {
        id: hourSVG
        z: 2
        source: !displayAmbient ? imgPath + "hour.svg" : imgPath + "hour-white.svg"
        anchors.horizontalCenter: root.horizontalCenter
        anchors.verticalCenter: root.verticalCenter
        width: root.width
        height: root.height
        transform: Rotation {
            origin.x: root.width/2;
            origin.y: root.height/2;
            angle: (wallClock.time.getHours()*30) + (wallClock.time.getMinutes()*0.5)
        }
    }

    Image {
        id: minuteSVG
        z: 3
        source: !displayAmbient ? imgPath + "minute.svg" : imgPath + "minute-white.svg"
        anchors.horizontalCenter: root.horizontalCenter
        anchors.verticalCenter: root.verticalCenter
        width: root.width
        height: root.height
        transform: Rotation {
            origin.x: root.width/2;
            origin.y: root.height/2;
            angle: (wallClock.time.getMinutes()*6)+(wallClock.time.getSeconds()*6/60)
        }
    }

    Image {
        id: secondSVG
        z: 4
        property var toggle: 1
        visible: !displayAmbient
        source: imgPath + "second.svg"
        anchors.horizontalCenter: root.horizontalCenter
        anchors.verticalCenter: root.verticalCenter
        width: root.width
        height: root.height
        transform: Rotation {
            origin.x: root.width/2;
            origin.y: root.height/2;
            angle: (wallClock.time.getSeconds()*6)
        }
        MouseArea {
            anchors.fill: parent
            onDoubleClicked: {
               if (secondSVG.toggle === 1) {
                    currentColor = "black"
                    secondSVG.toggle = 0
               } else {
                    currentColor = ""
                    secondSVG.toggle = 1
                }
            }
        }
    }

    Connections {
        target: compositor
        function onDisplayAmbientEntered() { if (currentColor == "black") {
                                     currentColor = ""
                                     userColor = "black"
                                 }
                                 else
                                     userColor = ""
        }

        function onDisplayAmbientLeft() { if (userColor == "black") {
                                     currentColor = "black"
                                 }
        }
    }
}
