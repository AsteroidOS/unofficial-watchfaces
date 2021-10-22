/*
 * Copyright (C) 2021 - Ed Beroset <github.com/beroset>
 *               2021 - CosmosDev <github.com/CosmosDev>
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
    Repeater {
        model: 12
        Rectangle {
            z: 1
            id: hourTicks
            antialiasing : true
            property var rotM: ((index) - 3)/12
            property var centerX: parent.width/2-width/2
            property var centerY: parent.height/2-height/2
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.46
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.46
            color: "orange"
            width: parent.width*0.02
            height: parent.height*0.03
            opacity: 0.6
            transform: Rotation { origin.x: width/2; origin.y: height/2; angle: (index)*30}
        }
    }

    Repeater{
        model: 12
        Rectangle {
            z: 1
            id: hourTicks
            antialiasing : true
            property var rotM: ((index) - 3)/12
            property var centerX: parent.width/2-width/2
            property var centerY: parent.height/2-height/2
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.46
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.46
            color: "orange"
            width: parent.width*0.02
            height: parent.height*0.03
            opacity: 0.6
            transform: Rotation { origin.x: width/2; origin.y: height/2; angle: (index)*30}
        }
    }

    
    Image {
        id: hourSVG
        z: 2
        source: "analog-halloween/hour.svg" 
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
        source: "analog-halloween/minute.svg" 
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
        source: "analog-halloween/second.svg"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        transform: Rotation {
            origin.x: parent.width/2;
            origin.y: parent.height/2;
            angle: (wallClock.time.getSeconds()*6)+6
            Behavior on angle { RotationAnimation { duration: 1000; direction: RotationAnimation.Clockwise } }
        }
    }
}
