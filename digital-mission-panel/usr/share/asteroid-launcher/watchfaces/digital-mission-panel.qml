// SPDX-FileCopyrightText: 2026 moWerk <github.com/moWerk>
// SPDX-License-Identifier: LGPL-2.1-or-later
// digital-mission-panel: complications driven digital watchface.
// Flight instrument flavour: MISSION TIME placard over a large digital readout,
// three boxed telemetry values (temperature, heart rate, steps), a caution stripe,
// the date and a power bar. Tap the BPM box to toggle the heart rate sensor.
// Companion of analog-ion-core-glow, abbreviated from analog-weather-glow.

import Nemo.Configuration
import Nemo.Mce
import QtQuick
import QtQuick.Shapes
import QtSensors
import org.asteroid.sensorlogd

Item {
    id: root

    property real rad: 0.01745
    property real maxSize: Math.min(width, height)
    // Every size below is a fraction of maxSize (the square face side) unless
    // noted, so one value here rescales every element that shares it.
    // The three panels (temp, heart rate, steps) are identical boxes. These
    // eleven drive all three together.
    property real panelWidth: 0.225
    property real panelHeight: 0.16
    property real panelOffsetX: 0.2425
    property real panelOffsetY: 0.038
    property real panelRadius: 0.015
    // Raw pixels, not a maxSize fraction, so it stays a crisp hairline at any
    // screen size. Make it maxSize relative if you want it to scale instead.
    property int panelBorder: 2
    property real panelBarWidth: 0.32
    property real panelBarHeight: 0.008
    property real panelBarInset: 0.09
    property real panelLabelSize: 0.034
    property real panelLabelSpacing: 0.005
    property real panelValueSize: 0.06
    // Fractions of a panel's own height, not of maxSize.
    property real panelLabelOffset: 0.22
    property real panelValueOffset: 0.18
    // Steps runs smaller so a five digit count stays inside its panel.
    property real stepsValueSize: 0.055
    // Time block. rightColumnX is shared by the seconds and AM/PM readouts.
    property real timeSize: 0.24
    property real timeOffsetX: 0.02
    property real timeOffsetY: 0.2
    property real rightColumnX: 0.325
    property real secondSize: 0.048
    property real secondOffsetY: 0.25
    property real apSize: 0.035
    property real apOffsetY: 0.185
    // Placard, separator, date
    property real placardSize: 0.03
    property real placardSpacing: 0.01
    property real placardOffset: 0.355
    property real separatorWidth: 0.64
    property real separatorHeight: 0.0025
    property real separatorOffset: 0.08
    property real dateSize: 0.0375
    property real dateSpacing: 0.01
    property real dateOffset: 0.2675
    // Battery bar and its label
    property real batteryBarWidth: 0.3
    property real batteryBarHeight: 0.015
    property real batteryBarOffset: 0.3325
    property real batteryLabelSize: 0.0275
    property real batteryLabelSpacing: 0.005
    property real batteryLabelOffset: 0.38
    // Caution stripe, fractions of its own box
    property real cautionStroke: 0.015
    property real cautionStartX: 0.325
    property real cautionEndX: 0.675
    property real cautionY: 0.695
    // Nightstand mode
    property real nightstandArcStroke: 0.016
    property real nightstandArcRadius: 0.39
    property real activeContentOpacity: !displayAmbient ? 0.95 : 0.7
    property real inactiveContentOpacity: !displayAmbient ? 0.5 : 0.5
    property string customAmber: "#FFC600"
    property string customGreen: "#26C485"
    property string customRed: "#DB5461"
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

    }

    Item {
        id: faceBox

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        Text {
            id: placardText

            color: "#ffffff"
            opacity: inactiveContentOpacity
            text: "MISSION TIME"

            anchors {
                centerIn: parent
                verticalCenterOffset: -root.maxSize * root.placardOffset
            }

            font {
                pixelSize: root.maxSize * root.placardSize
                family: "Titillium"
                styleName: "Bold"
                letterSpacing: root.maxSize * root.placardSpacing
            }

        }

        Text {
            id: timeDisplay

            color: "#ffffff"
            opacity: activeContentOpacity
            text: (use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) : wallClock.time.toLocaleString(Qt.locale(), "HH")) + ":" + wallClock.time.toLocaleString(Qt.locale(), "mm")

            anchors {
                centerIn: parent
                horizontalCenterOffset: -root.maxSize * root.timeOffsetX
                verticalCenterOffset: -root.maxSize * root.timeOffsetY
            }

            font {
                pixelSize: root.maxSize * root.timeSize
                family: "Titillium"
                styleName: "Thin"
            }

        }

        Text {
            id: secondDisplay

            color: customAmber
            opacity: activeContentOpacity
            visible: !displayAmbient
            text: wallClock.time.toLocaleString(Qt.locale(), "ss")

            anchors {
                centerIn: parent
                horizontalCenterOffset: root.maxSize * root.rightColumnX
                verticalCenterOffset: -root.maxSize * root.secondOffsetY
            }

            font {
                pixelSize: root.maxSize * root.secondSize
                family: "Titillium"
                styleName: "Bold"
            }

        }

        Text {
            id: apDisplay

            color: "#ffffff"
            opacity: inactiveContentOpacity
            visible: use12H.value
            text: wallClock.time.toLocaleString(Qt.locale(), "ap").toUpperCase()

            anchors {
                centerIn: parent
                horizontalCenterOffset: root.maxSize * root.rightColumnX
                verticalCenterOffset: -root.maxSize * root.apOffsetY
            }

            font {
                pixelSize: root.maxSize * root.apSize
                family: "Titillium"
                styleName: "Bold"
            }

        }

        Item {
            // Temperature telemetry box
            id: tempBox

            property bool weatherSynced: maxTemp.value != 0

            width: root.maxSize * root.panelWidth
            height: root.maxSize * root.panelHeight

            anchors {
                centerIn: parent
                horizontalCenterOffset: -root.maxSize * root.panelOffsetX
                verticalCenterOffset: root.maxSize * root.panelOffsetY
            }

            Rectangle {
                anchors.fill: parent
                radius: root.maxSize * root.panelRadius
                color: "#12ffffff"
                border.width: root.panelBorder
                border.color: "#40ffffff"
            }

            Rectangle {
                width: parent.width * root.panelBarWidth
                height: Math.max(1, root.maxSize * root.panelBarHeight)
                color: customAmber
                opacity: activeContentOpacity

                anchors {
                    top: parent.top
                    left: parent.left
                    leftMargin: parent.width * root.panelBarInset
                }

            }

            Text {
                color: customAmber
                opacity: inactiveContentOpacity
                text: "TEMP"

                anchors {
                    centerIn: parent
                    verticalCenterOffset: -parent.height * root.panelLabelOffset
                }

                font {
                    pixelSize: root.maxSize * root.panelLabelSize
                    family: "Titillium"
                    styleName: "Bold"
                    letterSpacing: root.maxSize * root.panelLabelSpacing
                }

            }

            Text {
                color: "#ffffff"
                opacity: activeContentOpacity
                text: tempBox.weatherSynced ? kelvinToTemperatureString(maxTemp.value) : "--°"

                anchors {
                    centerIn: parent
                    verticalCenterOffset: parent.height * root.panelValueOffset
                }

                font {
                    pixelSize: root.maxSize * root.panelValueSize
                    family: "Titillium"
                    styleName: "Regular"
                }

            }

        }

        Item {
            // Heart rate telemetry box. Tap toggles the sensor.
            id: hrmBox

            width: root.maxSize * root.panelWidth
            height: root.maxSize * root.panelHeight

            anchors {
                centerIn: parent
                verticalCenterOffset: root.maxSize * root.panelOffsetY
            }

            Rectangle {
                anchors.fill: parent
                radius: root.maxSize * root.panelRadius
                color: "#12ffffff"
                border.width: root.panelBorder
                border.color: hrmSensorActive ? customRed : "#40ffffff"
            }

            Rectangle {
                width: parent.width * root.panelBarWidth
                height: Math.max(1, root.maxSize * root.panelBarHeight)
                color: hrmSensorActive ? customRed : customAmber
                opacity: activeContentOpacity

                anchors {
                    top: parent.top
                    left: parent.left
                    leftMargin: parent.width * root.panelBarInset
                }

            }

            Text {
                color: hrmSensorActive ? customRed : customAmber
                opacity: hrmSensorActive ? activeContentOpacity : inactiveContentOpacity
                text: "BPM"

                anchors {
                    centerIn: parent
                    verticalCenterOffset: -parent.height * root.panelLabelOffset
                }

                font {
                    pixelSize: root.maxSize * root.panelLabelSize
                    family: "Titillium"
                    styleName: "Bold"
                    letterSpacing: root.maxSize * root.panelLabelSpacing
                }

            }

            Text {
                color: "#ffffff"
                opacity: hrmSensorActive ? activeContentOpacity : inactiveContentOpacity
                text: hrmBpm ? hrmBpm : "--"

                anchors {
                    centerIn: parent
                    verticalCenterOffset: parent.height * root.panelValueOffset
                }

                font {
                    pixelSize: root.maxSize * root.panelValueSize
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

        Item {
            // Steps telemetry box
            id: stepsBox

            width: root.maxSize * root.panelWidth
            height: root.maxSize * root.panelHeight

            anchors {
                centerIn: parent
                horizontalCenterOffset: root.maxSize * root.panelOffsetX
                verticalCenterOffset: root.maxSize * root.panelOffsetY
            }

            Rectangle {
                anchors.fill: parent
                radius: root.maxSize * root.panelRadius
                color: "#12ffffff"
                border.width: root.panelBorder
                border.color: "#40ffffff"
            }

            Rectangle {
                width: parent.width * root.panelBarWidth
                height: Math.max(1, root.maxSize * root.panelBarHeight)
                color: customAmber
                opacity: activeContentOpacity

                anchors {
                    top: parent.top
                    left: parent.left
                    leftMargin: parent.width * root.panelBarInset
                }

            }

            Text {
                color: customAmber
                opacity: inactiveContentOpacity
                text: "STEPS"

                anchors {
                    centerIn: parent
                    verticalCenterOffset: -parent.height * root.panelLabelOffset
                }

                font {
                    pixelSize: root.maxSize * root.panelLabelSize
                    family: "Titillium"
                    styleName: "Bold"
                    letterSpacing: root.maxSize * root.panelLabelSpacing
                }

            }

            Text {
                color: "#ffffff"
                opacity: activeContentOpacity
                text: root.stepCount

                anchors {
                    centerIn: parent
                    verticalCenterOffset: parent.height * root.panelValueOffset
                }

                font {
                    pixelSize: root.maxSize * root.stepsValueSize
                    family: "Titillium"
                    styleName: "Regular"
                }

            }

        }

        Shape {
            // Caution stripe drawn as a thick dashed line
            id: cautionStripe

            width: root.maxSize
            height: root.maxSize
            anchors.centerIn: parent
            opacity: !displayAmbient ? 0.75 : 0.35

            ShapePath {
                strokeColor: customAmber
                strokeWidth: root.maxSize * root.cautionStroke
                strokeStyle: ShapePath.DashLine
                dashPattern: [1.5, 1.17]
                fillColor: "transparent"
                startX: cautionStripe.width * root.cautionStartX
                startY: cautionStripe.height * root.cautionY

                PathLine {
                    x: cautionStripe.width * root.cautionEndX
                    y: cautionStripe.height * root.cautionY
                }

            }

        }

        Text {
            id: dateDisplay

            color: "#ffffff"
            opacity: !displayAmbient ? 0.8 : 0.5
            text: wallClock.time.toLocaleString(Qt.locale(), "ddd").slice(0, 3).toUpperCase() + " " + wallClock.time.toLocaleString(Qt.locale(), "dd") + " " + wallClock.time.toLocaleString(Qt.locale(), "MMM").slice(0, 3).toUpperCase()

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

        Rectangle {
            id: batteryBarBackground

            width: root.maxSize * root.batteryBarWidth
            height: root.maxSize * root.batteryBarHeight
            radius: height / 2
            color: "#26ffffff"
            visible: !nightstandMode.active

            anchors {
                centerIn: parent
                verticalCenterOffset: root.maxSize * root.batteryBarOffset
            }

            Rectangle {
                id: batteryBarFill

                width: parent.width * batteryChargePercentage.percent / 100
                height: parent.height
                radius: parent.radius
                color: batteryChargePercentage.percent < 30 ? customRed : batteryChargePercentage.percent < 60 ? customAmber : customGreen
                opacity: 0.85
            }

        }

        Text {
            id: batteryLabel

            color: "#ffffff"
            opacity: inactiveContentOpacity
            text: "PWR " + batteryChargePercentage.percent + "%"

            anchors {
                centerIn: parent
                verticalCenterOffset: root.maxSize * root.batteryLabelOffset
            }

            font {
                pixelSize: root.maxSize * root.batteryLabelSize
                family: "Titillium"
                styleName: "Bold"
                letterSpacing: root.maxSize * root.batteryLabelSpacing
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
