/*
* Copyright (C) 2021 - Darrel Griët <dgriet@gmail.com>
*               2021 - Timo Könnecke <github.com/eLtMosen>
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

import QtQuick 2.9
import QtGraphicalEffects 1.15
import org.asteroid.utils 1.0
import org.asteroid.controls 1.0

Item {
    property int length: width > height ? height : width
    property string imgPath: "../watchfaces-img/numerals-duo-synth-neon-green-"

    id: root

    Text {
        z: 0
        id: dowDisplay
        visible: !displayAmbient
        font.pixelSize: root.height * 0.054
        font.family: "Sunflower"
        font.styleName: "Light"
        font.letterSpacing: root.height*0.003
        color: "white"
        opacity: 0.95
        horizontalAlignment: Text.AlignHCenter
        anchors {
            bottom: root.verticalCenter
            bottomMargin: DeviceInfo.hasRoundScreen ? root.height*0.387 : root.height*0.402
            horizontalCenter: root.horizontalCenter
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "dddd").toUpperCase()
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 3
            radius: 12.0
            samples: 16
            color: "#fe16a2"
        }
    }

    Text {
        z: 0
        id: dateDisplay
        visible: !displayAmbient
        font.pixelSize: root.height * 0.056
        font.family: "Sunflower"
        font.styleName: "Light"
        color: "white"
        opacity: 0.95
        horizontalAlignment: Text.AlignHCenter
        anchors {
            top: root.verticalCenter
            topMargin: DeviceInfo.hasRoundScreen ? root.height*0.394 : root.height*0.406
            horizontalCenter: root.horizontalCenter
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "yyyy-MM-dd")
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: -3
            radius: 12.0
            samples: 16
            color: "#fe16a2"
        }
    }

    Item {
        x: DeviceInfo.hasRoundScreen ? length * 0.1 : (root.width != length ? root.width/2 - length/2 : !displayAmbient ? length * 0.1 : 0)
        y: DeviceInfo.hasRoundScreen ? length * 0.1 : (root.height != length ? root.height/2 - length/2 : !displayAmbient ? length * 0.1 : 0)
        width: DeviceInfo.hasRoundScreen ? length * 0.8 : displayAmbient ? length : length * 0.8
        height: DeviceInfo.hasRoundScreen ? length * 0.8 : displayAmbient ? length : length * 0.8

        LinearGradient {
            id: greenColor
            anchors.fill: parent
            smooth: true
            visible: false
            start: Qt.point(0, 0)
            end: Qt.point(300, 300)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#38FF12" }
                GradientStop { position: 1.0; color: "#00F5FB" }
            }
        }

        LinearGradient {
            id: whiteColor
            anchors.fill: parent
            smooth: true
            visible: false
            start: Qt.point(0, 0)
            end: Qt.point(300, 300)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FFF100" }
                GradientStop { position: 1.0; color: "#FFFFFF" }
            }
        }

       Image {
           id: topLeft
           visible: false
           smooth: true
           fillMode: Image.PreserveAspectFit
           x: parseInt(parent.width*0.135)
           y: parseInt(parent.height*0.045)
           sourceSize: Qt.size(parent.width/2 - parent.width*0.15, parent.height/2 - parent.height*0.15)
           source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(0, 1) + ".png"
       }
       Image {
           id: topRight
           visible: false
           smooth: true
           fillMode: Image.PreserveAspectFit
           x: parseInt(parent.width/2 + parent.width*0.03)
           y: parseInt(parent.height*0.045)
           sourceSize: Qt.size(parent.width/2 - parent.width*0.15, parent.height/2 - parent.height*0.15)
           source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(1, 2) + ".png"
       }
       Image {
           id: bottomLeft
           visible: false
           smooth: true
           fillMode: Image.PreserveAspectFit
           x: parseInt(parent.width*0.135)
           y: parseInt(parent.height/2 + parent.height*0.025)
           sourceSize: Qt.size(parent.width/2 - parent.width*0.15, parent.height/2 - parent.height*0.15)
           source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(0, 1) + ".png"
       }
       Image {
           id: bottomRight
           visible: false
           smooth: true
           fillMode: Image.PreserveAspectFit
           x: parseInt(parent.width/2 + parent.width*0.03)
           y: parseInt(parent.height/2 + parent.height*0.025)
           sourceSize: Qt.size(parent.width/2 - parent.width*0.15, parent.height/2 - parent.height*0.15)
           source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(1, 2) + ".png"
       }

        OpacityMask {
            invert: true
            anchors.fill: topLeft
            source: greenColor
            maskSource: topLeft
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 1
                verticalOffset: 1
                radius: 12.0
                samples: 20
                color: "#f800ff"
            }
        }
        OpacityMask {
            invert: true
            anchors.fill: topRight
            source: greenColor
            maskSource: topRight
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: -1
                verticalOffset: 1
                radius: 12.0
                samples: 20
                color: "#f800ff"
            }
        }
        OpacityMask {
            invert: true
            anchors.fill: bottomLeft
            source: whiteColor
            maskSource: bottomLeft
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: -1
                verticalOffset: -1
                radius: 12.0
                samples: 20
                color: "#9600ff"
            }
        }
        OpacityMask {
            invert: true
            anchors.fill: bottomRight
            source: whiteColor
            maskSource: bottomRight
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 1
                verticalOffset: -1
                radius: 12.0
                samples: 20
                color: "#9600ff"
            }
        }
    }
}
