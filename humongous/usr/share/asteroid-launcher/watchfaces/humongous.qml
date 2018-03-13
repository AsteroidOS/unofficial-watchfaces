/*
 * Copyright (C) 2018 - Timo Könnecke <el-t-mo@arcor.de>
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
 * Based on a qml fragmentshader example from http://doc.qt.io and
 * a well known pebble watchface design. Utillizing the great Item Font.
 */

import QtQuick 2.1

Item {

    Rectangle {
        id: layer2mask
        width: parent.width; height: parent.height
        color: Qt.rgba(0, 0, 0, 1)
        visible: true
        opacity: 0.0
        layer.enabled: true
        layer.smooth: true
    }

    Rectangle {
        id: _mask
        anchors.fill: layer2mask
        color: Qt.rgba(0, 1, 0, 0)
        visible: true

        Text {
            renderType: Text.NativeRendering
            font.pixelSize: parent.height*0.585
            font.letterSpacing: -parent.width*0.06
            font.family: "Item"
            font.styleName:"Black"
            color: Qt.rgba(1, 1, 1, 1)
            x: parent.width / 2 - width / 2.075
            y: parent.height / 2 - (height * 0.885)
            text: wallClock.time.toLocaleString(Qt.locale(), "HH")
        }

        Text {
            renderType: Text.NativeRendering
            font.pixelSize: parent.height*0.585
            font.letterSpacing: -parent.width*0.06
            font.family: "Item"
            font.styleName:"Black"
            color: Qt.rgba(1, 1, 1, 1)
            x: parent.width / 2 - width / 2.075
            y: parent.height / 2.65
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
}
