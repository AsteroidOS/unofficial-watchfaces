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

import QtQuick 2.1
import QtGraphicalEffects 1.15
import Nemo.Mce 1.0
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0

Item {
    id: root

    property string imgPath: "../watchfaces-img/analog-scientific-v2-"
    property real rad: .01745

    MceBatteryLevel {
        id: batteryChargePercentage
    }

    Repeater {
        model: 60

        Rectangle {
            id: minuteStrokes

            property real rotM: (index - 15) / 60
            property real centerX: root.width / 2 - width / 2
            property real centerY: root.height / 2 - height / 2

            x: index % 5 ? centerX+Math.cos(rotM * 2 * Math.PI) * parent.width * .488 :
                           centerX+Math.cos(rotM * 2 * Math.PI) * parent.width * .480
            y: index % 5 ? centerY+Math.sin(rotM * 2 * Math.PI) * parent.width * .488 :
                           centerY+Math.sin(rotM * 2 * Math.PI) * parent.width * .480
            antialiasing : true
            color: index % 5 ? "#77ffffff" : "#ffffffff"
            width: index % 5 ? parent.width * .0066 : parent.width * .009
            height: index % 5 ? parent.height * .026 : parent.height * .038
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
            id: hourNumbers

            property real rotM: ((index * 5 ) - 15) / 60
            property real centerX: parent.width / 2 - width / 2
            property real centerY: parent.height / 2 - height / 2

            x: index === 10 ?
                   centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * .378 :
                   index === 11 ?
                       centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * .388 :
                       centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * .4
            y: index === 10 ?
                   centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * .378 :
                   index === 11 ?
                       centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * .388 :
                       centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * .4
            font {
                pixelSize: parent.height * .088
                family: "Outfit"
                styleName: "Regular"
            }
            horizontalAlignment: Text.AlignHCenter
            color: "#ffffffff"
            text: index === 0 ? "12" : index
        }
    }

    Image {
        id: asteroidLogo

        visible: !displayAmbient
        source: "../watchfaces-img/asteroid-logo.svg"
        antialiasing: true
        anchors {
            centerIn: parent
            verticalCenterOffset: -parent.height * .272
        }
        width: parent.width * .12
        height: parent.height * .12
        opacity: .7

        Text {
            id: asteroidSlogan

            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.height * .005
            }
            font {
                pixelSize: parent.height * .31
                family: "Raleway"
            }
            visible: !displayAmbient
            color: "white"
            horizontalAlignment: Text.AlignHCenter
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
        id: digitalDisplay

        anchors {
            right: parent.horizontalCenter
            rightMargin: parent.width * .004
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -parent.width * .124
        }
        font {
            pixelSize: parent.height * .15
            family: "Open Sans"
            styleName: "Regular"
            letterSpacing: -parent.width * .001
        }
        color: "#bbffffff"
        text: if (use12H.value) {
                  wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2)}
              else
                  wallClock.time.toLocaleString(Qt.locale(), "HH")
    }

    Text {
        id: digitalMinutes

        anchors {
            left: digitalDisplay.right
            bottom: digitalDisplay.bottom
            leftMargin: root.width * .004
        }
        font {
            pixelSize: root.height * .15
            family: "Open Sans"
            styleName: "Light"
            letterSpacing: -parent.width * .001
        }
        color: "#ccffffff"
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    Text {
        id: apDisplay

        anchors {
            left: digitalMinutes.right
            leftMargin: parent.width * .014
            bottom: digitalMinutes.verticalCenter
            bottomMargin: -parent.width * .012
        }
        font {
            pixelSize: root.height * .06
            family: "Open Sans Condensed"
            styleName: "Regular"
        }
        visible: use12H.value
        color: "#ddffffff"
        text: wallClock.time.toLocaleString(Qt.locale(), "ap").toUpperCase()
    }

    Item {
        id: dayBox

        property var day: wallClock.time.toLocaleString(Qt.locale(), "dd")

        onDayChanged: dayArc.requestPaint()

        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width * .06
            horizontalCenterOffset: -parent.width * .23
        }
        width: parent.width * .22
        height: parent.height * .22

        Canvas {
            id: dayArc

            anchors.fill: parent
            opacity: !displayAmbient ? 1 : .3
            smooth: true
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.beginPath()
                ctx.fillStyle = "#22ffffff"
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * .45,
                        270 * rad,
                        360,
                        false);
                ctx.strokeStyle = "#77ffffff"
                ctx.lineWidth = root.height * .002
                ctx.stroke()
                ctx.fill()
                ctx.closePath()
                ctx.lineWidth = root.height * .005
                ctx.lineCap="round"
                ctx.strokeStyle = "#ff98E2C6"
                ctx.beginPath()
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * .456,
                        169 * rad,
                        ((wallClock.time.getDay() / 7 * 360) + 169) * rad,
                        false);
                ctx.stroke()
                ctx.closePath()
            }
        }

        Repeater {
            model: 7
            visible: !displayAmbient

            Text {
                id: dayStrokes

                property bool currentDayHighlight: new Date(2017, 1, index).toLocaleString(Qt.locale(), "ddd") === wallClock.time.toLocaleString(Qt.locale(), "ddd")
                property real rotM: ((index * 8.7) -15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * .35
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * .35
                antialiasing: true
                opacity: !displayAmbient ? 1 : .6
                color: currentDayHighlight ?
                           "#ffffffff" :
                           "#88ffffff"
                font {
                    pixelSize: currentDayHighlight ? root.height * .036 : root.height * .03
                    letterSpacing: parent.width * .004
                    family: "Outfit"
                    styleName: currentDayHighlight ?
                                    "Bold" :
                                    "Regular"
                }
                text: new Date(2017, 1, index).toLocaleString(Qt.locale(), "ddd").slice(0, 2).toUpperCase()
                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                    angle: index * 52
                }
            }
        }

        Text {
            id: dayDisplay

            anchors {
                centerIn: parent
                verticalCenterOffset: -root.width * .003
            }
            font {
                pixelSize: parent.height * .39
                family: "Open Sans Condensed"
                styleName:"Light"
            }
            color: "#ffffffff"
            text: wallClock.time.toLocaleString(Qt.locale(), "dd").slice(0, 2).toUpperCase()
        }
    }

    Item {
        id: monthBox

        property var month: wallClock.time.toLocaleString(Qt.locale(), "mm")

        onMonthChanged: monthArc.requestPaint()

        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width * .06
            horizontalCenterOffset: parent.width * .23
        }
        width: parent.width * .22
        height: parent.height * .22

        Canvas {
            id: monthArc

            anchors.fill: parent
            opacity: !displayAmbient ? 1 : .3
            smooth: true
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.beginPath()
                ctx.fillStyle = "#22ffffff"
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * .45,
                        270 * rad,
                        360,
                        false);
                ctx.strokeStyle = "#77ffffff"
                ctx.lineWidth = root.height * .002
                ctx.stroke()
                ctx.fill()
                ctx.closePath()
                ctx.lineWidth = root.height * .005
                ctx.lineCap="round"
                ctx.strokeStyle = "#ff98E2C6"
                ctx.beginPath()
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * .456,
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
                id: monthStrokes

                property bool currentMonthHighlight: Number(wallClock.time.toLocaleString(Qt.locale(), "MM")) === index ||
                                                     Number(wallClock.time.toLocaleString(Qt.locale(), "MM")) === index + 12
                property real rotM: ((index * 5) - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * .35
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * .35
                antialiasing: true
                opacity: !displayAmbient ? 1 : .6
                font {
                    pixelSize: currentMonthHighlight ?
                                   root.height * .036 :
                                   root.height * .03
                    letterSpacing: parent.width * .004
                    family: "Outfit"
                    styleName: currentMonthHighlight ?
                                   "Bold" :
                                   "Regular"
                }
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
            id: monthDisplay

            anchors.centerIn: parent
            renderType: Text.NativeRendering
            font {
                pixelSize: parent.height * .366
                family: "Open Sans Condensed"
                styleName:"Light"
                letterSpacing: -root.width * .0018
            }
            color: "#ddffffff"
            text: wallClock.time.toLocaleString(Qt.locale(), "MMM").slice(0, 3).toUpperCase()
        }
    }

    Item {
        id: batteryBox

        property int value: batteryChargePercentage.percent

        onValueChanged: batteryArc.requestPaint()

        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width * .206
        }
        width: parent.width * .26
        height: parent.height * .26

        Canvas {
            id: batteryArc

            property int hour: 0

            opacity: !displayAmbient ? 1 : .3
            anchors.fill: parent
            smooth: true
            renderStrategy: Canvas.Cooperative
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.beginPath()
                ctx.fillStyle = "#22ffffff"
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * .45,
                        270 * rad,
                        360,
                        false);
                ctx.strokeStyle = "#77ffffff"
                ctx.lineWidth = root.height * .002
                ctx.stroke()
                ctx.fill()
                ctx.closePath()
                var gradient = ctx.createRadialGradient (parent.width / 2,
                                                         parent.height / 2,
                                                         0,
                                                         parent.width / 2,
                                                         parent.height / 2,
                                                         parent.width * .46
                                                         )
                gradient.addColorStop(.44,
                                      batteryChargePercentage.percent < 30 ?
                                          "#00EF476F" :
                                          batteryChargePercentage.percent < 60 ?
                                              "#00D0E562" :
                                              "#0023F0C7"
                                      )
                gradient.addColorStop(.97,
                                      batteryChargePercentage.percent < 30 ?
                                          "#ffEF476F" :
                                          batteryChargePercentage.percent < 60 ?
                                              "#ffD0E562" :
                                              "#ff23F0C7"
                                      )
                ctx.lineWidth = root.height * .005
                ctx.lineCap="round"
                ctx.strokeStyle = gradient
                ctx.beginPath()
                ctx.arc(parent.width / 2,
                        parent.height / 2,
                        parent.width * .456,
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
            id: batteryDisplay

            anchors.centerIn: parent
            renderType: Text.NativeRendering
            font {
                pixelSize: parent.height * .48
                family: "Outfit"
                styleName:"Thin"
            }
            color: "#ffffffff"
            text: batteryChargePercentage.percent

            Text {
                 id: batteryPercent

                 anchors {
                     centerIn: batteryDisplay
                     verticalCenterOffset: parent.height*.34
                 }
                 font {
                     pixelSize: parent.height * .194
                     family: "Open Sans"
                     styleName:"Regular"
                 }
                 renderType: Text.NativeRendering
                 horizontalAlignment: Text.AlignHCenter
                 lineHeightMode: Text.FixedHeight
                 lineHeight: parent.height * .94
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
        samples: 11
        color: "#99000000"
    }

    Item {
        id: handBox

        width: parent.width
        height: parent.height

        Image {
            id: hourSVG

            anchors.centerIn: parent
            source: imgPath + (displayAmbient ? "hour-bw.svg" : "hour.svg")
            antialiasing: true
            width: parent.width
            height: parent.height
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
            layer {
                enabled: true
                samples: 4
                smooth: true
                textureSize: Qt.size(root.width * 2, root.height * 2)
                effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 4
                    verticalOffset: 4
                    radius: 8.0
                    samples: 17
                    color: Qt.rgba(0, 0, 0, .2)
                }
            }
        }

        Image {
            id: minuteSVG

            anchors.centerIn: parent
            source: imgPath + (displayAmbient ? "minute-bw.svg" : "minute.svg")
            antialiasing: true
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
            layer {
                enabled: true
                samples: 4
                smooth: true
                textureSize: Qt.size(root.width * 2, root.height * 2)
                effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 5
                    verticalOffset: 5
                    radius: 10.0
                    samples: 21
                    color: Qt.rgba(0, 0, 0, .2)
                }
            }
        }

        Image {
            id: secondSVG

            anchors.centerIn: parent
            source: imgPath + "second.svg"
            antialiasing: true
            visible: !displayAmbient
            width: parent.width
            height: parent.height
            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: (wallClock.time.getSeconds() * 6)
            }
            layer {
                enabled: true
                samples: 4
                smooth: true
                textureSize: Qt.size(root.width * 2, root.height * 2)
                effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 7
                    verticalOffset: 7
                    radius: 11.0
                    samples: 23
                    color: Qt.rgba(0, 0, 0, .2)
                }
            }
        }
    }
}
