// SPDX-FileCopyrightText: 2021 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: LGPL-2.1-or-later

import Qt5Compat.GraphicalEffects
import QtQuick

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
