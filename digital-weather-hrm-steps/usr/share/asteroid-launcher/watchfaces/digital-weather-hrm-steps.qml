/*
 * Copyright (C) 2025 - Jozef Mlich <github.com/jmlich>
 *               2023 - Timo Könnecke <github.com/eLtMosen>
 *               2022 - Darrel Griët <dgriet@gmail.com>
 *               2022 - Ed Beroset <github.com/beroset>
 *               2017 - Florent Revest <revestflo@gmail.com>
 * All rights reserved.
 *
 * You may use this file under the terms of BSD license as follows:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the author nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import Nemo.Configuration 1.0
import Nemo.Mce 1.0
import QtGraphicalEffects 1.15
import QtQuick 2.15
import QtQuick.Shapes 1.15
import QtSensors 5.11
import org.asteroid.controls 1.0
import org.asteroid.sensorlogd 1.0
import org.asteroid.utils 1.0
import "weathericons.js" as WeatherIcons

Item {
    id: root

    property string imgPath: "../watchfaces-img/digital-weather-hrm-steps-"
    property int dayNb: 0
    // HRM initialisation. Needs to be declared global since hrmBox and hrmSwitch both need it.
    property int hrmBpm: 0
    property bool hrmSensorActive: false
    property var hrmBpmTime: wallClock.time
    property bool stepSensorActive: false
    property int steps: 0
    property string customRed: "#DB5461" // Indian Red
    property string customBlue: "#1E96FC" // Dodger Blue

    function twoDigits(x) {
        if (x < 10)
            return "0" + x;
        else
            return x;
    }

    function kelvinToTemperatureString(kelvin) {
        var celsius = (kelvin - 273);
        if (!useFahrenheit.value)
            return celsius + "°";
        else
            return Math.round(((celsius) * 9 / 5) + 32) + "°";
    }

    function prepareContext(ctx) {
        ctx.reset();
        ctx.fillStyle = "white";
        ctx.textAlign = "center";
        ctx.textBaseline = 'middle';
        ctx.shadowColor = "black";
        ctx.shadowOffsetX = 0;
        ctx.shadowOffsetY = 0;
        ctx.shadowBlur = root.height * 0.0125;
    }

    anchors.fill: parent

    Item {
        anchors.centerIn: parent
        height: parent.width > parent.height ? parent.height : parent.width
        width: height
        Component.onCompleted: {
            var hour = wallClock.time.getHours();
            var minute = wallClock.time.getMinutes();
            var month = wallClock.time.getMonth();
            var date = wallClock.time.getDate();
            var am = hour < 12;
            if (use12H.value) {
                hour = hour % 12;
                if (hour === 0)
                    hour = 12;

            }
            hourCanvas.hour = hour;
            hourCanvas.requestPaint();
            minuteCanvas.minute = minute;
            minuteCanvas.requestPaint();
            dateCanvas.date = date;
            dateCanvas.requestPaint();
            dayOfWeekCanvas.requestPaint();
            amPmCanvas.am = am;
            amPmCanvas.requestPaint();
            burnInProtectionManager.widthOffset = Qt.binding(function() {
                return width * (nightstandMode.active ? 0.1 : 0.32);
            });
            burnInProtectionManager.heightOffset = Qt.binding(function() {
                return height * (nightstandMode.active ? 0.1 : 0.7);
            });
        }

        Item {
            // stepsBox

            id: watchfaceRoot

            anchors.centerIn: parent
            width: parent.width * (nightstandMode.active ? 0.86 : 1)
            height: width

            Canvas {
                id: hourCanvas

                property int hour: 0

                anchors.fill: parent
                antialiasing: true
                smooth: true
                renderStrategy: Canvas.Cooperative
                onPaint: {
                    var ctx = getContext("2d");
                    prepareContext(ctx);
                    ctx.font = "70 " + height * 0.36 + "px Cantarell";
                    ctx.fillText(twoDigits(hour), width * 0.378, height * 0.537);
                }
            }

            Canvas {
                id: minuteCanvas

                property int minute: 0

                anchors.fill: parent
                antialiasing: true
                smooth: true
                renderStrategy: Canvas.Cooperative
                onPaint: {
                    var ctx = getContext("2d");
                    prepareContext(ctx);
                    ctx.font = "50 " + height * 0.18 + "px Cantarell";
                    ctx.fillText(twoDigits(minute), width * 0.717, height * 0.473);
                }
            }

            Canvas {
                id: amPmCanvas

                property bool am: false

                anchors.fill: parent
                antialiasing: true
                smooth: true
                renderStrategy: Canvas.Cooperative
                visible: use12H.value
                onPaint: {
                    var ctx = getContext("2d");
                    prepareContext(ctx);
                    ctx.font = "35 " + height / 15 + "px Cantarell";
                    ctx.fillText(wallClock.time.toLocaleString(Qt.locale("en_EN"), "AP"), width * 0.894, height * 0.371);
                }
            }

            Canvas {
                id: dayOfWeekCanvas

                visible: !nightstandMode.active
                anchors.fill: parent
                antialiasing: true
                smooth: true
                renderStrategy: Canvas.Cooperative
                onPaint: {
                    var ctx = getContext("2d");
                    prepareContext(ctx);
                    ctx.font = "35 " + height / 10 + "px Cantarell";
                    ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "dddd"), width / 2, height * 60 / 480);
                }
            }

            Canvas {
                id: dateCanvas

                property variant date: wallClock.time.getDate()

                visible: !nightstandMode.active
                anchors.fill: parent
                antialiasing: true
                smooth: true
                renderStrategy: Canvas.Cooperative
                onPaint: {
                    var ctx = getContext("2d");
                    prepareContext(ctx);
                    ctx.font = "35 " + height / 10 + "px Cantarell";
                    ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "d MMMM"), width / 2, height * 130 / 480);
                }
            }

            Item {
                id: hrmBox

                anchors.fill: parent
                visible: !nightstandMode.active

                HrmSensor {
                    active: !displayAmbient && hrmSensorActive
                    onReadingChanged: {
                        root.hrmBpm = reading.bpm;
                        root.hrmBpmTime = wallClock.time;
                        hrmCanvas.requestPaint();
                    }
                }

                Canvas {
                    id: hrmCanvas

                    anchors.fill: parent
                    antialiasing: true
                    smooth: true
                    renderStrategy: Canvas.Cooperative
                    onPaint: {
                        var ctx = getContext("2d");
                        prepareContext(ctx);
                        ctx.font = "25 " + height / 13 + "px Cantarell";
                        //                    ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "d MMM"), width * .719, height * .595);
                        ctx.fillText(hrmBpm, width * 0.75, height * 370 / 480);
                    }
                }

                Icon {
                    //            opacity: hrmSensorActive ? activeContentOpacity : inactiveContentOpacity

                    // Icon class depends on import org.asteroid.controls 1.0
                    id: heartPicture

                    width: parent.width * 0.1
                    height: width
                    x: 0.55 * parent.width
                    y: (parent.height * 370 / 480) - height * 0.5
                    name: "ios-heart"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            hrmSensorActive = !hrmSensorActive;
                        }
                    }

                }

                ColorOverlay {
                    anchors.fill: heartPicture
                    source: heartPicture
                    visible: hrmSensorActive
                    color: customRed
                }
                // hrmBox

            }

            Item {
                id: weatherBox

                property bool weatherSynced: maxTemp.value != 0

                visible: !nightstandMode.active
                anchors.fill: parent

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

                Canvas {
                    id: weatherCanvas

                    anchors.fill: parent
                    antialiasing: true
                    smooth: true
                    renderStrategy: Canvas.Cooperative
                    onPaint: {
                        var ctx = getContext("2d");
                        prepareContext(ctx);
                        ctx.font = "25 " + height / 13 + "px Cantarell";
                        //                    ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "d MMM"), width * .719, height * .595);
                        ctx.fillText(weatherBox.weatherSynced ? kelvinToTemperatureString(maxTemp.value) : '', width * 0.4, height * 370 / 480);
                    }
                }

                Icon {
                    // Icon class depends on import org.asteroid.controls 1.0
                    id: weatherPicture

                    width: parent.width * 0.1
                    height: width
                    x: 0.2 * parent.width
                    y: (parent.height * 370 / 480) - height * 0.5
                    visible: weatherBox.weatherSynced
                    name: WeatherIcons.getIconName(owmId.value)
                }

            }

            Item {
                id: stepsBox

                anchors.fill: parent
                visible: !nightstandMode.active

                StepsDataLoader {
                    id: stepsDataLoader

                    Component.onCompleted: {
                        stepsDataLoader.getTodayTotal();
                        root.steps = stepsDataLoader.todayTotal;
                        stepsCanvas.requestPaint();
                    }
                    onDataChanged: {
                        stepsDataLoader.getTodayTotal();
                        root.steps = stepsDataLoader.todayTotal;
                        stepsCanvas.requestPaint();
                    }
                }

                Canvas {
                    id: stepsCanvas

                    anchors.fill: parent
                    antialiasing: true
                    smooth: true
                    renderStrategy: Canvas.Cooperative
                    onPaint: {
                        var ctx = getContext("2d");
                        prepareContext(ctx);
                        ctx.font = "25 " + height / 13 + "px Cantarell";
                        //                    ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "d MMM"), width * .719, height * .595);
                        ctx.fillText(root.steps, width * 0.55, height * 430 / 480);
                    }
                }

                Icon {
                    //            opacity: hrmSensorActive ? activeContentOpacity : inactiveContentOpacity

                    // Icon class depends on import org.asteroid.controls 1.0
                    id: stepsPicture

                    width: parent.width * 0.1
                    height: width
                    x: 0.3 * parent.width
                    y: (parent.height * 430 / 480) - height * 0.5
                    name: "ios-paw"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            stepSensorActive = !stepSensorActive;
                        }
                    }

                }

            }

        }

        Item {
            id: nightstandMode

            readonly property bool active: nightstand

            anchors.fill: parent

            layer {
                enabled: true
                samples: 4
                smooth: true
                textureSize: Qt.size(nightstandMode.width * 2, nightstandMode.height * 2)
            }
            visible: nightstandMode.active

            Repeater {
                id: segmentedArc

                property real inputValue: batteryChargePercentage.percent / 100
                property int segmentAmount: 50
                property int start: 0
                property int gap: 6
                property int endFromStart: 360
                property bool clockwise: true
                property real arcStrokeWidth: .055
                property real scalefactor: .45 - (arcStrokeWidth / 2)
                property real chargecolor: Math.floor(batteryChargePercentage.percent / 33.35)
                readonly property var colorArray: [ "red", "yellow", Qt.rgba(.318, 1, .051, .9)]

                model: segmentAmount

                Shape {
                    id: segment

                    visible: index === 0 ? true : (index/segmentedArc.segmentAmount) < segmentedArc.inputValue

                    ShapePath {
                        fillColor: "transparent"
                        strokeColor: segmentedArc.colorArray[segmentedArc.chargecolor]
                        strokeWidth: parent.height * segmentedArc.arcStrokeWidth
                        capStyle: ShapePath.FlatCap
                        joinStyle: ShapePath.MiterJoin
                        startX: parent.width / 2
                        startY: parent.height * ( .5 - segmentedArc.scalefactor)

                        PathAngleArc {
                            centerX: parent.width / 2
                            centerY: parent.height / 2
                            radiusX: segmentedArc.scalefactor * parent.width
                            radiusY: segmentedArc.scalefactor * parent.height
                            startAngle: -90 + index * (sweepAngle + (segmentedArc.clockwise ? +segmentedArc.gap : -segmentedArc.gap)) + segmentedArc.start
                            sweepAngle: segmentedArc.clockwise ? (segmentedArc.endFromStart / segmentedArc.segmentAmount) - segmentedArc.gap :
                                                                 -(segmentedArc.endFromStart / segmentedArc.segmentAmount) + segmentedArc.gap
                            moveToStart: true
                        }
                    }
                }
            }
        }

        MceBatteryLevel {
            id: batteryChargePercentage
        }

        Connections {
            function onTimeChanged() {
                var hour = wallClock.time.getHours();
                var minute = wallClock.time.getMinutes();
                var month = wallClock.time.getMonth();
                var date = wallClock.time.getDate();
                var am = hour < 12;
                if (use12H.value) {
                    hour = hour % 12;
                    if (hour === 0)
                        hour = 12;

                }
                if (hourCanvas.hour !== hour) {
                    hourCanvas.hour = hour;
                    hourCanvas.requestPaint();
                }
                if (minuteCanvas.minute !== minute) {
                    minuteCanvas.minute = minute;
                    minuteCanvas.requestPaint();
                }
                if (amPmCanvas.am != am) {
                    amPmCanvas.am = am;
                    amPmCanvas.requestPaint();
                }
                if (dateCanvas.date != date) {
                    dateCanvas.date = date;
                    dateCanvas.requestPaint();
                    dayOfWeekCanvas.requestPaint();
                }
            }

            target: wallClock
        }

    }

}
