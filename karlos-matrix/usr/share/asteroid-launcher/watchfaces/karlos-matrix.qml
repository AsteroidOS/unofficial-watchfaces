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
import org.freedesktop.contextkit 1.0
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0

Item {

    Rectangle {
        z: 1
        id: timeBack
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: Qt.rgba(0, 0, 0, 0.7)
        width: parent.width
        height: parent.height*0.22
    }

    Text {
        z: 6
        id: hourDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height * 0.246
        font.family: "Elektra"
        font.letterSpacing: parent.width*0.01
        color: Qt.rgba(0, 1, 1, 1)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            verticalCenter: parent.verticalCenter
            //verticalCenterOffset: parent.height*0.01
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: parent.width*0.0062
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "HH:mm")
    }

    Text {
        z: 7
        id: dowDisplay
        font.pixelSize: parent.height*0.08
        font.family: "Elektra"
        color: Qt.rgba(1, 1, 0, 0.9)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            topMargin: parent.height * 0.032
            top: hourDisplay.top
            right: hourDisplay.left
            rightMargin: parent.width*0.035
        }
        text: Qt.formatDate(wallClock.time, "ddd").slice(0, 3).toUpperCase()
    }

    Text {
        z: 5
        id: dateDisplay
        font.pixelSize: parent.height * 0.123
        font.family: "Elektra"
        font.styleName:"Thin"
        color: Qt.rgba(1, 0, 0.5, 1)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            bottomMargin: parent.height * 0.0245
            bottom: hourDisplay.bottom
            right: hourDisplay.left
            rightMargin: parent.width*0.0354
        }
        text: Qt.formatDate(wallClock.time, "dd")
    }

    Text {
        z: 6
        id: secondDisplay
        renderType: Text.NativeRendering
        font.pixelSize: parent.height * 0.123
        font.family: "Elektra"
        font.styleName:"Thin"
        color: Qt.rgba(0, 1, 1, 0.9)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            topMargin: parent.height * 0.0246
            top: hourDisplay.top
            left: hourDisplay.right
            leftMargin: parent.width*0.024
        }
        //x: parent.width / 6 * 5.35 - width / 2
        text: wallClock.time.toLocaleString(Qt.locale(), "ss")
    }


    Text {
        z: 8
        id: apDisplay
        font.pixelSize: parent.height*0.08
        font.family: "Elektra"
        color: Qt.rgba(1, 0, 1, 0.95)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            bottomMargin: parent.height * 0.032
            bottom: hourDisplay.bottom
            left: hourDisplay.right
            leftMargin: parent.width*0.0250
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "ap").slice(0, 2).toUpperCase()
    }

    Rectangle {
        id: batteryBack
        z: 8
        anchors {
            bottom: timeBack.top
            //topMargin: -parent.height*0.03
            horizontalCenter: parent.horizontalCenter
        }
        color: batteryChargePercentage.value < 30 ? 'red': batteryChargePercentage.value < 60 ? 'yellow': Qt.rgba(0, 1, 0, 1)
        width: parent.width/100*batteryChargePercentage.value
        height: parent.height * 0.004
    }

    Text {
        z: 8
        id: batteryDisplay
        font.pixelSize: parent.height*0.05
        font.family: "Elektra"
        color: batteryChargePercentage.value < 30 ? 'red': batteryChargePercentage.value < 60 ? 'yellow': Qt.rgba(0, 1, 0, 1)
        horizontalAlignment: Text.AlignHCenter
        anchors {
            top: batteryBack.bottom
            topMargin: -parent.height*0.0055
            horizontalCenter: parent.horizontalCenter
        }
        text: batteryChargePercentage.value
    }

    ContextProperty {
        id: batteryChargePercentage
        key: "Battery.ChargePercentage"
        value: "100"
        Component.onCompleted: batteryChargePercentage.subscribe()
    }
}
