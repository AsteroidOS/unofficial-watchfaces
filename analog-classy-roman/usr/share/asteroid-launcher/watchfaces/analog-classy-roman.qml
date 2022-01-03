/*
 * Copyright (C) 2021 - Timo Könnecke <github.com/eLtMosen>
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
    property string currentColor: "black"
    property string userColor: ""
    property string imgPath: "../watchfaces-img/analog-classy-roman-"
    property var numeral: ["\u216B", "\u2160", "\u2161", "\u2162", "\u2163", "\u2164", "\u2165", "\u2166", "\u2167", "\u2168", "\u2169", "\u216A"]

    Image {
        z: 0
        id: background
        property var toggle: 1
        source: !displayAmbient ? imgPath + "background-white.svg" :
                                  imgPath + "background.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height
        MouseArea {
            anchors.fill: parent
            onDoubleClicked: {
               if (background.toggle === 1) {
                    currentColor = ""
                    background.toggle = 0
               } else {
                    currentColor = "black"
                    background.toggle = 1
                }
            }
        }
        state: currentColor
        states: State { name: "black"
            PropertyChanges {
                target: background
                source: imgPath + "background.svg"
            }
        }
        transitions: Transition {
            from: ""
            to: "black"
            reversible: true
            ColorAnimation { duration: 300 }
        }
    }

    Image {
        z: 1
        id: logoAsteroid
        source: !displayAmbient ? imgPath + "asteroid_logo_bw.png" :
                                  imgPath + "asteroid_logo_wb.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -parent.height * .37
        width: parent.width / 4.4
        height: parent.height / 4.4
        state: currentColor
        states: State { name: "black"
            PropertyChanges {
                target: logoAsteroid
                source: imgPath + "asteroid_logo_wb.png"
            }
        }
        transitions: Transition {
            from: ""
            to: "black"
            reversible: true
            ColorAnimation { duration: 300 }
        }
    }

    Text {
        z: 1
        id: asteroidSlogan
        font.pixelSize: parent.height * .042
        font.family: "Raleway"
        color: "black"
        opacity: .8
        horizontalAlignment: Text.AlignHCenter
        anchors {
            top: parent.top
            topMargin: parent.height * .24
            horizontalCenter: parent.horizontalCenter
        }
        text: "<b>AsteroidOS</b><br>Hack Your Wrist"
        state: currentColor
        states: State { name: "black"
            PropertyChanges {
                target: asteroidSlogan
                color: "white" }
        }
        transitions: Transition {
            from: ""
            to: "black"
            reversible: true
            ColorAnimation { duration: 500 }
        }
    }

    Text {
            z: 1
            id: dayDisplay
            font.pixelSize: parent.height * .08
            font.family: "Roboto"
            font.styleName: "Bold"
            color: "black"
            opacity: .8
            horizontalAlignment: Text.AlignHCenter
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: parent.width * .215
            }
            text: wallClock.time.toLocaleString(Qt.locale(), "d").toUpperCase()
            state: currentColor
            states: State { name: "black"
                PropertyChanges {
                    target: dayDisplay
                    color: "white"
                }
            }
            transitions: Transition {
                from: ""
                to: "black"
                reversible: true
                ColorAnimation { duration: 500 }
            }
        }

    Text {
            z: 1
            id: dowDisplay
            font.pixelSize: parent.height * .08
            font.family: "Roboto"
            font.styleName: "Bold"
            color: "black"
            opacity: .8
            horizontalAlignment: Text.AlignHCenter
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: -parent.width * .215
            }
            text: wallClock.time.toLocaleString(Qt.locale(), "ddd").toUpperCase().slice(0, 2)
            state: currentColor
            states: State { name: "black"
                PropertyChanges {
                    target: dowDisplay
                    color: "white"
                }
            }
            transitions: Transition {
                from: ""
                to: "black"
                reversible: true
                ColorAnimation { duration: 500 }
            }
        }

    Text {
        z: 1
        id: monthDisplay
        font.pixelSize: parent.height * .042
        font.family: "Raleway"
        color: "black"
        opacity: .8
        horizontalAlignment: Text.AlignHCenter
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: parent.width * .22
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "<b>MMMM</b><br>yyyy")
        state: currentColor
        states: State { name: "black"
            PropertyChanges {
                target: monthDisplay
                color: "white"
            }
        }
        transitions: Transition {
            from: ""
            to: "black"
            reversible: true
            ColorAnimation { duration: 500 }
        }
    }

    Repeater {
        model: 60
        Rectangle {
            z: 0
            id: minuteStrokes
            antialiasing : true
            property var rotM: (index - 15) / 60
            property var centerX: parent.width / 2 - width / 2
            property var centerY: parent.height / 2 - height / 2
            x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * .47
            y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * .47
            color: "black"
            width: if (index % 5 == 0)
                       parent.width * .02
                   else
                       parent.width * .003
            height: if (index % 5 == 0)
                        parent.width * .02
                    else
                        parent.width * .02
            opacity: .6
            transform: Rotation {
                origin.x: width / 2
                origin.y: height / 2
                angle: if (index % 5 == 0)
                           (index * 6) + 45
                       else
                           index * 6
            }
            state: currentColor
            states: State { name: "black"
                PropertyChanges {
                    target: minuteStrokes
                    color: "white"
                }
            }
            transitions: Transition {
                from: ""
                to: "black"
                reversible: true
                ColorAnimation { duration: 500 }
            }
        }
    }

    Repeater {
        id: hourRepeater
        model: 12
        Text {
            id: hourText
            z: 2
            property var heightFontOffest: -parent.height * .002
            font.pixelSize: if (index == 0)
                                parent.height * .113
                            else
                                parent.height * .10
            antialiasing: true
            font.family: "Roboto Condensed"
            font.styleName: "Bold"
            property var rotM: ((index * 5 ) - 15) / 60
            property var centerX: parent.width / 2 - width / 2
            property var centerY: parent.height / 2 - height / 2
            x: if (index == 0)
                   centerX + Math.cos(rotM * 2 * Math.PI) * (parent.width * .356)
               else
                   centerX + Math.cos(rotM * 2 * Math.PI) * (parent.width * .41)
            y: if (index == 0)
                   centerY + Math.sin(rotM * 2 * Math.PI) * (parent.width * .356) + heightFontOffest
               else
                   centerY + Math.sin(rotM * 2 * Math.PI) * (parent.width * .41) + heightFontOffest
            color: "black"
            text: numeral[index]
            transform: Rotation {
                origin.x: width / 2
                origin.y: (height / 2) - heightFontOffest
                angle: index * 30
            }
            state: currentColor
            states: State { name: "black"
                PropertyChanges {
                    target: hourText
                    color: "white"
                }
            }
            transitions: Transition {
                from: ""
                to: "black"
                reversible: true
                ColorAnimation { duration: 500 }
            }
        }
    }

    Image {
        id: hourSVG
        z: 3
        source: imgPath + "hour.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height
        transform: Rotation {
            origin.x: parent.width / 2
            origin.y: parent.height / 2
            angle: (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * .5)
        }
    }

    Image {
        id: minuteSVG
        z: 4
        source: imgPath + "minute.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height
        transform: Rotation {
            origin.x: parent.width / 2
            origin.y: parent.height / 2
            angle: (wallClock.time.getMinutes() * 6) + (wallClock.time.getSeconds() * 6 / 60)
        }
    }

    Image {
        id: secondSVG
        z: 4
        visible: !displayAmbient
        source: imgPath + "second.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height
        transform: Rotation {
            origin.x: parent.width / 2
            origin.y: parent.height / 2
            angle: (wallClock.time.getSeconds() * 6)
        }
    }

    Connections {
        target: compositor
        function onDisplayAmbientEntered() { if (currentColor == "") {
                                     currentColor = "black"
                                     userColor = ""
                                 }
                                 else
                                     userColor = "black"
        }

        function onDisplayAmbientLeft() {    if (userColor == "") {
                                     currentColor = ""
                                 }
        }
    }
}
