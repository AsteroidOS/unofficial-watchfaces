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
 * Based on a fragmentShader example from doc.qt.io. Design is heavily
 * inspired by Jollas "The Bold Font" watchface. Battery readings thx to velox.
 */

import QtQuick 2.1
import org.freedesktop.contextkit 1.0
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0

Item {

    Rectangle {
        id: layer2mask
        width: parent.width; height: parent.height
        color: Qt.rgba(0, 0, 0, 0.8)
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
            property var voffset: parent.height*0.006
            renderType: Text.NativeRendering
            font.pixelSize: parent.height*0.58
            font.letterSpacing: -parent.width*0.06
            font.family: "League Spartan"
            font.styleName: "Bold"
            color: Qt.rgba(1, 1, 1, 1)
            y: parent.height/3-height/2+voffset
            x: -parent.width*0.077
            text: wallClock.time.toLocaleString(Qt.locale(), "<b>HH</b>").replace(/1/g,"&nbsp;1")
        }

        Text {
            property var voffset: parent.height*0.08
            renderType: Text.NativeRendering
            font.pixelSize: parent.height*0.58
            font.letterSpacing: -parent.width*0.07
            font.family: "League Spartan"
            font.styleName: "Bold"
            color: Qt.rgba(1, 1, 1, 1)
            y: parent.height/1.3-height/2+voffset
            x: parent.width*0.265
            text: wallClock.time.toLocaleString(Qt.locale(), "<b>mm</b>").replace(/1/g,"&nbsp;1")
        }

        Text {
            renderType: Text.NativeRendering
            font.pixelSize: parent.height*0.24
            font.letterSpacing: -parent.width*0.025
            font.family: "League Spartan"
            font.styleName: "Bold"
            color: Qt.rgba(1, 1, 1, 1)
            anchors {
                bottom: parent.verticalCenter
                bottomMargin: -parent.height*0.05
                left: parent.horizontalCenter
                leftMargin: parent.height*0.19
            }
            text: wallClock.time.toLocaleString(Qt.locale(), "<b>ss</b>").replace(/1/g,"&nbsp;1")
        }

        Text {
            renderType: Text.NativeRendering
            font.pixelSize: parent.height*0.08
            font.letterSpacing: -parent.width*0.01
            font.family: "League Spartan"
            font.styleName: "Bold"
            color: Qt.rgba(1, 1, 1, 1)
            horizontalAlignment: Text.AlignRight
            anchors {
                top: parent.verticalCenter
                topMargin: parent.height*0.02
                right: parent.horizontalCenter
                rightMargin: parent.height*0.25
            }
            text: "charge<br><b>" + batteryChargePercentage.value + "</b>%"
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

    ContextProperty {
        id: batteryChargePercentage
        key: "Battery.ChargePercentage"
        value: "100"
        Component.onCompleted: batteryChargePercentage.subscribe()
    }
}
