// SPDX-FileCopyrightText: 2026 moWerk <github.com/moWerk>
// SPDX-License-Identifier: LGPL-2.1-or-later
// digital-cockpit: complications driven digital watchface.
// Cockpit instrument flavour: vertical tick scales left (power) and right (steps)
// with pointer needles, weather on top, a large digital readout in the center,
// the date below it and heart rate at the bottom. Tap the heart to toggle the sensor.
// Companion of analog-ion-core-glow, abbreviated from analog-weather-glow.

import Nemo.Configuration
import Nemo.Mce
import Qt5Compat.GraphicalEffects
// QtQuick must precede Qt5Compat.GraphicalEffects when ColorOverlay is used —
// GraphicalEffects types inherit from QtQuick.Item and require it to be loaded first.
import QtQuick
import QtQuick.Shapes
import QtSensors
import org.asteroid.controls
import org.asteroid.sensorlogd
import "weathericons.js" as WeatherIcons

Item {
    id: root

    property real rad: 0.01745
    property real maxSize: Math.min(width, height)
    // Every size below is a fraction of maxSize (the square face side), so one
    // value here rescales every element that shares it.
    // The two gauges are mirrored, so these seven drive both at once.
    property real gaugeWidth: 0.1
    property real gaugeLineX: 0.05
    property real gaugeHairline: 0.0075
    property real gaugeTickLength: 0.02
    property real gaugePointerHalf: 0.01
    property real gaugeLabelMargin: 0.025
    property real gaugeLabelSize: 0.03
    property real gaugeLabelSpacing: 0.005
    // Mirrored positions differ per side, so they stay separate.
    property real powerScaleX: 0.08
    property real powerTickX: 0.03
    property real powerPointerBaseX: 0.0625
    property real powerPointerTipX: 0.0875
    property real stepsScaleX: 0.82
    property real stepsTickX: 0.055
    property real stepsPointerBaseX: 0.0425
    property real stepsPointerTipX: 0.0175
    // Complications share a width, everything else about them differs.
    property real complicationWidth: 0.25
    property real weatherHeight: 0.1
    property real weatherOffset: 0.31
    property real weatherIconSize: 0.05
    property real weatherIconInset: 0.045
    property real weatherTextInset: 0.04
    property real weatherTextSize: 0.048
    property real hrmHeight: 0.22
    property real hrmOffset: 0.27
    property real hrmIconSize: 0.045
    property real hrmIconInset: 0.0575
    property real hrmTextInset: 0.035
    property real hrmTextSize: 0.045
    // Time and date
    property real timeSize: 0.23
    property real timeOffset: 0.0375
    property real dateSize: 0.035
    property real dateOffset: 0.1075
    property real dateSpacing: 0.01
    // Dial furniture
    property real hourStrokeWidth: 0.008
    property real hourStrokeHeight: 0.015
    // Nightstand mode
    property real nightstandArcStroke: 0.016
    property real nightstandArcRadius: 0.39
    property real nightstandTextSize: 0.1
    property real nightstandTextOffset: 0.28
    property real activeContentOpacity: !displayAmbient ? 0.95 : 0.6
    property real inactiveContentOpacity: !displayAmbient ? 0.5 : 0.3
    property real scaleOpacity: !displayAmbient ? 0.5 : 0.3
    property string customAmber: "#FFC600"
    property string customGreen: "#26C485"
    property string customRed: "#DB5461"
    property int stepGoal: 10000
    property int stepCount: 0
    property int hrmBpm: 0
    property bool hrmSensorActive: false
    property var hrmBpmTime: wallClock.time
    property int dayNb: 0

    function kelvinToTemperatureString(kelvin) {
        var celsius = (kelvin - 273);
        if (!useFahrenheit.value)
            return celsius + "°";
        else
            return Math.round(((celsius) * 9 / 5) + 32) + "°";
    }

    anchors.fill: parent

    MceBatteryState {
        id: batteryChargeState
    }

    MceBatteryLevel {
        id: batteryChargePercentage
    }

    ConfigurationValue {
        id: useFahrenheit

        key: "/org/asteroidos/settings/use-fahrenheit"
        defaultValue: false
    }

    ConfigurationValue {
        id: owmId

        key: "/org/asteroidos/weather/day" + dayNb + "/id"
        defaultValue: 0
    }

    ConfigurationValue {
        id: maxTemp

        key: "/org/asteroidos/weather/day" + dayNb + "/max-temp"
        defaultValue: 0
    }

    StepsDataLoader {
        id: stepsDataLoader

        Component.onCompleted: {
            stepsDataLoader.getTodayTotal();
            root.stepCount = stepsDataLoader.todayTotal;
        }
        onDataChanged: {
            stepsDataLoader.getTodayTotal();
            root.stepCount = stepsDataLoader.todayTotal;
        }
    }

    HrmSensor {
        active: !displayAmbient && hrmSensorActive
        onReadingChanged: {
            root.hrmBpm = reading.bpm;
            root.hrmBpmTime = wallClock.time;
        }
    }

    Item {
        id: nightstandMode

        readonly property bool active: nightstand

        anchors.fill: parent
        visible: nightstandMode.active

        Shape {
            id: chargeArc

            property real angle: batteryChargePercentage.percent * 360 / 100
            property real arcStrokeWidth: root.nightstandArcStroke
            property real scalefactor: root.nightstandArcRadius - (arcStrokeWidth / 2)
            property var chargecolor: Math.floor(batteryChargePercentage.percent / 33.35)
            readonly property var colorArray: ["red", "yellow", Qt.rgba(0.318, 1, 0.051, 0.9)]

            width: root.maxSize
            height: root.maxSize
            anchors.centerIn: parent

            ShapePath {
                fillColor: "transparent"
                strokeColor: chargeArc.colorArray[chargeArc.chargecolor]
                strokeWidth: chargeArc.height * chargeArc.arcStrokeWidth
                capStyle: ShapePath.RoundCap
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

        Text {
            id: batteryDockPercent

            color: chargeArc.colorArray[chargeArc.chargecolor]
            style: Text.Outline
            styleColor: "#80000000"
            text: batteryChargePercentage.percent

            anchors {
                centerIn: parent
                verticalCenterOffset: root.maxSize * root.nightstandTextOffset
            }

            font {
                pixelSize: root.maxSize * root.nightstandTextSize
                family: "Noto Sans"
                styleName: "Condensed"
            }

        }

    }

    Item {
        id: faceBox

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        Repeater {
            // Twelve hour markers along the rim
            model: 12

            Rectangle {
                id: hourStrokes

                property real rotM: ((index * 5) - 15) / 60
                property real centerX: faceBox.width / 2 - width / 2
                property real centerY: faceBox.height / 2 - height / 2

                x: centerX + Math.cos(rotM * 2 * Math.PI) * faceBox.width * 0.48
                y: centerY + Math.sin(rotM * 2 * Math.PI) * faceBox.width * 0.48
                antialiasing: true
                color: "#ffffff"
                opacity: 0.3
                width: faceBox.width * root.hourStrokeWidth
                height: faceBox.height * root.hourStrokeHeight

                transform: Rotation {
                    origin.x: hourStrokes.width / 2
                    origin.y: hourStrokes.height / 2
                    angle: index * 30
                }

            }

        }

        Item {
            // Left instrument scale showing battery level
            id: powerScale

            property real scaleTop: 0.3
            property real scaleHeight: 0.4

            width: root.maxSize * root.gaugeWidth
            height: root.maxSize
            x: root.maxSize * root.powerScaleX

            Rectangle {
                id: powerScaleLine

                x: root.maxSize * root.gaugeLineX
                y: root.maxSize * powerScale.scaleTop
                width: Math.max(1, root.maxSize * root.gaugeHairline)
                height: root.maxSize * powerScale.scaleHeight
                color: "#ffffff"
                opacity: scaleOpacity
            }

            Repeater {
                model: 6

                Rectangle {
                    x: root.maxSize * root.powerTickX
                    y: root.maxSize * (powerScale.scaleTop + index * powerScale.scaleHeight / 5) - height / 2
                    width: root.maxSize * root.gaugeTickLength
                    height: Math.max(1, root.maxSize * root.gaugeHairline)
                    color: "#ffffff"
                    opacity: scaleOpacity
                }

            }

            Shape {
                id: powerPointer

                property real pointerY: root.maxSize * (powerScale.scaleTop + powerScale.scaleHeight * (1 - batteryChargePercentage.percent / 100))

                width: root.maxSize * root.gaugeWidth
                height: root.maxSize
                opacity: activeContentOpacity

                ShapePath {
                    fillColor: batteryChargePercentage.percent < 30 ? customRed : customAmber
                    strokeColor: "transparent"
                    startX: root.maxSize * root.powerPointerBaseX
                    startY: powerPointer.pointerY

                    PathLine {
                        x: root.maxSize * root.powerPointerTipX
                        y: powerPointer.pointerY - root.maxSize * root.gaugePointerHalf
                    }

                    PathLine {
                        x: root.maxSize * root.powerPointerTipX
                        y: powerPointer.pointerY + root.maxSize * root.gaugePointerHalf
                    }

                    PathLine {
                        x: root.maxSize * root.powerPointerBaseX
                        y: powerPointer.pointerY
                    }

                }

            }

            Text {
                color: "#ffffff"
                opacity: inactiveContentOpacity
                text: "PWR"

                anchors {
                    horizontalCenter: powerScaleLine.horizontalCenter
                    top: powerScaleLine.bottom
                    topMargin: root.maxSize * root.gaugeLabelMargin
                }

                font {
                    pixelSize: root.maxSize * root.gaugeLabelSize
                    family: "Titillium"
                    styleName: "Bold"
                    letterSpacing: root.maxSize * root.gaugeLabelSpacing
                }

            }

        }

        Item {
            // Right instrument scale showing step goal progress
            id: stepsScale

            property real scaleTop: 0.3
            property real scaleHeight: 0.4
            property real stepsRatio: Math.min(root.stepCount / root.stepGoal, 1)

            width: root.maxSize * root.gaugeWidth
            height: root.maxSize
            x: root.maxSize * root.stepsScaleX

            Rectangle {
                id: stepsScaleLine

                x: root.maxSize * root.gaugeLineX
                y: root.maxSize * stepsScale.scaleTop
                width: Math.max(1, root.maxSize * root.gaugeHairline)
                height: root.maxSize * stepsScale.scaleHeight
                color: "#ffffff"
                opacity: scaleOpacity
            }

            Repeater {
                model: 6

                Rectangle {
                    x: root.maxSize * root.stepsTickX
                    y: root.maxSize * (stepsScale.scaleTop + index * stepsScale.scaleHeight / 5) - height / 2
                    width: root.maxSize * root.gaugeTickLength
                    height: Math.max(1, root.maxSize * root.gaugeHairline)
                    color: "#ffffff"
                    opacity: scaleOpacity
                }

            }

            Shape {
                id: stepsPointer

                property real pointerY: root.maxSize * (stepsScale.scaleTop + stepsScale.scaleHeight * (1 - stepsScale.stepsRatio))

                width: root.maxSize * root.gaugeWidth
                height: root.maxSize
                opacity: activeContentOpacity

                ShapePath {
                    fillColor: customGreen
                    strokeColor: "transparent"
                    startX: root.maxSize * root.stepsPointerBaseX
                    startY: stepsPointer.pointerY

                    PathLine {
                        x: root.maxSize * root.stepsPointerTipX
                        y: stepsPointer.pointerY - root.maxSize * root.gaugePointerHalf
                    }

                    PathLine {
                        x: root.maxSize * root.stepsPointerTipX
                        y: stepsPointer.pointerY + root.maxSize * root.gaugePointerHalf
                    }

                    PathLine {
                        x: root.maxSize * root.stepsPointerBaseX
                        y: stepsPointer.pointerY
                    }

                }

            }

            Text {
                color: "#ffffff"
                opacity: inactiveContentOpacity
                text: "STP"

                anchors {
                    horizontalCenter: stepsScaleLine.horizontalCenter
                    top: stepsScaleLine.bottom
                    topMargin: root.maxSize * root.gaugeLabelMargin
                }

                font {
                    pixelSize: root.maxSize * root.gaugeLabelSize
                    family: "Titillium"
                    styleName: "Bold"
                    letterSpacing: root.maxSize * root.gaugeLabelSpacing
                }

            }

        }

        Item {
            // Weather complication on top
            id: weatherBox

            property bool weatherSynced: maxTemp.value != 0

            width: root.maxSize * root.complicationWidth
            height: root.maxSize * root.weatherHeight

            anchors {
                centerIn: parent
                verticalCenterOffset: -root.maxSize * root.weatherOffset
            }

            Icon {
                id: iconDisplay

                width: root.maxSize * root.weatherIconSize
                height: width
                opacity: activeContentOpacity
                visible: weatherBox.weatherSynced
                name: WeatherIcons.getIconName(owmId.value)

                anchors {
                    centerIn: parent
                    horizontalCenterOffset: -root.maxSize * root.weatherIconInset
                }

            }

            Text {
                color: "#ffffff"
                opacity: activeContentOpacity
                text: weatherBox.weatherSynced ? kelvinToTemperatureString(maxTemp.value) : "--°"

                anchors {
                    centerIn: parent
                    horizontalCenterOffset: root.maxSize * root.weatherTextInset
                }

                font {
                    pixelSize: root.maxSize * root.weatherTextSize
                    family: "Titillium"
                    styleName: "Regular"
                }

            }

        }

        Text {
            id: timeDisplay

            color: "#ffffff"
            opacity: activeContentOpacity
            text: (use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) : wallClock.time.toLocaleString(Qt.locale(), "HH")) + ":" + wallClock.time.toLocaleString(Qt.locale(), "mm")

            anchors {
                centerIn: parent
                verticalCenterOffset: -root.maxSize * root.timeOffset
            }

            font {
                pixelSize: root.maxSize * root.timeSize
                family: "Titillium"
                styleName: "Thin"
            }

        }

        Text {
            id: dateDisplay

            color: "#ffffff"
            opacity: inactiveContentOpacity
            text: wallClock.time.toLocaleString(Qt.locale(), "ddd").slice(0, 3).toUpperCase() + " " + wallClock.time.toLocaleString(Qt.locale(), "dd") + " " + wallClock.time.toLocaleString(Qt.locale(), "MMM").slice(0, 3).toUpperCase() + (use12H.value ? " " + wallClock.time.toLocaleString(Qt.locale(), "ap").toUpperCase() : "")

            anchors {
                centerIn: parent
                verticalCenterOffset: root.maxSize * root.dateOffset
            }

            font {
                pixelSize: root.maxSize * root.dateSize
                family: "Titillium"
                styleName: "Bold"
                letterSpacing: root.maxSize * root.dateSpacing
            }

        }

        Item {
            // Heart rate complication at the bottom. Tap toggles the sensor.
            id: hrmBox

            width: root.maxSize * root.complicationWidth
            height: root.maxSize * root.hrmHeight
            visible: !displayAmbient || hrmSensorActive

            anchors {
                centerIn: parent
                verticalCenterOffset: root.maxSize * root.hrmOffset
            }

            Icon {
                id: heartPicture

                width: root.maxSize * root.hrmIconSize
                height: width
                name: "ios-heart"
                opacity: hrmSensorActive ? activeContentOpacity : inactiveContentOpacity

                anchors {
                    centerIn: parent
                    horizontalCenterOffset: -root.maxSize * root.hrmIconInset
                }

            }

            ColorOverlay {
                anchors.fill: heartPicture
                source: heartPicture
                visible: hrmSensorActive
                color: customRed
            }

            Text {
                id: bpmDisplay

                color: "#ffffff"
                opacity: hrmSensorActive ? activeContentOpacity : inactiveContentOpacity
                text: hrmBpm ? hrmBpm : "--"

                anchors {
                    centerIn: parent
                    horizontalCenterOffset: root.maxSize * root.hrmTextInset
                }

                font {
                    pixelSize: root.maxSize * root.hrmTextSize
                    family: "Titillium"
                    styleName: "Regular"
                }

            }

            MouseArea {
                anchors.fill: parent
                enabled: !displayAmbient && !nightstandMode.active
                onClicked: hrmSensorActive = !hrmSensorActive
            }

        }

    }

    Connections {
        function onDisplayAmbientEntered() {
            hrmSensorActive = false;
        }

        target: compositor
    }

}
