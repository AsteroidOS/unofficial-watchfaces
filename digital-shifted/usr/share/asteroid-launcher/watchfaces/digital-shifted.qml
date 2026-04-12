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

    property real topbottomMargin: parent.height * 0.0086
    property real leftrightMargin: -parent.height * 0.048
    property size numeralSize: Qt.size(parent.width * 0.25, parent.height * 0.25)
    property real arcEnd: wallClock.time.getSeconds() * 6

    // Fire requestPaint once per second on tick, not on every animation frame.
    onArcEndChanged: canvas.requestPaint()

    Image {
        id: ring

        z: 0
        visible: !displayAmbient
        source: "../watchfaces-img/digital-shifted-ring.svg"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
    }

    Canvas {
        id: canvas

        visible: !displayAmbient
        anchors.fill: parent
        rotation: -90
        onPaint: {
            var ctx = getContext("2d");
            var x = root.width / 2;
            var y = root.height / 2;
            var start = 0;
            var end = Math.PI * (root.arcEnd / 180);
            ctx.reset();
            ctx.beginPath();
            ctx.lineCap = "round";
            ctx.arc(x, y, (root.width / 2) - parent.height * 0.124 / 2, start, end, false);
            ctx.lineWidth = parent.height * 0.03;
            ctx.strokeStyle = "#7738FF12";
            ctx.stroke();
        }
        layer.enabled: true

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 14
            samples: 9
            color: "#eeffff00"
        }

    }

    Item {
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        layer.enabled: true

        Image {
            id: topLeft

            sourceSize: numeralSize
            source: "../watchfaces-img/digital-shifted-" + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(0, 1) + ".png"

            anchors {
                bottom: parent.verticalCenter
                bottomMargin: topbottomMargin
                right: topCenter.left
                rightMargin: leftrightMargin
            }

        }

        Image {
            id: topCenter

            sourceSize: numeralSize
            source: "../watchfaces-img/digital-shifted-" + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(1, 2) + ".png"

            anchors {
                bottom: parent.verticalCenter
                bottomMargin: topbottomMargin
                horizontalCenter: parent.horizontalCenter
            }

        }

        Image {
            id: bottomCenter

            sourceSize: numeralSize
            source: "../watchfaces-img/digital-shifted-" + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(0, 1) + ".png"

            anchors {
                top: parent.verticalCenter
                topMargin: topbottomMargin
                horizontalCenter: parent.horizontalCenter
            }

        }

        Image {
            id: bottomRight

            sourceSize: numeralSize
            source: "../watchfaces-img/digital-shifted-" + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(1, 2) + ".png"

            anchors {
                top: parent.verticalCenter
                topMargin: topbottomMargin
                left: bottomCenter.right
                leftMargin: leftrightMargin
            }

        }

        Text {
            id: dowDisplay

            z: 2
            visible: !displayAmbient
            font.pixelSize: parent.height * 0.06
            font.family: "Open Sans"
            font.styleName: "Condensed Light"
            font.letterSpacing: -parent.height * 0.0006
            color: "#ddffffff"
            horizontalAlignment: Text.AlignHCenter
            text: wallClock.time.toLocaleString(Qt.locale(), "dddd").toUpperCase()

            anchors {
                left: topCenter.right
                leftMargin: -parent.height * 0.01
                bottom: topCenter.bottom
                bottomMargin: -parent.height * 0.002
            }

        }

        Text {
            id: apDisplay

            z: 2
            visible: !displayAmbient
            font.pixelSize: parent.height * 0.1
            font.family: "Open Sans"
            font.styleName: "Light"
            font.letterSpacing: -parent.height * 0.006
            color: "#ddffffff"
            horizontalAlignment: Text.AlignHCenter
            text: wallClock.time.toLocaleString(Qt.locale(), "<b>ap</b>").toUpperCase()

            anchors {
                left: topCenter.right
                leftMargin: -parent.height * 0.01
                bottom: dowDisplay.top
                bottomMargin: -parent.height * 0.016
            }

        }

        Text {
            id: monthDisplay

            z: 2
            visible: !displayAmbient
            font.pixelSize: parent.height * 0.06
            font.family: "Open Sans"
            font.styleName: "Condensed Light"
            font.letterSpacing: -parent.height * 0.0006
            color: "#ddffffff"
            horizontalAlignment: Text.AlignHCenter
            text: wallClock.time.toLocaleString(Qt.locale(), "MMMM").toUpperCase()

            anchors {
                right: bottomCenter.left
                rightMargin: -parent.height * 0.002
                top: bottomCenter.top
                topMargin: -parent.height * 0.006
            }

        }

        Text {
            id: dayDisplay

            z: 2
            visible: !displayAmbient
            font.pixelSize: parent.height * 0.122
            font.family: "Open Sans"
            font.styleName: "Light"
            font.letterSpacing: -parent.height * 0.008
            color: "#ddffffff"
            horizontalAlignment: Text.AlignHCenter
            text: wallClock.time.toLocaleString(Qt.locale(), "dd").toUpperCase()

            anchors {
                right: bottomCenter.left
                rightMargin: -parent.height * 0.002
                top: monthDisplay.bottom
                topMargin: -parent.height * 0.032
            }

        }

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 24
            samples: 9
            color: "#bbdd00bb"
        }

    }

}
