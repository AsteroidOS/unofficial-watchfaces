// SPDX-FileCopyrightText: 2026 moWerk <github.com/moWerk>
// SPDX-License-Identifier: LGPL-2.1-or-later
// analog-ion-core-glow: complications driven analog watchface.
// A glowing ion ring broken at the four cardinal points carries the complications
// inside its gaps: numeral 12 on top, weather right, heart rate left, two line date bottom.
// Steps are a green core ring hugging the hand pivot with a numeric readout below it.
// Abbreviated from analog-weather-glow.

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

    property string imgPath: "../watchfaces-img/analog-ion-core-glow-"
    property real rad: 0.01745
    property real maxSize: Math.min(width, height)
    // Every size below is a fraction of maxSize (the square face side) unless
    // noted, so one value here rescales every element that shares it.
    // Complications: weather on one side, heart rate on the other. These four
    // drive both of them together.
    property real complicationSize: 0.2
    property real complicationOffset: 0.3625
    property real complicationValueSize: 0.085
    property real complicationIconOffset: 0.1
    // Glyphs differ slightly by design, so they stay separate.
    property real weatherIconSize: 0.065
    property real heartIconSize: 0.06
    // Ion ring
    property real ionGlowStroke: 0.045
    property real ionRingStroke: 0.0225
    // Steps ring and its readout
    property real stepsRingSize: 0.5
    property real stepsRingHairline: 0.0075
    property real stepsArcStroke: 0.014
    property real stepsValueSize: 0.065
    property real stepsValueOffset: 0.132
    property real stepsLabelSize: 0.028
    property real stepsLabelOffset: 0.19
    property real stepsLabelSpacing: 0.006
    // Numeral and date. dayNameOffset shares a value with complicationOffset
    // today but is a different axis, so it stays its own knob.
    property real numeralSize: 0.1
    property real numeralOffset: 0.405
    property real dayNameSize: 0.0375
    property real dayNameOffset: 0.348
    property real dayNameSpacing: 0.0075
    property real dayNumberSize: 0.065
    property real dayNumberOffset: 0.4225
    // Hands
    property real centerCapSize: 0.03
    property real centerCapHairline: 0.005
    // Nightstand mode
    property real nightstandArcStroke: 0.016
    property real nightstandArcRadius: 0.25
    property real nightstandTextSize: 0.09
    property real nightstandTextOffset: 0.155
    property real activeArcOpacity: !displayAmbient ? 0.7 : 0.4
    property real inactiveArcOpacity: !displayAmbient ? 0.5 : 0.3
    property real activeContentOpacity: !displayAmbient ? 0.95 : 0.6
    property real inactiveContentOpacity: !displayAmbient ? 0.5 : 0.3
    property string customBlue: "#1E96FC"
    property string customGreen: "#26C485"
    property string customRed: "#DB5461"
    // Daily step goal used to scale the core ring
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

        // Wide low opacity arcs simulate the glow behind the ion ring.
        // Qt SVG has no blur filter, layered strokes are the canon safe way.
        Shape {
            id: ionRingGlow

            property real ringRadius: 0.425

            width: root.maxSize
            height: root.maxSize
            anchors.centerIn: parent
            opacity: !displayAmbient ? 0.25 : 0.12

            ShapePath {
                fillColor: "transparent"
                strokeColor: customBlue
                strokeWidth: root.maxSize * root.ionGlowStroke
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: ionRingGlow.width / 2
                    centerY: ionRingGlow.height / 2
                    radiusX: ionRingGlow.ringRadius * ionRingGlow.width
                    radiusY: ionRingGlow.ringRadius * ionRingGlow.height
                    startAngle: -71
                    sweepAngle: 52
                    moveToStart: true
                }

                PathAngleArc {
                    centerX: ionRingGlow.width / 2
                    centerY: ionRingGlow.height / 2
                    radiusX: ionRingGlow.ringRadius * ionRingGlow.width
                    radiusY: ionRingGlow.ringRadius * ionRingGlow.height
                    startAngle: 19
                    sweepAngle: 52
                    moveToStart: true
                }

                PathAngleArc {
                    centerX: ionRingGlow.width / 2
                    centerY: ionRingGlow.height / 2
                    radiusX: ionRingGlow.ringRadius * ionRingGlow.width
                    radiusY: ionRingGlow.ringRadius * ionRingGlow.height
                    startAngle: 109
                    sweepAngle: 52
                    moveToStart: true
                }

                PathAngleArc {
                    centerX: ionRingGlow.width / 2
                    centerY: ionRingGlow.height / 2
                    radiusX: ionRingGlow.ringRadius * ionRingGlow.width
                    radiusY: ionRingGlow.ringRadius * ionRingGlow.height
                    startAngle: 199
                    sweepAngle: 52
                    moveToStart: true
                }

            }

        }

        Shape {
            id: ionRing

            property real ringRadius: 0.425

            width: root.maxSize
            height: root.maxSize
            anchors.centerIn: parent
            opacity: activeArcOpacity

            ShapePath {
                fillColor: "transparent"
                strokeColor: customBlue
                strokeWidth: root.maxSize * root.ionRingStroke
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: ionRing.width / 2
                    centerY: ionRing.height / 2
                    radiusX: ionRing.ringRadius * ionRing.width
                    radiusY: ionRing.ringRadius * ionRing.height
                    startAngle: -71
                    sweepAngle: 52
                    moveToStart: true
                }

                PathAngleArc {
                    centerX: ionRing.width / 2
                    centerY: ionRing.height / 2
                    radiusX: ionRing.ringRadius * ionRing.width
                    radiusY: ionRing.ringRadius * ionRing.height
                    startAngle: 19
                    sweepAngle: 52
                    moveToStart: true
                }

                PathAngleArc {
                    centerX: ionRing.width / 2
                    centerY: ionRing.height / 2
                    radiusX: ionRing.ringRadius * ionRing.width
                    radiusY: ionRing.ringRadius * ionRing.height
                    startAngle: 109
                    sweepAngle: 52
                    moveToStart: true
                }

                PathAngleArc {
                    centerX: ionRing.width / 2
                    centerY: ionRing.height / 2
                    radiusX: ionRing.ringRadius * ionRing.width
                    radiusY: ionRing.ringRadius * ionRing.height
                    startAngle: 199
                    sweepAngle: 52
                    moveToStart: true
                }

            }

        }

        // Steps core ring background
        Rectangle {
            id: stepsRingBackground

            width: root.maxSize * root.stepsRingSize
            height: width
            radius: width / 2
            anchors.centerIn: parent
            color: "transparent"
            border.width: root.maxSize * root.stepsRingHairline
            border.color: "#24ffffff"
            visible: !nightstandMode.active
        }

        Shape {
            id: stepsArc

            property real angle: Math.min(root.stepCount / root.stepGoal, 1) * 360

            width: root.maxSize
            height: root.maxSize
            anchors.centerIn: parent
            opacity: activeArcOpacity
            visible: !nightstandMode.active

            ShapePath {
                fillColor: "transparent"
                strokeColor: customGreen
                strokeWidth: root.maxSize * root.stepsArcStroke
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: stepsArc.width / 2
                    centerY: stepsArc.height / 2
                    radiusX: 0.25 * stepsArc.width
                    radiusY: 0.25 * stepsArc.height
                    startAngle: -90
                    sweepAngle: stepsArc.angle
                    moveToStart: true
                }

            }

        }

        Text {
            id: stepsDisplay

            color: "#ffffff"
            opacity: activeContentOpacity
            visible: !nightstandMode.active
            text: root.stepCount

            anchors {
                centerIn: parent
                verticalCenterOffset: root.maxSize * root.stepsValueOffset
            }

            font {
                pixelSize: root.maxSize * root.dayNumberSize
                family: "League Spartan"
            }

        }

        Text {
            id: stepsLabel

            color: "#ffffff"
            opacity: inactiveContentOpacity
            visible: !nightstandMode.active
            text: "STEPS"

            anchors {
                centerIn: parent
                verticalCenterOffset: root.maxSize * root.stepsLabelOffset
            }

            font {
                pixelSize: root.maxSize * root.stepsLabelSize
                family: "Noto Sans"
                styleName: "Bold"
                letterSpacing: root.maxSize * root.stepsLabelSpacing
            }

        }

        Text {
            id: numeralTwelve

            color: "#ffffff"
            opacity: activeContentOpacity
            text: "12"

            anchors {
                centerIn: parent
                verticalCenterOffset: -root.maxSize * root.numeralOffset
            }

            font {
                pixelSize: root.maxSize * root.numeralSize
                family: "League Spartan"
            }

        }

        Item {
            // Weather complication inside the right ring gap
            id: weatherBox

            property bool weatherSynced: maxTemp.value != 0

            width: root.maxSize * root.complicationSize
            height: width

            anchors {
                centerIn: parent
                horizontalCenterOffset: root.maxSize * root.complicationOffset
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
                    verticalCenterOffset: -root.maxSize * root.complicationIconOffset
                }

            }

            Text {
                id: maxDisplay

                color: "#ffffff"
                opacity: activeContentOpacity
                text: weatherBox.weatherSynced ? kelvinToTemperatureString(maxTemp.value) : "--°"

                anchors {
                    centerIn: parent
                }

                font {
                    pixelSize: root.maxSize * root.complicationValueSize
                    family: "League Spartan"
                }

            }

        }

        Item {
            // Heart rate complication inside the left ring gap. Tap toggles the sensor.
            id: hrmBox

            width: root.maxSize * root.complicationSize
            height: width
            visible: !displayAmbient || hrmSensorActive

            anchors {
                centerIn: parent
                horizontalCenterOffset: -root.maxSize * root.complicationOffset
            }

            Icon {
                id: heartPicture

                width: root.maxSize * root.heartIconSize
                height: width
                name: "ios-heart"
                opacity: hrmSensorActive ? activeContentOpacity : inactiveContentOpacity

                anchors {
                    centerIn: parent
                    verticalCenterOffset: -root.maxSize * root.complicationIconOffset
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
                }

                font {
                    pixelSize: root.maxSize * root.complicationValueSize
                    family: "League Spartan"
                }

            }

            MouseArea {
                anchors.fill: parent
                onClicked: hrmSensorActive = !hrmSensorActive
            }

        }

        Text {
            id: dayName

            color: "#ffffff"
            opacity: inactiveContentOpacity
            text: wallClock.time.toLocaleString(Qt.locale(), "ddd").slice(0, 3).toUpperCase()

            anchors {
                centerIn: parent
                verticalCenterOffset: root.maxSize * root.dayNameOffset
            }

            font {
                pixelSize: root.maxSize * root.dayNameSize
                family: "Noto Sans"
                styleName: "Bold"
                letterSpacing: root.maxSize * root.dayNameSpacing
            }

        }

        Text {
            id: dayNumber

            color: "#ffffff"
            opacity: activeContentOpacity
            text: wallClock.time.toLocaleString(Qt.locale(), "dd").slice(0, 2)

            anchors {
                centerIn: parent
                verticalCenterOffset: root.maxSize * root.dayNumberOffset
            }

            font {
                pixelSize: root.maxSize * root.dayNumberSize
                family: "League Spartan"
            }

        }

    }

    Item {
        id: handBox

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        Image {
            id: hourSVG

            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            source: imgPath + "hour.svg"
            antialiasing: true
            smooth: true

            transform: Rotation {
                origin.x: hourSVG.width / 2
                origin.y: hourSVG.height / 2
                angle: (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * 0.5)
            }

        }

        Image {
            id: minuteSVG

            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            source: imgPath + "minute.svg"
            antialiasing: true
            smooth: true

            transform: Rotation {
                origin.x: minuteSVG.width / 2
                origin.y: minuteSVG.height / 2
                angle: (wallClock.time.getMinutes() * 6) + (wallClock.time.getSeconds() * 6 / 60)
            }

        }

        Image {
            id: secondSVG

            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            source: imgPath + "second.svg"
            antialiasing: true
            smooth: true
            visible: !displayAmbient && !nightstandMode.active

            transform: Rotation {
                origin.x: secondSVG.width / 2
                origin.y: secondSVG.height / 2
                angle: wallClock.time.getSeconds() * 6
            }

        }

        Rectangle {
            id: centerCap

            width: root.maxSize * root.centerCapSize
            height: width
            radius: width / 2
            anchors.centerIn: parent
            color: "#0a0f16"
            border.width: root.maxSize * root.centerCapHairline
            border.color: customBlue
        }

    }

    Connections {
        function onDisplayAmbientEntered() {
            hrmSensorActive = false;
        }

        target: compositor
    }

}
