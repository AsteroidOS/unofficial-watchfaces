// SPDX-FileCopyrightText: 2022 Ed Beroset <github.com/beroset>
// SPDX-License-Identifier: LGPL-2.1-or-later

import Nemo.Mce
import QtQuick
import QtQuick.Shapes
import org.asteroid.controls
import org.asteroid.utils

Item {
    id: root

    anchors.fill: parent
    Component.onCompleted: {
        datetext.text = wallClock.time.toLocaleString(Qt.locale(), "ddd dd");
        time.text = wallClock.time.toLocaleString(Qt.locale(), use12H.value ? "hhmm ap" : "HHmm").slice(0, 4);
        ampm.text = wallClock.time.toLocaleString(Qt.locale(), "ap");
    }

    Item {
        id: faceBox

        width: Math.min(parent.width, parent.height)
        height: width
        anchors.centerIn: parent

        Icon {
            id: batteryIcon

            name: "ios-battery-charging"
            visible: batteryChargeState.value === MceBatteryState.Charging
            width: parent.width * 0.2
            height: parent.height * 0.2
            opacity: displayAmbient ? 0.4 : 0.9

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.height * 0.272
            }

        }

        Text {
            id: datetext

            color: "white"
            text: wallClock.time.toLocaleString(Qt.locale(), "ddd dd")

            anchors {
                centerIn: parent
                verticalCenterOffset: parent.height * 0.25
            }

            font {
                family: "Titillium"
                weight: Font.Thin
                pixelSize: parent.height * 0.06
            }

        }

        Text {
            id: time

            color: "white"
            text: wallClock.time.toLocaleString(Qt.locale(), (use12H.value ? "hhmm ap" : "HHmm")).slice(0, 4)

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.height * 0.02
            }

            font {
                family: "Titillium"
                weight: Font.Thin
                pixelSize: parent.height * 0.3
            }

        }

        Text {
            id: ampm

            visible: use12H.value
            color: "white"
            text: wallClock.time.toLocaleString(Qt.locale(), "ap")

            anchors {
                centerIn: parent
                verticalCenterOffset: parent.height * 0.143
            }

            font {
                family: "Titillium"
                weight: Font.Bold
                pixelSize: parent.height * 0.05
            }

        }

        Shape {
            id: chargeArc

            property real angle: batteryChargePercentage.percent * 360 / 100
            // radius of arc is scalefactor * height or width
            property real scalefactor: 0.46
            property int chargecolor: Math.floor(batteryChargePercentage.percent / 33.35)
            readonly property var colorArray: ["red", "yellow", Qt.rgba(0.318, 1, 0.051, 0.9)]

            visible: true // batteryChargeState.value == MceBatteryState.Charging
            opacity: displayAmbient ? 0.5 : 1
            anchors.fill: parent

            ShapePath {
                fillColor: "transparent"
                strokeColor: chargeArc.colorArray[chargeArc.chargecolor]
                strokeWidth: chargeArc.height * 0.02
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin
                startX: chargeArc.width / 2
                startY: chargeArc.height * (0.5 - chargeArc.scalefactor)

                PathAngleArc {
                    centerX: chargeArc.width / 2
                    centerY: chargeArc.height / 2
                    radiusX: chargeArc.scalefactor * chargeArc.width
                    radiusY: chargeArc.scalefactor * chargeArc.height
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

    Connections {
        function onTimeChanged() {
            if (!visible)
                return ;

            datetext.text = wallClock.time.toLocaleString(Qt.locale(), "ddd dd");
            time.text = wallClock.time.toLocaleString(Qt.locale(), use12H.value ? "hhmm ap" : "HHmm").slice(0, 4);
            ampm.text = wallClock.time.toLocaleString(Qt.locale(), "ap");
        }

        target: wallClock
    }

}
