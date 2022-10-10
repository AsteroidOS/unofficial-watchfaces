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
import QtGraphicalEffects 1.12

Item {
    id: root

    property string imgPath: "../watchfaces-img/digital-namazu-no-henka-"

    Item {
        width: parent.width
        height: width

        Image {
            id: hour1

            anchors {
                right: parent.horizontalCenter
                rightMargin: -parent.height * 0.01
                bottom: parent.verticalCenter
                bottomMargin: -parent.height * 0.02
            }
            smooth: true
            sourceSize: Qt.size(parent.width*0.25, parent.height*0.25)
            source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(1, 2) + ".svg"
        }

        Image {
            id: hour2

            anchors {
                right: parent.horizontalCenter
                rightMargin: (-parent.height * 0.01) + (parent.height * 0.165)
                bottom: parent.verticalCenter
                bottomMargin: -parent.height * 0.02
            }
            smooth: true
            sourceSize: Qt.size(parent.width*0.25, parent.height*0.25)
            source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(0, 1) + ".svg"
        }

        Image {
            id: minute1

            anchors {
                left: parent.horizontalCenter
                leftMargin: (parent.height * 0.155) + (-parent.height * 0.165)
                bottom: parent.verticalCenter
                bottomMargin: -parent.height * 0.02
            }
            smooth: true
            sourceSize: Qt.size(parent.width*0.25, parent.height*0.25)
            source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(0, 1) + ".svg"
        }

        Image {
            id: minute2

            anchors {
                left: parent.horizontalCenter
                leftMargin: parent.height * 0.157
                bottom: parent.verticalCenter
                bottomMargin: -parent.height * 0.02
            }
            smooth: true
            sourceSize: Qt.size(parent.width*0.25, parent.height*0.25)
            source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(1, 2) + ".svg"
        }
    }
}
