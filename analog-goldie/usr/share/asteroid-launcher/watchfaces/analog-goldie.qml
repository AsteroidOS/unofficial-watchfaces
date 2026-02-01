/*
 * Copyright (C) 2021 - Timo Könnecke <github.com/eLtMosen>
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

    property string lowColor: !displayAmbient ? "#bbCFA526" : "#66CFA526"
    property string highColor: !displayAmbient ? "#FFEBAD" : "#aaFFEBAD"
    property string accColor: !displayAmbient ? "#D88C9A" : "#88D88C9A"
    property string imgPath: "../watchfaces-img/analog-goldie-"
    property real rad: .01745

    anchors.fill: parent

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
            samples: 17
            color: Qt.rgba(0, 0, 0, 1)
        }
    }

    Item {
        id: faceBox

        anchors.fill: parent

        Repeater {
            model: 60

            Rectangle {
                id: minuteStrokes

                property real rotM: ((index) - 15) / 60
                property real centerX: parent.width / 2 - width / 2
                property real centerY: parent.height / 2 - height / 2

                z: 1
                visible: index % 5
                antialiasing : true
                width: parent.width * .005
                height: parent.height * .04
                x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * .45
                y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * .45
                color: lowColor

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
                x: index % 6 ? centerX+Math.cos(rotM * 2 * Math.PI) * parent.width * .348 :
                               centerX+Math.cos(rotM * 2 * Math.PI) * parent.width * .326
                y: index % 6 ? centerY+Math.sin(rotM * 2 * Math.PI) * parent.width * .348 :
                               centerY+Math.sin(rotM * 2 * Math.PI) * parent.width * .326
                font {
                    pixelSize: index % 3 ? parent.height * .06 : parent.height * .12
                    family: "Noto Sans"
                    styleName: index % 3 ? "SemiCondensed SemiBold" : "SemiCondensed Medium"
                }
                color: "#ddffffff"
                text: index === 0 ? 12 : index

                LinearGradient  {
                         anchors.fill: hourNumbers
                         source: hourNumbers
                         gradient: Gradient {
                             GradientStop { position: 0; color: "#bf9b30" }
                             GradientStop { position: .4; color: "#ffcf40" }
                             GradientStop { position: .6; color: "#ffbf00" }
                             GradientStop { position: 1; color: "#ffdc73" }
                         }
                }
            }
        }

        Item {
            id: dayBox

            property var day: wallClock.time.toLocaleString(Qt.locale(), "dd")

            width: parent.width * .24
            height: parent.height * .24
            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.width * .044
                horizontalCenterOffset: -parent.width * .17
            }

            onDayChanged: dayArc.requestPaint()

            Canvas {
                id: dayArc

                z: 1
                opacity: !displayAmbient ? 1 : .3
                anchors.fill: parent
                smooth: true
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
                    ctx.strokeStyle = lowColor
                    ctx.lineWidth = root.height * .002
                    ctx.stroke()
                    ctx.fill()
                    ctx.closePath()
                    ctx.lineWidth = root.height * .005
                    ctx.lineCap="round"
                    ctx.strokeStyle = accColor
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

                    property real rotM: ((index * 8.7) - 15) / 60
                    property real centerX: parent.width / 2 - width / 2
                    property real centerY: parent.height / 2 - height / 2
                    property bool currentDayHighlight: new Date(2017, 1, index).toLocaleString(Qt.locale(), "ddd") === wallClock.time.toLocaleString(Qt.locale(), "ddd")

                    z: 2
                    x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * .35
                    y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * .35
                    antialiasing: true
                    font {
                        pixelSize: currentDayHighlight ? root.height * .036 : root.height * .03
                        letterSpacing: parent.width * .004
                        family: "Noto Sans"
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
                        angle: index * 52
                    }
                }
            }

            Text {
                id: dayDisplay

                z: 2
                color: highColor
                anchors {
                    centerIn: parent
                    verticalCenterOffset: -root.width * .003
                }
                font {
                    pixelSize: parent.height * .39
                    family: "Noto Sans"
                    styleName: "Condensed"
                }
                text: wallClock.time.toLocaleString(Qt.locale(), "dd").slice(0, 2).toUpperCase()
            }
        }

        Item {
            id: monthBox

            property var month: wallClock.time.toLocaleString(Qt.locale(), "mm")

            onMonthChanged: monthArc.requestPaint()

            width: parent.width * .24
            height: parent.height * .24
            anchors {
                centerIn: parent
                verticalCenterOffset: -parent.width * .044
                horizontalCenterOffset: parent.width * .17
            }

            Canvas {
                id: monthArc

                z: 1
                anchors.fill: parent
                opacity: !displayAmbient ? 1 : .3
                smooth: true
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
                    ctx.strokeStyle = lowColor
                    ctx.lineWidth = root.height * .002
                    ctx.stroke()
                    ctx.fill()
                    ctx.closePath()
                    ctx.lineWidth = root.height * .005
                    ctx.lineCap="round"
                    ctx.strokeStyle = accColor
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

                    property real rotM: ((index * 5) - 15) / 60
                    property real centerX: parent.width / 2 - width / 2
                    property real centerY: parent.height / 2 - height / 2
                    property bool currentMonthHighlight: Number(wallClock.time.toLocaleString(Qt.locale(), "MM")) === index ||
                                                         Number(wallClock.time.toLocaleString(Qt.locale(), "MM")) === index + 12
                    z: 2
                    x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * .35
                    y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * .35
                    antialiasing: true
                    font {
                        pixelSize: currentMonthHighlight ?
                                        root.height * .036 :
                                        root.height * .03
                        letterSpacing: parent.width * .004
                        family: "Noto Sans"
                        styleName: currentMonthHighlight ?
                                        "Black" :
                                        "Condensed Bold"
                    }
                    color:  currentMonthHighlight ?
                                highColor :
                                lowColor
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

                z: 2
                anchors.centerIn: parent
                renderType: Text.NativeRendering
                font {
                    pixelSize: parent.height * .28
                    family: "Noto Sans"
                    styleName:"ExtraCondensed Medium"
                }
                color: highColor
                text: wallClock.time.toLocaleString(Qt.locale(), "MMM").slice(0, 3).toUpperCase()
            }
        }

        Item {
            id: batteryBox

            property int value: batteryChargePercentage.percent

            onValueChanged: batteryArc.requestPaint()

            anchors {
                centerIn: parent
                verticalCenterOffset: parent.width * .15
            }
            width: parent.width * .22
            height: parent.height * .22

            Canvas {
                id: batteryArc

                z: 1
                anchors.fill: parent
                opacity: !displayAmbient ? 1 : .3
                smooth: true
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
                    ctx.strokeStyle = lowColor
                    ctx.lineWidth = root.height * .002
                    ctx.stroke()
                    ctx.fill()
                    ctx.closePath()
                    ctx.lineWidth = root.height * .005
                    ctx.lineCap="round"
                    ctx.strokeStyle = batteryChargePercentage.percent < 30 ?
                                accColor : "#44BBA4"
                    ctx.beginPath()
                    ctx.arc(parent.width / 2,
                            parent.height / 2,
                            parent.width * .456,
                            270 * rad,
                            ((batteryChargePercentage.percent / 100 * 360) + 270) * rad,
                            false
                            );
                    ctx.stroke()
                    ctx.closePath()
                }
            }

            Text {
                id: batteryDisplay

                z: 2
                anchors.centerIn: parent
                renderType: Text.NativeRendering
                font {
                    pixelSize: parent.height * .48
                    family: "Noto Sans"
                    styleName:"Condensed Light"
                }
                color: highColor
                text: batteryChargePercentage.percent

                Text {
                     id: batteryPercent

                     z: 9
                     anchors {
                         centerIn: batteryDisplay
                         verticalCenterOffset: parent.height * .34
                     }
                     renderType: Text.NativeRendering
                     font {
                         pixelSize: parent.height * .194
                         family: "Noto Sans"
                         styleName:"Bold"
                     }
                     lineHeightMode: Text.FixedHeight
                     lineHeight: parent.height * .94
                     horizontalAlignment: Text.AlignHCenter
                     color: !displayAmbient ?
                                highColor :
                                lowColor
                     text: "BAT<br>%"
                 }
            }
        }

        // DropShadow on all faceBox items
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 10
            samples: 21
            color: Qt.rgba(0, 0, 0, .8)
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
                radius: 5
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
                radius: 6
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
                radius: 8
                samples: 17
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
        radius: 8
        samples: 17
        color: Qt.rgba(0, 0, 0, .3)
    }
}
