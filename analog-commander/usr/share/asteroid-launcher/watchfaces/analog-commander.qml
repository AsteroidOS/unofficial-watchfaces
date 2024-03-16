/*
 * Copyright (C) 2022 - Ivo Hulsman <github.com/ivohulsman>
 *               2021 - Timo Könnecke <github.com/eLtMosen>
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
import Nemo.Mce 1.0

Item {
    id: root
    property string imgPath: "../watchfaces-img/analog-commander-"
    property real rad: 0.01745
    MceBatteryLevel {
        id: batteryChargePercentage
    }
    Repeater {
        model: 60
        id: minuteStrokes
        Rectangle {
            z: 0
            antialiasing: true
            property real rotM: (index - 15) / 60
            property real centerX: root.width / 2 - width / 2
            property real centerY: root.height / 2 - height / 2
            x: index % 5 ? centerX+Math.cos(rotM * 2 * Math.PI) * parent.width * 0.430 :
                           centerX+Math.cos(rotM * 2 * Math.PI) * parent.width * 0.388
            y: index % 5 ? centerY+Math.sin(rotM * 2 * Math.PI) * parent.height * 0.430 :
                           centerY+Math.sin(rotM * 2 * Math.PI) * parent.height * 0.388
            color: index % 5 ? "#ff949494" : "#ff949494"
            radius: 60
            opacity: (index%5)==0 && displayAmbient ? 0.2
                   : (index%5)==0 ? 0.6
                   : displayAmbient ? 0.2
                   : 0.5
            width: index % 5 ? parent.width * 0.0050 : parent.width * 0.018

            visible: ([0, 30].includes(index)) ? 0
                   : 1

            height: ([15, 45].includes(index)) ? parent.height * 0.060
                  : index % 5 ? parent.height * 0.026
                  : parent.height * 0.105

            transform: Rotation {
                origin.x: width / 2
                origin.y: height / 2
                angle: index * 6
            }
        }
    }

    Repeater {
        model: 12
        id: secondDots
        Rectangle {
            z: 0
            antialiasing : true
            property real rotM: (index + 2.5) / 12 
            property real centerX: root.width / 2 - width / 2
            property real centerY: root.height / 2 - height / 2
            x: centerX+Math.cos(rotM * 2 * Math.PI) * parent.width * 0.463
            y: centerY+Math.sin(rotM * 2 * Math.PI) * parent.height * 0.463
            color: "#ff949494"
            opacity: displayAmbient ? 0.2
                   : 0.5
            radius: 60
            width: parent.width * 0.022
            height: parent.height * 0.022
            transform: Rotation {
                origin.x: width / 2
                origin.y: height / 2
                angle: index * 6
            }
        }
    }

Repeater {
        id: hourNumbers
        model: 4
        Text {
            font {
                family: "Teko"
                styleName: "Regular"
                pixelSize: parent.height*0.130
            }
            property real angle: ((index) * 2 * Math.PI / hourNumbers.count - Math.PI/2) 
            property var extraY: [0.175, 0.044, -0.075 , 0.058 ]
            horizontalAlignment: Text.AlignHCenter
            opacity: displayAmbient ? 0.2 : 0.8
            anchors.centerIn: parent
            transform: 
                Translate {
                    x: Math.cos(angle) * (parent.width + width) * 0.445
                    y: Math.sin(angle) * (parent.height + height) * 0.388 + height * extraY[index]
                }
            color: "#ff949494"
            text: 3 * (index === 0 ? hourNumbers.count : index)
        }
    }

    Repeater {
    model: 60
    id: secondNumbers
        Text {
            z: 0
            font {
                family: "Michroma"
                styleName: "Regular"
                pixelSize: parent.height*0.030
            }
            horizontalAlignment: Text.AlignHCenter
            property real rotM: (index - 15) / 60
            property real centerX: parent.width / 2 - width / 2
            property real centerY: parent.height / 2 - height / 2
            property bool south: index > 15 && index < 45
            x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.463
            y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.height * 0.463
            opacity: displayAmbient ? 0.5
                   : 0.9
            color: "#ff949494"
            transform: Rotation {
                origin.x: width / 2
                origin.y: height / 2
                angle: (index) * 6 + (south ? 180 : 0)
            }
            text: (100+index).toString().substring(1)

            visible: [5, 10, 20, 25, 35, 40, 50, 55].includes(index)

        }
    }

    Image {
        z: 1
        id: asteroidLogo
        opacity: displayAmbient ? 0.1
               : 0.7
        source: "../watchfaces-img/analog-commander-asteroid-logo.svg"
        antialiasing: true
        anchors {
            centerIn: parent
            verticalCenterOffset: -parent.height * 0.272
        }
        width: parent.width * 0.12
        height: parent.height * 0.12

        Text {
            z: 2
            id: asteroidSlogan
            font {
                pixelSize: parent.height * 0.28
                family: "Raleway"
            }
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.height * -1.000
            }
            text: "<b>AsteroidOS</b><br>Hack Your Wrist"
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
        anchors {
            centerIn: parent
            horizontalCenterOffset: -parent.width * 0.22
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
                ctx.fillStyle = "#00ffffff"
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
                ctx.strokeStyle = "#ff029cdb"
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
                font {
                    pixelSize: currentMonthHighlight ?
                                    root.height * 0.036 :
                                    root.height * 0.03
                    letterSpacing: parent.width * 0.004
                    family: "Teko"
                    styleName: currentMonthHighlight ?
                                    "Regular" :
                                    "Light"
                }
                opacity: !displayAmbient ? 1 : 0.3
                property real rotM: ((index * 5) - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2
                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.35
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.35
                color:  currentMonthHighlight ?
                            "#ffffffff" :
                            "#ff949494"
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
                verticalCenterOffset: -parent.height * -0.0200
            }
            y: (parent.height + height) * -0.075
            renderType: Text.NativeRendering
            font { 
                pixelSize: parent.height * 0.39
                family: "Teko"
                styleName:"Light"
                letterSpacing: -root.width * 0.0018
            }
            color: "#ddffffff"
            opacity: !displayAmbient ? 1 : 0.3
            text: wallClock.time.toLocaleString(Qt.locale(), "dd").slice(0, 3)
        }
    }

    Item {
        id: batteryBox
        property int value: batteryChargePercentage.percent
        onValueChanged: batteryArc.requestPaint()
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width * 0.00
            horizontalCenterOffset: parent.width * 0.22
        }
        width: parent.width * 0.23
        height: parent.height * 0.23

        Canvas {
            z: 1
            id: batteryArc
            opacity: !displayAmbient ? 0.8 : 0.3
            property var hour: 0
            anchors.fill: parent
            smooth: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.beginPath()
                ctx.fillStyle = "#00ffffff"
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
                                      batteryChargePercentage.percent < 30 ?
                                          "#00EF476F" :
                                          batteryChargePercentage.percent < 60 ?
                                              "#00D0E562" :
                                              "#0023F0C7"
                                      )
                gradient.addColorStop(0.97,
                                      batteryChargePercentage.percent < 30 ?
                                          "#ffEF476F" :
                                          batteryChargePercentage.percent < 60 ?
                                              "#ffD0E562" :
                                              "#ff23F0C7"
                                      )
                ctx.lineWidth = root.height * 0.005
                ctx.lineCap = "round"
                ctx.strokeStyle = gradient
                ctx.beginPath()
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * 0.456,
                        270 * rad,
                        ((batteryChargePercentage.percent/100*360)+270) * rad,
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
                verticalCenterOffset: -parent.height * -0.0200 
            }
            renderType: Text.NativeRendering
            font {
                pixelSize: parent.height * 0.39
                family: "Teko"
                styleName:"Light"
            }
            color: "#ffffffff"
            text: batteryChargePercentage.percent
            opacity: !displayAmbient ? 0.8 : 0.3

            Text {
                 z: 9
                 id: batteryPercent
                 anchors {
                     centerIn: batteryDisplay
                     verticalCenterOffset: parent.height*0.34
                 }
                 renderType: Text.NativeRendering
                 font {
                    pixelSize: parent.height * 0.194
                    family: "Teko"
                    styleName:"Regular"
                 }
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

        z: 3
        anchors.fill: parent

        Image {
            id: hourSVG

            z: 3
            source: imgPath + "hour.svg"
            anchors.fill: parent

            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: (wallClock.time.getHours()*30) + (wallClock.time.getMinutes() * 0.5)
            }

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 2
                verticalOffset: 2
                radius: 5.0
                samples: 11
                color: Qt.rgba(0, 0, 0, .2)
            }
        }

        Image {
            id: minuteSVG

            z: 4
            source: imgPath + "minute.svg"
            anchors.fill: parent

            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: (wallClock.time.getMinutes()*6)+(wallClock.time.getSeconds() * 6 / 60)
            }

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 3
                verticalOffset: 3
                radius: 6.0
                samples: 13
                color: Qt.rgba(0, 0, 0, .3)
            }
        }

        Image {
            id: secondSVG

            z: 5
            visible: !displayAmbient
            source: imgPath + "second.svg"
            anchors.fill: parent

            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: (wallClock.time.getSeconds() * 6)
            }

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 4
                verticalOffset: 4
                radius: 8.0
                samples: 17
                color: Qt.rgba(0, 0, 0, .3)
            }
        }
    }
}
