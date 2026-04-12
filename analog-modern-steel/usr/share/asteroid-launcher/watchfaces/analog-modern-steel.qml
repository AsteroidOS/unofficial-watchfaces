/*
 * Copyright (C) 2021 - CosmosDev <github.com/CosmosDev>
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
    property string imgPath: "../watchfaces-img/analog-modern-steel-"

    Component.onCompleted: {
        var h = wallClock.time.getHours();
        var min = wallClock.time.getMinutes();
        var sec = wallClock.time.getSeconds();
        hourRot.angle = h * 30 + min * 0.5;
        minuteRot.angle = min * 6;
        secondRot.angle = sec * 6;
        monthRot.angle = (wallClock.time.getMonth() + 1) * 30;
    }

    Image {
        source: !displayAmbient ? imgPath + "strokes.svg" : imgPath + "strokes-ambient.svg"
        width: parent.width
        height: parent.height
    }

    Text {
        id: digitalDisplay

        z: 0
        font.pixelSize: parent.height * 0.04
        font.family: "Michroma"
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) + wallClock.time.toLocaleString(Qt.locale(), ":mm") : wallClock.time.toLocaleString(Qt.locale(), "HH:mm")

        anchors {
            centerIn: parent
            verticalCenterOffset: -parent.width / 4.5
        }

    }

    Text {
        id: dowDisplay

        z: 0
        font.pixelSize: parent.height * 0.05
        font.family: "Michroma"
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "ddd").toUpperCase()

        anchors {
            centerIn: parent
            horizontalCenterOffset: -parent.width / 4.5
        }

    }

    Repeater {
        model: 120

        Rectangle {
            property real rotM: (index - 30) / 120
            property real centerX: parent.width / 2 - width / 2
            property real centerY: parent.height / 2 - height / 2

            z: 1
            antialiasing: true
            x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.46
            y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.46
            color: "white"
            width: parent.width * 0.004
            height: index % 2 === 0 ? parent.height * 0.03 : parent.height * 0.01
            opacity: 0.6

            transform: Rotation {
                origin.x: width / 2
                origin.y: height / 2
                angle: index * 3
            }

        }

    }

    Repeater {
        model: 12

        Text {
            property real rotM: (index * 5 - 15) / 60
            property real centerX: parent.width / 2 - width / 2
            property real centerY: parent.height / 2 - height / 1.8

            z: 1
            font.pixelSize: parent.height * 0.08
            font.family: "Michroma"
            horizontalAlignment: Text.AlignHCenter
            x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.37
            y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.39
            color: "white"
            text: index === 0 ? "12" : index
            opacity: ([0, 2, 4, 8, 10].includes(index) || (index === 6 && displayAmbient)) ? 1 : 0
        }

    }

    Rectangle {
        id: dayBackground

        z: 0
        visible: !displayAmbient
        width: parent.width * 0.15
        height: parent.height * 0.15
        radius: width * 0.5
        color: "#18181B"

        anchors {
            centerIn: parent
            horizontalCenterOffset: parent.width / 4
        }

    }

    Text {
        id: dayDisplay

        z: 1
        font.pixelSize: dayBackground.height * 0.45
        font.family: "Michroma"
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "d").toUpperCase()

        anchors {
            centerIn: dayBackground
            verticalCenterOffset: -dayBackground.width * 0.05
        }

    }

    Rectangle {
        id: monthBackground

        z: 0
        visible: !displayAmbient
        width: parent.width * 0.25
        height: parent.height * 0.25
        radius: width * 0.5
        color: "#18181B"

        anchors {
            centerIn: parent
            verticalCenterOffset: parent.height / 3.5
        }

        Text {
            z: 1
            font.pixelSize: parent.height * 0.15
            font.family: "Michroma"
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            text: "12"

            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }

        }

        Text {
            z: 1
            font.pixelSize: parent.height * 0.15
            font.family: "Michroma"
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            text: "6"

            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }

        }

        Image {
            id: monthSVG

            z: 1
            source: imgPath + "handle.svg"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: parent.height

            transform: Rotation {
                id: monthRot

                origin.x: monthBackground.width / 2
                origin.y: monthBackground.height / 2
            }

        }

    }

    Repeater {
        model: 12

        Rectangle {
            property real rotM: (index * 5 - 15) / 60
            property real centerX: monthBackground.x + monthBackground.width / 2
            property real centerY: monthBackground.y + monthBackground.height / 2.1

            z: 1
            visible: !displayAmbient
            antialiasing: true
            x: centerX + Math.cos(rotM * 2 * Math.PI) * monthBackground.width * 0.4
            y: centerY + Math.sin(rotM * 2 * Math.PI) * monthBackground.width * 0.4
            color: "white"
            opacity: [0, 6].includes(index) ? 0 : 1
            width: monthBackground.width * 0.014
            height: monthBackground.height * 0.05
            radius: width * 0.5

            transform: Rotation {
                origin.x: width / 2
                origin.y: height / 2
                angle: index * 5 * 6
            }

        }

    }

    Image {
        id: hourSVG

        z: 2
        source: !displayAmbient ? imgPath + "hour.svg" : imgPath + "hour-ambient.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height

        transform: Rotation {
            id: hourRot

            origin.x: parent.width / 2
            origin.y: parent.height / 2
        }

    }

    Image {
        id: minuteSVG

        z: 3
        source: !displayAmbient ? imgPath + "minute.svg" : imgPath + "minute-ambient.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height

        transform: Rotation {
            id: minuteRot

            origin.x: parent.width / 2
            origin.y: parent.height / 2
        }

    }

    Image {
        id: secondSVG

        z: 4
        visible: !displayAmbient
        source: imgPath + "second.svg"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

        transform: Rotation {
            id: secondRot

            origin.x: parent.width / 2
            origin.y: parent.height / 2
        }

    }

    Connections {
        target: wallClock
        onTimeChanged: {
            if (!visible)
                return ;

            var h = wallClock.time.getHours();
            var min = wallClock.time.getMinutes();
            var sec = wallClock.time.getSeconds();
            hourRot.angle = h * 30 + min * 0.5;
            minuteRot.angle = min * 6;
            secondRot.angle = sec * 6;
            monthRot.angle = (wallClock.time.getMonth() + 1) * 30;
        }
    }

}
