/*
 * Copyright (C) 2021 - CosmosDev <github.com/CosmosDev>
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

Item {

    property string imgPath: "../watchfaces-img/analog-modern-steel-"

    Image {
      source: !displayAmbient ? imgPath + "strokes.svg" : imgPath + "strokes-ambient.svg"
      width: parent.width
      height: parent.height
    }

    Text {
        z: 0
        id: digitalDisplay
        font.pixelSize: parent.height*0.04
        font.family: "Michroma"
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        anchors {
            centerIn: parent
            verticalCenterOffset: -parent.width/4.5
        }
        text: if (use12H.value) {
                  wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) + wallClock.time.toLocaleString(Qt.locale(), ":mm") }
              else
                  wallClock.time.toLocaleString(Qt.locale(), "HH:mm")
    }

    Text {
        z: 0
        id: dowDisplay
        font.pixelSize: parent.height*0.05
        font.family: "Michroma"
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        anchors {
            centerIn: parent
            horizontalCenterOffset: -parent.width/4.5
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "ddd").toUpperCase()
    }

    Repeater {
        model: 120
        Rectangle {
            z: 1
            id: minuteStrokes
            antialiasing : true
            property var rotM: ((index) - 30)/120
            property var centerX: parent.width/2-width/2
            property var centerY: parent.height/2-height/2
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.46
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.46
            color: "white"
            width: parent.width*0.004
            height: if (index % 2 == 0)
                        parent.height*0.03
                    else
                        parent.height*0.01
            opacity: 0.6
            transform: Rotation { origin.x: width/2; origin.y: height/2; angle: (index)*3}
        }
    }

    Repeater {
        model: 12
        Text {
            z: 1
            id: hourNumbers
            font.pixelSize: parent.height*0.08
            font.family: "Michroma"
            horizontalAlignment: Text.AlignHCenter
            property var rotM: ((index * 5 ) - 15)/60
            property var centerX: parent.width/2-width/2
            property var centerY: parent.height/2-height/1.8
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.37
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.39
            color: "white"
            text: if (index === 0) 
                    "12" 
                  else 
                    index
            opacity: if ([0, 2, 4, 8, 10].includes(index) || (index == 6 && displayAmbient))
                         1
                     else
                         0
        }
    }
    
    Rectangle {
        z: 0
        id: dayBackground
        visible: !displayAmbient
        width: parent.width*0.15
        height: parent.height*0.15
        radius: width*0.5
        color: "#18181B"
        anchors {
            centerIn: parent
            horizontalCenterOffset: parent.width/4
        }
    }
    
    Text {
            z: 1
            id: dayDisplay
            font.pixelSize: dayBackground.height*0.45
            font.family: "Michroma"
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            anchors {
                centerIn: dayBackground
                verticalCenterOffset: -dayBackground.width*0.05
            }
            text: wallClock.time.toLocaleString(Qt.locale(), "d").toUpperCase()
        }
    
    Rectangle {
        z: 0
        id: monthBackground
        visible: !displayAmbient
        width: parent.width*0.25
        height: parent.height*0.25
        radius: width*0.5
        color: "#18181B"
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.height/3.5
        }
        
     
        Text {
            z: 1
            id: monthTwelve
            font.pixelSize: parent.height*0.15
            font.family: "Michroma"
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            text: "12"
        }
        
        Text {
            z: 1
            id: monthSix
            font.pixelSize: parent.height*0.15
            font.family: "Michroma"
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
            text: "6"
        }
        
        Image {
            id: monthSVG
            z: 1
            source: imgPath + "handle.svg"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: parent.height
            transform: Rotation {
                origin.x: monthBackground.width/2;
                origin.y: monthBackground.height/2;
                angle: (wallClock.time.getMonth() + 1)*30;
            }
        }
    }
    
    Repeater {
        model: 12
        Rectangle {
            z: 1
            id: monthStrokes
            visible: !displayAmbient
            antialiasing : true
            property var rotM: ((index * 5 ) - 15)/60
            property var centerX: monthBackground.x+monthBackground.width/2
            property var centerY: monthBackground.y+monthBackground.height/2.1
            x: centerX+Math.cos(rotM * 2 * Math.PI)*monthBackground.width*0.4
            y: centerY+Math.sin(rotM * 2 * Math.PI)*monthBackground.width*0.4
            color: "white"
            opacity: if ([0, 6].includes(index))
                         0
                     else
                         1
            width: monthBackground.width*0.014
            height: monthBackground.height*0.05
            radius: width*0.5
            transform: Rotation { origin.x: width/2; origin.y: height/2; angle: (index*5)*6}
        }
    }

    Image {
        id: hourSVG
        z: 2
        source: !displayAmbient ? imgPath + "hour.svg" : imgPath + "hour-ambient.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height
        transform: Rotation {
            origin.x: parent.width/2;
            origin.y: parent.height/2;
            angle: (wallClock.time.getHours()*30) + (wallClock.time.getMinutes()*0.5)
        }
    }

    Image {
        id: minuteSVG
        z: 3
        source: !displayAmbient ? imgPath + "minute.svg" : imgPath + "minute-ambient.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height
        transform: Rotation {
            origin.x: parent.width/2;
            origin.y: parent.height/2;
            angle: (wallClock.time.getMinutes()*6)
        }
    }

    Image {
        id: secondSVG
        z: 4
        visible: !displayAmbient
        source: imgPath + "second.svg"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        transform: Rotation {
            origin.x: parent.width/2;
            origin.y: parent.height/2;
            angle: (wallClock.time.getSeconds()*6)
        }
    }
}
