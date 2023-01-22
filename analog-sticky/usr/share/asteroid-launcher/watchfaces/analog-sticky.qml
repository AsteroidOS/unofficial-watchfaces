/*
 * Copyright (C) 2021 - Timo Könnecke <github.com/eLtMosen>
 *               2016 - Sylvia van Os <iamsylvie@openmailbox.org>
 *               2015 - Florent Revest <revestflo@gmail.com>
 *               2012 - Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
 *                      Aleksey Mikhailichenko <a.v.mich@gmail.com>
 *                      Arto Jalkanen <ajalkane@gmail.com>
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

import QtQuick 2.15
import QtGraphicalEffects 1.15
//import Nemo.Mce 1.0
//import org.asteroid.controls 1.0
//import org.asteroid.utils 1.0

Item {
    id: root

    property string lowColor: !displayAmbient ? "#bb66666" : "#6666666"
    property string highColor: !displayAmbient ? "#FFEBAD" : "#aaFFEBAD"
    property string accColor: !displayAmbient ? "#D88C9A" : "#88D88C9A"
    property string imgPath: "../watchfaces-img/analog-sticky-"
    property real rad: .01745

    anchors.fill: parent



    Item {
        id: faceBox

        anchors.fill: parent

        Image {
            id: hourMarks

            z: 1
            anchors.fill: parent
            source: imgPath + "hourmarks.svg"
        }

        Repeater {
            model: 60

            Rectangle {
                id: minuteStrokes

                property real rotM: ((index) - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                z: 1
                visible: index % 5
                antialiasing : true
                width: parent.width * .004
                height: parent.height * .016
                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * .47
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * .47
                color: lowColor

                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                    angle: (index) * 6
                }
            }
        }

        // DropShadow on all hands
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 6.0
            samples: 13
            color: Qt.rgba(0, 0, 0, .6)
        }
    }

    Item {
        id: handBox

        z: 3
        anchors.fill: parent

        Image {
            id: hourSVG

            z: 3
            source:imgPath + "hour.svg"
            anchors.fill: parent

            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: (wallClock.time.getHours()*30) + (wallClock.time.getMinutes() * 0.5)
            }

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 2
                verticalOffset: 2
                radius: 6.0
                samples: 11
                color: Qt.rgba(0, 0, 0, .2)
            }
        }

        Image {
            id: minuteSVG

            z: 4
            source: imgPath + "minute.svg"
            anchors.fill: parent

            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: (wallClock.time.getMinutes()*6)+(wallClock.time.getSeconds() * 6 / 60)
            }

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 3
                verticalOffset: 3
                radius: 7.0
                samples: 13
                color: Qt.rgba(0, 0, 0, .3)
            }
        }

        Image {
            id: secondSVG

            z: 5
            visible: !displayAmbient
            source: imgPath + "second.svg"
            anchors.fill: parent

            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: (wallClock.time.getSeconds() * 6)
            }

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 4
                verticalOffset: 4
                radius: 8.0
                samples: 17
                color: Qt.rgba(0, 0, 0, .3)
            }
        }

        // DropShadow on all hands
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 4
            verticalOffset: 4
            radius: 10.0
            samples: 21
            color: Qt.rgba(0, 0, 0, .6)
        }
    }


}
