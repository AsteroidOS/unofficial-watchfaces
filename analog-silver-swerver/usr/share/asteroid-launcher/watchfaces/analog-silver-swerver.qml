/*
 * Copyright (C) 2022 - Timo Könnecke <github.com/eLtMosen>
 *               2022 - Darrel Griët <dgriet@gmail.com>
 *               2022 - Ed Beroset <github.com/beroset>
 *               2016 - Sylvia van Os <iamsylvie@openmailbox.org>
 *               2015 - Florent Revest <revestflo@gmail.com>
 *               2012 - Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
 *                      Aleksey Mikhailichenko <a.v.mich@gmail.com>
 *                      Arto Jalkanen <ajalkane@gmail.com>
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

import Nemo.Mce 1.0
import QtGraphicalEffects 1.15
import QtQuick 2.15
import QtQuick.Shapes 1.15
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0

Item {
    id: root

    property string lowColor: !displayAmbient ? "#99b8bcc8" : "#55b8bcc8"
    property string highColor: !displayAmbient ? "#E5E5E5" : "#aaE5E5E5"
    property string accColor: !displayAmbient ? "#aeacb9" : "#aaaeacb9"
    property string accColor2: !displayAmbient ? "#F55D3E" : "#88F55D3E"
    property string imgPath: "../watchfaces-img/analog-silver-swerver-"
    property real rad: 0.01745

    anchors.fill: parent
    // DropShadow on all hands
    layer.enabled: true

    MceBatteryLevel {
        id: batteryChargePercentage
    }

    Item {
        id: faceBox

        anchors.fill: parent
        // DropShadow on all faceBox items
        layer.enabled: true

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
                property real arcStrokeWidth: 0.03
                property real scalefactor: 0.3 - (arcStrokeWidth / 2)
                property var chargecolor: Math.floor(batteryChargePercentage.percent / 33.35)
                readonly property var colorArray: ["red", "yellow", Qt.rgba(0.318, 1, 0.051, 0.9)]

                anchors.fill: parent

                ShapePath {
                    fillColor: "transparent"
                    strokeColor: chargeArc.colorArray[chargeArc.chargecolor]
                    strokeWidth: parent.height * chargeArc.arcStrokeWidth
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.MiterJoin
                    startX: width / 2
                    startY: height * (0.5 - chargeArc.scalefactor)

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

            Text {
                id: batteryDockPercent

                visible: nightstandMode.active
                color: chargeArc.colorArray[chargeArc.chargecolor]
                style: Text.Outline
                styleColor: "#80000000"
                text: batteryChargePercentage.percent

                anchors {
                    centerIn: parent
                    verticalCenterOffset: parent.width * 0.15
                }

                font {
                    pixelSize: parent.width * 0.15
                    family: "Noto Sans"
                    styleName: "Condensed Light"
                }

            }

        }

        Repeater {
            model: 12

            Text {
                id: hourNumbers

                property real rotM: ((index * 5) - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                x: index % 6 ? centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.435 : centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.4075
                y: index % 6 ? centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.435 : centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.4075
                color: "#ddffffff"
                text: index === 0 ? 12 : index

                font {
                    pixelSize: index % 3 ? parent.height * 0.075 : parent.height * 0.15
                    family: "Noto Sans"
                    styleName: index % 3 ? "SemiCondensed SemiBold" : "SemiCondensed Medium"
                }

                LinearGradient {
                    anchors.fill: hourNumbers
                    source: hourNumbers

                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#CDCBD1"
                        }

                        GradientStop {
                            position: 0.4
                            color: "#B8BCC8"
                        }

                        GradientStop {
                            position: 0.6
                            color: "#E5E5E5"
                        }

                        GradientStop {
                            position: 1
                            color: "#E1E6E8"
                        }

                    }

                }

            }

        }

        Item {
            id: dayBox

            property var day: wallClock.time.toLocaleString(Qt.locale(), "dd")

            width: parent.width * 0.3
            height: width
            visible: !nightstandMode.active
            onDayChanged: dayArc.requestPaint()

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.width * 0.055
                horizontalCenterOffset: -parent.width * 0.2125
            }

            // Static circle base
            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.9
                height: width
                radius: width / 2
                color: "#22ffffff"
                border.width: root.height * 0.002
                border.color: lowColor
                opacity: !displayAmbient ? 1 : 0.3
            }

            Canvas {
                id: dayArc

                anchors.fill: parent
                opacity: !displayAmbient ? 1 : 0.3
                renderStrategy: Canvas.Cooperative
                onPaint: {
                    var ctx = getContext("2d");
                    var day = wallClock.time.getDay();
                    ctx.reset();
                    ctx.lineWidth = root.height * 0.005;
                    ctx.lineCap = "round";
                    ctx.strokeStyle = accColor;
                    ctx.beginPath();
                    ctx.arc(parent.width / 2, parent.height / 2, parent.width * 0.456, 169 * rad, ((day / 7 * 360) + 169) * rad, false);
                    ctx.stroke();
                    ctx.closePath();
                }
            }

            Repeater {
                model: 7
                visible: !displayAmbient

                Text {
                    id: dayStrokes

                    property real rotM: ((index * 8.7) - 15) / 60
                    property real centerX: parent.width / 2 - width / 2
                    property real centerY: parent.height / 2 - height / 2
                    property bool currentDayHighlight: new Date(2017, 1, index).toLocaleString(Qt.locale(), "ddd") === wallClock.time.toLocaleString(Qt.locale(), "ddd")

                    x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.35
                    y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.35
                    antialiasing: true
                    color: currentDayHighlight ? highColor : lowColor
                    text: new Date(2017, 1, index).toLocaleString(Qt.locale(), "ddd").slice(0, 2).toUpperCase()

                    font {
                        pixelSize: currentDayHighlight ? root.height * 0.036 : root.height * 0.03
                        letterSpacing: parent.width * 0.004
                        family: "Noto Sans"
                        styleName: currentDayHighlight ? "Black" : "SemiCondensed Bold"
                    }

                    transform: Rotation {
                        origin.x: width / 2
                        origin.y: height / 2
                        angle: index * 52
                    }

                }

            }

            Text {
                id: dayDisplay

                color: highColor
                text: wallClock.time.toLocaleString(Qt.locale(), "dd").slice(0, 2).toUpperCase()

                anchors {
                    centerIn: parent
                    verticalCenterOffset: -root.width * 0.003
                }

                font {
                    pixelSize: parent.height * 0.39
                    family: "Noto Sans"
                    styleName: "Condensed"
                }

            }

        }

        Item {
            id: monthBox

            property var month: wallClock.time.toLocaleString(Qt.locale(), "MM")

            onMonthChanged: monthArc.requestPaint()
            width: parent.width * 0.3
            height: width
            visible: !nightstandMode.active

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.width * 0.055
                horizontalCenterOffset: parent.width * 0.2125
            }

            // Static circle base
            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.9
                height: width
                radius: width / 2
                color: "#22ffffff"
                border.width: root.height * 0.002
                border.color: lowColor
                opacity: !displayAmbient ? 1 : 0.3
            }

            Canvas {
                id: monthArc

                anchors.fill: parent
                opacity: !displayAmbient ? 1 : 0.3
                renderStrategy: Canvas.Cooperative
                onPaint: {
                    var ctx = getContext("2d");
                    var m = Number(wallClock.time.toLocaleString(Qt.locale(), "MM"));
                    ctx.reset();
                    ctx.lineWidth = root.height * 0.005;
                    ctx.lineCap = "round";
                    ctx.strokeStyle = accColor;
                    ctx.beginPath();
                    ctx.arc(parent.width / 2, parent.height / 2, parent.width * 0.456, 270 * rad, ((m / 12 * 360) + 270) * rad, false);
                    ctx.stroke();
                    ctx.closePath();
                }
            }

            Repeater {
                model: 12

                Text {
                    id: monthStrokes

                    property real rotM: ((index * 5) - 15) / 60
                    property real centerX: parent.width / 2 - width / 2
                    property real centerY: parent.height / 2 - height / 2
                    property bool currentMonthHighlight: Number(wallClock.time.toLocaleString(Qt.locale(), "MM")) === index || Number(wallClock.time.toLocaleString(Qt.locale(), "MM")) === index + 12

                    x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.35
                    y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.35
                    antialiasing: true
                    color: currentMonthHighlight ? highColor : lowColor
                    text: index === 0 ? 12 : index

                    font {
                        pixelSize: currentMonthHighlight ? root.height * 0.036 : root.height * 0.03
                        letterSpacing: parent.width * 0.004
                        family: "Noto Sans"
                        styleName: currentMonthHighlight ? "Black" : "Condensed Bold"
                    }

                    transform: Rotation {
                        origin.x: width / 2
                        origin.y: height / 2
                        angle: (index * 30)
                    }

                }

            }

            Text {
                id: monthDisplay

                anchors.centerIn: parent
                renderType: Text.NativeRendering
                color: highColor
                text: wallClock.time.toLocaleString(Qt.locale(), "MMM").slice(0, 3).toUpperCase()

                font {
                    pixelSize: parent.height * 0.28
                    family: "Noto Sans"
                    styleName: "ExtraCondensed Medium"
                }

            }

        }

        Item {
            id: batteryBox

            property int value: batteryChargePercentage.percent

            onValueChanged: batteryArc.requestPaint()
            width: parent.width * 0.275
            height: width
            visible: !nightstandMode.active

            anchors {
                centerIn: parent
                verticalCenterOffset: parent.width * 0.1875
            }

            Canvas {
                id: batteryArc

                anchors.fill: parent
                opacity: !displayAmbient ? 1 : 0.3
                smooth: true
                renderStrategy: Canvas.Cooperative
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.beginPath();
                    ctx.fillStyle = "#22ffffff";
                    ctx.arc(parent.width / 2, parent.height / 2, parent.width * 0.45, 270 * rad, 360, false);
                    ctx.strokeStyle = lowColor;
                    ctx.lineWidth = root.height * 0.002;
                    ctx.stroke();
                    ctx.fill();
                    ctx.closePath();
                    ctx.lineWidth = root.height * 0.005;
                    ctx.lineCap = "round";
                    ctx.strokeStyle = batteryBox.value < 30 ? accColor2 : "#2E933C";
                    ctx.beginPath();
                    ctx.arc(parent.width / 2, parent.height / 2, parent.width * 0.456, 270 * rad, ((batteryBox.value / 100 * 360) + 270) * rad, false);
                    ctx.stroke();
                    ctx.closePath();
                }
            }

            Text {
                id: batteryDisplay

                anchors.centerIn: parent
                renderType: Text.NativeRendering
                color: highColor
                text: batteryBox.value

                font {
                    pixelSize: parent.height * 0.48
                    family: "Noto Sans"
                    styleName: "Condensed Light"
                }

                Text {
                    id: batteryPercent

                    renderType: Text.NativeRendering
                    lineHeightMode: Text.FixedHeight
                    lineHeight: parent.height * 0.94
                    horizontalAlignment: Text.AlignHCenter
                    color: !displayAmbient ? highColor : lowColor
                    text: "BAT<br>%"

                    anchors {
                        centerIn: batteryDisplay
                        verticalCenterOffset: parent.height * 0.34
                    }

                    font {
                        pixelSize: parent.height * 0.194
                        family: "Noto Sans"
                        styleName: "Bold"
                    }

                }

            }

        }

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 10
            samples: 13
            color: Qt.rgba(0, 0, 0, 0.8)
        }

    }

    Item {
        id: handBox

        anchors.fill: parent

        Image {
            id: hourSVG

            source: imgPath + "hour.svg"
            anchors.fill: parent
            layer.enabled: true

            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * 0.5)
            }

            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 2
                verticalOffset: 2
                radius: 5
                samples: 11
                color: Qt.rgba(0, 0, 0, 0.2)
            }

        }

        Image {
            id: minuteSVG

            source: imgPath + "minute.svg"
            anchors.fill: parent
            layer.enabled: true

            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: (wallClock.time.getMinutes() * 6) + (wallClock.time.getSeconds() * 6 / 60)
            }

            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 4
                verticalOffset: 4
                radius: 6
                samples: 13
                color: Qt.rgba(0, 0, 0, 0.3)
            }

        }

        Image {
            id: secondSVG

            visible: !displayAmbient
            source: imgPath + "second.svg"
            anchors.fill: parent
            layer.enabled: true

            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: (wallClock.time.getSeconds() * 6)
            }

            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 6
                verticalOffset: 6
                radius: 8
                samples: 9
                color: Qt.rgba(0, 0, 0, 0.3)
            }

        }

    }

    Connections {
        function onTimeChanged() {
            if (!visible)
                return ;

        }

        target: wallClock
    }

    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 2
        verticalOffset: 2
        radius: 8
        samples: 17
        color: Qt.rgba(0, 0, 0, 0.3)
    }

}
