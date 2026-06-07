// SPDX-FileCopyrightText: 2021-2024 Ed Beroset <github.com/beroset>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick

Item {
    id: root

    // these three constants describe decimal time
    readonly property int decimalHoursPerStandardDay: 10
    readonly property int decimalMinutesPerDecimalHour: 100
    readonly property int decimalSecondsPerDecimalMinute: 100
    // this constant adjusts the minutes ticks on the watchface
    readonly property int majorMinuteTicksEvery: 5
    // this adjusts the number of revolutions per day
    // (e.g. 2 twelve-hour revolutions for a standard 24 hour day)
    readonly property int revolutionsPerDay: 1
    // these are derived constants
    readonly property int decimalSecondsPerStandardDay: decimalHoursPerStandardDay * decimalMinutesPerDecimalHour * decimalSecondsPerDecimalMinute
    readonly property double decimalSecondsScaleFactor: decimalSecondsPerStandardDay / 86400

    function getDecimalMilliseconds(t) {
        return (t.getHours() * 3.6e+06 + t.getMinutes() * 60000 + t.getSeconds() * 1000 + t.getMilliseconds()) * decimalSecondsScaleFactor;
    }

    function getDecimalHours(t) {
        return getDecimalMilliseconds(t) / decimalMinutesPerDecimalHour / decimalSecondsPerDecimalMinute / 1000;
    }

    // returns the number of standard milliseconds until the next full decimal second
    function getStandardMillisecondsToNextDecimalSecond() {
        let now = new Date();
        let decimalMillis = 1000 - (getDecimalMilliseconds(now) % 1000);
        return Math.round(decimalMillis / decimalSecondsScaleFactor);
    }

    anchors.fill: parent
    Component.onCompleted: {
        logoRot.angle = getDecimalHours(wallClock.time) * 360 * revolutionsPerDay / decimalHoursPerStandardDay;
    }

    Item {
        id: faceBox

        width: Math.min(parent.width, parent.height)
        height: width
        anchors.centerIn: parent

        Repeater {
            id: minuteTicks

            model: decimalMinutesPerDecimalHour / revolutionsPerDay

            Tick {
                angle: (index) * 360 / minuteTicks.count
                color: "lightgreen"
                opacity: 0.6
                visible: !displayAmbient
                width: parent.width * 0.005
                height: parent.width * (index % majorMinuteTicksEvery === 0 ? 0.03 : 0.015)
            }

        }

        Repeater {
            id: hourTicks

            model: decimalHoursPerStandardDay / revolutionsPerDay

            Tick {
                angle: (index) * 360 / hourTicks.count
                color: "lightgreen"
                opacity: displayAmbient ? 0.3 : 0.6
                width: parent.width * 0.01
                height: parent.width * 0.03
            }

        }

        Repeater {
            id: hourLabels

            model: decimalHoursPerStandardDay / revolutionsPerDay

            Text {
                id: hourLabel

                color: "lightblue"
                antialiasing: true
                opacity: displayAmbient ? 0.3 : 0.6
                text: index ? index : hourLabels.count
                transform: [
                    Rotation {
                        origin.x: hourLabel.width / 2
                        origin.y: hourLabel.height + parent.width * 0.4
                        angle: (index) * 360 / (decimalHoursPerStandardDay / revolutionsPerDay)
                    },
                    Translate {
                        x: (parent.width - hourLabel.width) / 2
                        y: parent.height / 2 - parent.width * 0.4 - hourLabel.height
                    }
                ]

                font {
                    pixelSize: parent.height * 0.08
                    family: "CPMono_v07"
                    styleName: "Plain"
                }

            }

        }

        Image {
            id: logoAsteroid

            antialiasing: true
            opacity: displayAmbient ? 0.6 : 1
            source: "../watchfaces-img/asteroid-logo.svg"
            width: parent.width / 12
            height: width
            transform: [
                Rotation {
                    id: logoRot

                    origin.x: logoAsteroid.width / 2
                    origin.y: logoAsteroid.height + parent.width * 0.275
                },
                Translate {
                    x: (parent.width - logoAsteroid.width) / 2
                    y: parent.height / 2 - logoAsteroid.height - parent.width * 0.275
                }
            ]
        }

        PlainText {
            id: conventionalTime

            anchors.verticalCenterOffset: +parent.width * 0.18
            text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh:mm:ss ap") : wallClock.time.toLocaleString(Qt.locale(), "HH:mm:ss")
        }

        PlainText {
            id: conventionalDate

            anchors.verticalCenterOffset: -parent.width * 0.18
            text: wallClock.time.toLocaleDateString(Qt.locale(), Locale.ShortFormat)
        }

        PlainText {
            id: decimalHours

            font.pixelSize: parent.width * 0.15
            textFormat: Text.RichText
            text: getDecimalHours(new Date()).toPrecision(5)
        }

    }

    Timer {
        id: decimalSecondsTimer

        running: !displayAmbient && visible
        repeat: true
        interval: getStandardMillisecondsToNextDecimalSecond()
        onTriggered: function() {
            decimalHours.text = getDecimalHours(new Date()).toPrecision(5);
            // Math.max to prevent rapid double firing in case it fires just before the boundary
            interval = Math.max(100, getStandardMillisecondsToNextDecimalSecond());
        }
    }

    Connections {
        function onTimeChanged() {
            if (!visible)
                return ;

            logoRot.angle = getDecimalHours(wallClock.time) * 360 * revolutionsPerDay / decimalHoursPerStandardDay;
        }

        target: wallClock
    }

    component Tick: Rectangle {
        id: thisTick

        property bool outsideRing: true
        property real angle: 0
        property real radius: 0.72

        antialiasing: true
        transform: [
            Rotation {
                origin.x: thisTick.width / 2
                origin.y: outsideRing ? thisTick.height + parent.width * radius / 2 : parent.width * radius / 2
                angle: thisTick.angle
            },
            Translate {
                x: (parent.width - thisTick.width) / 2
                y: outsideRing ? parent.height / 2 - parent.width * radius / 2 - thisTick.height : parent.height / 2 - parent.width * radius / 2
            }
        ]
    }

    component PlainText: Text {
        color: "white"
        visible: !displayAmbient
        horizontalAlignment: Text.AlignHCenter
        anchors.centerIn: parent

        font {
            pixelSize: parent.height * 0.06
            family: "CPMono_v07"
            styleName: "Plain"
        }

    }

}
