 /* 
  * Copyright (C) 2022 - David Rinehart wdaver(at)cox.net
  * 
  * All rights reserved.
  * 
  * This program is free software: you can redistribute it and / or modify
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
  * along with this program. If not, see  http://www.gnu.org/licenses/>.
  */
 
import QtQuick 2.9
import org.asteroid.utils 1.0
import org.asteroid.controls 1.0

Item {
    width: Dims.l(100)
    height: Dims.l(100)
    
    property int minutes: wallClock.time.getMinutes()
    property int hours: wallClock.time.getHours()
    property int seconds: wallClock.time.getSeconds()

    Rectangle {
        id: background
        visible: !displayAmbient
        anchors.fill: parent
        radius: DeviceSpecs.hasRoundScreen ? width / 2 : 0
        color: ((hours > 6 && hours < 18) ? "#EEEEEE" : "#343334")
        opacity: 0.5
    }

    Text {
        id: osSlogan
        visible: !displayAmbient
        anchors {
            centerIn: parent
            verticalCenterOffset:  - parent.height * 0.146
        }
        color: "grey"
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: parent.height * 0.040
        font.family: "Raleway"
        text: "<b>AsteroidOS</b><br>Free Your Wrist"
    }

    Repeater {
        id: ticks
        model: 60
        Rectangle {
            property var rotM: (index - 15)  / 60
            property var centerX: parent.width / 2 - width / 2
            property var centerY: parent.height / 2 - height / 2

            x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.46
            y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.height * 0.46
            z: 1
            antialiasing : true
            color: if ( displayAmbient ) "whitesmoke" 
                   else ((hours > 6 && hours < 18) ? "black" : "whitesmoke")
            width: if (index % 5) (parent.width * 0.0055)
                   else (parent.width * 0.008)
            height: if (index % 5) (parent.height * 0.03)
                    else (parent.height * 0.04)
            transform: Rotation { origin.x: width / 2; origin.y: height / 2; angle: index * 6 }
        }
    }

    Repeater {
        id: hourNumbers
        model: 12
        Text {
            property var rotM: ((index * 5 ) - 15) / 60
            property var centerX: parent.width / 2 - width / 2
            property var centerY: parent.height / 2 - height / 2

            x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.37
            y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.height * 0.37
            color: if ( displayAmbient ) "whitesmoke" 
                   else ((hours > 6 && hours < 18) ? "black" : "whitesmoke")
            font.pixelSize: parent.width * 0.08
            font.family: "Michroma"
            text: (index === 0) ? "12" : index
        }
    }

    Repeater {
        id: hourHandShadow 
        model: 1
        Rectangle {
            property var rotM: (((hours * 5) + (minutes / 12)) - 15) / 60
            property var centerX: parent.width / 2 - width / 2 + Dims.l(1.7)
            property var centerY: parent.height / 2 - height / 2 + Dims.l(1.7)
            radius: Dims.l(2.8)

            visible: !displayAmbient
            antialiasing : true
            x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.15
            y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.15
            color: "#55111111"
            width: parent.width * 0.032
            height: parent.width * 0.28
            transform: Rotation { origin.x: width / 2; origin.y: height / 2; angle: ((hours * 5) + (minutes / 12)) * 6 }
        }
    }

    Repeater {
    id: minuteHandShadow
	model: 1
        Rectangle {
            property var rotM: (minutes - 15) / 60
            property var centerX: parent.width / 2 - width / 2 + Dims.l(1.9)
            property var centerY: parent.height / 2 - height / 2 + Dims.l(1.9)
            radius: Dims.l(2.8)

            visible: !displayAmbient
            antialiasing : true
            x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.20
            y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.20
            color: "#55111111"
            width: parent.width * 0.02
            height: parent.width * 0.40
            transform: Rotation { origin.x: width / 2; origin.y: height / 2; angle: minutes * 6 }
        }
    }

    Repeater {
    id: secondHandShadow
	model: 1
        Rectangle {
            property var rotM: (seconds - 15) / 60
            property var centerX: parent.width / 2 - width / 2 + Dims.l(2.2)
            property var centerY: parent.height / 2 - height / 2 + Dims.l(2.2)
            radius: Dims.l(0.6)

            visible: !displayAmbient
            antialiasing : true
            x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.17
            y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.17
            color: "#55111111"
            width: parent.width * 0.008
            height: parent.width * 0.53
            transform: Rotation { origin.x: width / 2; origin.y: height / 2; angle: seconds * 6 }
        }
    }

    Rectangle {
        id: pinShadow
        visible: !displayAmbient
        antialiasing : true
        x: (parent.width / 2 - width / 2) + Dims.l(1.1)
        y: (parent.height / 2 - height / 2) + Dims.l(1.1)
        radius: (parent.width * 0.06) / 2
        width: parent.width * 0.06
        height: parent.width * 0.06
        color: "#55111111"
    }

    Repeater {
        id: hourHand
        model: 1
        Rectangle {
            property var rotM: (((hours * 5) + (minutes / 12)) - 15) / 60
            property var centerX: parent.width / 2 - width / 2
            property var centerY: parent.height / 2 - height / 2
            radius: Dims.l(2.8)
            
            antialiasing : true
            x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.15
            y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.15
            color: if ( displayAmbient ) "whitesmoke" 
                   else ((hours > 6 && hours < 18) ? "black" : "whitesmoke")
            width: parent.width * 0.032
            height: parent.width * 0.28
            transform: Rotation { origin.x: width / 2; origin.y: height / 2; angle: ((hours * 5) + (minutes / 12)) * 6 }
        }
    }

    Repeater {
    id: minuteHand
	model: 1
        Rectangle {
            property var rotM: (minutes - 15) / 60
            property var centerX: parent.width / 2 - width / 2
            property var centerY: parent.height / 2 - height / 2
            radius: Dims.l(2.8)
            
            antialiasing : true
            x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.20
            y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.20
            color: if ( displayAmbient ) "whitesmoke" 
                   else ((hours > 6 && hours < 18) ? "black" : "whitesmoke")
            width: parent.width * 0.02
            height: parent.width * 0.40
            transform: Rotation { origin.x: width / 2; origin.y: height / 2; angle: minutes * 6 }
        }
    }

    Repeater {
    id: secondHand
	model: 1
        Rectangle {
            property var rotM: (seconds - 15) / 60
            property var centerX: parent.width / 2 - width / 2
            property var centerY: parent.height / 2 - height / 2
            radius: Dims.l(0.6)
            
            visible: !displayAmbient
            antialiasing : true
            x: centerX + Math.cos(rotM * 2 * Math.PI) * parent.width * 0.17
            y: centerY + Math.sin(rotM * 2 * Math.PI) * parent.width * 0.17
            color: "#EE7F00"
            width: parent.width * 0.008
            height: parent.width * 0.53
            transform: Rotation { origin.x: width / 2; origin.y: height / 2; angle: seconds * 6 }
        }
    }

    Rectangle {
        id: centerPin
        x: (parent.width / 2 - width / 2)
        y: (parent.height / 2 - height / 2)
        antialiasing : true
        radius: (parent.width * 0.0625) / 2
        width: parent.width * 0.0625
        height: parent.width * 0.0625
        color: (hours > 6 && hours < 18) ? "black" : "whitesmoke"
    }
    
    Rectangle {
        x: (parent.width / 2 - width / 2)
        y: (parent.height / 2 - height / 2)
        antialiasing : true
        radius: (parent.width * 0.05) / 2
        width: parent.width * 0.05
        height: parent.width * 0.05
        color: (hours > 6 && hours < 18) ? "whitesmoke" : "black"
    }
}
