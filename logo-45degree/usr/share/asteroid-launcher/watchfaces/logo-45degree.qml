/*
 * Copyright (C) 2018 - Timo Könnecke <el-t-mo@arcor.de>
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

/*
 * Based on digital stock watchfaces, example of how to offset and
 * rotate fonts to align them to other objects.
 * v2, changed font to Sinner for more edgy look fitting the logo.
 */

import QtQuick 2.1

Item {

    Image {
        source: "asteroid_logo.png"
        opacity: 0.75
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width/1.68
        height: parent.height/1.68
    }

    Text {
        id: hourDisplay
        property var hoffset: parent.width*0.28
        property var voffset: -parent.height*0.03
        property var rotH: (wallClock.time.getHours()-3 + wallClock.time.getMinutes()/60) / 12
        font.pixelSize: parent.height/4
        font.family: "sinner"
        color: Qt.rgba(1, 1, 1, 0.8)
        opacity: 0.95
        style: Text.Outline; styleColor: Qt.rgba(0, 0, 0, 0.4)
        x: parent.width/3.8 - hoffset
        y: parent.height/3.8 - voffset
        horizontalAlignment: Text.AlignHCenter
        transform: Rotation {angle: -45}
        text: wallClock.time.toLocaleString(Qt.locale(), "HH")
    }

    Text {
        id: minuteDisplay
        property var hoffset: parent.width*0.035
        property var voffset: parent.height*0.28
        font.pixelSize: parent.height/4
        font.family: "sinner"
        color: Qt.rgba(1, 1, 1, 0.8)
        opacity: 0.95
        style: Text.Outline; styleColor: Qt.rgba(0, 0, 0, 0.4)
        transform: Rotation {angle: +45}
        x: parent.width/1.35 - hoffset
        y: parent.height/3.8 - voffset
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    Text {
        id: secondDisplay
        property var hoffset: parent.width*0.28
        property var voffset: -parent.height*0.03
        font.pixelSize: parent.height/4
        font.family: "sinner"
        color: Qt.rgba(1, 1, 1, 0.8)
        opacity: 0.95
        style: Text.Outline; styleColor: Qt.rgba(0, 0, 0, 0.4)
        transform: Rotation {angle: -45}
        x: parent.width/1.35 - hoffset
        y: parent.height/1.35 - voffset
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "ss")
    }
}
