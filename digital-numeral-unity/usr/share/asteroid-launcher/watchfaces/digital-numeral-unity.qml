/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
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

import QtGraphicalEffects 1.15
import QtQuick 2.9

Item {
    id: root

    property real topbottomMargin: root.height * 0.022
    property real leftrightMargin: -root.height * 0.018
    property var numeralSize: Qt.size(root.width * 0.32, root.height * 0.32)
    property string imagePath: "../watchfaces-img/digital-numeral-unity-"

    layer.enabled: true

    Image {
        id: topLeft

        sourceSize: numeralSize
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(0, 1) + ".png"

        anchors {
            bottom: root.verticalCenter
            bottomMargin: topbottomMargin
            right: root.horizontalCenter
            rightMargin: leftrightMargin
        }

    }

    Image {
        id: topRight

        sourceSize: numeralSize
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(1, 2) + ".png"

        anchors {
            bottom: root.verticalCenter
            bottomMargin: topbottomMargin
            left: root.horizontalCenter
            leftMargin: leftrightMargin
        }

    }

    Image {
        id: bottomLeft

        sourceSize: numeralSize
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(0, 1) + ".png"

        anchors {
            top: root.verticalCenter
            topMargin: topbottomMargin
            right: root.horizontalCenter
            rightMargin: leftrightMargin
        }

    }

    Image {
        id: bottomRight

        sourceSize: numeralSize
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(1, 2) + ".png"

        anchors {
            top: root.verticalCenter
            topMargin: topbottomMargin
            left: root.horizontalCenter
            leftMargin: leftrightMargin
        }

    }

    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 0
        radius: 30
        samples: 9
        color: Qt.rgba(0, 255, 255, 0.5)
    }

}
