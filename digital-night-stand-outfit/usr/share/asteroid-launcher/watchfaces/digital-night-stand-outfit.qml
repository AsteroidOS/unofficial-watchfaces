/*
 * Copyright (C) 2022 - Timo Könnecke <github.com/eLtMosen>
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

import QtQuick 2.1
import QtGraphicalEffects 1.15
import Nemo.Mce 1.0
import org.asteroid.controls 1.0

Item {
    id: root

    property real rad: 0.01745
    property string userColor: "#65AFFF" // green: #9BE564 / orange: #EA9010 / blue: #65AFFF

    MceBatteryLevel {
        id: batteryChargePercentage
    }

    anchors.centerIn: parent

    width: parent.width
    height: parent.height

    Item {
        id: batteryBox
        property int value: batteryChargePercentage.percent
        onValueChanged: batteryArc.requestPaint()
        anchors {
            centerIn: parent
        }
        width: parent.width * .85
        height: parent.height * .88

        Canvas {
            z: 1
            id: batteryArc
            anchors.fill: parent
            smooth: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.lineWidth = root.height * 0.009
                ctx.lineCap = "round"
                ctx.strokeStyle = userColor
                ctx.beginPath()
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * 0.456,
                        270 * rad,
                        ((batteryChargePercentage.percent/100*360)+270) * rad,
                        false
                        );
                ctx.stroke()
                ctx.closePath()
            }
        }

        Text {
            z: 2
            id: batteryDisplay
            anchors {
                centerIn: parent
                verticalCenterOffset: -root.height * .21
            }
            renderType: Text.NativeRendering
            font {
                pixelSize: root.height * .12
                family: "Outfit"
                styleName: "Light"
            }
            color: userColor
            text: batteryChargePercentage.percent + "%"
        }
    }

    Text {
        id: hourDisplay

        anchors {
            centerIn: root
            horizontalCenterOffset: -root.height * .15
        }
        renderType: Text.NativeRendering
        font {
            pixelSize: root.height * .22
            letterSpacing: root.height * .006
            family: "Outfit"
            styleName: "Medium"
        }
        color: userColor
        horizontalAlignment: Text.AlignHCenter
        text: use12H.value ?
                  wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) :
                  wallClock.time.toLocaleString(Qt.locale(), "HH")
    }

    Text {
        id: minuteDisplay

        anchors {
            centerIn: root
            horizontalCenterOffset: root.height * .15
        }
        renderType: Text.NativeRendering
        color: userColor
        horizontalAlignment: Text.AlignHCenter
        font {
            pixelSize: root.height * .22
            letterSpacing: root.height * .006
            family: "Outfit"
            styleName: "Light"
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    Text {
        id: monthDisplay

        anchors {
            centerIn: root
            verticalCenterOffset: root.height * .22
        }
        renderType: Text.NativeRendering
        color: userColor
        horizontalAlignment: Text.AlignHCenter
        font {
            pixelSize: root.height * .054
            letterSpacing: root.height * .006
            family: "Outfit"
            styleName: "Regular"
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "ddd MMM dd").replace(".","").toUpperCase() + "<br>" + wallClock.time.toLocaleString(Qt.locale(), "ap").toUpperCase()
    }

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 4
        verticalOffset: 4
        radius: 10.0
        samples: 21
        color: "#99000000"
    }
}
