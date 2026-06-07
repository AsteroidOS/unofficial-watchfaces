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

    Image {
        id: hourSVG

        anchors.centerIn: root
        source: imgPath + "hour.svg"
        width: root.width
        height: root.height

        transform: Rotation {
            origin.x: root.width / 2
            origin.y: root.height / 2
            angle: (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * 0.5)
        }

    }

    Image {
        id: minuteSVG

        anchors.centerIn: root
        source: imgPath + "minute.svg"
        width: root.width
        height: root.height

        transform: Rotation {
            origin.x: root.width / 2
            origin.y: root.height / 2
            angle: (wallClock.time.getMinutes() * 6) + (wallClock.time.getSeconds() * 6 / 60)
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
            origin.x: root.width / 2
            origin.y: root.height / 2
            angle: (wallClock.time.getSeconds() * 6)
        }

    }

}
