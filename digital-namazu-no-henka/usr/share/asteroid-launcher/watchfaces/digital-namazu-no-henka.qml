/*
 * Copyright (C) 2022 - Timo Könnecke <github.com/eLtMosen>
 *               2021 - Darrel Griët <dgriet@gmail.com>
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

import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: root

    property string imgPath: "../watchfaces-img/digital-namazu-no-henka-"
    property var largeNumeralSize: Qt.size(parent.width * .25, parent.height * .25)
    property var smallNumeralSize: Qt.size(parent.width * .076, parent.height * .076)
    property real largeNumeralOffset: -parent.height * .02
    property real smallNumeralOffset: parent.height * 0.0606

    Item {
          id: batteryChargePercentage
          property real value: (featureSlider.value * 100).toFixed(0)
    }

    Item {
        id: digitalTime

        anchors.fill: parent

        Image {
            id: hour1

            anchors {
                right: parent.horizontalCenter
                rightMargin: -parent.height * 0.01
                bottom: parent.verticalCenter
                bottomMargin: largeNumeralOffset
            }
            smooth: true
            sourceSize: largeNumeralSize
            source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(1, 2) + ".svg"
        }

        Image {
            id: hour2

            anchors {
                right: parent.horizontalCenter
                rightMargin: (-parent.height * 0.01) + (parent.height * 0.165)
                bottom: parent.verticalCenter
                bottomMargin: largeNumeralOffset
            }
            smooth: true
            sourceSize: largeNumeralSize
            source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(0, 1) + ".svg"
        }

        Image {
            id: colon

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.verticalCenter
                bottomMargin: largeNumeralOffset
            }
            smooth: true
            sourceSize: largeNumeralSize
            source: imgPath + "colon.svg"
        }

        Image {
            id: minute1

            anchors {
                left: parent.horizontalCenter
                leftMargin: (parent.height * 0.155) + (-parent.height * 0.165)
                bottom: parent.verticalCenter
                bottomMargin: largeNumeralOffset
            }
            smooth: true
            sourceSize: largeNumeralSize
            source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(0, 1) + ".svg"
        }

        Image {
            id: minute2

            anchors {
                left: parent.horizontalCenter
                leftMargin: parent.height * 0.157
                bottom: parent.verticalCenter
                bottomMargin: largeNumeralOffset
            }
            smooth: true
            sourceSize: largeNumeralSize
            source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(1, 2) + ".svg"
        }
    }

    Item {
        id: digitalDate

        anchors.fill: parent

        Image {
            id: day1

            anchors {
                right: parent.horizontalCenter
                rightMargin: parent.height * 0.288
                top: parent.verticalCenter
                topMargin: smallNumeralOffset
            }
            smooth: true
            sourceSize: smallNumeralSize
            source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "MM").slice(0, 1) + "-small.svg"
        }

        Image {
            id: day2

            anchors {
                right: parent.horizontalCenter
                rightMargin: parent.height * 0.229
                top: parent.verticalCenter
                topMargin: smallNumeralOffset
            }
            smooth: true
            sourceSize: smallNumeralSize
            source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "MM").slice(1, 2) + "-small.svg"
        }

        Image {
            id: hyphen

            anchors {
                right: parent.horizontalCenter
                rightMargin: parent.height * 0.17
                top: parent.verticalCenter
                topMargin: smallNumeralOffset
            }
            smooth: true
            sourceSize: smallNumeralSize
            source: imgPath + "hyphen-small.svg"
        }

        Image {
            id: month1

            anchors {
                left: parent.horizontalCenter
                leftMargin: -parent.height * 0.187
                top: parent.verticalCenter
                topMargin: smallNumeralOffset
            }
            smooth: true
            sourceSize: smallNumeralSize
            source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "dd").slice(0, 1) + "-small.svg"
        }

        Image {
            id: month2

            anchors {
                left: parent.horizontalCenter
                leftMargin: -parent.height * 0.127
                top: parent.verticalCenter
                topMargin: smallNumeralOffset
            }
            smooth: true
            sourceSize: smallNumeralSize
            source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "dd").slice(1, 2) + "-small.svg"
        }
    }
}
