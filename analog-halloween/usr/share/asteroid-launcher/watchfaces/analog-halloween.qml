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

    property string imgPath: "../watchfaces-img/analog-halloween-"

    Repeater {
        model: 12
        Rectangle {
            z: 1
            id: hourTicks
            antialiasing : true
            property real rotM: (index - 3) / 12
            property real centerX: parent.width / 2 - width / 2
            property real centerY: parent.height / 2 - height / 2
            x: centerX+Math.cos(rotM * 2 * Math.PI)*parent.width*0.46
            y: centerY+Math.sin(rotM * 2 * Math.PI)*parent.width*0.46
            color: "orange"
            width: parent.width*0.02
            height: parent.height*0.03
            opacity: 0.9
            transform: Rotation { origin.x: width/2; origin.y: height/2; angle: (index)*30}
        }
    }
    
    Image {
        id: hourSVG
        z: 2
        source: imgPath + "hour.svg"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        transform: Rotation {
            id: hourRot
            origin.x: parent.width / 2
            origin.y: parent.height / 2
        }
    }
    
    Image {
        id: minuteSVG
        z: 3
        source: imgPath + "minute.svg"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        transform: Rotation {
            id: minuteRot
            origin.x: parent.width / 2
            origin.y: parent.height / 2
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
            id: secondRot
            origin.x: parent.width / 2
            origin.y: parent.height / 2
        }
    }
    
    // +6 offset preserved from original to align SVG artwork
    Timer {
        interval: 16
        repeat: true
        running: !displayAmbient && visible
        onTriggered: {
            var now = new Date()
            secondRot.angle = (now.getSeconds() * 1000 + now.getMilliseconds()) * 6 / 1000 + 6
        }
    }
    
    Connections {
        target: wallClock
        onTimeChanged: {
            if (!visible) return
                var h = wallClock.time.getHours()
                var min = wallClock.time.getMinutes()
                hourRot.angle = h * 30 + min * 0.5
                minuteRot.angle = min * 6
        }
    }
    
    Component.onCompleted: {
        var h = wallClock.time.getHours()
        var min = wallClock.time.getMinutes()
        hourRot.angle = h * 30 + min * 0.5
        minuteRot.angle = min * 6
    }
}
