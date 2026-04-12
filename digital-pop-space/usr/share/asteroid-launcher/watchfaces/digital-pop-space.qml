/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
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
import org.asteroid.utils 1.0

Item {
    id: rootitem

    Image {
        id: background

        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        source: "../watchfaces-img/digital-pop-space-background.svg"
    }

    Text {
        id: hour

        renderType: Text.NativeRendering
        color: "#F50097"
        style: Text.Sunken
        styleColor: "#000"
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) + wallClock.time.toLocaleString(Qt.locale(), " mm") : wallClock.time.toLocaleString(Qt.locale(), "HH mm")
        layer.enabled: true

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

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 24
            samples: 9
            color: "#FFFF5C"
        }

    }

    Text {
        id: dateDisplay

        renderType: Text.NativeRendering
        color: "white"
        style: Text.Sunken
        styleColor: "#000"
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "MMMM ").toUpperCase() + wallClock.time.toLocaleString(Qt.locale(), "<b>dd</b>")

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

    }

    Text {
        id: dowDisplay

        renderType: Text.NativeRendering
        color: "white"
        style: Text.Sunken
        styleColor: "#000"
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "dddd ").toUpperCase()

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

    }

    Text {
        id: apDisplay

        visible: use12H.value
        renderType: Text.NativeRendering
        color: "#ddffff00"
        style: Text.Sunken
        styleColor: "#000"
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "<b>ap</b>")
        layer.enabled: true

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

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 30
            samples: 9
            color: "#ffff19a6"
        }

    }

    Item {
        id: backgroundWaveWrapper

        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        layer.enabled: DeviceSpecs.hasRoundScreen

        Image {
            id: backgroundWave

            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            source: "../watchfaces-img/digital-pop-space-backgroundwave.svg"
        }

        layer.effect: OpacityMask {

            maskSource: Rectangle {
                width: backgroundWaveWrapper.width
                height: backgroundWaveWrapper.height
                radius: width / 2
                visible: false
            }

        }

    }

}
