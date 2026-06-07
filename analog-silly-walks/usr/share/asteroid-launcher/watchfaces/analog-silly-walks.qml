// SPDX-FileCopyrightText: 2021 Timo Könnecke <github.com/moWerk>
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
    property string imgPath: "../watchfaces-img/analog-silly-walks-"

    Component.onCompleted: {
        var h = wallClock.time.getHours();
        var min = wallClock.time.getMinutes();
        var sec = wallClock.time.getSeconds();
        hourRot.angle = h * 30 + min * 0.5;
        minuteRot.angle = min * 6 + sec * 6 / 60;
    }

    Repeater {
        model: 12

        Text {
            property real rotM: (index * 5 - 15) / 60
            property real centerX: root.width / 2 - width / 2
            property real centerY: root.height / 2 - height / 2

            z: 1
            x: centerX + Math.cos(rotM * 2 * Math.PI) * root.width * 0.383
            y: centerY + Math.sin(rotM * 2 * Math.PI) * root.width * 0.383
            color: "white"
            text: index
            opacity: index === 0 ? 0 : 1
            state: currentColor

            font {
                pixelSize: root.height * 0.15
                family: "Varieté"
            }

            states: State {
                name: "black"

                PropertyChanges {
                    target: parent
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

        Text {
            property real rotM: (index * 5 - 15) / 60
            property real centerX: root.width / 2 - width / 2
            property real centerY: root.height / 2 - height / 2

            z: 0
            x: centerX + Math.cos(rotM * 2 * Math.PI) * root.width * 0.37
            y: centerY + Math.sin(rotM * 2 * Math.PI) * root.width * 0.37
            color: "black"
            text: index
            opacity: index === 0 ? 0 : 1
            state: currentColor

            font {
                pixelSize: root.height * 0.155
                family: "Varieté"
            }

            states: State {
                name: "black"

                PropertyChanges {
                    target: parent
                    color: "white"
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

        property int toggle: 1

        z: 4
        visible: !displayAmbient
        source: imgPath + "second.svg"
        anchors.centerIn: root
        width: root.width
        height: root.height

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
            id: secondRot

            origin.x: root.width / 2
            origin.y: root.height / 2
        }

    }

    // 16ms sweep gives the silly walk figure true continuous slow-motion movement
    Timer {
        interval: 16
        repeat: true
        running: !displayAmbient && visible
        onTriggered: {
            var now = new Date();
            secondRot.angle = (now.getSeconds() * 1000 + now.getMilliseconds()) * 6 / 1000;
        }
    }

    Connections {
        function onTimeChanged() {
            if (!visible)
                return;

            var h = wallClock.time.getHours();
            var min = wallClock.time.getMinutes();
            var sec = wallClock.time.getSeconds();
            hourRot.angle = h * 30 + min * 0.5;
            minuteRot.angle = min * 6 + sec * 6 / 60;
        }

        target: wallClock
    }

    Connections {
        function onDisplayAmbientEntered() {
            if (currentColor === "black") {
                currentColor = "";
                userColor = "black";
            } else {
                userColor = "";
            }
        }

        function onDisplayAmbientLeft() {
            if (userColor === "black")
                currentColor = "black";

        }

        target: compositor
    }

}
