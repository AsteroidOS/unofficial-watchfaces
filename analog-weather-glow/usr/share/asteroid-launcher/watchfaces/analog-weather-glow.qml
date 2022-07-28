/*
 * Copyright (C) 2022 - Timo Könnecke <github.com/eLtMosen>
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

import QtQuick 2.9
import QtSensors 5.11
import QtGraphicalEffects 1.15
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0
import Nemo.Configuration 1.0
import Nemo.Mce 1.0
import Connman 0.2
import 'weathericons.js' as WeatherIcons

Item {
    id: root

    anchors.fill: parent

    property string imgPath: "../watchfaces-img/analog-weather-glow-"

    // Radian per degree used by all canvas arcs
    property real rad: .01745

    // Element sizes, linewidth and opacity
    property real switchSize: root.width * .1375
    property real boxSize: root.width * .35
    property real switchPosition: root.width * .27
    property real boxPosition: root.width * .25
    property real innerArcLineWidth: root.height * .008
    property real outerArcLineWidth: root.height * .016
    property real activeArcOpacity: !displayAmbient ? .7 : .4
    property real inactiveArcOpacity: !displayAmbient ? .5 : .3
    property real activeContentOpacity: !displayAmbient ? .95 : .6
    property real inactiveContentOpacity: !displayAmbient ? .5 : .3

    // Color definition
    property string customRed: "#DB5461" // Indian Red "#FF595E" // Red Salsa
    property string customBlue: "#1E96FC" // Dodger Blue
    property string customGreen: "#26C485" // Ocean Green "#5EFC8D" // Spring Green
    property string customOrange: "#FFC600" // Mikado Yellow
    property string boxColor: "#E8DCB9" // Dutch White
    property string switchColor: "#A2D6F9" // Uranian Blue

    // HRM initialisation. Needs to be declared global since hrmBox and hrmSwitch both need it.
    property int hrmBpm: 0
    property bool hrmSensorActive: false
    property var hrmUpdated: wallClock.time

    // Set day to use in the weatherBox to today.
    property int dayNb: 0

    function kelvinToTemperatureString(kelvin) {
        var celsius = (kelvin - 273);
        if(!useFahrenheit.value)
            return celsius + "°";
        else
            return Math.round(((celsius) * 9 / 5) + 32) + "°";
    }

    // Prepare for feature where the secondary hardware button activates HRM mode.
    // Keycode 134 = Sawfish lower button.
    /*Keys.onPressed: {
        if (event.keyCode === 134) {
            hrmSensorActive = !hrmSensorActive
        }
    }*/

    // Request the heart rate related arcs to be repainted when hrm sensor is toggled.
    onHrmSensorActiveChanged: {
        hrmArc.requestPaint()
        hrmSwitchArc.requestPaint()
    }

    Repeater {
        // Hour numerals. hourModeSwitch toggles the 12/24hour display.
        model: 12

        Text {
            id: hourNumbers

            property real rotM: ((index * 5) - 15) / 60
            property real centerX: root.width / 2 - width / 2
            property real centerY: root.height / 2 - height / 2

            antialiasing : true
            font {
                pixelSize: root.height * .06
                family: "Noto Sans"
                styleName: "Bold"
            }
            x: centerX + Math.cos(rotM * 2 * Math.PI) * root.width * .46
            y: centerY + Math.sin(rotM * 2 * Math.PI) * root.width * .46
            color: hourSVG.toggle24h && index === 0 ? customGreen : "white"
            opacity: inactiveContentOpacity
            visible: !displayAmbient
            text: hourSVG.toggle24h ?
                      index === 0 ? 24 : index * 2 :
                      index === 0 ? 12 : index

            transform: Rotation {
                origin.x: width / 2
                origin.y: height / 2
                angle: index === 6 ?
                           0 :
                           ([4, 5, 7, 8].includes(index)) ?
                               (index * 30) + 180 :
                               index * 30
            }
        }
    }

    Item {
        // Toggle switch for the 12/24 hour mode. Affecting hourNumbers and hourHand appearance.
        id: hourModeSwitch

        anchors {
            centerIn: root
            verticalCenterOffset: -root.width * .4
        }
        width: boxSize
        height: width

        Text {
            id: hourModeSwitchText

            anchors {
                centerIn: parent
            }
            font {
                pixelSize: parent.width * .12
                family: "Barlow"
                styleName: "Bold"
            }
            color: hourSVG.toggle24h ? customGreen : "#ffffff"
            opacity: inactiveContentOpacity
            text: "HOUR MODE"
        }

        MouseArea {
            anchors.fill: hourModeSwitch
            onClicked:
                hourSVG.toggle24h ?
                    hourSVG.toggle24h = false :
                    hourSVG.toggle24h = true
        }
    }

    Item {
        // Wrapper box for digital time related objects. Hour, minute and AP following units setting.
        id: digitalBox

        anchors {
            centerIn: root
            verticalCenterOffset: -root.width * .29
        }
        width: boxSize
        height: width
        opacity: activeContentOpacity

        Text {
            id: digitalHour

            anchors {
                right: parent.horizontalCenter
                rightMargin: parent.width * .01
                verticalCenter: parent.verticalCenter
            }
            font {
                pixelSize: parent.width * .46
                family: "Noto Sans"
                styleName: "Regular"
                letterSpacing: -parent.width * .001
            }
            color: "#ccffffff"
            text: if (use12H.value) {
                      wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2)}
                  else
                      wallClock.time.toLocaleString(Qt.locale(), "HH")
        }

        Text {
            id: digitalMinutes

            anchors {
                left: digitalHour.right
                bottom: digitalHour.bottom
                leftMargin: parent.width * .01
            }
            font {
                pixelSize: parent.width * .46
                family: "Noto Sans"
                styleName: "Light"
                letterSpacing: -parent.width * .001
            }
            color: "#ddffffff"
            text: wallClock.time.toLocaleString(Qt.locale(), "mm")
        }

        Text {
            id: apDisplay

            anchors {
                left: digitalMinutes.right
                leftMargin: parent.width * .09
                bottom: digitalMinutes.verticalCenter
                bottomMargin: -parent.width * .22
            }
            font {
                pixelSize: parent.width * 0.14
                family: "Noto Sans"
                styleName: "Condensed"
            }
            visible: use12H.value
            color: "#ddffffff"
            text: wallClock.time.toLocaleString(Qt.locale(), "ap").toUpperCase()
        }
    }

    Item {
        // Toggle switch that hides the dateBox and shows the hrmBox
        id: hrmSwitch

        anchors {
            centerIn: root
            verticalCenterOffset: -root.height * .13
        }
        width: switchSize
        height: width
        visible: !displayAmbient || hrmSensorActive

        Canvas {
            id: hrmSwitchArc

            anchors.fill: parent
            opacity: hrmSensorActive ? activeArcOpacity : inactiveArcOpacity
            smooth: true
            onPaint: {
                var ctx = getContext("2d")  // Returns a drawing context on the canvas
                ctx.reset()                 // Initialize and clear canvas
                ctx.beginPath()
                ctx.arc(parent.width / 2,   // x-coordinate of the center of the arc
                        parent.height / 2,  // y-coordinate of the center of the arc
                        parent.width * .44, // Radius of the arc
                        270 * rad,          // Start angle in radians (0 is at the 3 o'clock position of the arc's circle)
                        360,                // End angle in radians
                        false);             // Counter clockwise?
                ctx.lineWidth = innerArcLineWidth
                ctx.strokeStyle = hrmSensorActive ? customRed : switchColor
                ctx.fillStyle = "#22ffffff"
                ctx.stroke()                // Draw a stroke along the arc with strokeStyle properties
                ctx.fill()                  // Fill the arc area
                ctx.closePath()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                   hrmSensorActive = !hrmSensorActive
                }
            }
        }

        Icon {
            // Icon class depends on import org.asteroid.controls 1.0
            id: heartPicture

            anchors{
                centerIn: hrmSwitch
                verticalCenterOffset: hrmSwitch.width * .02
                horizontalCenterOffset: hrmSwitch.width * .02
            }
            width: parent.width * .55
            height: width
            name: "ios-heart"
            opacity: hrmSensorActive ? activeContentOpacity : inactiveContentOpacity
        }

        // ColorOverlay depends on import QtGraphicalEffects 1.15
        ColorOverlay {
            anchors.fill: heartPicture
            source: heartPicture
            visible: hrmSensorActive
            color: customRed
        }
    }

    Item {
        // Wrapper box for weather related elements. Contains a weatherIcon and maxTemp display.
        // "No weather data" text is shown when no data is available.
        // ConfigurationValue depends on Nemo.Configuration 1.0
        id: weatherBox

        anchors {
            centerIn: root
            horizontalCenterOffset: -boxPosition
        }
        width: boxSize
        height: width

        ConfigurationValue {
            id: timestampDay0

            key: "/org/asteroidos/weather/timestamp-day0"
            defaultValue: 0
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

        // Work around for the beta release here. Currently catching for -273° string to display the no data message.
        // Plan is to use the commented check. But the result is always false like used now. Likely due to timestamp0 expecting a listview or delegate?
        property bool weatherSynced: kelvinToTemperatureString(maxTemp.value) !== "-273°" //availableDays(timestampDay0.value*1000) > 0

        Canvas {
            id: weatherArc

            anchors.fill: parent
            opacity: inactiveArcOpacity
            smooth: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.lineWidth = outerArcLineWidth
                ctx.lineCap="round"
                ctx.strokeStyle = "#33ffffff"
                ctx.beginPath()
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * .43,
                        270 * rad,
                        360,
                        false);
                ctx.stroke()
                ctx.closePath()
                ctx.beginPath()
                ctx.fillStyle = "#22ffffff"
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * .43,
                        270 * rad,
                        360,
                        false);
                ctx.strokeStyle = boxColor
                ctx.lineWidth = innerArcLineWidth
                ctx.stroke()
                ctx.fill()
                ctx.closePath()
            }
        }

        Icon {
            // WeatherIcons depends on import 'weathericons.js' as WeatherIcons
            id: iconDisplay

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.height * .155
            }
            width: parent.width * .42
            height: width
            opacity: activeContentOpacity
            visible: weatherBox.weatherSynced
            name: WeatherIcons.getIconName(owmId.value)
        }

        Label {
            id: maxDisplay

            anchors {
                centerIn: parent
                verticalCenterOffset: parent.height * (weatherBox.weatherSynced ? .155 : 0)
                horizontalCenterOffset: parent.height * (weatherBox.weatherSynced ? .05 : 0)
            }
            width: parent.width
            height: width
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            opacity: activeContentOpacity
            font {
                family: "Barlow"
                styleName: weatherBox.weatherSynced ? "Medium" : "Bold"
                pixelSize: parent.width * (weatherBox.weatherSynced ? .30 : .14)
            }
            text: weatherBox.weatherSynced ? kelvinToTemperatureString(maxTemp.value) : "NO<br>WEATHER<br>DATA"
        }

        // Preparation for a feature to open the weather app when the weatherBox is pressed.
        // Needs a delegate to hold the application names afaiu
        /*MouseArea {
            anchors.fill: weatherBox
            onClicked: {
               weather.launchApplication()
            }
        }*/
    }

    Item {
        // Wrapper box for date related objects, day name, day number and month short code.
        id: dayBox

        anchors {
            centerIn: root
            horizontalCenterOffset: boxPosition
        }
        width: boxSize
        height: width
        visible: !hrmSensorActive

        Canvas {
            id: dayArc

            anchors.fill: parent
            opacity: inactiveArcOpacity
            smooth: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.beginPath()
                ctx.fillStyle = "#22ffffff"
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * .43,
                        270 * rad,
                        360,
                        false);
                ctx.strokeStyle = boxColor
                ctx.lineWidth = innerArcLineWidth
                ctx.stroke()
                ctx.fill()
                ctx.closePath()
                ctx.lineWidth = outerArcLineWidth
                ctx.lineCap="round"
                ctx.strokeStyle = "#33ffffff"
                ctx.beginPath()
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * .43,
                        270 * rad,
                        360,
                        false);
                ctx.stroke()
                ctx.closePath()
            }
        }

        Text {
            id: dayName

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.width * .25
            }
            font {
                pixelSize: parent.width * .14
                family: "Barlow"
                styleName: "Bold"
            }
            color: "#ffffffff"
            opacity: activeContentOpacity
            text: wallClock.time.toLocaleString(Qt.locale(), "ddd").slice(0, 3).toUpperCase()
        }

        Text {
            id: dayNumber

            anchors {
                centerIn: parent
            }
            font {
                pixelSize: parent.width * .38
                family: "Noto Sans"
                styleName: "Condensed"
            }
            color: "#ffffffff"
            opacity: activeContentOpacity
            text: wallClock.time.toLocaleString(Qt.locale(), "dd").slice(0, 2).toUpperCase()
        }

        Text {
            id: monthName

            anchors {
                centerIn: parent
                verticalCenterOffset: parent.width * .25
            }
            font {
                pixelSize: parent.width * .14
                family: "Barlow"
                styleName: "Bold"
            }
            color: "#ffffffff"
            opacity: activeContentOpacity
            text: wallClock.time.toLocaleString(Qt.locale(), "MMM").slice(0, 3).toUpperCase()
        }
    }

    Item {
        // Wrapper box for heart rate monitor related elements.
        // HrmSensor depends on import QtSensors 5.11
        id: hrmBox

        HrmSensor {
            active: !displayAmbient && hrmSensorActive
            onReadingChanged: {
                root.hrmBpm = reading.bpm;
                root.hrmUpdated = wallClock.time
                hrmArc.requestPaint()
            }
        }

        anchors {
            centerIn: root
            horizontalCenterOffset: boxPosition
        }
        width: boxSize
        height: width
        visible: hrmSensorActive

        Canvas {
            id: hrmArc

            anchors.fill: parent
            opacity: hrmSensorActive ? activeArcOpacity : inactiveArcOpacity
            smooth: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.beginPath()
                ctx.fillStyle = "#22ffffff"
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * .43,
                        270 * rad,
                        360,
                        false);
                ctx.strokeStyle = "#33ffffff"
                ctx.lineWidth = innerArcLineWidth
                ctx.stroke()
                ctx.fill()
                ctx.closePath()
                ctx.lineWidth = outerArcLineWidth
                ctx.lineCap="round"
                ctx.strokeStyle = customRed
                ctx.beginPath()
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * .43,
                        270 * rad,
                        360,
                        false);
                ctx.stroke()
                ctx.closePath()
            }
        }

        Text {
            id: bpmText

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.width * .25
            }
            font {
                pixelSize: parent.width * .14
                family: "Barlow"
                styleName: "Bold"
            }
            color: "#ffffff"
            opacity: inactiveContentOpacity
            text: "BPM"
        }

        Text {
            id: bpmDisplay

            anchors {
                centerIn: parent
            }
            font {
                pixelSize: parent.width * .38
                family: "Noto Sans"
                styleName: "Condensed"
            }
            color: "#ffffff"
            opacity: activeContentOpacity
            text: (hrmBpm ? hrmBpm : "---")
         }

        Text {
            id: updateDisplay

            property bool bpmIsRecent: parseInt((wallClock.time - hrmUpdated) / 60000) === 0

            anchors {
                centerIn: parent
                verticalCenterOffset: parent.width * .25
            }
            font {
                pixelSize: parent.width * .12
                family: "Barlow"
                styleName: "Bold"
            }
            color: "#ffffff"
            opacity: inactiveContentOpacity
            text: bpmIsRecent ?
                      "NOW" :
                      parseInt((wallClock.time - hrmUpdated) / 60000) + "m ago"
        }
    }

    Item {
        // Toggle switch to turn bluetooth on and off.
        // BluetoothStatus depends on import org.asteroid.utils 1.0
        id: btSwitch

        BluetoothStatus {
            id: btStatus
        }

        property bool btStatusOn: btStatus.powered
        property bool btStatusConnect: btStatus.connected

        onBtStatusOnChanged: btSwitchArc.requestPaint()
        onBtStatusConnectChanged: btSwitchArc.requestPaint()

        anchors {
            centerIn: root
            horizontalCenterOffset: -switchPosition
            verticalCenterOffset: switchPosition
        }
        width: switchSize
        height: width
        visible: !displayAmbient || btStatusOn

        Canvas {
            id: btSwitchArc

            anchors.fill: parent
            smooth: true
            opacity: btStatus.powered ? activeArcOpacity : inactiveArcOpacity
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.beginPath()
                ctx.fillStyle = "#22ffffff"
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * .44,
                        270 * rad,
                        360,
                        false);
                ctx.strokeStyle = btStatus.connected ? customBlue : switchColor
                ctx.lineWidth = innerArcLineWidth
                ctx.stroke()
                ctx.fill()
                ctx.closePath()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                   btStatus.powered = !btStatus.powered
                }
            }
        }

        Icon {
            id: btIcon

            anchors {
                centerIn: parent
                verticalCenterOffset: parent.width * .01
            }
            width: parent.width * .6
            height: width
            name: btStatus.powered && btStatus.connected ? "ios-bluetooth-connected" : "ios-bluetooth"
            opacity: btStatus.powered ? activeContentOpacity : inactiveContentOpacity
        }
    }

    Item {
        // Toggle switch to power wlan hardware on and off using connman.
        // Connmanctl needs to be set up with "agent on" to automatically reconnect to the last used wifi network when wlan is powered on.
        // NetworkTechnology depends on import Connman 0.2
        id: wifiSwitch

        NetworkTechnology {
            id: wifiStatus

            path: "/net/connman/technology/wifi"
        }

        property bool wifiStatusOn: wifiStatus.powered

        onWifiStatusOnChanged: wifiSwitchArc.requestPaint()

        anchors {
            centerIn: root
            horizontalCenterOffset: switchPosition
            verticalCenterOffset: switchPosition
        }
        width: switchSize
        height: width
        visible: !displayAmbient || wifiStatusOn

        Canvas {
            id: wifiSwitchArc

            anchors.fill: parent
            opacity: wifiStatus.powered ? activeArcOpacity : inactiveArcOpacity
            smooth: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.beginPath()
                ctx.fillStyle = "#22ffffff"
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * .44,
                        270 * rad,
                        360,
                        false);
                ctx.strokeStyle = switchColor
                ctx.lineWidth = innerArcLineWidth
                ctx.stroke()
                ctx.fill()
                ctx.closePath()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                   wifiStatus.powered = !wifiStatus.powered
                }
            }
        }

        Icon {
            id: wifiIcon

            anchors {
                centerIn: parent
                verticalCenterOffset: parent.width * .03
            }
            width: parent.width * .6
            height: width
            name: "ios-wifi"
            opacity: wifiStatus.powered ? activeContentOpacity : inactiveContentOpacity
        }
    }

    Item {
        // Wrapper box for the battery related elements
        // MceBatteryLevel and MceBatteryState depend on Nemo.Mce 1.0
        id: batteryBox

        MceBatteryLevel {
            id: batteryChargePercentage
        }

        MceBatteryState {
            id: batteryChargeState
        }

        property int value: batteryChargePercentage.percent

        onValueChanged: batteryArc.requestPaint()

        anchors {
            centerIn: root
            verticalCenterOffset: boxPosition
        }
        width: boxSize
        height: width
        Canvas {
            id: batteryArc

            anchors.fill: parent
            opacity: activeArcOpacity
            smooth: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.beginPath()
                ctx.fillStyle = "#22ffffff"
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * .43,
                        270 * rad,
                        360,
                        false);
                ctx.strokeStyle = "#77ffffff"
                ctx.lineWidth = innerArcLineWidth
                ctx.stroke()
                ctx.fill()
                ctx.closePath()
                ctx.lineWidth = outerArcLineWidth
                ctx.lineCap="round"
                ctx.strokeStyle = batteryBox.value < 30 ?
                            customRed :
                            batteryBox.value < 60 ?
                                customOrange :
                                customGreen
                ctx.beginPath()
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * .43,
                        270 * rad,
                        ((batteryBox.value/100*360)+270) * rad,
                        false
                        );
                ctx.stroke()
                ctx.closePath()
            }
        }

        Icon {
            id: batteryIcon

            name: "ios-flash"
            visible: batteryChargeState.value === MceBatteryState.Charging
            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.height * .26
            }
            width: parent.width * .25
            height: width
            opacity: inactiveContentOpacity
        }

        Text {
            id: batteryDisplay

            anchors {
                centerIn: parent
            }
            font {
                pixelSize: parent.width * .38
                family: "Noto Sans"
                styleName: "Condensed"
            }
            color: "#ffffffff"
            opacity: activeContentOpacity
            text: batteryBox.value

        }

        Text {
            id: chargeText

            anchors {
                centerIn: parent
                verticalCenterOffset: parent.width * .25
            }
            font {
                pixelSize: parent.width * .14
                family: "Barlow"
                styleName: "Bold"
            }
            color: "#ffffffff"
            opacity: inactiveContentOpacity
            text: "%"
        }
    }

    Item {
        // Wrapper box for the analog hands
        id: handBox

        width: root.width
        height: width

        Image {
            id: hourSVG

            property bool toggle24h: false

            anchors.centerIn: parent
            width: parent.width
            height: width
            source: imgPath + (hourSVG.toggle24h ? "hour-24h.svg" : "hour-12h.svg")
            antialiasing: true
            smooth: true

            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: hourSVG.toggle24h ?
                           (wallClock.time.getHours() * 15) + (wallClock.time.getMinutes() * .25) :
                           (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * .5)

                Behavior on angle {
                    RotationAnimation {
                        duration: 500
                        direction: RotationAnimation.Clockwise
                        easing.type: Easing.InOutQuad
                    }
                }
            }
            // DropShadow depends on import QtGraphicalEffects 1.15
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 17
                color: Qt.rgba(0, 0, 0, .1)
            }
        }

        Image {
            id: minuteSVG

            anchors.centerIn: parent
            width: parent.width
            height: width
            source: imgPath + "minute.svg"
            antialiasing: true
            smooth: true

            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: (wallClock.time.getMinutes() * 6) + (wallClock.time.getSeconds() * 6 / 60)

                Behavior on angle {
                    RotationAnimation {
                        duration: 1000
                        direction: RotationAnimation.Clockwise
                    }
                }
            }

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 5
                verticalOffset: 5
                radius: 10.0
                samples: 21
                color: Qt.rgba(0, 0, 0, .2)
            }
        }
    }

    // Slight dropshadow under all Items.
    // Causes a double dropshadow for the handBox.
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 1
        verticalOffset: 1
        radius: 6.0
        samples: 13
        color: Qt.rgba(0, 0, 0, .7)
    }
}
