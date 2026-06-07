// SPDX-FileCopyrightText: 2025 Ed Beroset <github.com/beroset>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick

Item {
    property string imgPath: "../watchfaces-img/analog-square-"
    property real pip: width * 0.43
    property int nonsquare: height - width

    Component {
        id: minute_pip

        Rectangle {
            property bool major: index % 5 === 2
            property int quadrant: index / 15
            property int rotangle: 48 + 6 * index
            property real degrees: rotangle + (quadrant & 1 ? 90 : 0)
            property real radians: degrees * Math.PI / 180
            property real a: 1 / Math.tan(radians)
            property real delta: parent.width * 0.02

            color: major ? "lightblue" : "darkgray"
            radius: width * 0.5
            width: parent.width * 0.05 + (major ? delta : 0)
            height: parent.width * 0.01
            x: parent.width / 2
            y: (parent.height + height) / 2
            transform: [
                Translate {
                    x: pip * Math.sqrt(1 + a * a) - (major ? delta : 0) + (quadrant & 1 ? 0 : nonsquare / 2)
                },
                Rotation {
                    angle: rotangle
                }
            ]
        }

    }

    Repeater {
        model: 60
        delegate: minute_pip
    }

    WatchText {
        id: dayDisplay

        font.pixelSize: parent.height / 24
        text: Qt.formatDate(wallClock.time, "dddd").toUpperCase()

        anchors {
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -parent.height * 0.23
        }

    }

    WatchText {
        id: digitalDisplay

        font.pixelSize: parent.height / 14
        anchors.top: dayDisplay.bottom
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) + wallClock.time.toLocaleString(Qt.locale(), ":mm") : wallClock.time.toLocaleString(Qt.locale(), "HH:mm")
    }

    WatchText {
        id: dateDisplay

        font.pixelSize: parent.height * 0.1
        text: Qt.formatDate(wallClock.time, "d")

        anchors {
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: parent.height * 0.164
        }

    }

    WatchText {
        id: monthDisplay

        font.pixelSize: parent.height * 0.05
        anchors.top: dateDisplay.bottom
        text: Qt.formatDate(wallClock.time, "MMMM")
    }

    Repeater {
        model: 12

        Item {
            property real radians: 2 * Math.PI * index / 12

            x: parent.width / 2 + Math.cos(radians) * parent.width * 0.356 - width / 2
            y: parent.height / 2 + Math.sin(radians) * parent.height * 0.356 - height / 2
            width: parent.width * 0.1
            height: parent.height * 0.1

            HourNumberText {
                id: hourNumbers

                font.pixelSize: parent.height * 0.8
                text: (index + 2) % 12 + 1
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
            }

        }

    }

    WatchHand {
        id: hourSVG

        source: imgPath + "hour.svg"
        rotationAngle: (wallClock.time.getHours() + wallClock.time.getMinutes() / 60) * 360 / 12
    }

    WatchHand {
        id: minuteSVG

        source: imgPath + "minute.svg"
        rotationAngle: (wallClock.time.getMinutes() + wallClock.time.getSeconds() / 60) * 360 / 60
    }

    WatchHand {
        id: secondSVG

        visible: !displayAmbient
        source: imgPath + "second.svg"
        rotationAngle: wallClock.time.getSeconds() * 360 / 60
    }

    component WatchText: Text {
        color: Qt.rgba(1, 1, 1, 0.7)
        styleColor: Qt.rgba(0, 0, 0, 0.4)
        style: Text.Outline
        font.family: "Noto Sans"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    component HourNumberText: WatchText {
        color: "lightblue"
        styleColor: "steelblue"
    }

    component WatchHand: Image {
        required property real rotationAngle

        anchors.fill: parent

        transform: Rotation {
            origin.x: parent.width / 2
            origin.y: parent.height / 2
            angle: rotationAngle
        }

    }

}
