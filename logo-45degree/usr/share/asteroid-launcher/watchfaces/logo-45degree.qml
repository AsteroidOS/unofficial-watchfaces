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

import QtQuick 2.1

Item {

    Image {
        id: logoAsteroid
        source: "asteroid_logo.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width/2.1
        height: parent.height/2.1
    }

    Text {
        id: hourDisplay
        property var rotH: (wallClock.time.getHours()-3 + wallClock.time.getMinutes()/60) / 12
        font.pixelSize: parent.height/3
        font.family: "OpenSans"
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.95
        horizontalAlignment: Text.AlignHCenter
        transform: Rotation { origin.x: centerX;
                              origin.y: centerY;
                              angle: -45}
        x: parent.width/2-width/0.70
        y: parent.height/2-height/1.78
        text: wallClock.time.toLocaleString(Qt.locale(), "<b>HH</b>")


    }

    Text {
        id: minuteDisplay
        font.pixelSize: parent.height/3
        font.family: "OpenSans"
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.95
        transform: Rotation { origin.x: centerX;
                              origin.y: centerY;
                              angle: +45}
        x: parent.width/1.295
        y: parent.height/2-height/0.855
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")

    }

    Text {
        id: secondDisplay
        font.pixelSize: parent.height/3
        font.family: "OpenSans"
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.95
        transform: Rotation { origin.x: centerX;
                              origin.y: centerY;
                              angle: -45}
        x: parent.width/2.34
        y: parent.height/1.41
        text: wallClock.time.toLocaleString(Qt.locale(), "ss")

    }
}
