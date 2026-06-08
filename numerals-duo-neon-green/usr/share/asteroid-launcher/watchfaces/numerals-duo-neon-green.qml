// SPDX-FileCopyrightText: 2021 Darrel Griët <dgriet@gmail.com>
// SPDX-FileCopyrightText: 2021 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import Qt5Compat.GraphicalEffects
import QtQuick
import org.asteroid.utils

Item {
    id: root

    property int length: width > height ? height : width
    property string imgPath: "../watchfaces-img/numerals-duo-neon-green-"

    Item {
        x: DeviceSpecs.hasRoundScreen ? length * 0.1 : (root.width != length ? root.width / 2 - length / 2 : 0)
        y: DeviceSpecs.hasRoundScreen ? length * 0.1 : (root.height != length ? root.height / 2 - length / 2 : 0)
        width: DeviceSpecs.hasRoundScreen ? length * 0.8 : length
        height: DeviceSpecs.hasRoundScreen ? length * 0.8 : length

        Rectangle {
            id: greenColor

            anchors.fill: parent
            smooth: true
            visible: false
            color: "#b0e60d"
        }

        Rectangle {
            id: whiteColor

            anchors.fill: parent
            smooth: true
            visible: false
            color: "#ffffff"
        }

        Image {
            id: topLeft

            visible: false
            smooth: true
            fillMode: Image.PreserveAspectFit
            x: parseInt(parent.width * 0.135)
            y: parseInt(parent.height * 0.045)
            sourceSize: Qt.size(parent.width / 2 - parent.width * 0.15, parent.height / 2 - parent.height * 0.15)
            source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(0, 1) + ".png"
        }

        Image {
            id: topRight

            visible: false
            smooth: true
            fillMode: Image.PreserveAspectFit
            x: parseInt(parent.width / 2 + parent.width * 0.03)
            y: parseInt(parent.height * 0.045)
            sourceSize: Qt.size(parent.width / 2 - parent.width * 0.15, parent.height / 2 - parent.height * 0.15)
            source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(1, 2) + ".png"
        }

        Image {
            id: bottomLeft

            visible: false
            smooth: true
            fillMode: Image.PreserveAspectFit
            x: parseInt(parent.width * 0.135)
            y: parseInt(parent.height / 2 + parent.height * 0.025)
            sourceSize: Qt.size(parent.width / 2 - parent.width * 0.15, parent.height / 2 - parent.height * 0.15)
            source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(0, 1) + ".png"
        }

        Image {
            id: bottomRight

            visible: false
            smooth: true
            fillMode: Image.PreserveAspectFit
            x: parseInt(parent.width / 2 + parent.width * 0.03)
            y: parseInt(parent.height / 2 + parent.height * 0.025)
            sourceSize: Qt.size(parent.width / 2 - parent.width * 0.15, parent.height / 2 - parent.height * 0.15)
            source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(1, 2) + ".png"
        }

        OpacityMask {
            invert: true
            anchors.fill: topLeft
            source: greenColor
            maskSource: topLeft
        }

        OpacityMask {
            invert: true
            anchors.fill: topRight
            source: greenColor
            maskSource: topRight
        }

        OpacityMask {
            invert: true
            anchors.fill: bottomLeft
            source: whiteColor
            maskSource: bottomLeft
        }

        OpacityMask {
            invert: true
            anchors.fill: bottomRight
            source: whiteColor
            maskSource: bottomRight
        }

    }

}
