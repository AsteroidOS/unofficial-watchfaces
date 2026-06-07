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

    Component.onCompleted: {
        var h = wallClock.time.getHours();
        var min = wallClock.time.getMinutes();
        hourRot.angle = h * 30 + min * 0.5;
        minuteRot.angle = min * 6 + (wallClock.time.getSeconds() * 6 / 60);
    }

    Image {
        id: hourSVG

        anchors.centerIn: root
        source: imgPath + "hour.svg"
        width: root.width
        height: root.height
        layer.enabled: true

        transform: Rotation {
            id: hourRot

            origin.x: root.width / 2
            origin.y: root.height / 2
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

        anchors.centerIn: root
        source: imgPath + "minute.svg"
        width: root.width
        height: root.height
        layer.enabled: true

        transform: Rotation {
            id: minuteRot

            origin.x: root.width / 2
            origin.y: root.height / 2
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

        anchors.centerIn: root
        source: imgPath + "second.svg"
        width: root.width
        height: root.height
        visible: !displayAmbient

        transform: Rotation {
            id: secondRot

            origin.x: root.width / 2
            origin.y: root.height / 2
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
                return;

            var h = wallClock.time.getHours();
            var min = wallClock.time.getMinutes();
            hourRot.angle = h * 30 + min * 0.5;
            minuteRot.angle = min * 6 + (wallClock.time.getSeconds() * 6 / 60);
        }

        target: wallClock
    }

}
