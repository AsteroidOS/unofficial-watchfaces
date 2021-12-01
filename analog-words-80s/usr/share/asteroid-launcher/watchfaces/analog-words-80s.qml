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
    property string currentHour: ''
    property string hourColor: ''
    property var neonColor: ["#99FF00E3", "#993500FF", "#9901FE01", "#99FFFE37", "#99FF8600", "#99ED0003", "#9900ffff", "#9938FF12", "#99007FFF", "#99FAAB00"]
    property string imgPath: "../watchface-img/analog-words-80s-"

    Image {
        z: 0
        id: backplate
        source: imgPath + "backplate.svg"
        opacity: displayAmbient ? 0.3 : 0.5
        anchors {
            centerIn: root
        }
        width: root.width
        height: root.height
    }

    Image {
        z: 1
        id: hourOverlay
        source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) + ".svg"
        anchors {
            centerIn: root
        }
        width: root.width
        height: root.height
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 14.0
            samples: 14
            // select random color from array on every new hour
            color: if (currentHour !== wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2)) {
                       currentHour = wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2)
                       hourColor = Math.floor(Math.random() * neonColor.length)
                       neonColor[hourColor]
                   }
                   else {
                       neonColor[hourColor]
                   }
        }
    }

    Image {
        id: hourSVG
        z: 0
        source: imgPath + "hour.svg"
        anchors {
            centerIn: root
        }
        width: root.width
        height: root.height
        transform: Rotation {
            origin.x: root.width/2;
            origin.y: root.height/2;
            angle: (wallClock.time.getHours()*30) + (wallClock.time.getMinutes()*0.5)
        }
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 1
            verticalOffset: 1
            radius: 8.0
            samples: 10
            color: neonColor[Math.floor(Math.random() * 10)]
        }
    }

    Image {
        id: minuteSVG
        z: 3
        source: imgPath + "minute.svg"
        anchors {
            centerIn: root
        }
        width: root.width
        height: root.height
        transform: Rotation {
            origin.x: root.width/2;
            origin.y: root.height/2;
            angle: (wallClock.time.getMinutes()*6)+(wallClock.time.getSeconds()*6/60)
        }
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 8.0
            samples: 10
            color: neonColor[hourColor]
        }
    }

    Image {
        id: secondSVG
        z: 4
        visible: !displayAmbient
        source: imgPath + "second.svg"
        anchors {
            centerIn: root
        }
        width: root.width
        height: root.height
        transform: Rotation {
            origin.x: root.width/2;
            origin.y: root.height/2;
            angle: (wallClock.time.getSeconds()*6)
        }
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 6
            verticalOffset: 6
            radius: 5.0
            samples: 8
            color: "#66000000"
        }
    }
}
