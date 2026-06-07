// SPDX-FileCopyrightText: 2026 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import Qt5Compat.GraphicalEffects
import QtQuick

Item {
    id: root

    property string imgPath: "../watchfaces-img/analog-nort-"
    property real maxSize: Math.min(width, height)

    anchors.fill: parent
    Component.onCompleted: {
        var h = wallClock.time.getHours();
        var min = wallClock.time.getMinutes();
        hourRot.angle = h * 30 + min * 0.5;
        minuteRot.angle = min * 6 + (wallClock.time.getSeconds() * 6 / 60);
    }

    Item {
        id: faceBox

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        Image {
            id: hourSVG

            anchors.centerIn: parent
            source: imgPath + "hour.svg"
            width: parent.width
            height: parent.width
            layer.enabled: true

            transform: Rotation {
                id: hourRot

                origin.x: hourSVG.width / 2
                origin.y: hourSVG.height / 2
            }

            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 0
                radius: 8
                samples: 9
                color: "#66fbfb"
            }

        }

        Image {
            id: minuteSVG

            anchors.centerIn: parent
            source: imgPath + "minute.svg"
            width: parent.width
            height: parent.width
            layer.enabled: true

            transform: Rotation {
                id: minuteRot

                origin.x: minuteSVG.width / 2
                origin.y: minuteSVG.height / 2
            }

            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 0
                radius: 8
                samples: 9
                color: "#66fbfb"
            }

        }

        Image {
            id: secondSVG

            anchors.centerIn: parent
            source: imgPath + "second.svg"
            width: parent.width
            height: parent.width
            visible: !displayAmbient

            transform: Rotation {
                id: secondRot

                origin.x: secondSVG.width / 2
                origin.y: secondSVG.height / 2
            }

        }

    }

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
                return ;

            var h = wallClock.time.getHours();
            var min = wallClock.time.getMinutes();
            hourRot.angle = h * 30 + min * 0.5;
            minuteRot.angle = min * 6 + (wallClock.time.getSeconds() * 6 / 60);
        }

        target: wallClock
    }

}
