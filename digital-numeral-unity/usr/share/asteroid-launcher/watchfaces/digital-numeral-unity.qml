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
import QtGraphicalEffects 1.15

Item {
    id: root
    property var topbottomMargin: root.height*0.022
    property var leftrightMargin: -root.height*0.018
    property var numeralSize: Qt.size(root.width*0.32, root.height*0.32)
    property string imagePath: "../watchface-img/digital-numeral-unity-"

    Image {
        id: topLeft
        anchors {
            bottom: root.verticalCenter
            bottomMargin: topbottomMargin
            right: root.horizontalCenter
            rightMargin: leftrightMargin
        }
        sourceSize: numeralSize
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(0, 1) + ".png"
    }

    Image {
        id: topRight
        anchors {
            bottom: root.verticalCenter
            bottomMargin: topbottomMargin
            left: root.horizontalCenter
            leftMargin: leftrightMargin
        }
        sourceSize: numeralSize
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(1, 2) + ".png"
    }

    Image {
        id: bottomLeft
        anchors {
            top: root.verticalCenter
            topMargin: topbottomMargin
            right: root.horizontalCenter
            rightMargin: leftrightMargin
        }
        sourceSize: numeralSize
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(0, 1) + ".png"
    }

    Image {
        id: bottomRight
        anchors {
            top: root.verticalCenter
            topMargin: topbottomMargin
            left: root.horizontalCenter
            leftMargin: leftrightMargin
        }
        sourceSize: numeralSize
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(1, 2) + ".png"
    }

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 0
        radius: 40.0
        samples: 20
        color: Qt.rgba(0, 255, 255, 0.5)
    }
}
