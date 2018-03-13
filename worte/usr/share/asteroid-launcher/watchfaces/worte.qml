/*
 * Copyright (C) 2018 - Timo Könnecke <el-t-mo@arcor.de>
 *               2016 - Sylvia van Os <iamsylvie@openmailbox.org>
 *               2015 - Florent Revest <revestflo@gmail.com>
 *               2014 - Aleksi Suomalainen <suomalainen.aleksi@gmail.com>
 * All rights reserved.
 *
 * You may use this file under the terms of BSD license as follows:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the author nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import QtQuick 2.1

Item {
    id: rootitem

    Text {
        function generateTime(time) {
            var minutesList = [" ", "<b>fünf</b><br>nach", "<b>zehn</b><br>nach", "<b>viertel</b><br>nach", "<b>zwanzig</b>", "<b>fünf</b><br> vor halb", "<b>dreißig</b>", "<b>fünf</b><br> nach halb", "<b>vierzig</b>", "<b>viertel</b><br>vor", "<b>zehn</b><br>vor", "<b>fünf</b><br>vor", " "]
            var hoursList = ["<b>zwölf</b>", "<b>ein</b>", "<b>zwei</b>", "<b>drei</b>", "<b>vier</b>", "<b>fünf</b>", "<b>sechs</b>", "<b>sieben</b>", "<b>acht</b>", "<b>neun</b>", "<b>zehn</b>", "<b>elf</b>"]
            var minutesFirst = [false, true, true, true, false, true, false, true, false, true, true, true, false]
            var nextHour   = [false, false, false, false, false, false, false, false, false, true, true, true, true]
            var hourSuffix = [true, false, false, false ,true, false, true, false, true, false, false, false, true]

            var minutes = Math.round(time.getMinutes()/5)
            var hours = (time.getHours() + (nextHour[minutes] ? 1 : 0)) % 12

            var start = "<p style=\"text-align:center\">"
            var newline = "<br>"
            var end = "</p>"
            
            if (hourSuffix[minutes]) {
                if (minutesFirst[minutes]) {
                    var generatedString = minutesList[minutes].toUpperCase() + newline + hoursList[hours].toUpperCase() +" UHR"
                } else {
                    var generatedString = hoursList[hours].toUpperCase()+" UHR" + newline + minutesList[minutes].toUpperCase()}
            } else {
                if (hours == 1) {
                    if (minutesFirst[minutes]) {
                        var generatedString = minutesList[minutes].toUpperCase() + newline + hoursList[hours].toUpperCase()+"<b>S</b>"
                    } else {
                        var generatedString = hoursList[hours].toUpperCase() +"<b>S</b>"+ newline + minutesList[minutes].toUpperCase()
                    }
                } else {
                    if (minutesFirst[minutes]) {
                        var generatedString = minutesList[minutes].toUpperCase() + newline + hoursList[hours].toUpperCase()
                    } else {
                        var generatedString = hoursList[hours].toUpperCase() + newline + minutesList[minutes].toUpperCase()
                    }
                }
            }
            return start + generatedString + end
        }

        id: timeDisplay

        textFormat: Text.RichText

        font.pixelSize: parent.height*0.15
        font.weight: Font.Light
        lineHeight: 0.85
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        horizontalAlignment: Text.AlignHCenter
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
        }
        Behavior on text {
            SequentialAnimation {
                NumberAnimation { target: timeDisplay; property: "opacity"; to: 0 }
                PropertyAction {}
                NumberAnimation { target: timeDisplay; property: "opacity"; to: 1 }
            }
        }
        text: generateTime(wallClock.time)
    }

    Text {
        id: dateDisplay
        font.pixelSize: parent.height*0.07
        color: "white"
        style: Text.Outline; styleColor: "#80000000"
        opacity: 0.8
        horizontalAlignment: Text.AlignHCenter
        anchors {
            bottomMargin: parent.height*0.115
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        text: wallClock.time.toLocaleString(Qt.locale(), "<b>dddd</b> d MMM")
    }

    Connections {
        target: localeManager
        onChangesObserverChanged: {
            timeDisplay.text = Qt.binding(function() { return generateTime(wallClock.time) })
            dateDisplay.text = Qt.binding(function() { return wallClock.time.toLocaleString(Qt.locale(), "<b>dddd</b> d MMM") })
        }
    }
}
