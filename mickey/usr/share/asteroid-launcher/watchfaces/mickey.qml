/*
 * Copyright (C) 2021 - Darrel Griët <dgriet@gmail.com>
 *               2021 - Timo Könnecke <github.com/eLtMosen>
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

import QtQuick 2.9

Item {
    function getScale() {
        var scaleX = backgroundImage.width/backgroundImage.sourceSize.width
        var scaleY = backgroundImage.height/backgroundImage.sourceSize.height
        return scaleX < scaleY ? scaleX : scaleY
    }

    Rectangle {
        id: backgroundColor
        width: parent.width
        height: parent.height
        color: "#070707"
    }

    Image {
        id: backgroundImage
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        source: "../watchfaces-img/background.png"
    }

    Image {
        property int currentImage: 1
        id: foodAnimationImage
        x: (parent.width + 0.04 * (backgroundImage.sourceSize.width * getScale())) / 2
        y: (parent.height + 0.30 * (backgroundImage.sourceSize.height * getScale())) / 2
        width: getScale() * sourceSize.width
        height: getScale() * sourceSize.height
        source: "../watchfaces-img/food_"+currentImage+".png"
        NumberAnimation on currentImage {
            loops: Animation.Infinite
            from: 1
            to: 15
            duration: 1600
        }
    }

    Image {
        id: hourHand
        x: (parent.width / 2) - width / 2
        y: (parent.height / 2) - height
        width: getScale() * sourceSize.width
        height: getScale() * sourceSize.height
        source: "../watchfaces-img/hour_hand.png"
        transform: Rotation {
            angle: (parseInt(wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2)) + parseFloat(wallClock.time.toLocaleString(Qt.locale(), "mm").slice(0, 2)*1 / 60)) * 30
            origin.x: hourHand.width / 2
            origin.y: hourHand.height
        }
    }
    Image {
        id: minuteHand
        x: (parent.width / 2) - width / 2
        y: (parent.height / 2) - height
        width: getScale() * sourceSize.width
        height: getScale() * sourceSize.height
        source: "../watchfaces-img/minute_hand.png"
        transform: Rotation {
            angle: wallClock.time.toLocaleString(Qt.locale(), "mm").slice(0, 2) * 6
            origin.x: minuteHand.width / 2
            origin.y: minuteHand.height
        }
    }
}
