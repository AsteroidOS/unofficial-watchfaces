/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
 *               2021 - Timo Könnecke <github.com/eLtMosen>
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
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0

Item {
    id: root

    property string lowColor: !displayAmbient ? "#bbCFA526" : "#66CFA526"
    property string highColor: !displayAmbient ? "#FFEBAD" : "#aaFFEBAD"
    property string accColor: !displayAmbient ? "#D88C9A" : "#88D88C9A"
    property string imgPath: "../watchfaces-img/analog-goldie-"
    property real rad: 0.01745

    anchors.fill: parent
    layer.enabled: true

    MceBatteryLevel {
        id: batteryChargePercentage
    }

    Image {
        id: backPlate

        z: 0
        anchors.fill: parent
        visible: !displayAmbient
        source: imgPath + "background.svg"
    }

    Image {
        id: hourMarks

        z: 1
        anchors.fill: parent
        source: imgPath + "hourmarks.svg"
        layer.enabled: true

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 8
            samples: 9
            color: Qt.rgba(0, 0, 0, 1)
        }

    }

    Item {
        id: faceBox

        anchors.fill: parent
        layer.enabled: true

        Repeater {
            model: 60

            Rectangle {
                property real rotM: (index - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                z: 1
                visible: index % 5
                antialiasing: true
                width: parent.width * 0.005
                height: parent.height * 0.04
                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.45
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.45
                color: lowColor

                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                    angle: index * 6
                }

            }

        }

        Repeater {
            model: 12

            Text {
                property real rotM: ((index * 5) - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                z: 1
                x: index % 6 ? centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.348 : centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.326
                y: index % 6 ? centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.348 : centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.326
                color: "#ddffffff"
                text: index === 0 ? 12 : index

                font {
                    pixelSize: index % 3 ? parent.height * 0.06 : parent.height * 0.12
                    family: "Noto Sans"
                    styleName: index % 3 ? "SemiCondensed SemiBold" : "SemiCondensed Medium"
                }

                LinearGradient {
                    anchors.fill: parent
                    source: parent

                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#bf9b30"
                        }

                        GradientStop {
                            position: 0.4
                            color: "#ffcf40"
                        }

                        GradientStop {
                            position: 0.6
                            color: "#ffbf00"
                        }

                        GradientStop {
                            position: 1
                            color: "#ffdc73"
                        }

                    }

                }

            }

        }

        Item {
            id: dayBox

            property var day: wallClock.time.toLocaleString(Qt.locale(), "dd")

            width: parent.width * 0.24
            height: parent.height * 0.24
            onDayChanged: dayArc.requestPaint()

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.width * 0.044
                horizontalCenterOffset: -parent.width * 0.17
            }

            // Static circle base
            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.9
                height: width
                radius: width / 2
                color: "#22ffffff"
                opacity: !displayAmbient ? 1 : 0.3
                border.width: root.height * 0.002
                border.color: lowColor
            }

            Canvas {
                id: dayArc

                z: 1
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
                    property real rotM: ((index * 8.7) - 15) / 60
                    property real centerX: parent.width / 2 - width / 2
                    property real centerY: parent.height / 2 - height / 2
                    property bool currentDayHighlight: new Date(2017, 1, index).toLocaleString(Qt.locale(), "ddd") === wallClock.time.toLocaleString(Qt.locale(), "ddd")

                    z: 2
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

                z: 2
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

            // Fixed: was "mm" (minutes) — caused monthly arc repaints every minute
            property var month: wallClock.time.toLocaleString(Qt.locale(), "MM")

            onMonthChanged: monthArc.requestPaint()
            width: parent.width * 0.24
            height: parent.height * 0.24

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.width * 0.044
                horizontalCenterOffset: parent.width * 0.17
            }

            // Static circle base
            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.9
                height: width
                radius: width / 2
                color: "#22ffffff"
                opacity: !displayAmbient ? 1 : 0.3
                border.width: root.height * 0.002
                border.color: lowColor
            }

            Canvas {
                id: monthArc

                z: 1
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
                    property real rotM: ((index * 5) - 15) / 60
                    property real centerX: parent.width / 2 - width / 2
                    property real centerY: parent.height / 2 - height / 2
                    property bool currentMonthHighlight: Number(wallClock.time.toLocaleString(Qt.locale(), "MM")) === index || Number(wallClock.time.toLocaleString(Qt.locale(), "MM")) === index + 12

                    z: 2
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
                        angle: index * 30
                    }

                }

            }

            Text {
                id: monthDisplay

                z: 2
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
            width: parent.width * 0.22
            height: parent.height * 0.22

            anchors {
                centerIn: parent
                verticalCenterOffset: parent.width * 0.15
            }

            Canvas {
                id: batteryArc

                z: 1
                anchors.fill: parent
                opacity: !displayAmbient ? 1 : 0.3
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
                    ctx.strokeStyle = batteryChargePercentage.percent < 30 ? accColor : "#44BBA4";
                    ctx.beginPath();
                    ctx.arc(parent.width / 2, parent.height / 2, parent.width * 0.456, 270 * rad, ((batteryChargePercentage.percent / 100 * 360) + 270) * rad, false);
                    ctx.stroke();
                    ctx.closePath();
                }
            }

            Text {
                id: batteryDisplay

                z: 2
                anchors.centerIn: parent
                renderType: Text.NativeRendering
                color: highColor
                text: batteryChargePercentage.percent

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
                        centerIn: parent
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

        z: 3
        anchors.fill: parent

        Image {
            id: hourSVG

            z: 3
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
                samples: 9
                color: Qt.rgba(0, 0, 0, 0.2)
            }

        }

        Image {
            id: minuteSVG

            z: 4
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
                horizontalOffset: 3
                verticalOffset: 3
                radius: 6
                samples: 9
                color: Qt.rgba(0, 0, 0, 0.3)
            }

        }

        Image {
            id: secondSVG

            z: 5
            visible: !displayAmbient
            source: imgPath + "second.svg"
            anchors.fill: parent
            layer.enabled: true

            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: wallClock.time.getSeconds() * 6
            }

            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 4
                verticalOffset: 4
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
        samples: 9
        color: Qt.rgba(0, 0, 0, 0.3)
    }

}
