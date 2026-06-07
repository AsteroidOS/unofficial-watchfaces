// SPDX-FileCopyrightText: 2021 Ed Beroset <github.com/beroset>
// SPDX-FileCopyrightText: 2021 CosmosDev <github.com/CosmosDev>
// SPDX-FileCopyrightText: 2021 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick

Item {
    property string imgPath: "../watchfaces-img/analog-halloween-"

    Component.onCompleted: {
        var h = wallClock.time.getHours();
        var min = wallClock.time.getMinutes();
        hourRot.angle = h * 30 + min * 0.5;
        minuteRot.angle = min * 6;
    }

    Repeater {
        model: 12

        Rectangle {
            id: hourTicks

            property real rotM: (index - 3) / 12
            property real centerX: parent.width / 2 - width / 2
            property real centerY: parent.height / 2 - height / 2

            z: 1
            antialiasing: true
            x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.46
            y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.46
            color: "orange"
            width: parent.width * 0.02
            height: parent.height * 0.03
            opacity: 0.9

            transform: Rotation {
                origin.x: width / 2
                origin.y: height / 2
                angle: (index) * 30
            }

        }

    }

    Image {
        id: hourSVG

        z: 2
        source: imgPath + "hour.svg"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

        transform: Rotation {
            id: hourRot

            origin.x: hourSVG.width / 2
            origin.y: hourSVG.height / 2
        }

    }

    Image {
        id: minuteSVG

        z: 3
        source: imgPath + "minute.svg"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

        transform: Rotation {
            id: minuteRot

            origin.x: minuteSVG.width / 2
            origin.y: minuteSVG.height / 2
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
            id: secondRot

            origin.x: secondSVG.width / 2
            origin.y: secondSVG.height / 2
        }

    }

    // +6 offset preserved from original to align SVG artwork
    Timer {
        interval: 16
        repeat: true
        running: !displayAmbient && visible
        onTriggered: {
            var now = new Date();
            secondRot.angle = (now.getSeconds() * 1000 + now.getMilliseconds()) * 6 / 1000 + 6;
        }
    }

    Connections {
        function onTimeChanged() {
            if (!visible)
                return;

            var h = wallClock.time.getHours();
            var min = wallClock.time.getMinutes();
            hourRot.angle = h * 30 + min * 0.5;
            minuteRot.angle = min * 6;
        }

        target: wallClock
    }

}
