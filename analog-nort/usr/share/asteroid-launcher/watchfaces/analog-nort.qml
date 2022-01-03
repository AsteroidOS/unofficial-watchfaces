/*
 * Copyright (C) 2021 - Timo Könnecke <github.com/eLtMosen>
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
import QtGraphicalEffects 1.15

Item {
    id: root

    property string imgPath: "../watchfaces-img/analog-nort-"

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
            origin.x: root.width / 2
            origin.y: root.height / 2
            angle: (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * 0.5)
            Behavior on angle {
                RotationAnimation {
                    duration: 1000
                    direction: RotationAnimation.Clockwise
                }
            }
        }
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 8.0
            samples: 12
            color: "#66fbfb"
        }
    }

    Image {
        id: minuteSVG
        z: 1
        source: imgPath + "minute.svg"
        anchors {
            centerIn: root
        }
        width: root.width
        height: root.height
        transform: Rotation {
            origin.x: root.width / 2
            origin.y: root.height / 2
            angle: (wallClock.time.getMinutes() * 6)+(wallClock.time.getSeconds() * 6 / 60)
            Behavior on angle {
                RotationAnimation {
                    duration: 1000
                    direction: RotationAnimation.Clockwise
                }
            }
        }
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 8.0
            samples: 12
            color: "#66fbfb"
        }
    }

    Image {
        id: secondSVG
        z: 2
        visible: !displayAmbient
        source: imgPath + "second.svg"
        anchors {
            centerIn: root
        }
        width: root.width
        height: root.height
        transform: Rotation {
            origin.x: root.width / 2
            origin.y: root.height / 2
            angle: (wallClock.time.getSeconds() * 6)
            Behavior on angle {
                RotationAnimation {
                    duration: 1000
                    direction: RotationAnimation.Clockwise
                }
            }
        }
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 8.0
            samples: 12
            color: "#ffc312"
        }
    }
 }
