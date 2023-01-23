/*
 * Copyright (C) 2021 - Timo Könnecke <github.com/eLtMosen>
 *
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
import QtGraphicalEffects 1.15

Item {

    property string currentColor: ""
    property string userColor: ""
    property string imgPath: "../watchfaces-img/analog-aviator-"

    Image {
        z: 0
        id: asteroidLogo
        source: "../watchfaces-img/asteroid-logo-white.svg"
        antialiasing: true
        anchors {
            centerIn: parent
            verticalCenterOffset: -parent.height * 0.324
        }
        width: parent.width/5.5
        height: parent.height/5.5
        opacity: 1
        state: currentColor
        states: State { name: "black"
            PropertyChanges {
                target: asteroidLogo
                source: "../watchfaces-img/asteroid-logo-black.svg"
            }
        }
    }

    Text {
        z: 1
        id: asteroidSlogan
        visible: !displayAmbient
        font.pixelSize: parent.height * 0.048
        font.family: "Raleway"
        color: "#bbffffff"
        horizontalAlignment: Text.AlignHCenter
        anchors {
            centerIn: parent
            verticalCenterOffset: -parent.height * 0.146
        }
        text: "<b>AsteroidOS</b><br>Free Your Wrist"
        state: currentColor
        states: State { name: "black";
            PropertyChanges { target: asteroidSlogan; color: "black" }
        }
        transitions: Transition {
            from: ""; to: "black"; reversible: true
                ColorAnimation { duration: 300 }
        }
    }

    Text {
        z: 0
        id: dateDisplay
        visible: !displayAmbient
        font.pixelSize: parent.height * 0.052
        font.family: "Raleway"
        color: "#bbffffff"
        horizontalAlignment: Text.AlignHCenter
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: parent.height*0.14
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "<b>dd</b> MMMM<br>yyyy")
        state: currentColor
        states: State { name: "black";
            PropertyChanges { target: dateDisplay; color: "black" }
        }
        transitions: Transition {
            from: ""; to: "black"; reversible: true
                ColorAnimation { duration: 300 }
        }
    }

    Text {
        z: 0
        id: apDisplay
        property int day: wallClock.time.toLocaleString(Qt.locale(), "d")
        property int month: wallClock.time.toLocaleString(Qt.locale(), "M")
        font.pixelSize: parent.height*0.065
        font.family: "PTSans"
        font.styleName: "Regular"
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        anchors {
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: parent.height/3.8
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: parent.width/3.8
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "ap").toUpperCase()
        state: currentColor
        states: State { name: "black";
            PropertyChanges { target: apDisplay; color: "black" }
        }
        transitions: Transition {
            from: ""; to: "black"; reversible: true
                ColorAnimation { duration: 300 }
        }
    }

    Text {
        z: 0
        id: dowDisplay
        font.pixelSize: parent.height*0.065
        font.family: "PTSans"
        font.styleName: "Regular"
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        anchors {
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: parent.height/3.8
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: -parent.width/3.8
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "ddd").slice(0, 2).toUpperCase()
        state: currentColor
        states: State { name: "black";
            PropertyChanges { target: dowDisplay; color: "black" }
        }
        transitions: Transition {
            from: ""; to: "black"; reversible: true
                ColorAnimation { duration: 300 }
        }
    }

    Repeater {
        model: 60
        Rectangle {
            z: 1
            visible: index % 5
            id: minuteStrokes
            antialiasing : true
            property var rotM: ((index) - 15)/60
            property var centerX: parent.width/2-width/2
            property var centerY: parent.height/2-height/2
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.48
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.48
            color: "#bbffffff"
            width: parent.width*0.0055
            height: parent.height*0.04
            transform: Rotation { origin.x: width/2; origin.y: height/2; angle: (index)*6}
            state: currentColor
            states: State { name: "black";
                PropertyChanges { target: minuteStrokes; color: "black" }
            }
            transitions: Transition {
                from: ""; to: "black"; reversible: true
                    ColorAnimation { duration: 300 }
            }
        }
    }


    Repeater {
        model: 4
        Text {
            z: 1
            id: hourNumbers
            font.pixelSize: parent.height*0.16
            font.family: "Arkhip"
            property var rotM: ((index * 15 ) - 15)/60
            property var centerX: parent.width/2-width/2
            property var centerY: parent.height/2-height/2.6
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.35
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.35
            color: "#ccffffff"
            text: if (index === 0)
                      ""
                  else
                      index*3
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
        Rectangle {
            z: 1
            id: hourStrokes
            antialiasing : true
            property var rotM: ((index * 5 ) - 15)/60
            property var centerX: parent.width/2-width/2
            property var centerY: parent.height/2-height/2
            x: if ([0, 3, 6, 9].includes(index))
                   centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.48
               else
                   centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.44
            y: if ([0, 3, 6, 9].includes(index))
                   centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.48
               else
                   centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.44
            color: "#ccffffff"
            width: parent.width*0.020
            height: [0, 3, 6, 9].includes(index) ? parent.height*0.04 : parent.height*0.13
            transform: Rotation { origin.x: width/2; origin.y: height/2; angle: (index*5)*6}
            state: currentColor
            states: State { name: "black";
                PropertyChanges { target: hourStrokes; color: "black" }
            }
            transitions: Transition {
                from: ""; to: "black"; reversible: true
                    ColorAnimation { duration: 300 }
            }
        }
    }

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 2
        verticalOffset: 2
        radius: 12.0
        samples: 17
        color: "#bb000000"
    }

    Image {
        id: hourSVG
        z: 2
        source: !displayAmbient ? imgPath + "hour-ambient.svg" : imgPath + "hour-ambient.svg"
        anchors {
            centerIn: parent
        }
        width: parent.width
        height: parent.height
        transform: Rotation {
            origin.x: parent.width/2;
            origin.y: parent.height/2;
            angle: (wallClock.time.getHours()*30) + (wallClock.time.getMinutes()*0.5)
        }
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 4
            verticalOffset: 4
            radius: 6.0
            samples: 17
            color: "#22000000"
        }
        state: currentColor
        states: State { name: "black"
            PropertyChanges {
                target: hourSVG
                source: imgPath + "hour.svg"
            }
        }
    }

    Image {
        id: minuteSVG
        z: 3
        source: !displayAmbient ? imgPath + "minute-ambient.svg" : imgPath + "minute-ambient.svg"
        anchors {
            centerIn: parent
        }
        width: parent.width
        height: parent.height
        transform: Rotation {
            origin.x: parent.width/2;
            origin.y: parent.height/2;
            angle: (wallClock.time.getMinutes()*6)+(wallClock.time.getSeconds()*6/60)
        }
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 6
            verticalOffset: 6
            radius: 8.0
            samples: 17
            color: "#22000000"
        }
        state: currentColor
        states: State { name: "black"
            PropertyChanges {
                target: minuteSVG
                source: imgPath + "minute.svg"
            }
        }
    }

    Image {
        id: secondSVG
        z: 4
        property var toggle: 1
        visible: !displayAmbient
        source: imgPath + "second-ambient.svg"
        anchors {
            centerIn: parent
        }
        width: parent.width
        height: parent.height
        transform: Rotation {
            origin.x: parent.width/2;
            origin.y: parent.height/2;
            angle: (wallClock.time.getSeconds()*6)
        }
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 8
            verticalOffset: 8
            radius: 9.0
            samples: 12
            color: "#22000000"
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
        state: currentColor
        states: State { name: "black"
            PropertyChanges {
                target: secondSVG
                source: imgPath + "second.svg"
            }
        }

    }

    Connections {
        target: compositor
        onDisplayAmbientEntered: if (currentColor == "black") {
                                     currentColor = ""
                                     userColor = "black"
                                 }
                                 else
                                     userColor = ""

        onDisplayAmbientLeft:    if (userColor == "black") {
                                     currentColor = "black"
                                 }
    }
}
