// SPDX-FileCopyrightText: 2022 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2021 Darrel Griët <dgriet@gmail.com>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import Nemo.Mce
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property string imgPath: "../watchfaces-img/digital-namazu-no-henka-"
    property var largeNumeralSize: Qt.size(parent.width * 0.25, parent.height * 0.25)
    property var smallNumeralSize: Qt.size(parent.width * 0.076, parent.height * 0.076)
    property real largeNumeralOffset: -parent.height * 0.02
    property real smallNumeralOffset: parent.height * 0.0606
    property string hour: wallClock.time.toLocaleString(Qt.locale(), "HH")
    property string minute: wallClock.time.toLocaleString(Qt.locale(), "mm")
    property string month: wallClock.time.toLocaleString(Qt.locale(), "MM")
    property string day: wallClock.time.toLocaleString(Qt.locale(), "dd")

    function pad(num, size) {
        num = num.toString();
        while (num.length < size)num = "0" + num
        return num;
    }

    layer.enabled: true

    MceBatteryLevel {
        id: batteryChargePercentage
    }

    Item {
        id: digitalTime

        anchors.fill: parent

        Image {
            id: hour1

            sourceSize: largeNumeralSize
            source: imgPath + hour.slice(1, 2) + ".svg"

            anchors {
                right: parent.horizontalCenter
                rightMargin: -parent.height * 0.01
                bottom: parent.verticalCenter
                bottomMargin: largeNumeralOffset
            }

        }

        Image {
            id: hour2

            sourceSize: largeNumeralSize
            source: imgPath + hour.slice(0, 1) + ".svg"

            anchors {
                right: parent.horizontalCenter
                rightMargin: (-parent.height * 0.01) + (parent.height * 0.165)
                bottom: parent.verticalCenter
                bottomMargin: largeNumeralOffset
            }

        }

        Image {
            id: colon

            sourceSize: largeNumeralSize
            source: imgPath + "colon.svg"

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.verticalCenter
                bottomMargin: largeNumeralOffset
            }

        }

        Image {
            id: minute1

            sourceSize: largeNumeralSize
            source: imgPath + minute.slice(0, 1) + ".svg"

            anchors {
                left: parent.horizontalCenter
                leftMargin: (parent.height * 0.155) + (-parent.height * 0.165)
                bottom: parent.verticalCenter
                bottomMargin: largeNumeralOffset
            }

        }

        Image {
            id: minute2

            sourceSize: largeNumeralSize
            source: imgPath + minute.slice(1, 2) + ".svg"

            anchors {
                left: parent.horizontalCenter
                leftMargin: parent.height * 0.157
                bottom: parent.verticalCenter
                bottomMargin: largeNumeralOffset
            }

        }

    }

    Item {
        id: digitalDate

        anchors.fill: parent

        Image {
            id: day1

            sourceSize: smallNumeralSize
            source: imgPath + month.slice(0, 1) + "-small.svg"

            anchors {
                right: parent.horizontalCenter
                rightMargin: parent.height * 0.288
                top: parent.verticalCenter
                topMargin: smallNumeralOffset
            }

        }

        Image {
            id: day2

            sourceSize: smallNumeralSize
            source: imgPath + month.slice(1, 2) + "-small.svg"

            anchors {
                right: parent.horizontalCenter
                rightMargin: parent.height * 0.229
                top: parent.verticalCenter
                topMargin: smallNumeralOffset
            }

        }

        Image {
            id: hyphen

            sourceSize: smallNumeralSize
            source: imgPath + "hyphen-small.svg"

            anchors {
                right: parent.horizontalCenter
                rightMargin: parent.height * 0.17
                top: parent.verticalCenter
                topMargin: smallNumeralOffset
            }

        }

        Image {
            id: month1

            sourceSize: smallNumeralSize
            source: imgPath + day.slice(0, 1) + "-small.svg"

            anchors {
                left: parent.horizontalCenter
                leftMargin: -parent.height * 0.187
                top: parent.verticalCenter
                topMargin: smallNumeralOffset
            }

        }

        Image {
            id: month2

            sourceSize: smallNumeralSize
            source: imgPath + day.slice(1, 2) + "-small.svg"

            anchors {
                left: parent.horizontalCenter
                leftMargin: -parent.height * 0.127
                top: parent.verticalCenter
                topMargin: smallNumeralOffset
            }

        }

    }

    Item {
        id: batteryDigits

        property string batteryChargeString: pad((batteryChargePercentage.percent), 3)

        anchors.fill: parent

        Image {
            id: batDigit1

            sourceSize: smallNumeralSize
            source: imgPath + batteryDigits.batteryChargeString.slice(0, 1) + "-small.svg"

            anchors {
                right: parent.horizontalCenter
                rightMargin: parent.height * 0.021
                top: parent.verticalCenter
                topMargin: parent.height * 0.3
            }

        }

        Image {
            id: batDigit2

            sourceSize: smallNumeralSize
            source: imgPath + batteryDigits.batteryChargeString.slice(1, 2) + "-small.svg"

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.verticalCenter
                topMargin: parent.height * 0.3
            }

        }

        Image {
            id: batDigit3

            sourceSize: smallNumeralSize
            source: imgPath + batteryDigits.batteryChargeString.slice(2, 3) + "-small.svg"

            anchors {
                left: parent.horizontalCenter
                leftMargin: parent.height * 0.021
                top: parent.verticalCenter
                topMargin: parent.height * 0.3
            }

        }

    }

    Item {
        id: batterySegments

        anchors.fill: parent

        Repeater {
            id: segmentedArc

            property real inputValue: batteryChargePercentage.percent / 100
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

                visible: index === 0 ? true : (index / segmentedArc.segmentAmount) <= (segmentedArc.inputValue - 0.1)

                ShapePath {
                    fillColor: "transparent"
                    strokeColor: "green"
                    strokeWidth: segment.height * segmentedArc.arcStrokeWidth
                    capStyle: ShapePath.FlatCap
                    joinStyle: ShapePath.MiterJoin
                    startX: segment.width / 2
                    startY: segment.height * (0.5 - segmentedArc.scalefactor)

                    PathAngleArc {
                        centerX: segment.width / 2
                        centerY: segment.height / 2
                        radiusX: segmentedArc.scalefactor * segment.width
                        radiusY: segmentedArc.scalefactor * segment.height
                        startAngle: -90 + index * (sweepAngle + (segmentedArc.clockwise ? +segmentedArc.gap : -segmentedArc.gap)) + segmentedArc.start
                        sweepAngle: segmentedArc.clockwise ? (segmentedArc.endFromStart / segmentedArc.segmentAmount) - segmentedArc.gap : -(segmentedArc.endFromStart / segmentedArc.segmentAmount) + segmentedArc.gap
                        moveToStart: true
                    }

                }

            }

        }

    }

    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 0
        radius: 10
        samples: 9
        color: Qt.rgba(0, 0, 0, 0.75)
    }

}
