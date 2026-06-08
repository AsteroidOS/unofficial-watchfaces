// SPDX-FileCopyrightText: 2021 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: LGPL-2.1-or-later

import Qt5Compat.GraphicalEffects
import QtQuick

Item {
    id: root

    property real maxSize: Math.min(width, height)
    property real topbottomMargin: maxSize * 0.0086
    property real leftrightMargin: -maxSize * 0.048
    property size numeralSize: Qt.size(maxSize * 0.25, maxSize * 0.25)
    property real arcEnd: wallClock.time.getSeconds() * 6

    anchors.fill: parent
    onArcEndChanged: canvas.requestPaint()

    Image {
        id: ring

        z: 0
        visible: !displayAmbient
        source: "../watchfaces-img/digital-shifted-ring.svg"
        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent
    }

    Canvas {
        id: canvas

        visible: !displayAmbient
        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent
        rotation: -90
        onPaint: {
            var ctx = getContext("2d");
            var x = width / 2;
            var y = height / 2;
            var start = 0;
            var end = Math.PI * (root.arcEnd / 180);
            ctx.reset();
            ctx.beginPath();
            ctx.lineCap = "round";
            ctx.arc(x, y, (width / 2) - height * 0.124 / 2, start, end, false);
            ctx.lineWidth = height * 0.03;
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
        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent
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
