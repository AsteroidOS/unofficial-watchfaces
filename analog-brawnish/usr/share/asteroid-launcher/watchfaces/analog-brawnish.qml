/*
 * Copyright (C) 2022 - David Rinehart wdaver(at)cox.net
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
import QtQuick 2.9
import QtGraphicalEffects 1.15

Item {

    // background
    Rectangle {
        property var hours: wallClock.time.getHours()

        visible: !displayAmbient
        width: 800
        height: 800
        color: ((hours > 6 && hours < 18) ? "#eeeeee" : "#343334")
    }

    // os and slogan
    Text {
        visible: !displayAmbient
        anchors {
            centerIn: parent
            verticalCenterOffset: -parent.height * 0.146
        }
        color: "grey"
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: parent.height * 0.040
        font.family: "Raleway"
        text: "<b>AsteroidOS</b><br>Hack Your Wrist"
    }

    // ticks
    Repeater {
        model: 60
        Rectangle {
            property var hours: wallClock.time.getHours()
            property var rotM: (index - 15) /60
            property var centerX: parent.width/2-width/2
            property var centerY: parent.height/2-height/2

            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.46
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.height*0.46
            z: 1
            antialiasing : true
            color: if ( displayAmbient ) "whitesmoke" 
                   else ((hours > 6 && hours < 18) ? "black" : "whitesmoke")
            width: if (index % 5) (parent.width * 0.0055)
                   else (parent.width*0.008)
            height: if (index % 5) (parent.height * 0.03)
                    else (parent.height*0.04)
            transform: Rotation { origin.x: width/2; origin.y: height/2; angle: index * 6}
        }
    }

    // hour numbers
    Repeater {
        model: 12
        Text {
            property var hours: wallClock.time.getHours()
            property var rotM: ((index * 5 ) - 15)/60
            property var centerX: parent.width/2-width/2
            property var centerY: parent.height/2-height/2

            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.37
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.height*0.37
            color: if ( displayAmbient ) "whitesmoke" 
                   else ((hours > 6 && hours < 18) ? "black" : "whitesmoke")
            font.pixelSize: parent.width*0.08
            font.family: "Michroma"
            text: (index === 0) ? "12" : index
        }
    }

    // hour hand shadow
    Repeater {
        model: 1
        Rectangle {
            property var hours: wallClock.time.getHours()
            property var minutes: wallClock.time.getMinutes()
            property var rotM: (((hours * 5) + (minutes / 12)) - 15) / 60
            property var centerX: parent.width/2-width/2 + 6
            property var centerY: parent.height/2-height/2 + 6

            visible: !displayAmbient
            antialiasing : true
            radius: 10.0
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.15
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.15
            color: "#55111111"
            width: parent.width * 0.032
            height: parent.width * 0.28
            transform: Rotation { origin.x: width/2; origin.y: height/2; angle: ((hours * 5) + (minutes / 12)) * 6}
        }
    }

    // minute hand shadow
    Repeater {
	model: 1
        Rectangle {
            property var minutes: wallClock.time.getMinutes()
            property var hours: wallClock.time.getHours()
            property var rotM: (minutes - 15) / 60
            property var centerX: parent.width/2-width/2 + 7
            property var centerY: parent.height/2-height/2 + 7

            visible: !displayAmbient
            antialiasing : true
	    radius: 10.0
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.20
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.20
            color: "#55111111"
            width: parent.width*0.02
            height: parent.width*0.40
            transform: Rotation { origin.x: width/2; origin.y: height/2; angle: minutes * 6}
        }
    }

    // second hand shadow
    Repeater {
	model: 1
        Rectangle {
            property var seconds: wallClock.time.getSeconds()
            property var rotM: (seconds - 15) / 60
            property var centerX: parent.width/2-width/2 + 8
            property var centerY: parent.height/2-height/2 + 8

            visible: !displayAmbient
            antialiasing : true
	    radius: 2.0
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.17
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.17
            color: "#55111111"
            width: parent.width*0.008
            height: parent.width*0.53
            transform: Rotation { origin.x: width/2; origin.y: height/2; angle: seconds * 6}
        }
    }

    // pin shadow
    Rectangle {
        property var hours: wallClock.time.getHours()

        visible: !displayAmbient
        antialiasing : true
        x: (parent.width/2-width/2) + 4
        y: (parent.height/2-height/2) + 4
        radius: (parent.width * 0.06) / 2
        width: parent.width * 0.06
        height: parent.width * 0.06
        color: "#55111111"
    }

    // hour hand
    Repeater {
        model: 1
        Rectangle {
            property var hours: wallClock.time.getHours()
            property var minutes: wallClock.time.getMinutes()
            property var rotM: (((hours * 5) + (minutes / 12)) - 15) / 60
            property var centerX: parent.width/2-width/2
            property var centerY: parent.height/2-height/2

            antialiasing : true
            radius: 10.0
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.15
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.15
            color: if ( displayAmbient ) "whitesmoke" 
                   else ((hours > 6 && hours < 18) ? "black" : "whitesmoke")
            width: parent.width * 0.032
            height: parent.width * 0.28
            transform: Rotation { origin.x: width/2; origin.y: height/2; angle: ((hours * 5) + (minutes / 12)) * 6}
        }
    }

    // minute hand
    Repeater {
	model: 1
        Rectangle {
            property var minutes: wallClock.time.getMinutes()
            property var hours: wallClock.time.getHours()
            property var rotM: (minutes - 15) / 60
            property var centerX: parent.width/2-width/2
            property var centerY: parent.height/2-height/2

            antialiasing : true
	    radius: 10.0
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.20
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.20
            color: if ( displayAmbient ) "whitesmoke" 
                   else ((hours > 6 && hours < 18) ? "black" : "whitesmoke")
            width: parent.width*0.02
            height: parent.width*0.40
            transform: Rotation { origin.x: width/2; origin.y: height/2; angle: minutes * 6}
        }
    }

    // second hand
    Repeater {
	model: 1
        Rectangle {
            property var hours: wallClock.time.getHours()
            property var seconds: wallClock.time.getSeconds()
            property var rotM: (seconds - 15) / 60
            property var centerX: parent.width/2-width/2
            property var centerY: parent.height/2-height/2

            visible: !displayAmbient
            antialiasing : true
	    radius: 2.0
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.17
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.17
            color: "#ee7f00"
            width: parent.width*0.008
            height: parent.width*0.53
            transform: Rotation { origin.x: width/2; origin.y: height/2; angle: seconds * 6}
        }
    }

    // center pin (actually circles)
    Rectangle {
        property var hours: wallClock.time.getHours()
        x: (parent.width/2-width/2)
        y: (parent.height/2-height/2)

        antialiasing : true
        radius: (parent.width * 0.0625) / 2
        width: parent.width * 0.0625
        height: parent.width * 0.0625
        color: (hours > 6 && hours < 18) ? "black" : "whitesmoke"
    }
    Rectangle {
        property var hours: wallClock.time.getHours()
        x: (parent.width/2-width/2)
        y: (parent.height/2-height/2)

        antialiasing : true
        radius: (parent.width * 0.05) / 2
        width: parent.width * 0.05
        height: parent.width * 0.05
        color: (hours > 6 && hours < 18) ? "whitesmoke" : "black"
    }

}
