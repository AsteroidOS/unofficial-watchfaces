// SPDX-FileCopyrightText: 2026 moWerk <github.com/moWerk>
// SPDX-License-Identifier: LGPL-2.1-or-later
// analog-fancy-glow: complications driven analog watchface.
// A classy trio of hairline sub-dials: weather at nine, heart rate at three,
// steps at six with a condensed readout that stays inside the ring at five digits.
// Numeral 12 and a small date line on top, baton hands with lume dots, no second hand.
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

    property string imgPath: "../watchfaces-img/analog-fancy-glow-"
    property real rad: 0.01745
    property real maxSize: Math.min(width, height)
    // Every size below is a fraction of maxSize (the square face side) unless
    // noted, so one value here rescales every element that shares it.
    // Sub-dials: weather at nine, heart rate at three, steps at six. These four
    // drive all three dials together.
    property real dialRadius: 0.12
    property real dialOffset: 0.22
    property real dialHairline: 0.005
    property real dialValueSize: 0.06
    // Fractions of a sub-dial's own height, not of maxSize.
    property real dialIconOffset: 0.2
    property real dialValueOffset: 0.22
    // Glyph sizes: heart and steps share one, weather runs larger by design.
    property real dialIconSize: 0.075
    property real weatherIconSize: 0.085
    // Dial furniture
    property real numeralSize: 0.1
    property real numeralOffset: 0.39
    property real dateSize: 0.04
    property real dateLetterSpacing: 0.0075
    property real dateOffset: 0.3
    property real minuteDotSize: 0.01
    property real minuteDotOrbit: 0.45
    property real centerCapSize: 0.0275
    property real centerCapHairline: 0.004
    // Nightstand mode
    property real nightstandArcStroke: 0.016
    property real nightstandArcRadius: 0.39
    property real nightstandTextSize: 0.1
    property real nightstandTextOffset: 0.13
    property real activeArcOpacity: !displayAmbient ? 0.7 : 0.4
    property real inactiveArcOpacity: !displayAmbient ? 0.5 : 0.3
    property real activeContentOpacity: !displayAmbient ? 0.95 : 0.7
    property real inactiveContentOpacity: !displayAmbient ? 0.5 : 0.3
    property string customRed: "#DB5461"
    property string lumeColor: "#E8DCB9"
    property string hairlineColor: "#e6e6e6"
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
            // Minute dot track along the rim
            model: 60

            Rectangle {
                id: minuteDots

                property real rotM: (index - 15) / 60
                property real centerX: faceBox.width / 2 - width / 2
                property real centerY: faceBox.height / 2 - height / 2

                x: centerX + Math.cos(rotM * 2 * Math.PI) * faceBox.width * root.minuteDotOrbit
                y: centerY + Math.sin(rotM * 2 * Math.PI) * faceBox.width * root.minuteDotOrbit
                width: faceBox.width * root.minuteDotSize
                height: width
                radius: width / 2
                antialiasing: true
                color: "#ffffff"
                opacity: index === 0 ? 0.9 : 0.4
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
                family: "Raleway"
                styleName: "Light"
            }

        }

        Text {
            id: dateDisplay

            color: "#ffffff"
            opacity: inactiveContentOpacity
            text: wallClock.time.toLocaleString(Qt.locale(), "ddd").slice(0, 3).toUpperCase() + " " + wallClock.time.toLocaleString(Qt.locale(), "dd")

            anchors {
                centerIn: parent
                verticalCenterOffset: -root.maxSize * root.dateOffset
            }

            font {
                pixelSize: root.maxSize * root.dateSize
                family: "Noto Sans"
                styleName: "Bold"
                letterSpacing: root.maxSize * root.dateLetterSpacing
            }

        }

        Item {
            // Weather sub-dial at nine
            id: weatherBox

            property bool weatherSynced: maxTemp.value != 0

            width: root.maxSize * root.dialRadius * 2
            height: width

            anchors {
                centerIn: parent
                horizontalCenterOffset: -root.maxSize * root.dialOffset
            }

            Rectangle {
                id: weatherRing

                anchors.fill: parent
                radius: width / 2
                color: "transparent"
                opacity: inactiveArcOpacity
                border.width: root.maxSize * root.dialHairline
                border.color: hairlineColor
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
                    verticalCenterOffset: -parent.height * root.dialIconOffset
                }

            }

            Text {
                id: maxDisplay

                color: "#ffffff"
                opacity: activeContentOpacity
                text: weatherBox.weatherSynced ? kelvinToTemperatureString(maxTemp.value) : "--°"

                anchors {
                    centerIn: parent
                    verticalCenterOffset: parent.height * root.dialValueOffset
                }

                font {
                    pixelSize: root.maxSize * root.dialValueSize
                    family: "Raleway"
                    styleName: "Regular"
                }

            }

        }

        Item {
            // Heart rate sub-dial at three. Tap toggles the sensor.
            id: hrmBox

            width: root.maxSize * root.dialRadius * 2
            height: width
            visible: !displayAmbient || hrmSensorActive

            anchors {
                centerIn: parent
                horizontalCenterOffset: root.maxSize * root.dialOffset
            }

            Rectangle {
                id: hrmRing

                anchors.fill: parent
                radius: width / 2
                color: "transparent"
                opacity: hrmSensorActive ? activeArcOpacity : inactiveArcOpacity
                border.width: root.maxSize * root.dialHairline
                border.color: hrmSensorActive ? customRed : hairlineColor
            }

            Icon {
                id: heartPicture

                width: root.maxSize * root.dialIconSize
                height: width
                name: "ios-heart"
                opacity: hrmSensorActive ? activeContentOpacity : inactiveContentOpacity

                anchors {
                    centerIn: parent
                    verticalCenterOffset: -parent.height * root.dialIconOffset
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
                    verticalCenterOffset: parent.height * root.dialValueOffset
                }

                font {
                    pixelSize: root.maxSize * root.dialValueSize
                    family: "Raleway"
                    styleName: "Regular"
                }

            }

            MouseArea {
                anchors.fill: parent
                onClicked: hrmSensorActive = !hrmSensorActive
            }

        }

        Item {
            // Steps sub-dial at six
            id: stepsBox

            width: root.maxSize * root.dialRadius * 2
            height: width

            anchors {
                centerIn: parent
                verticalCenterOffset: root.maxSize * root.dialOffset
            }

            Rectangle {
                id: stepsRing

                anchors.fill: parent
                radius: width / 2
                color: "transparent"
                opacity: inactiveArcOpacity
                border.width: root.maxSize * root.dialHairline
                border.color: hairlineColor
            }

            Icon {
                // ios-walk is the expected pedestrian glyph, swap if the set names it differently
                id: stepsPicture

                width: root.maxSize * root.dialIconSize
                height: width
                name: "ios-walk"
                opacity: activeContentOpacity

                anchors {
                    centerIn: parent
                    verticalCenterOffset: -parent.height * root.dialIconOffset
                }

            }

            Text {
                id: stepsDisplay

                color: "#ffffff"
                opacity: activeContentOpacity
                text: root.stepCount

                anchors {
                    centerIn: parent
                    verticalCenterOffset: parent.height * root.dialValueOffset
                }

                font {
                    pixelSize: root.maxSize * root.dialValueSize
                    family: "Noto Sans"
                    styleName: "Condensed"
                }

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
                angle: wallClock.time.getMinutes() * 6
            }

        }

        Rectangle {
            id: centerCap

            width: root.maxSize * root.centerCapSize
            height: width
            radius: width / 2
            anchors.centerIn: parent
            color: "#141210"
            border.width: root.maxSize * root.centerCapHairline
            border.color: hairlineColor
        }

    }

    Connections {
        function onDisplayAmbientEntered() {
            hrmSensorActive = false;
        }

        target: compositor
    }

}
