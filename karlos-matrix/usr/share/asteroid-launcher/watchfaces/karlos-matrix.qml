/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
 *               2018 - Timo Könnecke <el-t-mo@arcor.de>
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

import Nemo.Mce 1.0
import QtQuick 2.9
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0

Item {
    Rectangle {
        id: timeBack

        anchors.centerIn: parent
        color: Qt.rgba(0, 0, 0, 0.7)
        width: parent.width
        height: parent.height * 0.22
    }

    Text {
        id: dateDisplay

        color: Qt.rgba(1, 0, 0.5, 1)
        horizontalAlignment: Text.AlignHCenter
        text: Qt.formatDate(wallClock.time, "dd")

        font {
            pixelSize: parent.height * 0.123
            family: "Elektra"
            styleName: "Thin"
        }

        anchors {
            bottomMargin: parent.height * 0.0245
            bottom: hourDisplay.bottom
            right: hourDisplay.left
            rightMargin: parent.width * 0.0354
        }

    }

    Text {
        id: hourDisplay

        renderType: Text.NativeRendering
        color: Qt.rgba(0, 1, 1, 1)
        horizontalAlignment: Text.AlignHCenter
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) + wallClock.time.toLocaleString(Qt.locale(), ":mm") : wallClock.time.toLocaleString(Qt.locale(), "HH") + wallClock.time.toLocaleString(Qt.locale(), ":mm")

        font {
            pixelSize: parent.height * 0.246
            family: "Elektra"
            letterSpacing: parent.width * 0.01
        }

        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: parent.width * 0.0062
        }

    }

    Text {
        id: secondDisplay

        renderType: Text.NativeRendering
        color: Qt.rgba(0, 1, 1, 0.9)
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "ss")

        font {
            pixelSize: parent.height * 0.123
            family: "Elektra"
            styleName: "Thin"
        }

        anchors {
            topMargin: parent.height * 0.0246
            top: hourDisplay.top
            left: hourDisplay.right
            leftMargin: parent.width * 0.024
        }
        //x: parent.width / 6 * 5.35 - width / 2

    }

    Text {
        id: dowDisplay

        color: Qt.rgba(1, 1, 0, 0.9)
        horizontalAlignment: Text.AlignHCenter
        text: Qt.formatDate(wallClock.time, "ddd").slice(0, 3).toUpperCase()

        font {
            pixelSize: parent.height * 0.08
            family: "Elektra"
        }

        anchors {
            topMargin: parent.height * 0.032
            top: hourDisplay.top
            right: hourDisplay.left
            rightMargin: parent.width * 0.035
        }

    }

    Text {
        id: apDisplay

        visible: use12H.value
        color: Qt.rgba(1, 0, 1, 0.95)
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "ap").slice(0, 2).toUpperCase()

        font {
            pixelSize: parent.height * 0.08
            family: "Elektra"
        }

        anchors {
            bottomMargin: parent.height * 0.032
            bottom: hourDisplay.bottom
            left: hourDisplay.right
            leftMargin: parent.width * 0.025
        }

    }

    Rectangle {
        id: batteryBack

        color: batteryChargePercentage.percent < 30 ? 'red' : batteryChargePercentage.percent < 60 ? 'yellow' : Qt.rgba(0, 1, 0, 1)
        width: parent.width / 100 * batteryChargePercentage.percent
        height: parent.height * 0.004

        anchors {
            bottom: timeBack.top
            //topMargin: -parent.height*0.03
            horizontalCenter: parent.horizontalCenter
        }

    }

    Text {
        id: batteryDisplay

        color: batteryChargePercentage.percent < 30 ? 'red' : batteryChargePercentage.percent < 60 ? 'yellow' : Qt.rgba(0, 1, 0, 1)
        horizontalAlignment: Text.AlignHCenter
        text: batteryChargePercentage.percent

        font {
            pixelSize: parent.height * 0.05
            family: "Elektra"
        }

        anchors {
            top: batteryBack.bottom
            topMargin: -parent.height * 0.0055
            horizontalCenter: parent.horizontalCenter
        }

    }

    MceBatteryLevel {
        id: batteryChargePercentage
    }

}
