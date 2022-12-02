/*
 * Copyright (C) 2022 - Timo Könnecke <github.com/eLtMosen>
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

import QtQuick 2.15
import QtGraphicalEffects 1.15
import Nemo.Mce 1.0
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0

Item {
    id: root

    property string lowColor: !displayAmbient ? "#aab8bcc8" : "#44b8bcc8"
    property string highColor: !displayAmbient ? "#E5E5E5" : "#aaE5E5E5"
    property real verticalFontOffset: root.height * .018
    property string imgPath: "../watchfaces-img/analog-duppy-vintage-"
    property real rad: .01745

    anchors.fill: parent

    MceBatteryLevel {
            id: batteryChargePercentage
    }

    Item {
        id: faceBox

        anchors.fill: root

        Repeater {
            model: 60

            Rectangle {
                id: minuteStrokes

                property real rotM: ((index) - 15) / 60
                property real centerX: root.width / 2 - width / 2
                property real centerY: root.height / 2 - height / 2

                z: 1
                antialiasing : true
                width: index % 5 ? parent.width * .003 : root.width * .0064
                height: parent.height * .028
                x: centerX + Math.cos(rotM * 2 * Math.PI) * root.width * .484
                y: centerY + Math.sin(rotM * 2 * Math.PI) * root.width * .484
                color: highColor

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

                z: 1
                x: index % 3 ? centerX+Math.cos(rotM * 2 * Math.PI) * parent.width * .395 :
                               centerX+Math.cos(rotM * 2 * Math.PI) * parent.width * .395
                y: verticalFontOffset + (index % 3 ? centerY+Math.sin(rotM * 2 * Math.PI) * parent.width * .395 :
                               centerY+Math.sin(rotM * 2 * Math.PI) * parent.width * .395)
                font {
                    pixelSize: index % 3 ? parent.height * .074 : parent.height * .126
                    family: index % 3 ? "Kumar One" : "Kumar One Outline"
                    styleName:  index % 3 ? "Condensed" : "SemiCondensed Medium"
                    letterSpacing: index % 3 ? -root.width * .004 : -root.width * .008
                }
                opacity: index % 3 ? .9 : 1
                text: index === 0 ? 12 : index

                LinearGradient  {
                         anchors.fill: hourNumbers
                         source: hourNumbers
                         gradient: Gradient {
                             GradientStop { position: 0; color: "#CDCBD1" }
                             GradientStop { position: .4; color: "#B8BCC8" }
                             GradientStop { position: .6; color: "#E5E5E5" }
                             GradientStop { position: 1; color: "#E1E6E8" }
                         }
                }
            }
        }

        Item {
            id: dayBox

            property var day: wallClock.time.toLocaleString(Qt.locale(), "dd")

            width: parent.width * .6
            height: parent.height * .6
            anchors {
                centerIn: parent
            }

            Repeater {
                model: 7
                visible: !displayAmbient

                Text {
                    id: dayStrokes

                    property real rotM: ((index * 4.89) + 30.6) / 60
                    property real centerX: parent.width / 2 - width / 2
                    property real centerY: parent.height / 2 - height / 2
                    property bool currentDayHighlight: new Date(2017, 1, index).toLocaleString(Qt.locale(), "ddd") === wallClock.time.toLocaleString(Qt.locale(), "ddd")

                    z: 2
                    x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * .35
                    y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * .35
                    antialiasing: true
                    font {
                        pixelSize: currentDayHighlight ? root.height * .07 : root.height * .06
                        letterSpacing: parent.width * .004
                        family: "Varieté"
                        styleName: currentDayHighlight ?
                                        "Black" :
                                        "SemiCondensed Bold"
                    }
                    color: currentDayHighlight ?
                               highColor :
                               lowColor
                    text: new Date(2017, 1, index).toLocaleString(Qt.locale(), "ddd").slice(0, 2).toUpperCase()

                    transform: Rotation {
                        origin.x: width / 2
                        origin.y: height / 2
                        angle: -90 + (index *30)
                    }
                }
            }
        }

        Item {
            id: batteryBox

            property int value: batteryChargePercentage.percent

            anchors {
                centerIn: parent
            }
            width: parent.width * .5
            height: parent.height * .5

            Repeater {
                id: arcRepeater
                model: 3

                Canvas {
                    id: batteryArc

                    property int value: batteryBox.value
                    property int arcStart: 110
                    property int arcEnd: 250

                    onValueChanged: batteryArc.requestPaint()

                    z: 1

                    anchors.fill: parent
                    opacity: !displayAmbient ? 1 - (index/5) : .3
                    smooth: true
                    renderStrategy: Canvas.Cooperative
                    onPaint: {
                        var ctx = getContext("2d")

                        ctx.reset()
                        ctx.beginPath()
                        ctx.fillStyle = "#22ffffff"
                        ctx.arc(parent.width / 2,
                                parent.height / 2,
                                parent.width * .39 + (index * (parent.width * 0.04)),
                                (arcStart + 270) * rad,
                                (arcEnd - 90) * rad,
                                false);
                        ctx.strokeStyle = lowColor
                        ctx.lineWidth = root.height * .004
                        ctx.stroke()
                        ctx.closePath()
                        ctx.lineWidth = root.height * .005
                        ctx.lineCap="round"
                        ctx.strokeStyle = batteryBox.value < 30 ?
                                    accColor2 : "#2E933C"
                        ctx.beginPath()
                        ctx.arc(parent.width / 2,
                                parent.height / 2,
                                parent.width * .39 + (index * (parent.width * 0.04)),
                                (arcStart + 270) * rad,
                                (((batteryBox.value / (36000/(arcEnd-arcStart))) * (arcStart + arcEnd)) + (arcEnd + arcStart + (arcStart - 90))) * rad,
                                false
                                );
                        ctx.stroke()
                        ctx.closePath()
                    }
                }
            }

            Text {
                id: batteryDisplay

                z: 2
                anchors {
                    centerIn: parent
                    verticalCenterOffset: parent.height * .30
                }
                renderType: Text.NativeRendering
                font {
                    pixelSize: parent.height * .12
                    family: "Kumar One"
                    styleName:"Condensed Light"
                }
                color: highColor
                opacity: 0.9
                text: batteryBox.value

                Text {
                     id: batteryPercent

                     z: 9
                     anchors {
                         left: batteryDisplay.right
                         leftMargin: parent.height * .034
                         verticalCenter: batteryDisplay.verticalCenter
                     }
                     renderType: Text.NativeRendering
                     font {
                         pixelSize: parent.height * .24
                         family: "Kumar One Outline"
                         styleName:"Bold"
                     }
                     horizontalAlignment: Text.AlignHCenter

                     color: !displayAmbient ?
                                highColor :
                                lowColor
                     text: "%"
                 }
            }
        }

        // DropShadow on all faceBox items
        layer.enabled: true

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 6.0
            samples: 13
            color: Qt.rgba(0, 0, 0, .7)
        }
    }

    Item {
        id: handBox

        z: 3
        anchors.fill: parent

        Image {
            id: hourSVG

            z: 3
            source:imgPath + "hour.svg"
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
                color: Qt.rgba(0, 0, 0, .4)
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
                angle: (wallClock.time.getMinutes()*6)
            }

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 4
                verticalOffset: 4
                radius: 6.0
                samples: 13
                color: Qt.rgba(0, 0, 0, .3)
            }
        }
    }

    // DropShadow on all hands
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 2
        verticalOffset: 2
        radius: 8.0
        samples: 17
        color: Qt.rgba(0, 0, 0, .3)
    }
}
