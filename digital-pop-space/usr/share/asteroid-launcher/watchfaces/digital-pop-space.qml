/*
 * Copyright (C) 2022 - Timo Könnecke <github.com/eLtMosen>
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

import QtQuick 2.9
import QtGraphicalEffects 1.15

Item {
    Image {
        id: background

        source: "../watchface-img/background-digital-pop-space.svg"
        anchors {
            centerIn: parent
        }
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 30.0
            samples: 15
            color: "#ffCD0074"
        }
    }

    Text {
        id: hour

        anchors {
            centerIn: parent
            verticalCenterOffset: -parent.height * 0.18
        }
        font {
            pixelSize: parent.height * 0.19
            family: "outrun future"
            styleName: "Regular"
            letterSpacing: -parent.height * 0.004
        }
        renderType: Text.NativeRendering
        antialiasing: true
        color: "#F50097"
        style: Text.Sunken
        styleColor: "#000"
        text: if (use12H.value) {
                  wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) +
                  wallClock.time.toLocaleString(Qt.locale(), " mm")}
              else
                  wallClock.time.toLocaleString(Qt.locale(), "HH mm")
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 24.0
            samples: 16
            color: "#FFFF5C"
        }
    }

    Text {
        id: dateDisplay

        anchors {
            centerIn: parent
            verticalCenterOffset: parent.height * 0.024
        }
        font {
            pixelSize: parent.height * 0.061
            family: "Baloo Tammudu 2"
            styleName: "Light"
            letterSpacing: -parent.height * 0.0034
        }
        visible: !displayAmbient
        renderType: Text.NativeRendering
        style: Text.Sunken
        styleColor: "#000"
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "MMMM ").toUpperCase() +
              wallClock.time.toLocaleString(Qt.locale(), "<b>dd</b>")
    }

    Text {
        id: dowDisplay

        anchors {
            centerIn: parent
            verticalCenterOffset: parent.height * 0.07
        }
        font {
            pixelSize: parent.height * 0.048
            family: "Baloo Tammudu 2"
            styleName: "Light"
            letterSpacing: -parent.height * 0.0034
        }
        style: Text.Sunken
        styleColor: "#000"
        visible: !displayAmbient
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "dddd ").toUpperCase()
    }

    Text {
        id: apDisplay

        anchors {
            centerIn: parent
            verticalCenterOffset: parent.height * 0.165
        }
        font {
            pixelSize: parent.height * 0.16
            family: "outrun future"
            styleName: "Regular"
            letterSpacing: -parent.height * 0.002
        }
        color: "#ddffff00"
        style: Text.Sunken
        styleColor: "#000"
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "<b>ap</b>")
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 30.0
            samples: 15
            color: "#ffff19a6"
        }
    }

    Image {

        id: backgroundWave
        z: 3
        source: "../watchface-img/backgroundwave-digital-pop-space.svg"
        anchors {
            centerIn: parent
        }
        width: parent.width
        height: parent.height
    }
 }
