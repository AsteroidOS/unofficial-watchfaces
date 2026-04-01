/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
 *               2021 - Timo Könnecke <github.com/eLtMosen>
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
            font {
                pixelSize: root.height * 0.15
                family: "Varieté"
            }
            property real rotM: (index * 5 - 15) / 60
            property real centerX: root.width / 2 - width / 2
            property real centerY: root.height / 2 - height / 2
            x: centerX + Math.cos(rotM * 2 * Math.PI) * root.width * 0.383
            y: centerY + Math.sin(rotM * 2 * Math.PI) * root.width * 0.383
            color: "white"
            text: index
            opacity: index === 0 ? 0 : 1
            state: currentColor
            states: State {
                name: "black"
                PropertyChanges { target: parent; color: "black" }
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
            font {
                pixelSize: root.height * 0.155
                family: "Varieté"
            }
            property real rotM: (index * 5 - 15) / 60
            property real centerX: root.width / 2 - width / 2
            property real centerY: root.height / 2 - height / 2
            x: centerX + Math.cos(rotM * 2 * Math.PI) * root.width * 0.370
            y: centerY + Math.sin(rotM * 2 * Math.PI) * root.width * 0.370
            color: "black"
            text: index
            opacity: index === 0 ? 0 : 1
            state: currentColor
            states: State {
                name: "black"
                PropertyChanges { target: parent; color: "white" }
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
        anchors.centerIn: root
        width: root.width
        height: root.height
    }
    
    Image {
        id: hourSVG
        z: 2
        source: !displayAmbient ? imgPath + "hour.svg" : imgPath + "hour-white.svg"
        anchors.centerIn: root
        width: root.width
        height: root.height
        transform: Rotation {
            id: hourRot
            origin.x: root.width / 2
            origin.y: root.height / 2
        }
    }
    
    Image {
        id: minuteSVG
        z: 3
        source: !displayAmbient ? imgPath + "minute.svg" : imgPath + "minute-white.svg"
        anchors.centerIn: root
        width: root.width
        height: root.height
        transform: Rotation {
            id: minuteRot
            origin.x: root.width / 2
            origin.y: root.height / 2
        }
    }
    
    Image {
        id: secondSVG
        z: 4
        property int toggle: 1
        visible: !displayAmbient
        source: imgPath + "second.svg"
        anchors.centerIn: root
        width: root.width
        height: root.height
        transform: Rotation {
            id: secondRot
            origin.x: root.width / 2
            origin.y: root.height / 2
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
    
    // 16ms sweep gives the silly walk figure true continuous slow-motion movement
    Timer {
        interval: 16
        repeat: true
        running: !displayAmbient && visible
        onTriggered: {
            var now = new Date()
            secondRot.angle = (now.getSeconds() * 1000 + now.getMilliseconds()) * 6 / 1000
        }
    }
    
    Connections {
        target: wallClock
        onTimeChanged: {
            if (!visible) return
                var h = wallClock.time.getHours()
                var min = wallClock.time.getMinutes()
                var sec = wallClock.time.getSeconds()
                hourRot.angle = h * 30 + min * 0.5
                minuteRot.angle = min * 6 + sec * 6 / 60
        }
    }
    
    Connections {
        target: compositor
        function onDisplayAmbientEntered() {
            if (currentColor === "black") {
                currentColor = ""
                userColor = "black"
            } else {
                userColor = ""
            }
        }
        function onDisplayAmbientLeft() {
            if (userColor === "black") {
                currentColor = "black"
            }
        }
    }
    
    Component.onCompleted: {
        var h = wallClock.time.getHours()
        var min = wallClock.time.getMinutes()
        var sec = wallClock.time.getSeconds()
        hourRot.angle = h * 30 + min * 0.5
        minuteRot.angle = min * 6 + sec * 6 / 60
    }
}
