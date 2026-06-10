// SPDX-FileCopyrightText: 2026 Timo Könnecke <mo@mowerk.net>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later
// This watchface is a fan recreation of Jolla Oy's Sailfish Watch concept designs from 2016.
// Visual design elements (e.g., hand styles, strokes, shadows, and layout) are derived from
// Jolla's intellectual property as shown at https://blog.jolla.com/watch/.
// Used and distributed with explicit permission from Jolla Oy (granted by CEO Sami Pienimäki
// in 2026, with witnesses at FOSDEM).
// Permission is for non-commercial, community-driven distribution within the AsteroidOS
// unofficial-watchfaces repository.

import QtQuick

Item {
    id: root

    // invisible dark layer used as alpha mask source for the shader knockout effect
    Rectangle {
        id: layer2mask

        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.7)
        opacity: 0
        layer.enabled: true
    }

    Rectangle {
        id: _mask

        anchors.fill: layer2mask
        layer.enabled: true
        layer.samplerName: "maskSource"

        Text {
            renderType: Text.NativeRendering
            color: Qt.rgba(1, 1, 1, 1)
            text: wallClock.time.toLocaleString(Qt.locale(), "HH")

            font {
                pixelSize: parent.height * 0.66
                family: "Lexend"
                styleName: "Black"
            }

            anchors {
                top: parent.top
                topMargin: -parent.height * 0.16
                horizontalCenter: parent.horizontalCenter
            }

        }

        Text {
            renderType: Text.NativeRendering
            color: Qt.rgba(1, 1, 1, 1)
            text: wallClock.time.toLocaleString(Qt.locale(), "mm")

            font {
                pixelSize: parent.height * 0.66
                family: "Lexend"
                styleName: "Black"
            }

            anchors {
                bottom: parent.bottom
                bottomMargin: -parent.height * 0.16
                horizontalCenter: parent.horizontalCenter
            }

        }

        layer.effect: ShaderEffect {
            property variant source: layer2mask

            fragmentShader: "../watchfaces-img/sfos-style-three.qsb"
        }

    }

    // cyan ghost text visible through the knockout — gives the SFOS glow effect
    Text {
        renderType: Text.NativeRendering
        color: Qt.rgba(0, 0.937, 0.937, 0.4)
        text: wallClock.time.toLocaleString(Qt.locale(), "HH")

        font {
            pixelSize: parent.height * 0.66
            family: "Lexend"
            styleName: "Black"
        }

        anchors {
            top: parent.top
            topMargin: -parent.height * 0.16
            horizontalCenter: parent.horizontalCenter
        }

    }

    Text {
        renderType: Text.NativeRendering
        color: Qt.rgba(0, 0.937, 0.937, 0.4)
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")

        font {
            pixelSize: parent.height * 0.66
            family: "Lexend"
            styleName: "Black"
        }

        anchors {
            bottom: parent.bottom
            bottomMargin: -parent.height * 0.16
            horizontalCenter: parent.horizontalCenter
        }

    }

}
