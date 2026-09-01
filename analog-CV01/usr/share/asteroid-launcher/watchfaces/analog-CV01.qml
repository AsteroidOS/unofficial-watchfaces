// SPDX-FileCopyrightText: 2026 Jessica Tran <https://cambionn.nl>
// SPDX-FileCopyrightText: 2022 Ivo Hulsman <*github.com/ivohulsman>
// SPDX-FileCopyrightText: 2021 Timo Könnecke <github.com/eLtMosen>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import Nemo.Mce
import Qt5Compat.GraphicalEffects
import QtQuick

Item {
    id: root

    property string imgPath: "../watchfaces-img/analog-CV01-"
    property real rad: 0.01745

    layer.enabled: true

    MceBatteryLevel {
        id: batteryChargePercentage
    }

    Image {
        id: backPlate

        z: 0
        anchors.fill: parent
        opacity: !displayAmbient ? 1 : 0.3
        source: imgPath + "background.png"
    }

    Image {
        id: asteroidLogo

        z: 1
        opacity: displayAmbient ? 0.1 : 0.7
        source: "../watchfaces-img/analog-commander-asteroid-logo.svg"
        antialiasing: true
        width: parent.width * 0.12
        height: parent.height * 0.12

        anchors {
            centerIn: parent
            verticalCenterOffset: -parent.height * 0.25
        }

        Text {
            id: asteroidSlogan

            z: 2
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            text: "<b>AsteroidOS</b><br>Hack Your Wrist"

            font {
                pixelSize: parent.height * 0.28
                family: "Raleway"
            }

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.height * -0.85
            }

        }

        MouseArea {
            anchors.fill: parent
            onPressAndHold: asteroidLogo.visible = !asteroidLogo.visible
        }

    }

    Item {
        id: monthBox

        property var month: wallClock.time.toLocaleString(Qt.locale(), "mm")

        onMonthChanged: monthArc.requestPaint()
        width: parent.width * 0.22
        height: parent.height * 0.22

        anchors {
            centerIn: parent
            horizontalCenterOffset: -parent.width * 0.22
        }

        Canvas {
            id: monthArc

            z: 1
            opacity: !displayAmbient ? 1 : 0.3
            anchors.fill: parent
            smooth: true
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.beginPath();
                ctx.fillStyle = "#00ffffff";
                ctx.arc(parent.width / 2, parent.height / 2, parent.width * 0.45, 270 * rad, 360, false);
                ctx.strokeStyle = "#77ffffff";
                ctx.lineWidth = root.height * 0.002;
                ctx.stroke();
                ctx.fill();
                ctx.closePath();
                ctx.lineWidth = root.height * 0.005;
                ctx.lineCap = "round";
                ctx.strokeStyle = "#44bed6";
                ctx.beginPath();
                ctx.arc(parent.width / 2, parent.height / 2, parent.width * 0.456, 270 * rad, ((wallClock.time.toLocaleString(Qt.locale(), "MM") / 12 * 360) + 270) * rad, false);
                ctx.stroke();
                ctx.closePath();
            }

        }

        Repeater {
            model: 12

            Text {
                id: monthStrokes

                property bool currentMonthHighlight: Number(wallClock.time.toLocaleString(Qt.locale(), "MM")) === index || Number(wallClock.time.toLocaleString(Qt.locale(), "MM")) === index + 12
                property real rotM: ((index * 5) - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                z: 2
                antialiasing: true
                opacity: !displayAmbient ? 1 : 0.3
                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.35
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.35
                color: currentMonthHighlight ? "#ffffffff" : "#ff949494"
                text: index === 0 ? 12 : index

                font {
                    pixelSize: currentMonthHighlight ? root.height * 0.036 : root.height * 0.03
                    letterSpacing: parent.width * 0.004
                    family: "Teko"
                    styleName: currentMonthHighlight ? "Regular" : "Light"
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

            z: 2
            y: (parent.height + height) * -0.075
            renderType: Text.NativeRendering
            color: "#ddffffff"
            opacity: !displayAmbient ? 1 : 0.3
            text: wallClock.time.toLocaleString(Qt.locale(), "dd").slice(0, 3)

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.height * -0.02
            }

            font {
                pixelSize: parent.height * 0.39
                family: "Teko"
                styleName: "Light"
                letterSpacing: -root.width * 0.0018
            }

        }

    }

    Item {
        id: batteryBox

        property int value: batteryChargePercentage.percent

        onValueChanged: batteryArc.requestPaint()
        width: parent.width * 0.23
        height: parent.height * 0.23

        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width * 0
            horizontalCenterOffset: parent.width * 0.22
        }

        Canvas {
            id: batteryArc

            property var hour: 0

            z: 1
            opacity: !displayAmbient ? 0.8 : 0.3
            anchors.fill: parent
            smooth: true
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.beginPath();
                ctx.fillStyle = "#00ffffff";
                ctx.arc(parent.width / 2, parent.height / 2, parent.width * 0.45, 270 * rad, 360, false);
                ctx.strokeStyle = "#77ffffff";
                ctx.lineWidth = root.height * 0.002;
                ctx.stroke();
                ctx.fill();
                ctx.closePath();
                var gradient = ctx.createRadialGradient(parent.width / 2, parent.height / 2, 0, parent.width / 2, parent.height / 2, parent.width * 0.46);
                gradient.addColorStop(0.44, batteryChargePercentage.percent < 30 ? "#00EF476F" : batteryChargePercentage.percent < 60 ? "#00D0E562" : "#0023F0C7");
                gradient.addColorStop(0.97, batteryChargePercentage.percent < 30 ? "#9f0040" : batteryChargePercentage.percent < 60 ? "#ffD0E562" : "#ff23F0C7");
                ctx.lineWidth = root.height * 0.005;
                ctx.lineCap = "round";
                ctx.strokeStyle = gradient;
                ctx.beginPath();
                ctx.arc(parent.width / 2, parent.height / 2, parent.width * 0.456, 270 * rad, ((batteryChargePercentage.percent / 100 * 360) + 270) * rad, false);
                ctx.lineTo(parent.width / 2, parent.height / 2);
                ctx.stroke();
                ctx.closePath();
            }

        }

        Text {
            id: batteryDisplay

            z: 2
            renderType: Text.NativeRendering
            color: "#ffffffff"
            text: batteryChargePercentage.percent
            opacity: !displayAmbient ? 0.8 : 0.3

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.height * -0.02
            }

            font {
                pixelSize: parent.height * 0.39
                family: "Teko"
                styleName: "Light"
            }

            Text {
                id: batteryPercent

                z: 9
                renderType: Text.NativeRendering
                lineHeightMode: Text.FixedHeight
                lineHeight: parent.height * 0.94
                horizontalAlignment: Text.AlignHCenter
                color: !displayAmbient ? "#bbffffff" : "#55ffffff"
                text: "BAT<br>%"

                anchors {
                    centerIn: batteryDisplay
                    verticalCenterOffset: parent.height * 0.34
                }

                font {
                    pixelSize: parent.height * 0.194
                    family: "Teko"
                    styleName: "Regular"
                }

            }

        }

    }

    Item {
        id: handBox

        z: 3
        anchors.fill: parent

        Image {
            id: minuteSVG

            z: 3
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
                samples: 13
                color: Qt.rgba(0, 0, 0, 0.3)
            }

        }

        Image {
            id: hourSVG

            z: 4
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
            id: secondSVG

            z: 5
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
                horizontalOffset: 4
                verticalOffset: 4
                radius: 8
                samples: 17
                color: Qt.rgba(0, 0, 0, 0.3)
            }

        }

    }

    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 2
        verticalOffset: 2
        radius: 5
        samples: 8
        color: "#99000000"
    }

}

