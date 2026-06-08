// SPDX-FileCopyrightText: 2018 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later
// Based on digital stock watchfaces, example of how to offset and
// rotate fonts to align them to other objects.
// v2, changed font to Sinner for more edgy look fitting the logo.

import QtQuick 2.1

Item {
    Image {
        source: "../watchfaces-img/asteroid-logo.svg"
        opacity: 0.75
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width / 1.68
        height: parent.height / 1.68
    }

    Text {
        id: hourDisplay

        property var hoffset: parent.width * 0.28
        property var voffset: -parent.height * 0.03
        property var rotH: (wallClock.time.getHours() - 3 + wallClock.time.getMinutes() / 60) / 12

        font.pixelSize: parent.height / 4
        font.family: "sinner"
        color: Qt.rgba(1, 1, 1, 0.8)
        opacity: 0.95
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.4)
        x: parent.width / 3.8 - hoffset
        y: parent.height / 3.8 - voffset
        horizontalAlignment: Text.AlignHCenter
        text: {
            if (use12H.value)
                wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2);
            else
                wallClock.time.toLocaleString(Qt.locale(), "HH");
        }

        transform: Rotation {
            angle: -45
        }

    }

    Text {
        id: minuteDisplay

        property var hoffset: parent.width * 0.035
        property var voffset: parent.height * 0.28

        font.pixelSize: parent.height / 4
        font.family: "sinner"
        color: Qt.rgba(1, 1, 1, 0.8)
        opacity: 0.95
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.4)
        x: parent.width / 1.35 - hoffset
        y: parent.height / 3.8 - voffset
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")

        transform: Rotation {
            angle: +45
        }

    }

    Text {
        id: secondDisplay

        property var hoffset: parent.width * 0.28
        property var voffset: -parent.height * 0.03

        font.pixelSize: parent.height / 4
        font.family: "sinner"
        color: Qt.rgba(1, 1, 1, 0.8)
        opacity: 0.95
        style: Text.Outline
        styleColor: Qt.rgba(0, 0, 0, 0.4)
        x: parent.width / 1.35 - hoffset
        y: parent.height / 1.35 - voffset
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "ss")

        transform: Rotation {
            angle: -45
        }

    }

}
