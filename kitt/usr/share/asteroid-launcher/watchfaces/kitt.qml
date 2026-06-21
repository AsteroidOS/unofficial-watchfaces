// SPDX-FileCopyrightText: 2016 Velox <github.com/velox>
// SPDX-License-Identifier: LGPL-2.1-or-later

import Nemo.Mce
import QtQuick
import QtSensors
import org.asteroid.controls
import org.asteroid.utils

Item {
    id: root

    property string imgPath: "../watchfaces-img/"

    anchors.fill: parent

    Image {
        id: backgroundImage

        sourceSize.height: width
        sourceSize.width: width
        anchors.fill: parent
        source: imgPath + "kitt-bg.svg"
    }

    Item {
        id: lcdArea

        height: parent.width * 0.26
        width: parent.width * 0.68

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: parent.width * 0.22
        }

        Text {
            id: dateDisplay

            color: "black"
            style: Text.Outline
            styleColor: Qt.rgba(255, 255, 255, 0.5)
            opacity: 0.9
            horizontalAlignment: Text.AlignHCenter
            text: wallClock.time.toLocaleString(Qt.locale(), "<b>ddd</b> d MMM")

            font {
                family: "Digital-7 Mono"
                pixelSize: parent.width * 0.1
                capitalization: Font.Capitalize
            }

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: parent.height * 0.05
            }

        }

        Item {
            id: timeRow

            width: parent.width * 0.9
            height: parent.width * 0.8

            anchors {
                topMargin: parent.width * 0.02
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: timeDisplay

                anchors.left: parent.left
                anchors.top: parent.top
                color: "black"
                style: Text.Outline
                styleColor: Qt.rgba(255, 255, 255, 0.5)
                opacity: 0.9
                horizontalAlignment: Text.AlignHCenter
                text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh:mm ap").slice(0, 5) : wallClock.time.toLocaleString(Qt.locale(), "HH:mm")

                font {
                    family: "Digital-7 Mono"
                    pixelSize: parent.width * 0.35
                    capitalization: Font.Capitalize
                }

            }

            Text {
                id: secondsDisplay

                text: wallClock.time.toLocaleString(Qt.locale(), "ss")
                color: timeDisplay.color
                style: timeDisplay.style
                styleColor: timeDisplay.styleColor

                anchors {
                    topMargin: parent.width * 0.01
                    right: parent.right
                    top: parent.top
                }

                font {
                    family: "Digital-7 Mono"
                    pixelSize: timeDisplay.font.pixelSize * 0.5
                    capitalization: Font.Capitalize
                }

            }

        }

    }

    Item {
        id: chargingIndicatorArea

        x: parent.width * 0.165
        y: parent.width * 0.056
        width: parent.width * 0.289
        height: parent.width * 0.115

        Rectangle {
            color: batteryChargePercentage.percent < 50 ? 'red' : 'green'
            width: batteryChargePercentage.percent * parent.width / 100
            opacity: 0.5

            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }

        }

        Icon {
            id: batteryIcon

            name: "ios-battery-charging"
            width: parent.height * 0.6
            height: width
            anchors.right: parent.left
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0.4
            rotation: 270
            visible: batteryChargeState.value === MceBatteryState.Charging
        }

    }

    Image {
        id: compassRotateImage

        x: parent.width * 0.037
        y: parent.width * 0.65
        width: parent.width * 0.36
        height: width
        sourceSize.height: parent.width
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectFit
        source: imgPath + "kitt-compass.svg"
    }

    Image {
        id: connectedImage

        x: parent.width * 0.17
        y: parent.width * 0.53
        width: parent.width * 0.19
        height: width * 0.308
        sourceSize.height: width
        sourceSize.width: height
        fillMode: Image.PreserveAspectFit
        source: imgPath + "kitt-connected.svg"
        opacity: btStatus.connected ? 1 : btStatus.powered ? 0.5 : 0.1
    }

    Image {
        id: buttonImage

        x: parent.width * 0.64
        y: parent.width * 0.668
        width: parent.width * 0.298
        height: parent.width * 0.32
        sourceSize.height: height
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        source: imgPath + "kitt-button.svg"
    }

    Image {
        id: foregroundImage

        anchors.fill: parent
        sourceSize.height: width
        sourceSize.width: width
        source: imgPath + "kitt-fg.svg"
    }

    BluetoothStatus {
        id: btStatus
    }

    MceBatteryLevel {
        id: batteryChargePercentage
    }

    MceBatteryState {
        id: batteryChargeState
    }

    Compass {
        active: visible
        onReadingChanged: {
            compassRotateImage.rotation = -reading.azimuth;
        }
    }

}
