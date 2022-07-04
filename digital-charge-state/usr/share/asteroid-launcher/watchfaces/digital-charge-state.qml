/*
 * Copyright (C) 2022 - Ed Beroset <github.com/beroset>
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

import QtQuick 2.15
import QtQuick.Shapes 1.15
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0
import Nemo.Mce 1.0

Item {

    Icon {
        id: batteryIcon
        name: "ios-battery-charging"
        visible: batteryChargeState.value === MceBatteryState.Charging
        anchors {
            centerIn: parent
            verticalCenterOffset: -parent.height * 0.272
        }
        width: parent.width * 0.2
        height: parent.height * 0.2
        opacity: displayAmbient ? 0.4 : 0.9
    }

    Text {
        id: datetext
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.height * 0.25 
        }
        font {
            family: "Titillium"
            weight: Font.Thin
            pixelSize: parent.height * 0.06
        }
        color: "white"
        text: wallClock.time.toLocaleString(Qt.locale(), "ddd dd");
    }

    Text {
        id: time
        anchors.centerIn: parent
        font {
            family: "Titillium"
            weight: Font.Thin
            pixelSize: parent.height * 0.30
        }
        color: "white"
        text: wallClock.time.toLocaleString(Qt.locale(), (use12H.value ? "hhmm ap" : "HHmm")).slice(0,4);
    }

    Text {
        id: ampm
        visible: use12H.value
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.height * 0.143
        }
        font {
            family: "Titillium"
            weight: Font.Bold
            pixelSize: parent.height * 0.05
        }
        color: "white"
        text: wallClock.time.toLocaleString(Qt.locale(), "ap");
    }


    Shape {
        id: chargeArc
        property real angle: batteryChargePercentage.percent * 360 / 100
        // radius of arc is scalefactor * height or width
        property real scalefactor: 0.46
        property var chargecolor: Math.floor(batteryChargePercentage.percent / 33.35)
        visible: true // batteryChargeState.value == MceBatteryState.Charging
        opacity: displayAmbient ? 0.5 : 1.0
        anchors.fill: parent
        smooth: true
        readonly property var colorArray: [ "red", "yellow", Qt.rgba(0.318, 1, 0.051, 0.9)]
        ShapePath {
            fillColor: "transparent"
            strokeColor: chargeArc.colorArray[chargeArc.chargecolor]
            strokeWidth: parent.height * 0.02
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            startX: width / 2
            startY: height * ( 0.5 - chargeArc.scalefactor)
            PathAngleArc {
                centerX: parent.width / 2
                centerY: parent.height / 2
                radiusX: chargeArc.scalefactor * parent.width 
                radiusY: chargeArc.scalefactor * parent.height
                startAngle: -90
                sweepAngle: chargeArc.angle
                moveToStart: false
            }
        }
    }

    MceBatteryLevel {
        id: batteryChargePercentage
    }

    MceBatteryState {
        id: batteryChargeState
    } 
}
