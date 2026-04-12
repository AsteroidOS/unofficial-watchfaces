/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
 *               2021 - Timo Könnecke <github.com/eLtMosen>
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

    property string currentColor: "black"
    property string userColor: ""
    property string imgPath: "../watchfaces-img/analog-classy-roman-"
    property var numeral: ["\u216B", "\u2160", "\u2161", "\u2162", "\u2163", "\u2164", "\u2165", "\u2166", "\u2167", "\u2168", "\u2169", "\u216A"]

    Image {
        id: background

        z: 0
        source: !displayAmbient ? imgPath + "background-white.svg" : imgPath + "background.svg"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        state: currentColor

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: currentColor = currentColor === "black" ? "" : "black"
        }

        states: State {
            name: "black"

            PropertyChanges {
                target: background
                source: imgPath + "background.svg"
            }

        }

        transitions: Transition {
            from: ""
            to: "black"
            reversible: true

            ColorAnimation {
                duration: 300
            }

        }

    }

    Image {
        id: logoAsteroid

        z: 1
        source: !displayAmbient ? imgPath + "asteroid_logo_bw.png" : imgPath + "asteroid_logo_wb.png"
        width: parent.width / 4.4
        height: parent.height / 4.4
        state: currentColor

        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -parent.height * 0.37
        }

        states: State {
            name: "black"

            PropertyChanges {
                target: logoAsteroid
                source: imgPath + "asteroid_logo_wb.png"
            }

        }

        transitions: Transition {
            from: ""
            to: "black"
            reversible: true

            ColorAnimation {
                duration: 300
            }

        }

    }

    Text {
        id: asteroidSlogan

        z: 1
        font.pixelSize: parent.height * 0.042
        font.family: "Raleway"
        color: "black"
        opacity: 0.8
        horizontalAlignment: Text.AlignHCenter
        text: "<b>AsteroidOS</b><br>Free Your Wrist"
        state: currentColor

        anchors {
            top: parent.top
            topMargin: parent.height * 0.24
            horizontalCenter: parent.horizontalCenter
        }

        states: State {
            name: "black"

            PropertyChanges {
                target: asteroidSlogan
                color: "white"
            }

        }

        transitions: Transition {
            from: ""
            to: "black"
            reversible: true

            ColorAnimation {
                duration: 500
            }

        }

    }

    Text {
        id: dayDisplay

        z: 1
        font.pixelSize: parent.height * 0.08
        font.family: "Roboto"
        font.styleName: "Bold"
        color: "black"
        opacity: 0.8
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "d").toUpperCase()
        state: currentColor

        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: parent.width * 0.215
        }

        states: State {
            name: "black"

            PropertyChanges {
                target: dayDisplay
                color: "white"
            }

        }

        transitions: Transition {
            from: ""
            to: "black"
            reversible: true

            ColorAnimation {
                duration: 500
            }

        }

    }

    Text {
        id: dowDisplay

        z: 1
        font.pixelSize: parent.height * 0.08
        font.family: "Roboto"
        font.styleName: "Bold"
        color: "black"
        opacity: 0.8
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "ddd").toUpperCase().slice(0, 2)
        state: currentColor

        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: -parent.width * 0.215
        }

        states: State {
            name: "black"

            PropertyChanges {
                target: dowDisplay
                color: "white"
            }

        }

        transitions: Transition {
            from: ""
            to: "black"
            reversible: true

            ColorAnimation {
                duration: 500
            }

        }

    }

    Text {
        id: monthDisplay

        z: 1
        font.pixelSize: parent.height * 0.042
        font.family: "Raleway"
        color: "black"
        opacity: 0.8
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "<b>MMMM</b><br>yyyy")
        state: currentColor

        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: parent.width * 0.22
        }

        states: State {
            name: "black"

            PropertyChanges {
                target: monthDisplay
                color: "white"
            }

        }

        transitions: Transition {
            from: ""
            to: "black"
            reversible: true

            ColorAnimation {
                duration: 500
            }

        }

    }

    Repeater {
        model: 60

        Rectangle {
            property real rotM: (index - 15) / 60
            property real centerX: parent.width / 2 - width / 2
            property real centerY: parent.height / 2 - height / 2

            z: 0
            x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.47
            y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.47
            antialiasing: true
            color: "black"
            // height is identical in both cases — single value
            width: index % 5 === 0 ? parent.width * 0.02 : parent.width * 0.003
            height: parent.width * 0.02
            opacity: 0.6
            state: currentColor

            transform: Rotation {
                origin.x: width / 2
                origin.y: height / 2
                angle: index % 5 === 0 ? (index * 6) + 45 : index * 6
            }

            states: State {
                name: "black"

                PropertyChanges {
                    target: minuteStrokes
                    color: "white"
                }

            }

            transitions: Transition {
                from: ""
                to: "black"
                reversible: true

                ColorAnimation {
                    duration: 500
                }

            }

        }

    }

    Repeater {
        id: hourRepeater

        model: 12

        Text {
            property real heightFontOffest: -parent.height * 0.002
            property real rotM: ((index * 5) - 15) / 60
            property real centerX: parent.width / 2 - width / 2
            property real centerY: parent.height / 2 - height / 2

            z: 2
            font.pixelSize: index === 0 ? parent.height * 0.113 : parent.height * 0.1
            antialiasing: true
            font.family: "Roboto Condensed"
            font.styleName: "Bold"
            x: index === 0 ? centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.356 : centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.41
            y: index === 0 ? centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.356 + heightFontOffest : centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.41 + heightFontOffest
            color: "black"
            text: numeral[index]
            state: currentColor

            transform: Rotation {
                origin.x: width / 2
                origin.y: (height / 2) - heightFontOffest
                angle: index * 30
            }

            states: State {
                name: "black"

                PropertyChanges {
                    target: hourText
                    color: "white"
                }

            }

            transitions: Transition {
                from: ""
                to: "black"
                reversible: true

                ColorAnimation {
                    duration: 500
                }

            }

        }

    }

    Image {
        id: hourSVG

        z: 3
        source: imgPath + "hour.svg"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

        transform: Rotation {
            origin.x: parent.width / 2
            origin.y: parent.height / 2
            angle: (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * 0.5)
        }

    }

    Image {
        id: minuteSVG

        z: 4
        source: imgPath + "minute.svg"
        anchors.centerIn: parent
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
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

        transform: Rotation {
            origin.x: parent.width / 2
            origin.y: parent.height / 2
            angle: wallClock.time.getSeconds() * 6
        }

    }

    Connections {
        function onTimeChanged() {
            if (!visible)
                return ;

        }

        target: wallClock
    }

    Connections {
        function onDisplayAmbientEntered() {
            if (currentColor === "") {
                currentColor = "black";
                userColor = "";
            } else {
                userColor = "black";
            }
        }

        function onDisplayAmbientLeft() {
            if (userColor === "")
                currentColor = "";

        }

        target: compositor
    }

}
