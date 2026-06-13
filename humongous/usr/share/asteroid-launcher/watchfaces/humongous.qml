// SPDX-FileCopyrightText: 2018 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later
// Based on a well known Pebble watchface design using the Item font.
// Fragment shader cuts a dark overlay using giant digit layers as a knockout mask.

import QtQuick

Item {
    Rectangle {
        id: layer2mask

        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 1)
        opacity: 0
        layer.enabled: true
    }

    Rectangle {
        id: _mask

        anchors.fill: layer2mask
        color: Qt.rgba(0, 1, 0, 0)
        layer.enabled: true
        layer.samplerName: "maskSource"

        Text {
            renderType: Text.NativeRendering
            color: Qt.rgba(1, 1, 1, 1)
            x: parent.width / 2 - width / 2.075
            y: parent.height / 2 - (height * 0.885)
            text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) : wallClock.time.toLocaleString(Qt.locale(), "HH")

            font {
                pixelSize: parent.height * 0.585
                letterSpacing: -parent.width * 0.06
                family: "Item"
                styleName: "Black"
            }

        }

        Text {
            renderType: Text.NativeRendering
            color: Qt.rgba(1, 1, 1, 1)
            x: parent.width / 2 - width / 2.075
            y: parent.height / 2.65
            text: wallClock.time.toLocaleString(Qt.locale(), "mm")

            font {
                pixelSize: parent.height * 0.585
                letterSpacing: -parent.width * 0.06
                family: "Item"
                styleName: "Black"
            }

        }

        layer.effect: ShaderEffect {
            property variant source: layer2mask

            fragmentShader: "../watchfaces-img/humongous.qsb"
        }

    }

}
