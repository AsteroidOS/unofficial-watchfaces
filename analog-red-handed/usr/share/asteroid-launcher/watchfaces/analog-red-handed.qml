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

    property string currentColor: ""
    property string userColor: ""
    property string imgPath: "../watchface-img/analog-red-handed-"

    Text {
        z: 0
        id: digitalDisplay
        visible: !displayAmbient
        font.pixelSize: parent.height*0.05
        font.family: "PTSans"
        font.styleName: "Bold"
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            verticalCenterOffset: -parent.width/4.9
        }
        text: if (use12H.value) {
                  wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) + wallClock.time.toLocaleString(Qt.locale(), ":mm") }
              else
                  wallClock.time.toLocaleString(Qt.locale(), "HH:mm")
        state: currentColor
        states: State { name: "black";
            PropertyChanges { target: digitalDisplay; color: "black" }
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
        font.pixelSize: parent.height*0.05
        font.family: "PTSans"
        font.styleName: "Bold"
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            verticalCenterOffset: -parent.width/7
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "dd MMM").toUpperCase()
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
        font.pixelSize: parent.height*0.07
        font.family: "PTSans"
        font.styleName: "Bold"
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: parent.width/5.5
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
        font.pixelSize: parent.height*0.07
        font.family: "PTSans"
        font.styleName: "Bold"
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: -parent.width/5.5
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

    Image {
        z: 0
        id: logoAsteroid
        source: "../watchface-img/asteroid-logo.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: parent.height*0.18
        width: parent.width/9
        height: parent.height/9
    }

    Repeater {
        model: 12
        Rectangle {
            z: 1
            id: hourDots
            antialiasing : true
            property var rotM: ((index * 5 ) - 15)/60
            property var centerX: parent.width/2-width/2
            property var centerY: parent.height/2-height/2
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.29
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.29
            color: "white"
            width: parent.width*0.032
            height: parent.height*0.032
            radius: width*0.5
            state: currentColor
            states: State { name: "black";
                PropertyChanges { target: hourDots; color: "black" }
            }
            transitions: Transition {
                from: ""; to: "black"; reversible: true
                    ColorAnimation { duration: 300 }
            }
        }
    }

    Repeater {
        model: 60
        Rectangle {
            z: 1
            id: minuteStrokes
            antialiasing : true
            property var rotM: ((index) - 15)/60
            property var centerX: parent.width/2-width/2
            property var centerY: parent.height/2-height/2
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.29
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.29
            color: "white"
            width: parent.width*0.004
            height: parent.height*0.02
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
            font.pixelSize: parent.height*0.14
            font.family: "RussoOne"
            property var rotM: ((index * 15 ) - 15)/60
            property var centerX: parent.width/2-width/2
            property var centerY: parent.height/2-height/2
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.4
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.4
            color: "white"
            text: if (index === 0)
                      12
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
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.4
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.4
            color: "white"
            opacity: if ([0, 3, 6, 9].includes(index))
                         0
                     else
                         1
            width: parent.width*0.014
            height: parent.height*0.1
            radius: width*0.5
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

    Image {
        id: hourSVG
        z: 2
        source: !displayAmbient ? imgPath + "hour.svg" : imgPath + "hour-ambient.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height
        transform: Rotation {
            origin.x: parent.width/2;
            origin.y: parent.height/2;
            angle: (wallClock.time.getHours()*30) + (wallClock.time.getMinutes()*0.5)
        }
    }

    Image {
        id: minuteSVG
        z: 3
        source: !displayAmbient ? imgPath + "minute.svg" : imgPath + "minute-ambient.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height
        transform: Rotation {
            origin.x: parent.width/2;
            origin.y: parent.height/2;
            angle: (wallClock.time.getMinutes()*6)+(wallClock.time.getSeconds()*6/60)
        }
    }

    Image {
        id: secondSVG
        z: 4
        property var toggle: 1
        visible: !displayAmbient
        source: imgPath + "second.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height
        transform: Rotation {
            origin.x: parent.width/2;
            origin.y: parent.height/2;
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
