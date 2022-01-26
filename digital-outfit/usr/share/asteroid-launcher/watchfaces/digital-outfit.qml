/*
 * Copyright (C) 2021 - Timo Könnecke <github.com/eLtMosen>
 *
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
import QtGraphicalEffects 1.12

Item {
    id: root

    anchors.centerIn: parent

    width: parent.width
    height: parent.height

    Text {
        id: hourDisplay

        anchors {
            centerIn: root
            verticalCenterOffset: -root.height * .218
        }
        renderType: Text.NativeRendering
        font {
            pixelSize: root.height * .4
            letterSpacing: root.height * .006
            family: "Outfit"
            styleName: "Medium"
        }
        color: "#ffffff"
        horizontalAlignment: Text.AlignHCenter
        text: use12H.value ?
                  wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) :
                  wallClock.time.toLocaleString(Qt.locale(), "HH")
    }

    Text {
        id: apDisplay

        anchors {
            left: hourDisplay.right
            leftMargin: root.height * .01
            bottom: root.verticalCenter
            bottomMargin: root.height * .22
        }
        renderType: Text.NativeRendering
        visible: use12H.value
        color: "#ddffffff"
        font {
            pixelSize: root.height * .076
            family: "Outfit"
            styleName: "Regular"
            letterSpacing: root.height * .006
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "ap").toUpperCase()
    }

    Text {
        id: monthDisplay

        anchors.centerIn: root

        renderType: Text.NativeRendering
        color: "#ddffffff"
        horizontalAlignment: Text.AlignHCenter
        font {
            pixelSize: root.height * .1
            letterSpacing: root.height * .006
            family: "Outfit"
            styleName: "Light"
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "MMM dd").replace(".","").toUpperCase()
    }

    Text {
        id: minuteDisplay

        anchors {
            centerIn: root
            verticalCenterOffset: root.height * .21
        }
        renderType: Text.NativeRendering
        color: "#ffffff"
        horizontalAlignment: Text.AlignHCenter
        font {
            pixelSize: root.height * .4
            letterSpacing: root.height * .006
            family: "Outfit"
            styleName: "Light"
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 4
        verticalOffset: 4
        radius: 7.0
        samples: 15
        color: "#99000000"
    }
}
