// SPDX-FileCopyrightText: 2024 github.com/turretkeeper
// SPDX-FileCopyrightText: 2022 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick

Item {
    id: root

    property string imgPath: "../watchfaces-img/analog-nihil-dark-"
    property real maxSize: Math.min(width, height)

    anchors.fill: parent

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

            transform: Rotation {
                origin.x: hourSVG.width / 2
                origin.y: hourSVG.height / 2
                angle: (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * 0.5)
            }

        }

        Image {
            id: minuteSVG

            anchors.centerIn: parent
            source: imgPath + "minute.svg"
            width: parent.width
            height: parent.width

            transform: Rotation {
                origin.x: minuteSVG.width / 2
                origin.y: minuteSVG.height / 2
                angle: (wallClock.time.getMinutes() * 6) + (wallClock.time.getSeconds() * 6 / 60)
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
                origin.x: secondSVG.width / 2
                origin.y: secondSVG.height / 2
                angle: (wallClock.time.getSeconds() * 6)
            }

        }

    }

}
