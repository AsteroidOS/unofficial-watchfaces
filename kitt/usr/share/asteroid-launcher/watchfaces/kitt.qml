/*
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
import Nemo.Mce 1.0
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0
import QtSensors 5.11

Item {
    id: watchFace
    property var time: wallClock.time //new Date() //
    property string imgPath: "../watchfaces-img/"

    FontLoader { id: localFont
        name:'Digital-7 Mono'
    }

    Image {
        id: backgroundImage
        sourceSize.height: width
        sourceSize.width: width
        anchors.fill: parent
        source: imgPath + "kitt-bg.svg"
    }

    Item {
        id: lcdArea
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.22
        height: parent.height * 0.26
        width: parent.width * 0.68

        Text {
            id: dateDisplay
            font { family: localFont.name; pixelSize:parent.width*0.1;capitalization: Font.Capitalize }
            color: "black"
            style: Text.Outline; styleColor: Qt.rgba(255,255,255,0.5)
            opacity: 0.9
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height*0.05
            text: watchFace.time.toLocaleString(Qt.locale(), "<b>ddd</b> d MMM")
        }

        Item {
            id: timeRow
            width: parent.width * 0.9
            height: parent.width * 0.8
            anchors.topMargin: parent.width * 0.02
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: timeDisplay
                anchors.left: parent.left
                anchors.top: parent.top
                font { family: localFont.name; pixelSize:parent.width*0.35;capitalization: Font.Capitalize }
                color: "black"
                style: Text.Outline; styleColor: Qt.rgba(255,255,255,0.5)
                opacity: 0.9
                horizontalAlignment: Text.AlignHCenter
                text: if (use12H.value)
                          wallClock.time.toLocaleString(Qt.locale(), "hh:mm ap").slice(0, 5)
                      else
                          wallClock.time.toLocaleString(Qt.locale(), "HH:mm")

            }

            Text {
                id: secondsDisplay
                anchors.topMargin: parent.width * 0.01
                anchors.right: parent.right
                anchors.top: parent.top
                text: wallClock.time.toLocaleString(Qt.locale(), "ss")
                font { family: localFont.name; pixelSize:timeDisplay.font.pixelSize * 0.5; capitalization: Font.Capitalize }
                color: timeDisplay.color
                style: timeDisplay.style
                styleColor: timeDisplay.styleColor
            }
        }

    }

    Item {
        id: chargingIndicatorArea
        x: parent.width * 0.165
        y: parent.width * 0.056
        width: parent.width * 0.289
        height: parent.width  * 0.115
        Rectangle {
            color: batteryChargePercentage.percent < 50 ? 'red': 'green'
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: batteryChargePercentage.percent * parent.width/100
            opacity: 0.5
        }
        Icon {
            id: batteryIcon
            name: "ios-battery-charging"
            width:  parent.height * 0.6
            height: width
            anchors.right: parent.left
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0.4
            rotation: 270
            visible: batteryChargeState.value == MceBatteryState.Charging
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
        opacity: btStatus.connected ? 1 : btStatus.powered? 0.5 : 0.1
    }

    Image {
        id: buttonImage
        x: parent.width * 0.64
        y: parent.width * 0.668
        width: parent.width*0.298
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
        active: true
        onReadingChanged: {
            compassRotateImage.rotation = -reading.azimuth
        }
    }

}
