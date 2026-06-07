// SPDX-FileCopyrightText: 2018 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick

Item {
    id: root

    property string currentColor: ""
    property string userColor: ""
    property string imgPath: "../watchfaces-img/analog-red-handed-"
    property real maxSize: Math.min(width, height)

    anchors.fill: parent

    Item {
        id: faceBox

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        Text {
            id: digitalDisplay

            visible: !displayAmbient
            font.pixelSize: parent.height * 0.05
            font.family: "PTSans"
            font.styleName: "Bold"
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) + wallClock.time.toLocaleString(Qt.locale(), ":mm") : wallClock.time.toLocaleString(Qt.locale(), "HH:mm")
            state: currentColor

            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
                verticalCenterOffset: -parent.width / 4.9
            }

            states: State {
                name: "black"

                PropertyChanges {
                    target: digitalDisplay
                    color: "black"
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
            id: dateDisplay

            visible: !displayAmbient
            font.pixelSize: parent.height * 0.05
            font.family: "PTSans"
            font.styleName: "Bold"
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            text: wallClock.time.toLocaleString(Qt.locale(), "dd MMM").toUpperCase()
            state: currentColor

            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
                verticalCenterOffset: -parent.width / 7
            }

            states: State {
                name: "black"

                PropertyChanges {
                    target: dateDisplay
                    color: "black"
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
            id: apDisplay

            visible: use12H.value
            font.pixelSize: parent.height * 0.07
            font.family: "PTSans"
            font.styleName: "Bold"
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            text: wallClock.time.toLocaleString(Qt.locale(), "ap").toUpperCase()
            state: currentColor

            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: parent.width / 5.5
            }

            states: State {
                name: "black"

                PropertyChanges {
                    target: apDisplay
                    color: "black"
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
            id: dowDisplay

            font.pixelSize: parent.height * 0.07
            font.family: "PTSans"
            font.styleName: "Bold"
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            text: wallClock.time.toLocaleString(Qt.locale(), "ddd").slice(0, 2).toUpperCase()
            state: currentColor

            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: -parent.width / 5.5
            }

            states: State {
                name: "black"

                PropertyChanges {
                    target: dowDisplay
                    color: "black"
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

            source: "../watchfaces-img/asteroid-logo.svg"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: parent.height * 0.18
            width: parent.width / 9
            height: parent.height / 9
        }

        Repeater {
            model: 12

            Rectangle {
                id: hourDots

                property real rotM: ((index * 5) - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                antialiasing: true
                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.29
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.29
                color: "white"
                width: parent.width * 0.032
                height: parent.height * 0.032
                radius: width * 0.5
                state: currentColor

                states: State {
                    name: "black"

                    PropertyChanges {
                        target: hourDots
                        color: "black"
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

        }

        Repeater {
            model: 60

            Rectangle {
                id: minuteStrokes

                property real rotM: ((index) - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                antialiasing: true
                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.29
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.29
                color: "white"
                width: parent.width * 0.004
                height: parent.height * 0.02
                state: currentColor

                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                    angle: (index) * 6
                }

                states: State {
                    name: "black"

                    PropertyChanges {
                        target: minuteStrokes
                        color: "black"
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

        }

        Repeater {
            model: 4

            Text {
                id: hourNumbers

                property real rotM: ((index * 15) - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                font.pixelSize: parent.height * 0.14
                font.family: "RussoOne"
                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.4
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.4
                color: "white"
                text: index === 0 ? 12 : index * 3
                state: currentColor

                states: State {
                    name: "black"

                    PropertyChanges {
                        target: hourNumbers
                        color: "black"
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

        }

        Repeater {
            model: 12

            Rectangle {
                id: hourStrokes

                property real rotM: ((index * 5) - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                antialiasing: true
                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.4
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.4
                color: "white"
                opacity: [0, 3, 6, 9].includes(index) ? 0 : 1
                width: parent.width * 0.014
                height: parent.height * 0.1
                radius: width * 0.5
                state: currentColor

                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                    angle: (index * 5) * 6
                }

                states: State {
                    name: "black"

                    PropertyChanges {
                        target: hourStrokes
                        color: "black"
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

        }

        Image {
            id: hourSVG

            source: !displayAmbient ? imgPath + "hour.svg" : imgPath + "hour-ambient.svg"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: width

            transform: Rotation {
                origin.x: hourSVG.width / 2
                origin.y: hourSVG.height / 2
                angle: (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * 0.5)
            }

        }

        Image {
            id: minuteSVG

            source: !displayAmbient ? imgPath + "minute.svg" : imgPath + "minute-ambient.svg"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: width

            transform: Rotation {
                origin.x: minuteSVG.width / 2
                origin.y: minuteSVG.height / 2
                angle: (wallClock.time.getMinutes() * 6) + (wallClock.time.getSeconds() * 6 / 60)
            }

        }

        Image {
            id: secondSVG

            property var toggle: 1

            visible: !displayAmbient
            source: imgPath + "second.svg"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: width

            MouseArea {
                anchors.fill: parent
                onDoubleClicked: {
                    if (secondSVG.toggle === 1) {
                        currentColor = "black";
                        secondSVG.toggle = 0;
                    } else {
                        currentColor = "";
                        secondSVG.toggle = 1;
                    }
                }
            }

            transform: Rotation {
                origin.x: secondSVG.width / 2
                origin.y: secondSVG.height / 2
                angle: (wallClock.time.getSeconds() * 6)
            }

        }

    }

    Connections {
        function onDisplayAmbientEntered() {
            if (currentColor == "black") {
                currentColor = "";
                userColor = "black";
            } else {
                userColor = "";
            }
        }

        function onDisplayAmbientLeft() {
            if (userColor == "black")
                currentColor = "black";

        }

        target: compositor
    }

}
