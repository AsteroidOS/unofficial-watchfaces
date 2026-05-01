// SPDX-FileCopyrightText: 2023 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later
/*
 * Based on 002-analog stock watchface.
 * Converted to QtShapes with declarative wallClock bindings.
 */

import QtGraphicalEffects 1.15
import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {
    id: root

    property real maxSize: Math.min(width, height)
    property real hourAngle: (wallClock.time.getHours() % 12 + wallClock.time.getMinutes() / 60) / 12 * 360
    property real minuteAngle: wallClock.time.getMinutes() / 60 * 360
    property real secondAngle: wallClock.time.getSeconds() / 60 * 360

    anchors.fill: parent

    Item {
        id: hourStrokes

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        Repeater {
            model: 12

            Shape {
                width: hourStrokes.width
                height: hourStrokes.height
                rotation: index * 30

                ShapePath {
                    fillColor: Qt.rgba(1, 1, 1, 0.85)
                    strokeColor: "transparent"
                    startX: hourStrokes.width / 2
                    startY: hourStrokes.height / 2 + hourStrokes.height * 0.42

                    PathLine {
                        x: hourStrokes.width / 2 - hourStrokes.width * 0.0096
                        y: hourStrokes.height / 2 + hourStrokes.height * 0.43
                    }

                    PathLine {
                        x: hourStrokes.width / 2
                        y: hourStrokes.height / 2 + hourStrokes.height * 0.44
                    }

                    PathLine {
                        x: hourStrokes.width / 2 + hourStrokes.width * 0.0096
                        y: hourStrokes.height / 2 + hourStrokes.height * 0.43
                    }

                    PathLine {
                        x: hourStrokes.width / 2
                        y: hourStrokes.height / 2 + hourStrokes.height * 0.42
                    }

                }

            }

        }

        layer {
            enabled: true
            samples: 4

            effect: DropShadow {
                transparentBorder: true
                horizontalOffset: root.maxSize * 0.00625
                verticalOffset: root.maxSize * 0.00625
                radius: 6
                samples: 13
                color: Qt.rgba(0, 0, 0, 0.4)
            }

        }

    }

    Item {
        id: hourHand

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent
        rotation: root.hourAngle

        Shape {
            width: hourHand.width
            height: hourHand.height

            ShapePath {
                fillColor: "transparent"
                strokeColor: Qt.rgba(1, 1, 1, 1)
                strokeWidth: hourHand.width * 0.048
                capStyle: ShapePath.FlatCap
                startX: hourHand.width / 2
                startY: hourHand.height / 2 - hourHand.height * 0.13

                PathLine {
                    x: hourHand.width / 2
                    y: hourHand.height / 2 - hourHand.height * 0.28
                }

            }

            ShapePath {
                fillColor: "transparent"
                strokeColor: Qt.rgba(1, 1, 1, 1)
                strokeWidth: hourHand.width * 0.024
                capStyle: ShapePath.FlatCap
                joinStyle: ShapePath.MiterJoin
                startX: hourHand.width / 2 - hourHand.width * 0.0612
                startY: hourHand.height / 2 - hourHand.height * 0.3304

                PathLine {
                    x: hourHand.width / 2
                    y: hourHand.height / 2 - hourHand.height * 0.393
                }

                PathLine {
                    x: hourHand.width / 2 + hourHand.width * 0.0612
                    y: hourHand.height / 2 - hourHand.height * 0.3304
                }

                PathLine {
                    x: hourHand.width / 2
                    y: hourHand.height / 2 - hourHand.height * 0.27
                }

                PathLine {
                    x: hourHand.width / 2 - hourHand.width * 0.0612
                    y: hourHand.height / 2 - hourHand.height * 0.3304
                }

            }

        }

        layer {
            enabled: true
            samples: 4

            effect: DropShadow {
                transparentBorder: true
                horizontalOffset: root.maxSize * 0.00625
                verticalOffset: root.maxSize * 0.00625
                radius: root.maxSize * 0.024
                samples: 25
                color: Qt.rgba(0, 0, 0, 0.4)
            }

        }

    }

    Item {
        id: minuteHand

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent
        rotation: root.minuteAngle

        Shape {
            width: minuteHand.width
            height: minuteHand.height

            ShapePath {
                fillColor: "transparent"
                strokeColor: Qt.rgba(1, 1, 1, 1)
                strokeWidth: minuteHand.width * 0.03
                capStyle: ShapePath.FlatCap
                startX: minuteHand.width / 2
                startY: minuteHand.height / 2 - minuteHand.height * 0.13

                PathLine {
                    x: minuteHand.width / 2
                    y: minuteHand.height / 2 - minuteHand.height * 0.405
                }

            }

            ShapePath {
                fillColor: "transparent"
                strokeColor: Qt.rgba(1, 1, 1, 1)
                strokeWidth: minuteHand.width * 0.014
                capStyle: ShapePath.FlatCap
                joinStyle: ShapePath.MiterJoin
                startX: minuteHand.width / 2 - minuteHand.width * 0.0339
                startY: minuteHand.height / 2 - minuteHand.height * 0.4307

                PathLine {
                    x: minuteHand.width / 2
                    y: minuteHand.height / 2 - minuteHand.height * 0.464
                }

                PathLine {
                    x: minuteHand.width / 2 + minuteHand.width * 0.0339
                    y: minuteHand.height / 2 - minuteHand.height * 0.4307
                }

                PathLine {
                    x: minuteHand.width / 2
                    y: minuteHand.height / 2 - minuteHand.height * 0.395
                }

                PathLine {
                    x: minuteHand.width / 2 - minuteHand.width * 0.0339
                    y: minuteHand.height / 2 - minuteHand.height * 0.4307
                }

            }

        }

        layer {
            enabled: true
            samples: 4

            effect: DropShadow {
                transparentBorder: true
                horizontalOffset: root.maxSize * 0.00625
                verticalOffset: root.maxSize * 0.00625
                radius: root.maxSize * 0.024
                samples: 25
                color: Qt.rgba(0, 0, 0, 0.4)
            }

        }

    }

    Item {
        id: secondHand

        visible: !displayAmbient
        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent
        rotation: root.secondAngle

        Shape {
            width: secondHand.width
            height: secondHand.height

            ShapePath {
                fillColor: "transparent"
                strokeColor: "red"
                strokeWidth: secondHand.height * 0.008
                capStyle: ShapePath.FlatCap
                startX: secondHand.width / 2
                startY: secondHand.height / 2 - secondHand.height * 0.13

                PathLine {
                    x: secondHand.width / 2
                    y: secondHand.height / 2 - secondHand.height * 0.432
                }

            }

        }

        layer {
            enabled: true
            samples: 4

            effect: DropShadow {
                transparentBorder: true
                horizontalOffset: root.maxSize * 0.00625
                verticalOffset: root.maxSize * 0.00625
                radius: root.maxSize * 0.024
                samples: 25
                color: Qt.rgba(0, 0, 0, 0.4)
            }

        }

    }

    Image {
        id: logo

        source: "../watchfaces-img/asteroid-logo.svg"
        anchors.centerIn: parent
        width: root.maxSize / 2.5
        height: root.maxSize / 2.5

        layer {
            enabled: true
            samples: 4

            effect: DropShadow {
                transparentBorder: true
                horizontalOffset: root.maxSize * 0.0125
                verticalOffset: root.maxSize * 0.0125
                radius: root.maxSize * 0.0375
                samples: 25
                color: Qt.rgba(0, 0, 0, 0.65)
            }

        }

    }

}
