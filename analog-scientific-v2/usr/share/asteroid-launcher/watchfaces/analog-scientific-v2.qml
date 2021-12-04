/*
 * Copyright (C) 2021 - Timo Könnecke <github.com/eLtMosen>
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

import QtQuick 2.1
import QtGraphicalEffects 1.15
import org.freedesktop.contextkit 1.0
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0

Item {
    id: root
    property string imgPath: "../watchface-img/analog-scientific-v2-"
    property real rad: 0.01745

    ContextProperty {
        id: batteryChargePercentage
        key: "Battery.ChargePercentage"
        value: "100"
        Component.onCompleted: batteryChargePercentage.subscribe()
    }

    Repeater {
        model: 60
        Rectangle {
            z: 0
            id: minuteStrokes
            antialiasing : true
            property real rotM: (index - 15) / 60
            property real centerX: root.width / 2 - width / 2
            property real centerY: root.height / 2 - height / 2
            x: index % 5 ? centerX+Math.cos(rotM * 2 * Math.PI) * parent.width * 0.488 :
                           centerX+Math.cos(rotM * 2 * Math.PI) * parent.width * 0.480
            y: index % 5 ? centerY+Math.sin(rotM * 2 * Math.PI) * parent.width * 0.488 :
                           centerY+Math.sin(rotM * 2 * Math.PI) * parent.width * 0.480
            color: index % 5 ? "#77ffffff" : "#ffffffff"
            width: index % 5 ? parent.width * 0.0066 : parent.width * 0.009
            height: index % 5 ? parent.height * 0.026 : parent.height * 0.038
            transform: Rotation {
                origin.x: width / 2
                origin.y: height / 2
                angle: (index) * 6
            }

        }
    }

    Repeater {
        model: 12
        Text {
            z: 0
            id: hourNumbers
            font.pixelSize: parent.height*0.088
            font.family: "Outfit"
            font.styleName: "Regular"
            horizontalAlignment: Text.AlignHCenter
            property real rotM: ((index * 5 ) - 15) / 60
            property real centerX: parent.width / 2 - width / 2
            property real centerY: parent.height / 2 - height / 2
            x: index === 10 ?
                   centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.378 :
                   index === 11 ?
                       centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.388 :
                       centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.4
            y: index === 10 ?
                   centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.378 :
                   index === 11 ?
                       centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.388 :
                       centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.4
            color: "#ffffffff"
            text: index === 0 ? "12" : index
        }
    }

    Image {
        z: 1
        id: asteroidLogo
        visible: !displayAmbient
        source: "../watchface-img/asteroid-logo.svg"
        antialiasing: true
        anchors {
            centerIn: parent
            verticalCenterOffset: -parent.height * 0.272
        }
        width: parent.width * 0.12
        height: parent.height * 0.12
        opacity: 0.7

        Text {
            z: 2
            id: asteroidSlogan
            visible: !displayAmbient
            font.pixelSize: parent.height * 0.31
            font.family: "Raleway"
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.height * 0.005
            }
            text: "<b>AsteroidOS</b><br>Hack Your Wrist"
        }
        MouseArea {
            anchors.fill: parent
            onPressAndHold: asteroidLogo.visible ?
                                asteroidLogo.visible = false :
                                asteroidLogo.visible = true
        }
    }

    Text {
        z: 1
        id: digitalDisplay
        font.pixelSize: parent.height * 0.15
        font.family: "Open Sans"
        font.styleName: "Regular"
        font.letterSpacing: -parent.width * 0.001
        color: "#bbffffff"
        anchors {
            right: parent.horizontalCenter
            rightMargin: parent.width * 0.004
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -parent.width * 0.124

        }
        text: if (use12H.value) {
                  wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2)}
              else
                  wallClock.time.toLocaleString(Qt.locale(), "HH")
    }

    Text {
        z: 1
        id: digitalMinutes
        font.pixelSize: root.height * 0.15
        font.family: "Open Sans"
        font.styleName: "Light"
        font.letterSpacing: -parent.width * 0.001
        color: "#ccffffff"
        anchors {
            left: digitalDisplay.right
            bottom: digitalDisplay.bottom
            leftMargin: root.width * 0.004
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    Text {
        z: 1
        id: apDisplay
        visible: use12H.value
        font.pixelSize: root.height*0.06
        font.family: "Open Sans Condensed"
        font.styleName: "Regular"
        color: "#ddffffff"
        anchors {
            left: digitalMinutes.right
            leftMargin: parent.width * 0.014
            bottom: digitalMinutes.verticalCenter
            bottomMargin: -parent.width * 0.012
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "ap").toUpperCase()
    }

    Item {
        id: dayBox
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width * 0.06
            horizontalCenterOffset: -parent.width * 0.23
        }
        width: parent.width * 0.22
        height: parent.height * 0.22
        property var day: wallClock.time.toLocaleString(Qt.locale(), "dd")

        onDayChanged: dayArc.requestPaint()

        Canvas {
            z: 1
            id: dayArc
            opacity: !displayAmbient ? 1 : 0.3

            anchors.fill: parent
            smooth: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.beginPath()
                ctx.fillStyle = "#22ffffff"
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * 0.45,
                        270 * rad,
                        360,
                        false);
                ctx.strokeStyle = "#77ffffff"
                ctx.lineWidth = root.height * 0.002
                ctx.stroke()
                ctx.fill()
                ctx.closePath()
                ctx.lineWidth = root.height * 0.005
                ctx.lineCap="round"
                ctx.strokeStyle = "#ff98E2C6"
                ctx.beginPath()
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * 0.456,
                        169 * rad,
                        ((wallClock.time.getDay() / 7 * 360) + 169) * rad,
                        false);
                ctx.stroke()
                ctx.closePath()
            }
        }

        Repeater {
            visible: !displayAmbient
            model: 7
            Text {
                z: 2
                id: dayStrokes
                property bool currentDayHighlight: new Date(2017, 1, index).toLocaleString(Qt.locale(), "ddd") === wallClock.time.toLocaleString(Qt.locale(), "ddd")
                antialiasing: true
                font.pixelSize: currentDayHighlight ? root.height * 0.036 : root.height * 0.03
                font.letterSpacing: parent.width * 0.004
                font.family: "Outfit"
                font.styleName: currentDayHighlight ?
                                    "Bold" :
                                    "Regular"
                opacity: !displayAmbient ? 1 : 0.6
                property real rotM: ((index * 8.7) -15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2
                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.35
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.35
                color: currentDayHighlight ?
                           "#ffffffff" :
                           "#88ffffff"
                text: new Date(2017, 1, index).toLocaleString(Qt.locale(), "ddd").slice(0, 2).toUpperCase()
                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                    angle: index * 52
                }
            }
        }

        Text {
            z: 2
            id: dayDisplay
            font.pixelSize: parent.height * 0.39
            font.family: "Open Sans Condensed"
            font.styleName:"Light"
            color: "#ffffffff"
            anchors {
                centerIn: parent
                verticalCenterOffset: -root.width * 0.003
            }
            text: wallClock.time.toLocaleString(Qt.locale(), "dd").slice(0, 2).toUpperCase()
        }
    }

    Item {
        id: monthBox
        property var month: wallClock.time.toLocaleString(Qt.locale(), "mm")
        onMonthChanged: monthArc.requestPaint()
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width * 0.06
            horizontalCenterOffset: parent.width * 0.23
        }
        width: parent.width * 0.22
        height: parent.height * 0.22

        Canvas {
            z: 1
            id: monthArc
            opacity: !displayAmbient ? 1 : 0.3
            anchors.fill: parent
            smooth: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.beginPath()
                ctx.fillStyle = "#22ffffff"
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * 0.45,
                        270 * rad,
                        360,
                        false);
                ctx.strokeStyle = "#77ffffff"
                ctx.lineWidth = root.height * 0.002
                ctx.stroke()
                ctx.fill()
                ctx.closePath()
                ctx.lineWidth = root.height * 0.005
                ctx.lineCap="round"
                ctx.strokeStyle = "#ff98E2C6"
                ctx.beginPath()
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * 0.456,
                        270 * rad,
                        ((wallClock.time.toLocaleString(Qt.locale(),"MM") / 12 * 360) + 270) * rad,
                        false);
                ctx.stroke()
                ctx.closePath()
            }
        }

        Repeater {
            model: 12
            Text {
                z: 2
                id: monthStrokes
                property bool currentMonthHighlight: Number(wallClock.time.toLocaleString(Qt.locale(), "MM")) === index ||
                                                     Number(wallClock.time.toLocaleString(Qt.locale(), "MM")) === index + 12
                antialiasing: true
                font.pixelSize: currentMonthHighlight ?
                                    root.height * 0.036 :
                                    root.height * 0.03
                font.letterSpacing: parent.width * 0.004
                font.family: "Outfit"
                font.styleName: currentMonthHighlight ?
                                    "Bold" :
                                    "Regular"
                opacity: !displayAmbient ? 1 : 0.6
                property real rotM: ((index * 5) - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2
                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.35
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.35
                color:  currentMonthHighlight ?
                            "#ffffffff" :
                            "#88ffffff"
                text: index === 0 ? 12 : index
                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                    angle: (index * 30)
                }
            }
        }

        Text {
            z: 2
            id: monthDisplay
            anchors {
                centerIn: parent
            }
            renderType: Text.NativeRendering
            font.pixelSize: parent.height * 0.366
            font.family: "Open Sans Condensed"
            font.styleName:"Light"
            font.letterSpacing: -root.width * 0.0018
            color: "#ddffffff"
            text: wallClock.time.toLocaleString(Qt.locale(), "MMM").slice(0, 3).toUpperCase()
        }
    }

    Item {
        id: batteryBox
        property int value: batteryChargePercentage.value
        onValueChanged: batteryArc.requestPaint()
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width * 0.206
        }
        width: parent.width * 0.26
        height: parent.height * 0.26

        Canvas {
            z: 1
            id: batteryArc
            opacity: !displayAmbient ? 1 : 0.3
            property var hour: 0
            anchors.fill: parent
            smooth: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.beginPath()
                ctx.fillStyle = "#22ffffff"
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * 0.45,
                        270 * rad,
                        360,
                        false);
                ctx.strokeStyle = "#77ffffff"
                ctx.lineWidth = root.height * 0.002
                ctx.stroke()
                ctx.fill()
                ctx.closePath()
                var gradient = ctx.createRadialGradient (parent.width / 2,
                                                         parent.height / 2,
                                                         0,
                                                         parent.width / 2,
                                                         parent.height / 2,
                                                         parent.width * 0.46
                                                         )
                gradient.addColorStop(0.44,
                                      batteryChargePercentage.value < 30 ?
                                          "#00EF476F" :
                                          batteryChargePercentage.value < 60 ?
                                              "#00D0E562" :
                                              "#0023F0C7"
                                      )
                gradient.addColorStop(0.97,
                                      batteryChargePercentage.value < 30 ?
                                          "#ffEF476F" :
                                          batteryChargePercentage.value < 60 ?
                                              "#ffD0E562" :
                                              "#ff23F0C7"
                                      )
                ctx.lineWidth = root.height * 0.005
                ctx.lineCap="round"
                ctx.strokeStyle = gradient
                ctx.beginPath()
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * 0.456,
                        270 * rad,
                        ((batteryChargePercentage.value/100*360)+270) * rad,
                        false
                        );
                ctx.lineTo(parent.width / 2,
                           parent.height / 2)
                ctx.stroke()
                ctx.closePath()
            }
        }

        Text {
            z: 2
            id: batteryDisplay
            anchors {
                centerIn: parent
            }
            renderType: Text.NativeRendering
            font.pixelSize: parent.height * 0.48
            font.family: "Outfit"
            font.styleName:"Thin"
            color: "#ffffffff"
            text: batteryChargePercentage.value

            Text {
                 z: 9
                 id: batteryPercent
                 anchors {
                     centerIn: batteryDisplay
                     verticalCenterOffset: parent.height*0.34
                 }
                 renderType: Text.NativeRendering
                 font.pixelSize: parent.height * 0.194
                 font.family: "Open Sans"
                 font.styleName:"Regular"
                 lineHeightMode: Text.FixedHeight
                 lineHeight: parent.height * 0.94
                 horizontalAlignment: Text.AlignHCenter
                 color: !displayAmbient ?
                            "#bbffffff" :
                            "#55ffffff"
                 text: "BAT<br>%"
             }
        }
    }

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 2
        verticalOffset: 2
        radius: 5.0
        samples: 8
        color: "#99000000"
    }

    Item {
        id: handBox
        z:3
        width: parent.width
        height: parent.height

        Image {
            id: hourSVG
            z: 3
            property bool toggle24h: false
            source: imgPath + "hour.svg"
            antialiasing: true
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: hourSVG.toggle24h ?
                           (wallClock.time.getHours() * 15) + (wallClock.time.getMinutes() * 0.25) :
                           (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * 0.5)
                Behavior on angle {
                    RotationAnimation {
                        duration: 500
                        direction: RotationAnimation.Clockwise
                        easing.type: Easing.InOutQuad
                    }
                }
            }
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 4
                verticalOffset: 4
                radius: 8.0
                samples: 12
                color: Qt.rgba(0, 0, 0, 0.2)
            }
        }

        Image {
            id: minuteSVG
            z: 4
            source: imgPath + "minute.svg"
            antialiasing: true
            smooth: true
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
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
                samples: 13
                color: Qt.rgba(0, 0, 0, 0.2)
            }
        }

        Image {
            id: secondSVG
            z: 5
            antialiasing: true
            visible: !displayAmbient
            source: imgPath + "second.svg"
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: (wallClock.time.getSeconds() * 6)
            }
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 8
                verticalOffset: 8
                radius: 10.0
                samples: 13
                color: Qt.rgba(0, 0, 0, 0.2)
            }
        }
    }
}
