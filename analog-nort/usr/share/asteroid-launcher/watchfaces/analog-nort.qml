/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
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

import QtGraphicalEffects 1.15
import QtQuick 2.9

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
        target: wallClock
        onTimeChanged: {
            if (!visible)
                return ;

            var h = wallClock.time.getHours();
            var min = wallClock.time.getMinutes();
            hourRot.angle = h * 30 + min * 0.5;
            minuteRot.angle = min * 6 + (wallClock.time.getSeconds() * 6 / 60);
        }
    }

}
