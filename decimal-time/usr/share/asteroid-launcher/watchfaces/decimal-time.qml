/*
 * Copyright (C) 2021 - Ed Beroset <github.com/beroset>
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

import QtQuick 2.1

Item {

    function getMetricMilliseconds(t) {
        return (t.getHours() * 3600000
            + t.getMinutes() * 60000
            + t.getSeconds() * 1000
            + t.getMilliseconds()) / 0.864
    }

    function getMetricHours(metricMilli){
        return getMetricMilliseconds(wallClock.time) / 10000000
    }

    Repeater{
        id: hourTicks
        model: 10
        Rectangle {
            z: 2
            id: decimalHourTick
            antialiasing : true
            color: "lightgreen"
            width: parent.width*0.01
            height: parent.height*0.03
            opacity: displayAmbient ? 0.3 : 0.6
            transform: [
                Rotation { 
                    origin.x: decimalHourTick.width/2
                    origin.y: decimalHourTick.height + parent.height*0.36
                    angle: (index)*360/hourTicks.count 
                },
                Translate { 
                    x: (parent.width - decimalHourTick.width)/2
                    y: parent.height/2 - (decimalHourTick.height + parent.height * 0.36)
                }
            ]
        }
    }

    Repeater{
        id: minuteTicks
        model: 100
        Rectangle {
            z: 1
            id: decimalHourTick
            visible: !displayAmbient
            antialiasing : true
            color: "lightgreen"
            width: parent.width*0.005
            height: parent.height*(index % 5 == 0 ? 0.030 : 0.015)
            opacity: 0.6
            transform: [
                Rotation { 
                    origin.x: decimalHourTick.width/2
                    origin.y: decimalHourTick.height + parent.height*0.36
                    angle: (index)*360/minuteTicks.count 
                },
                Translate { 
                    x: (parent.width - decimalHourTick.width)/2
                    y: parent.height/2 - (decimalHourTick.height + parent.height * 0.36)
                }
            ]
        }
    }

    Repeater{
        id: hourLabels
        model: 10
        Text {
            z: 3
            font.pixelSize: parent.height*0.08
            font.family: "CPMono_v07"
            color: "lightblue"
            id: hourLabel
            antialiasing : true
            opacity: displayAmbient ? 0.3 : 0.6
            text: index ? index : hourLabels.count
            transform: [
                Rotation { 
                    origin.x: hourLabel.width/2
                    origin.y: hourLabel.height + parent.height*0.40
                    angle: (index)*360/hourTicks.count 
                },
                Translate { 
                    x: (parent.width - hourLabel.width)/2
                    y: parent.height/2 - (hourLabel.height + parent.height * 0.40)
                }
            ]
        }
    }

    Text {
        id: conventionalTime
        z: 4
        font.pixelSize: parent.height*0.06
        font.family: "CPMono_v07"
        color: "white"
        visible: !displayAmbient
        horizontalAlignment: Text.AlignHCenter
        anchors {
            centerIn: parent
            verticalCenterOffset: +parent.width*0.18
        }
        text: if (use12H.value)
                  wallClock.time.toLocaleString(Qt.locale(), "hh:mm:ss ap")
              else
                  wallClock.time.toLocaleString(Qt.locale(), "HH:mm:ss")
    }

    Text {
        id: conventionalDate
        z: 4
        visible: !displayAmbient
        font.pixelSize: parent.height*0.06
        font.family: "CPMono_v07"
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        anchors {
            centerIn: parent
            verticalCenterOffset: -parent.width*0.18
        }
        text: wallClock.time.toLocaleDateString(Qt.locale(), Locale.ShortFormat)
    }

    Text {
        id: decimalHours
        z: 4
        visible: !displayAmbient
        font.pixelSize: parent.height*0.15
        font.family: "CPMono_v07"
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        anchors {
            centerIn: parent
        }
        textFormat: Text.RichText
        text: getMetricHours(wallClock.time).toPrecision(5)

    }

    Image {
        id: logoAsteroid
        z: 3
        opacity: displayAmbient ? 0.6 : 1.0
        source: "asteroid_logo.png"
        width: parent.width/12
        height: parent.height/12
        transform : [ 
            Rotation {
                origin.x : logoAsteroid.width/2
                origin.y : logoAsteroid.height + parent.height * 0.275
                angle: getMetricHours(wallClock.time)*36
                // angle: wallClock.time.getSeconds()*6
            },
            Translate {
                x: (parent.width - logoAsteroid.width)/2
                y: parent.height/2 - (logoAsteroid.height + parent.height * 0.275) 
            }
        ]
    }

}
