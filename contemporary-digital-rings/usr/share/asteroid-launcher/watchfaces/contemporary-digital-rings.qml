/*
 * Copyright (C) 2026 - Luca Barbera <github.com/lbarbera>
 *               2023 - Timo Könnecke <github.com/eLtMosen>
 *               2022 - Darrel Griët <dgriet@gmail.com>
 *               2022 - Ed Beroset <github.com/beroset>
 *               2017 - Mario Kicherer <dev@kicherer.org>
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
 * Based on digital-rings by Timo Könnecke. New modern fonts inspired by Eurostile
 * plus some tight alignment and kerning. Works best with colorful wallpaper.
 */

import QtQuick 2.15
import QtQuick.Shapes 1.15
import QtGraphicalEffects 1.15
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0
import Nemo.Mce 1.0

Item {
    // Loader for the Bold version
    FontLoader {
        id: customFontBold
        source: "/usr/share/fonts/Waukegan_LDO_Bold.ttf"
    }

    // Loader for the Regular version
    FontLoader {
        id: customFontRegular
        source: "/usr/share/fonts/Waukegan_LDO.ttf"
    }
    // Loader for the Extended Black Regular version
    FontLoader {
        id: customFontEBR
        source: "/usr/share/fonts/Waukegan_LDO_EBR.ttf"
    }

    anchors.fill: parent

    property real radian: .01745

    function prepareContext(ctx) {
        ctx.reset()
        ctx.shadowColor = (0, 0, 0, .25)
        ctx.shadowOffsetX = 0
        ctx.shadowOffsetY = 0
        ctx.shadowBlur = parent.height * .00625
        ctx.lineCap= "round"
    }

    Item {
        anchors.centerIn: parent

        height: parent.width > parent.height ? parent.height : parent.width
        width: height

        Rectangle {
            x: parent.width / 2-width / 2
            y: parent.height / 2-width / 2
            color: Qt.rgba(0, 0, 0, .2)
            width: parent.width / 1.3
            height: parent.height / 1.3
            radius: width * .5
        }

        Canvas {
            id: secondCanvas

            property int second: 0

            anchors.fill: parent
            smooth: true
            renderStrategy: Canvas.Cooperative
            visible: !displayAmbient && !nightstandMode.active
            onPaint: {
                var ctx = getContext("2d")
                var rot = (wallClock.time.getSeconds() - 15) * 6
                var rot_half = (wallClock.time.getSeconds() - 22) * 6
                prepareContext(ctx)
                ctx.beginPath()
                ctx.arc(parent.width / 2, parent.height / 2, width / 2.2, -89.5 * radian, rot* radian, false);
                ctx.lineWidth = parent.width * .009375
                ctx.strokeStyle = Qt.rgba(.871, .165, .102, .95)
                ctx.stroke()
            }
        }

        Canvas {
            id: minuteCanvas

            property int minute: 0

            anchors.fill: parent
            smooth: true
            renderStrategy: Canvas.Cooperative
            visible: !displayAmbient && !nightstandMode.active
            onPaint: {
                var ctx = getContext("2d")
                var rot = (minute -15 ) * 6
                prepareContext(ctx)
                ctx.beginPath()
                ctx.arc(parent.width / 2, parent.height / 2, width / 2.33, -88.8 * radian, rot * radian, false);
                ctx.lineWidth = parent.width * .01875
                ctx.strokeStyle = Qt.rgba(1, .549, .149, .95)
                ctx.stroke()
            }
        }

        Canvas {
            id: hourCanvas

            property int hour: 0

            anchors.fill: parent
            smooth: true
            renderStrategy: Canvas.Cooperative
            visible: !displayAmbient && !nightstandMode.active
            onPaint: {
                var ctx = getContext("2d")
                var rot = .5 * (60 * (hour - 3) + wallClock.time.getMinutes())
                prepareContext(ctx)
                ctx.beginPath()
                ctx.arc(parent.width / 2, parent.height / 2, width / 2.6,  273.5 * radian, rot * radian, false);
                ctx.lineWidth = parent.width * .05
                ctx.strokeStyle = Qt.rgba(.945, .769, .059, .95)
                ctx.stroke()
                ctx.beginPath()
            }
        }

        Text {
            id: hourDisplay

            anchors {
                right: parent.horizontalCenter
                rightMargin: -parent.height * .0938
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: parent.height * .0281
            }
            font {
                pixelSize: parent.height * .305
                family: customFontEBR.name
                letterSpacing: -0.5
            }
            color: Qt.rgba(1, 1, 1, 1)
            style: Text.Outline
            styleColor: Qt.rgba(0, 0, 0, .5)
            text: if (use12H.value) {
                      wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) }
                  else
                      wallClock.time.toLocaleString(Qt.locale(), "HH")
        }

        Text {
            id: minuteDisplay

            property real rotM: (wallClock.time.getMinutes() - 12.1) / 60

            anchors {
                top: hourDisplay.top;
//*                topMargin: -parent.height * .015625
                topMargin:  parent.height * 0.015
                leftMargin: parent.width * .025
                left: hourDisplay.right;
            }
            font {
                pixelSize: parent.height * .1375
                family: customFontBold.name
                letterSpacing: 0.5
            }
            color: Qt.rgba(1, 1, 1, 1)
            style: Text.Outline
            styleColor: Qt.rgba(0, 0, 0, .5)
            text: wallClock.time.toLocaleString(Qt.locale(), "mm")
        }

        Text {
            id: secondDisplay

            anchors {
                bottom: hourDisplay.bottom;
                bottomMargin: parent.height * .03
                leftMargin: parent.width * .025
                left: hourDisplay.right;
            }
            font {
                pixelSize: parent.height * .11
                family: "Titillium"
                styleName: 'Thin'
                letterSpacing: -1
            }
            color: Qt.rgba(1, 1, 1, 1)
            style: Text.Outline
            styleColor: Qt.rgba(0, 0, 0, .5)
            horizontalAlignment: Text.AlignHCenter
            text: wallClock.time.toLocaleString(Qt.locale(), "ss")
            visible: !displayAmbient
        }

        Text {
            id: dowDisplay

            anchors {
                bottom: hourDisplay.top
		// Adjust the factor value (.02 = 2%) to increase spacing from hour display.
                bottomMargin: parent.height * .02
                left: parent.left
                right: parent.right
            }
            font {
                pixelSize: parent.height * .094375
                family: customFontRegular.name
 //*               styleName: 'Thin'
            }
            color: Qt.rgba(1, 1, 1, 1)
            style: Text.Outline
            styleColor: Qt.rgba(0, 0, 0, .5)
            horizontalAlignment: Text.AlignHCenter
            text: wallClock.time.toLocaleString(Qt.locale(), "dddd")
        }

        Text {
            id: dateDisplay

            anchors {
//*                topMargin: -parent.height * .005
                topMargin: 0
                top: hourDisplay.bottom
                left: parent.left
                right: parent.right
            }
            font {
                pixelSize: parent.height*.094375
                family: customFontRegular.name
//*               styleName: 'Thin'
            }
            color: Qt.rgba(1, 1, 1, 1)
            style: Text.Outline
            styleColor: Qt.rgba(0, 0, 0, .5)
            horizontalAlignment: Text.AlignHCenter
            text: wallClock.time.toLocaleString(Qt.locale(), "<b>dd</b> MMMM")
        }

        Text {
            id: pmDisplay

            anchors {
                bottomMargin: +parent.height * .018
                bottom: dowDisplay.top
                left: parent.left
                right: parent.right
            }
            font {
                pixelSize: parent.height * .05
                family: "Titillium"
                styleName: 'Semibold'
            }
            color: Qt.rgba(1, 1, 1, 1)
            style: Text.Outline
            styleColor: Qt.rgba(0, 0, 0, .5)
            horizontalAlignment: Text.AlignHCenter
            visible: use12H.value
            text: wallClock.time.toLocaleString(Qt.locale(), "<b>ap</b>")
        }

        Item {
            id: nightstandMode

            readonly property bool active: nightstand
            property int batteryPercentChanged: batteryChargePercentage.percent

            anchors.fill: parent
            visible: nightstandMode.active
            layer {
                enabled: true
                samples: 4
                smooth: true
                textureSize: Qt.size(nightstandMode.width * 2, nightstandMode.height * 2)
            }

            Shape {
                id: chargeArc

                property real angle: batteryChargePercentage.percent * 360 / 100
                // radius of arc is scalefactor * height or width
                property real arcStrokeWidth: .03
                property real scalefactor: .45 - (arcStrokeWidth / 2)
                property var chargecolor: Math.floor(batteryChargePercentage.percent / 33.35)
                readonly property var colorArray: [ "red", "yellow", Qt.rgba(.318, 1, .051, .9)]

                anchors.fill: parent
                smooth: true
                antialiasing: true

                ShapePath {
                    fillColor: "transparent"
                    strokeColor: chargeArc.colorArray[chargeArc.chargecolor]
                    strokeWidth: parent.height * chargeArc.arcStrokeWidth
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.MiterJoin
                    startX: chargeArc.width / 2
                    startY: chargeArc.height * ( .5 - chargeArc.scalefactor)

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

            Icon {
                id: batteryIcon

                name: "ios-battery-charging"
                anchors {
                    centerIn: parent
                    verticalCenterOffset: -parent.width * .316
                }
                visible: nightstandMode.active
                width: parent.width * .14
                height: parent.height * .14
            }

            ColorOverlay {
                anchors.fill: batteryIcon
                source: batteryIcon
                color: chargeArc.colorArray[chargeArc.chargecolor]
            }

            Text {
                id: batteryPercent

                anchors {
                    centerIn: parent
                    verticalCenterOffset: parent.width * .324
                }

                font {
                    pixelSize: parent.width * .09
                    family: "Titillium"
                    styleName: "ExtraCondensed"
                }
                visible: nightstandMode.active
                color: chargeArc.colorArray[chargeArc.chargecolor]
                style: Text.Outline; styleColor: "#80000000"
                text: batteryChargePercentage.percent + "%"
            }
        }

        MceBatteryLevel {
            id: batteryChargePercentage
        }

        Connections {
            target: wallClock
            function onTimeChanged() {
                if (displayAmbient) return
                var hour = wallClock.time.getHours()
                var minute = wallClock.time.getMinutes()
                var second = wallClock.time.getSeconds()
                if(secondCanvas.second !== second) {
                    secondCanvas.second = second
                    secondCanvas.requestPaint()
                } if(hourCanvas.hour !== hour) {
                    hourCanvas.hour = hour
                }if(minuteCanvas.minute !== minute) {
                    minuteCanvas.minute = minute
                    minuteCanvas.requestPaint()
                    hourCanvas.requestPaint()
                }
            }
        }

        Component.onCompleted: {
            var hour = wallClock.time.getHours()
            var minute = wallClock.time.getMinutes()
            var second = wallClock.time.getSeconds()
            secondCanvas.second = second
            secondCanvas.requestPaint()
            minuteCanvas.minute = minute
            minuteCanvas.requestPaint()
            hourCanvas.hour = hour
            hourCanvas.requestPaint()

            burnInProtectionManager.widthOffset = Qt.binding(function() { return width * nightstandMode.active ? .08 : .3})
            burnInProtectionManager.heightOffset = Qt.binding(function() { return height * nightstandMode.active ? .08 : .3})
        }
    }
}
