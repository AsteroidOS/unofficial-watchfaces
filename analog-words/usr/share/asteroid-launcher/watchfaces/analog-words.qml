/*
 * Copyright (C) 2021 - Timo Könnecke <github.com/eLtMosen>
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
    property string currentColor: ""
    property string userColor: ""
    property var rotateOffset: [90, -90, -90, -90, -90, -90, -90, 90, 90, 90, 90, 90]
    property int hour: wallClock.time.toLocaleString(Qt.locale(), "h ap").slice(0, 2) === "12" ? 0 : wallClock.time.toLocaleString(Qt.locale(), "h ap").slice(0, 2)
    property var colorOffset: ["#ff0000", "#ff8000", "#ffff00", "#80ff00", "#00ff00", "#00ff80", "#00ffff", "#0080ff", "#0000ff", "#8000ff", "#ff00ff", "#ff0080"]
    property var wordsDE: ["zwölf", "eins", "zwei", "drei", "vier", "fünf", "sechs", "sieben", "acht", "neun", "zehn", "elf"]
    property var wordsEN: ["twelve", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven"]
    property var wordsFR: ["douze", "une", "deux", "trois", "quatre", "cinq", "six", "sept", "huit", "neuf", "dix", "onze"]
    property var wordsES: ["doce", "una", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve", "diez", "once"]
    property var wordsIT: ["dodici", "uno", "due", "tre", "quattro", "cinque", "sei", "sette", "otto", "nove", "dieci", "undici"]
    property var wordsNL: ["twaalf", "één", "twee", "drie", "vier", "vijf", "zes", "zeven", "acht", "negen", "tien", "elf"]
    property var wordsGR: ["δώδεκα", "ένα", "δύο", "τρία", "τέσσερα", "πέντε", "έξι", "επτά", "οκτώ", "εννέα", "δέκα", "έντεκα"]
    property var wordsSV: ["tolv", "ett", "två", "tre", "fyra", "fem", "sex", "sju", "åtta", "nio", "tio", "elva"]
    property var wordsSK: ["dvanajst", "ena", "dve", "tri", "štiri", "pet", "šest", "sedem", "osem", "devet", "deset", "enajst"]
    property var wordsDA: ["tolv", "en", "et", "to", "tre", "fire", "fem", "seks", "syv", "otte", "ni", "ti", "elleve"]
    property var wordsPT: ["doze", "um", "dois", "três", "quatro", "cinco", "seis", "sete", "oito", "nove", "dez", "onze"]
    property var wordsTR: ["on iki", "bir", "iki", "üç", "dört", "beş", "altı", "yedi", "sekiz", "dokuz", "on", "onbir"]
    property var wordsNB: ["tolv", "en", "to", "tre", "fire", "fem", "seks", "syv", "åtte", "ni", "ti", "elleve"]

    Rectangle {
        z: 7
        id: circleBack
        property var toggle: 1
        antialiasing : true
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        color: "white"
        width: parent.width * 0.3
        height: parent.height * 0.3
        radius: width * 0.5
        MouseArea {
            anchors.fill: parent
            onDoubleClicked: {
               if (circleBack.toggle === 1) {
                    currentColor = ""
                    circleBack.toggle = 0
               } else {
                    currentColor = "black"
                    circleBack.toggle = 1
                }
            }
        }
    }

    Text {
        id: minuteDisplay
        z: 7
        font.letterSpacing: -parent.height * 0.008
        font.pixelSize: parent.height * 0.165
        font.family: "Montserrat"
        font.styleName: "Regular"
        color: "black"
        opacity: 1.00
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
    }

    Repeater {
        model: 12
        Rectangle {
            z: 1
            id: backRectangles
            property int currentHourOffset: (hour == index) ? -parent.height * 0.02 : parent.height * 0.05
            property var rotM: ((index * 5 ) - 15)/60
            property var centerX: parent.width / 2 - width / 2
            property var centerY: parent.height / 2 - height / 2
            antialiasing: true
            width: hourRepeater.itemAt(index).contentWidth + (parent.width * 0.23) + currentHourOffset
            height: parent.height * 0.13
            x: centerX+Math.cos(rotM * 2 * Math.PI) * ((hourRepeater.itemAt(index).contentWidth / 2) + (parent.width * 0.1))
            y: centerY+Math.sin(rotM * 2 * Math.PI) * ((hourRepeater.itemAt(index).contentWidth / 2) + (parent.width * 0.1))
            color: colorOffset[index]
            opacity: 1
            radius: width * 0.5
            transform: Rotation {
                origin.x: width / 2;
                origin.y: height / 2;
                angle: ((index) * 30) + 90
            }
            state: currentColor
            states: State { name: "black";
                PropertyChanges { target: backRectangles; color: "black" }
            }
            transitions: Transition {
                from: ""; to: "black"; reversible: true
                    ColorAnimation { duration: 500 }
            }
        }
    }

    Repeater {
        model: 1
        Rectangle {
            z: 4
            id: backCurrentHour
            property int currentHourOffset: -parent.height * 0.02
            property var rotM: ((hour * 5 ) - 15)/60
            property var centerX: parent.width / 2 - width / 2
            property var centerY: parent.height / 2 - height / 2
            antialiasing: true
            width: hourRepeater.itemAt(hour).contentWidth + (parent.width * 0.23) + currentHourOffset
            height: parent.height * 0.13
            x: centerX+Math.cos(rotM * 2 * Math.PI) * ((currentHourRepeater.itemAt(hour).contentWidth/2) + (parent.width * 0.1))
            y: centerY+Math.sin(rotM * 2 * Math.PI) * ((currentHourRepeater.itemAt(hour).contentWidth/2) + (parent.width * 0.1))
            color: "white"
            opacity: 1
            radius: width * 0.5
            transform: Rotation {
                origin.x: width / 2;
                origin.y: height/2;
                angle: ((hour) * 30) + 90
            }
        }
    }

    Repeater {
        id: currentHourRepeater
        model: 12
        Text {
            id: currentHourText
            z: 7
            property var heightFontOffest: -parent.height * 0.006
            property int currentHourOffset: (rotateOffset[hour] === 90) ?
                                                parent.height * 0.03 :
                                                -parent.height * 0.03
            font.pixelSize: parent.height*0.1
            antialiasing: true
            font.family: "SourceSansPro"
            font.styleName: "Semibold"
            property var rotM: ((hour * 5 ) - 15) / 60
            property var centerX: parent.width / 2 - width / 2
            property var centerY: parent.height / 2 - height / 2
            x: centerX+Math.cos(rotM * 2 * Math.PI) * ((parent.width*0.17)+currentHourText.contentWidth / 2) + currentHourOffset
            y: centerY+Math.sin(rotM * 2 * Math.PI) * ((parent.width*0.17)+currentHourText.contentWidth / 2) + heightFontOffest
            color: "black"
            text: Qt.locale().name.substring(0,2) === "de" ? wordsDE[hour]:
                  Qt.locale().name.substring(0,2) === "fr" ? wordsFR[hour]:
                  Qt.locale().name.substring(0,2) === "es" ? wordsES[hour]:
                  Qt.locale().name.substring(0,2) === "it" ? wordsIT[hour]:
                  Qt.locale().name.substring(0,2) === "nl" ? wordsNL[hour]:
                  Qt.locale().name.substring(0,2) === "el" ? wordsGR[hour]:
                  Qt.locale().name.substring(0,2) === "sv" ? wordsSV[hour]:
                  Qt.locale().name.substring(0,2) === "sk" ? wordsSK[hour]:
                  Qt.locale().name.substring(0,2) === "da" ? wordsDA[hour]:
                  Qt.locale().name.substring(0,2) === "pt" ? wordsPT[hour]:
                  Qt.locale().name.substring(0,2) === "tr" ? wordsTR[hour]:
                  Qt.locale().name.substring(0,2) === "nb" ? wordsNB[hour]:
                                                             wordsEN[hour]
            transform: Rotation {
                origin.x: (currentHourText.contentWidth / 2) - currentHourOffset;
                origin.y: (currentHourText.contentHeight / 2) - heightFontOffest;
                angle: ((hour) * 30) + rotateOffset[hour]
            }
        }
    }

    Repeater {
        id: hourRepeater
        model: 12
        Text {
            id: hourText
            z: 3
            property var heightFontOffest: -parent.height * 0.004
            property int currentHourOffset: (rotateOffset[index] === 90) ?
                                                -parent.height * 0.02 :
                                                parent.height * 0.02
            font.pixelSize: parent.height * 0.08
            antialiasing: true
            font.letterSpacing: parent.height * 0.002
            font.family: "SourceSansPro"
            font.styleName: "Light"
            property var rotM: ((index * 5 ) - 15)/60
            property var centerX: parent.width / 2 - width / 2
            property var centerY: parent.height / 2 - height / 2
            x: centerX+Math.cos(rotM * 2 * Math.PI)*((parent.width * 0.17) + contentWidth/2) + currentHourOffset
            y: centerY+Math.sin(rotM * 2 * Math.PI)*((parent.width * 0.17) + contentWidth/2) + heightFontOffest
            color: "black"
            text: Qt.locale().name.substring(0,2) === "de" ? wordsDE[index]:
                  Qt.locale().name.substring(0,2) === "fr" ? wordsFR[index]:
                  Qt.locale().name.substring(0,2) === "es" ? wordsES[index]:
                  Qt.locale().name.substring(0,2) === "it" ? wordsIT[index]:
                  Qt.locale().name.substring(0,2) === "nl" ? wordsNL[index]:
                  Qt.locale().name.substring(0,2) === "el" ? wordsGR[index]:
                  Qt.locale().name.substring(0,2) === "sv" ? wordsSV[index]:
                  Qt.locale().name.substring(0,2) === "sk" ? wordsSK[index]:
                  Qt.locale().name.substring(0,2) === "da" ? wordsDA[index]:
                  Qt.locale().name.substring(0,2) === "pt" ? wordsPT[index]:
                  Qt.locale().name.substring(0,2) === "tr" ? wordsTR[index]:
                  Qt.locale().name.substring(0,2) === "nb" ? wordsNB[index]:
                                                             wordsEN[index]
            transform: Rotation {
                origin.x: (width / 2) - currentHourOffset;
                origin.y: (height / 2) - heightFontOffest;
                angle: (index * 30) + rotateOffset[index]
            }
            state: currentColor
            states: State { name: "black";
                PropertyChanges { target: hourText; color: "white" }
            }
            transitions: Transition {
                from: ""; to: "black"; reversible: true
                    ColorAnimation { duration: 500 }
            }
        }
    }



    Connections {
        target: compositor
        onDisplayAmbientEntered: if (currentColor == "") {
                                     currentColor = "black"
                                     userColor = ""
                                 }
                                 else
                                     userColor = "black"

        onDisplayAmbientLeft:    if (userColor == "") {
                                     currentColor = ""
                                 }
    }
}
