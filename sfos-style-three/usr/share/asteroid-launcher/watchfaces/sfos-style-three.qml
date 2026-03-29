/*
 * Copyright (C) 2026 - Timo Könnecke <mo@mowerk.net>
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

/*
 * This watchface is a fan recreation of Jolla Oy's Sailfish Watch concept designs from 2016.
 * Visual design elements (e.g., hand styles, strokes, shadows, and layout) are derived from Jolla's intellectual property as shown at https://blog.jolla.com/watch/.
 * Used and distributed with explicit permission from Jolla Oy (granted by CEO Sami Pienimäki in 2026, with witnesses at FOSDEM).
 * Permission is for non-commercial, community-driven distribution within the AsteroidOS unofficial-watchfaces repository.
 */

import QtQuick 2.1

Item {

    Rectangle {
        id: layer2mask
        width: parent.width; height: parent.height
        color: Qt.rgba(0, 0, 0, 0.7)
        visible: true
        opacity: 0.0
        layer.enabled: true
        layer.smooth: true
    }

    Rectangle {
        id: _mask
        anchors.fill: layer2mask
        color: Qt.rgba(0, 0, 0, 0)
        visible: true

        Text {
            renderType: Text.NativeRendering
            font.pixelSize: parent.height*0.66
            font.family: "Lexend"
            font.styleName: "Black"
            color: Qt.rgba(1, 1, 1, 1)
            anchors.top: parent.top
            anchors.topMargin: -parent.height*0.16
            anchors.horizontalCenter: parent.horizontalCenter
            text: wallClock.time.toLocaleString(Qt.locale(), "HH")
        }

        Text {
            renderType: Text.NativeRendering
            font.pixelSize: parent.height*0.66
            font.family: "Lexend"
            font.styleName: "Black"
            color: Qt.rgba(1, 1, 1, 1)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -parent.height*0.16
            anchors.horizontalCenter: parent.horizontalCenter
            text: wallClock.time.toLocaleString(Qt.locale(), "mm")
        }

        layer.enabled: true
        layer.samplerName: "maskSource"
        layer.effect: ShaderEffect {
            property variant source: layer2mask
            fragmentShader: "
                    varying highp vec2 qt_TexCoord0;
                    uniform highp float qt_Opacity;
                    uniform lowp sampler2D source;
                    uniform lowp sampler2D maskSource;
                    void main(void) {
                        gl_FragColor = texture2D(source, qt_TexCoord0.st) * (1.0-texture2D(maskSource, qt_TexCoord0.st).a) * qt_Opacity;
                    }
                "
        }
    }

    Text {
        renderType: Text.NativeRendering
        font.pixelSize: parent.height*0.66
        font.family: "Lexend"
        font.styleName: "Black"
        color: Qt.rgba(0, 0.937, 0.937, 0.4)
        anchors.top: parent.top
        anchors.topMargin: -parent.height*0.16
        anchors.horizontalCenter: parent.horizontalCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "HH")
    }

    Text {
        renderType: Text.NativeRendering
        font.pixelSize: parent.height*0.66
        font.family: "Lexend"
        font.styleName: "Black"
        color: Qt.rgba(0, 0.937, 0.937, 0.4)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -parent.height*0.16
        anchors.horizontalCenter: parent.horizontalCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }
}
