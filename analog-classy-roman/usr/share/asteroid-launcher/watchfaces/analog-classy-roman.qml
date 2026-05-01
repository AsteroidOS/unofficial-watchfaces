// SPDX-FileCopyrightText: 2021 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick 2.15

Item {
    id: root

    property string currentColor: "black"
    property string userColor: ""
    property string imgPath: "../watchfaces-img/analog-classy-roman-"
    property var numeral: ["\u216B", "\u2160", "\u2161", "\u2162", "\u2163", "\u2164", "\u2165", "\u2166", "\u2167", "\u2168", "\u2169", "\u216A"]
    property real maxSize: Math.min(width, height)

    anchors.fill: parent

    Image {
        id: background

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent
        source: !displayAmbient ? imgPath + "background-white.svg" : imgPath + "background.svg"
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

        width: root.maxSize / 4.4
        height: root.maxSize / 4.4
        source: !displayAmbient ? imgPath + "asteroid_logo_bw.png" : imgPath + "asteroid_logo_wb.png"
        state: currentColor

        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -root.maxSize * 0.37
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

        color: "black"
        opacity: 0.8
        horizontalAlignment: Text.AlignHCenter
        text: "<b>AsteroidOS</b><br>Free Your Wrist"
        state: currentColor

        anchors {
            top: parent.top
            topMargin: root.maxSize * 0.24
            horizontalCenter: parent.horizontalCenter
        }

        font {
            pixelSize: root.maxSize * 0.042
            family: "Raleway"
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

        color: "black"
        opacity: 0.8
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "d").toUpperCase()
        state: currentColor

        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: root.maxSize * 0.215
        }

        font {
            pixelSize: root.maxSize * 0.08
            family: "Roboto"
            styleName: "Bold"
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

        color: "black"
        opacity: 0.8
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "ddd").toUpperCase().slice(0, 2)
        state: currentColor

        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: -root.maxSize * 0.215
        }

        font {
            pixelSize: root.maxSize * 0.08
            family: "Roboto"
            styleName: "Bold"
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

        color: "black"
        opacity: 0.8
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "<b>MMMM</b><br>yyyy")
        state: currentColor

        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: root.maxSize * 0.22
        }

        font {
            pixelSize: root.maxSize * 0.042
            family: "Raleway"
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

            x: root.width / 2 - width / 2 + Math.cos(rotM * 2 * Math.PI) * root.maxSize * 0.47
            y: root.height / 2 - height / 2 + Math.sin(rotM * 2 * Math.PI) * root.maxSize * 0.47
            antialiasing: true
            color: currentColor === "black" ? "white" : "black"
            width: index % 5 === 0 ? root.maxSize * 0.02 : root.maxSize * 0.003
            height: root.maxSize * 0.02
            opacity: 0.6

            transform: Rotation {
                origin.x: width / 2
                origin.y: height / 2
                angle: index % 5 === 0 ? (index * 6) + 45 : index * 6
            }

        }

    }

    Repeater {
        id: hourRepeater

        model: 12

        Text {
            property real heightFontOffest: -root.maxSize * 0.002
            property real rotM: ((index * 5) - 15) / 60

            x: index === 0 ? root.width / 2 - width / 2 + Math.cos(rotM * 2 * Math.PI) * root.maxSize * 0.356 : root.width / 2 - width / 2 + Math.cos(rotM * 2 * Math.PI) * root.maxSize * 0.41
            y: index === 0 ? root.height / 2 - height / 2 + Math.sin(rotM * 2 * Math.PI) * root.maxSize * 0.356 + heightFontOffest : root.height / 2 - height / 2 + Math.sin(rotM * 2 * Math.PI) * root.maxSize * 0.41 + heightFontOffest
            antialiasing: true
            color: currentColor === "black" ? "white" : "black"
            text: numeral[index]

            font {
                pixelSize: index === 0 ? root.maxSize * 0.113 : root.maxSize * 0.1
                family: "Roboto Condensed"
                styleName: "Bold"
            }

            transform: Rotation {
                origin.x: width / 2
                origin.y: height / 2 - heightFontOffest
                angle: index * 30
            }

        }

    }

    Image {
        id: hourSVG

        anchors.centerIn: parent
        width: root.maxSize
        height: root.maxSize
        source: imgPath + "hour.svg"

        transform: Rotation {
            origin.x: hourSVG.width / 2
            origin.y: hourSVG.height / 2
            angle: (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * 0.5)
        }

    }

    Image {
        id: minuteSVG

        anchors.centerIn: parent
        width: root.maxSize
        height: root.maxSize
        source: imgPath + "minute.svg"

        transform: Rotation {
            origin.x: minuteSVG.width / 2
            origin.y: minuteSVG.height / 2
            angle: (wallClock.time.getMinutes() * 6) + (wallClock.time.getSeconds() * 6 / 60)
        }

    }

    Image {
        id: secondSVG

        anchors.centerIn: parent
        visible: !displayAmbient
        width: root.maxSize
        height: root.maxSize
        source: imgPath + "second.svg"

        transform: Rotation {
            origin.x: secondSVG.width / 2
            origin.y: secondSVG.height / 2
            angle: wallClock.time.getSeconds() * 6
        }

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
