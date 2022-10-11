/*
 * Copyright (C) 2022 - Timo Könnecke <github.com/eLtMosen>
 *               2021 - Darrel Griët <dgriet@gmail.com>
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

import QtQuick 2.15
import QtGraphicalEffects 1.15
import QtQuick.Shapes 1.15


Item {
    id: root

    property string imgPath: "../watchfaces-img/digital-namazu-no-henka-"
    property var largeNumeralSize: Qt.size(parent.width * .25, parent.height * .25)
    property var smallNumeralSize: Qt.size(parent.width * .076, parent.height * .076)
    property real largeNumeralOffset: -parent.height * .02
    property real smallNumeralOffset: parent.height * 0.0606
    property string hour: wallClock.time.toLocaleString(Qt.locale(), "HH")
    property string minute: wallClock.time.toLocaleString(Qt.locale(), "mm")
    property string month: wallClock.time.toLocaleString(Qt.locale(), "MM")
    property string day: wallClock.time.toLocaleString(Qt.locale(), "dd")

    function pad(num, size) {
        num = num.toString();
        while (num.length < size) num = "0" + num;
        return num;
    }

    Item {
          id: batteryChargePercentage
          property real value: (featureSlider.value * 100).toFixed(0)
    }

    Item {
        id: digitalTime

        anchors.fill: parent

        Image {
            id: hour1

            anchors {
                right: parent.horizontalCenter
                rightMargin: -parent.height * 0.01
                bottom: parent.verticalCenter
                bottomMargin: largeNumeralOffset
            }
            smooth: true
            sourceSize: largeNumeralSize
            source: imgPath + hour.slice(1, 2) + ".svg"
        }

        Image {
            id: hour2

            anchors {
                right: parent.horizontalCenter
                rightMargin: (-parent.height * 0.01) + (parent.height * 0.165)
                bottom: parent.verticalCenter
                bottomMargin: largeNumeralOffset
            }
            smooth: true
            sourceSize: largeNumeralSize
            source: imgPath + hour.slice(0, 1) + ".svg"
        }

        Image {
            id: colon

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.verticalCenter
                bottomMargin: largeNumeralOffset
            }
            smooth: true
            sourceSize: largeNumeralSize
            source: imgPath + "colon.svg"
        }

        Image {
            id: minute1

            anchors {
                left: parent.horizontalCenter
                leftMargin: (parent.height * 0.155) + (-parent.height * 0.165)
                bottom: parent.verticalCenter
                bottomMargin: largeNumeralOffset
            }
            smooth: true
            sourceSize: largeNumeralSize
            source: imgPath + minute.slice(0, 1) + ".svg"
        }

        Image {
            id: minute2

            anchors {
                left: parent.horizontalCenter
                leftMargin: parent.height * 0.157
                bottom: parent.verticalCenter
                bottomMargin: largeNumeralOffset
            }
            smooth: true
            sourceSize: largeNumeralSize
            source: imgPath + minute.slice(1, 2) + ".svg"
        }
    }

    Item {
        id: digitalDate

        anchors.fill: parent

        Image {
            id: day1

            anchors {
                right: parent.horizontalCenter
                rightMargin: parent.height * 0.288
                top: parent.verticalCenter
                topMargin: smallNumeralOffset
            }
            smooth: true
            sourceSize: smallNumeralSize
            source: imgPath + month.slice(0, 1) + "-small.svg"
        }

        Image {
            id: day2

            anchors {
                right: parent.horizontalCenter
                rightMargin: parent.height * 0.229
                top: parent.verticalCenter
                topMargin: smallNumeralOffset
            }
            smooth: true
            sourceSize: smallNumeralSize
            source: imgPath + month.slice(1, 2) + "-small.svg"
        }

        Image {
            id: hyphen

            anchors {
                right: parent.horizontalCenter
                rightMargin: parent.height * 0.17
                top: parent.verticalCenter
                topMargin: smallNumeralOffset
            }
            smooth: true
            sourceSize: smallNumeralSize
            source: imgPath + "hyphen-small.svg"
        }

        Image {
            id: month1

            anchors {
                left: parent.horizontalCenter
                leftMargin: -parent.height * 0.187
                top: parent.verticalCenter
                topMargin: smallNumeralOffset
            }
            smooth: true
            sourceSize: smallNumeralSize
            source: imgPath + day.slice(0, 1) + "-small.svg"
        }

        Image {
            id: month2

            anchors {
                left: parent.horizontalCenter
                leftMargin: -parent.height * 0.127
                top: parent.verticalCenter
                topMargin: smallNumeralOffset
            }
            smooth: true
            sourceSize: smallNumeralSize
            source: imgPath + day.slice(1, 2) + "-small.svg"
        }
    }

    Item {
        id: batteryDigits

        property string batteryChargeString: pad((batteryChargePercentage.value), 3)

        anchors.fill: parent

        Image {
            id: batDigit1

            anchors {
                right: parent.horizontalCenter
                rightMargin: parent.height * 0.021
                top: parent.verticalCenter
                topMargin: parent.height * 0.3
            }
            smooth: true
            sourceSize: smallNumeralSize
            source: imgPath + batteryDigits.batteryChargeString.slice(0, 1) + "-small.svg"
        }

        Image {
            id: batDigit2

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.verticalCenter
                topMargin: parent.height * 0.3
            }
            smooth: true
            sourceSize: smallNumeralSize
            source: imgPath + batteryDigits.batteryChargeString.slice(1, 2) + "-small.svg"
        }

        Image {
            id: batDigit3

            anchors {
                left: parent.horizontalCenter
                leftMargin: parent.height * 0.021
                top: parent.verticalCenter
                topMargin: parent.height * 0.3
            }
            smooth: true
            sourceSize: smallNumeralSize
            source: imgPath + batteryDigits.batteryChargeString.slice(2, 3) + "-small.svg"
        }
    }

    Item {
        id: batterySegments

        anchors.fill: parent

        layer {
            enabled: true
            samples: 4
            smooth: true
            textureSize: Qt.size(root.width * 2, root.height * 2)
        }

        Repeater {
            id: segmentedArc

            property real inputValue: batteryChargePercentage.value / 100
            property int segmentAmount: 5
            property int start: -159
            property int gap: 2
            property int endFromStart: 44
            property bool clockwise: false
            property real arcStrokeWidth: 0.026
            property real scalefactor: 0.456 - (arcStrokeWidth / 2)

            model: segmentAmount

            Shape {
                id: segment

                visible: index === 0 ? true : (index/segmentedArc.segmentAmount) < segmentedArc.inputValue

                ShapePath {
                    fillColor: "transparent"
                    strokeColor: "green"
                    strokeWidth: parent.height * segmentedArc.arcStrokeWidth
                    capStyle: ShapePath.FlatCap
                    joinStyle: ShapePath.MiterJoin
                    startX: parent.width / 2
                    startY: parent.height * ( 0.5 - segmentedArc.scalefactor)

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

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 0
        radius: 8.0
        samples: 17
        color: Qt.rgba(0, 0, 0, .7)
    }
}
