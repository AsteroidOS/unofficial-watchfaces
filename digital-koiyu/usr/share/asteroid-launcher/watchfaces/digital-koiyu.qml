/*
 * Copyright (C) 2023 - Arseniy Movshev <dodoradio@outlook.com>
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

import QtQuick 2.15
import QtGraphicalEffects 1.15
import Nemo.Mce 1.0

Item {
    id: root
    property string imgPath: "../watchfaces-img/digital-koiyu/"
    property int hours: use12H.value ? wallClock.time.getHours() % 12 : wallClock.time.getHours()
    property string minutes: wallClock.time.getMinutes() < 10 ? "0" + wallClock.time.getMinutes() : wallClock.time.getMinutes()
    property string mainDisplayValue: (hours < 10 ? " " : "") + hours + minutes + " "//this if statement gets rid of the leading 0 on the hours
    property string bottomDisplayValue: "  " + wallClock.time.toLocaleString(Qt.locale(), "ss")
    property bool separatorsVisible: false
    property bool dotMatrixTextMode: true
    property string dom: (wallClock.time.getDate() < 10) ? " " + wallClock.time.getDate() : wallClock.time.getDate()
    property string dotMatrixText: dows[wallClock.time.getDay()] + dom
    property var dows: ["SU","MO","TU","WE","TH","FR","SA"]
    property var decode: { // this blob is used to decode the state of the various displays
        "dotMatrixVisible": {
            "A": [
            [0,1,1,1,0,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,1,1,1,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0]],
            "B": [
            [1,1,1,1,0,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,1,1,1,0,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,1,1,1,0,0]],
            "C": [
            [0,1,1,1,0,0],
            [1,0,0,0,1,0],
            [1,0,0,0,0,0],
            [1,0,0,0,0,0],
            [1,0,0,0,0,0],
            [1,0,0,0,1,0],
            [0,1,1,1,0,0]],
            "D": [
            [1,1,1,1,0,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,1,1,1,0,0]],
            "E": [
            [1,1,1,1,1,0],
            [1,0,0,0,0,0],
            [1,0,0,0,0,0],
            [1,1,1,1,0,0],
            [1,0,0,0,0,0],
            [1,0,0,0,0,0],
            [1,1,1,1,1,0]],
            "F": [
            [1,1,1,1,1,0],
            [1,0,0,0,0,0],
            [1,0,0,0,0,0],
            [1,1,1,1,0,0],
            [1,0,0,0,0,0],
            [1,0,0,0,0,0],
            [1,0,0,0,0,0]],
            "H": [
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,1,1,1,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0]],
            "M": [
            [1,0,0,0,1,0],
            [1,1,0,1,1,0],
            [1,0,1,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0]],
            "O": [
            [0,1,1,1,0,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [0,1,1,1,0,0]],
            "R": [
            [1,1,1,1,0,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,1,1,1,0,0],
            [1,0,1,0,0,0],
            [1,0,0,1,0,0],
            [1,0,0,0,1,0]],
            "S": [
            [0,1,1,1,0,0],
            [1,0,0,0,1,0],
            [1,0,0,0,0,0],
            [0,1,1,1,0,0],
            [0,0,0,0,1,0],
            [1,0,0,0,1,0],
            [0,1,1,1,0,0]],
            "T": [
            [1,1,1,1,1,0],
            [0,0,1,0,0,0],
            [0,0,1,0,0,0],
            [0,0,1,0,0,0],
            [0,0,1,0,0,0],
            [0,0,1,0,0,0],
            [0,0,1,0,0,0]],
            "D": [
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [0,1,1,1,0,0]],
            "W": [
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [1,0,1,0,1,0],
            [1,0,1,0,1,0],
            [0,1,0,1,0,0]],
            "0": [
            [0,1,1,1,0,0],
            [1,0,0,0,1,0],
            [1,0,0,1,1,0],
            [1,0,1,0,1,0],
            [1,1,0,0,1,0],
            [1,0,0,0,1,0],
            [0,1,1,1,0,0]],
            "1": [
            [0,0,1,0,0,0],
            [0,1,1,0,0,0],
            [0,0,1,0,0,0],
            [0,0,1,0,0,0],
            [0,0,1,0,0,0],
            [0,0,1,0,0,0],
            [0,0,1,0,0,0]],
            "2": [
            [0,1,1,1,0,0],
            [1,0,0,0,1,0],
            [0,0,0,0,1,0],
            [0,0,1,1,0,0],
            [0,1,0,0,0,0],
            [1,0,0,0,0,0],
            [1,1,1,1,1,0]],
            "3": [
            [0,1,1,1,0,0],
            [1,0,0,0,1,0],
            [0,0,0,0,1,0],
            [0,0,1,1,0,0],
            [0,0,0,0,1,0],
            [1,0,0,0,1,0],
            [0,1,1,1,0,0]],
            "4": [
            [0,0,0,1,0,0],
            [0,0,1,1,0,0],
            [0,1,0,1,0,0],
            [1,0,0,1,0,0],
            [1,1,1,1,1,0],
            [0,0,0,1,0,0],
            [0,0,0,1,0,0]],
            "5": [
            [1,1,1,1,1,0],
            [1,0,0,0,0,0],
            [1,1,1,1,0,0],
            [0,0,0,0,1,0],
            [0,0,0,0,1,0],
            [1,0,0,0,1,0],
            [0,1,1,1,0,0]],
            "6": [
            [0,1,1,1,0,0],
            [1,0,0,0,1,0],
            [1,0,0,0,0,0],
            [1,1,1,1,0,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [0,1,1,1,0,0]],
            "7": [
            [1,1,1,1,1,0],
            [0,0,0,0,1,0],
            [0,0,0,0,1,0],
            [0,0,0,1,0,0],
            [0,0,1,0,0,0],
            [0,0,1,0,0,0],
            [0,0,1,0,0,0]],
            "8": [
            [0,1,1,1,0,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [0,1,1,1,0,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [0,1,1,1,0,0]],
            "9": [
            [0,1,1,1,0,0],
            [1,0,0,0,1,0],
            [1,0,0,0,1,0],
            [0,1,1,1,1,0],
            [0,0,0,0,1,0],
            [1,0,0,0,1,0],
            [0,1,1,1,0,0]],
            " ": [
            [0,0,0,0,0,0],
            [0,0,0,0,0,0],
            [0,0,0,0,0,0],
            [0,0,0,0,0,0],
            [0,0,0,0,0,0],
            [0,0,0,0,0,0],
            [0,0,0,0,0,0]]
        }
    }

    Item {
        id: segmentParent
        width: parent.width
        height: parent.width*15/16
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -parent.width/32
        Image { // these two lines are shown if the watch is a) prepared for 'timepiece mode' (meaning that the LCD will continue working if the display turns off) or b) if the LCD is showing some data other than time
            anchors.fill: parent
            source: imgPath + "separators.svg"
            visible: separatorsVisible
        }
        Image { // this watchface ships a pile of other punctuation, but this isn't used for normal timekeeping
            anchors.fill: parent
            source: imgPath + "main-colon.svg"
        }
        Image {
            anchors.fill: parent
            source: imgPath + "pm-indicator.svg"
            visible: use12H.value ? wallClock.time.getHours() > 12 : false
        }
        Image { // this is shown when the watch is charging. We don't use nightstand in order to emulate the behaviour of the original display.
            anchors.fill: parent
            source: imgPath + "battery-icon.svg"
            visible: mceChargerType.type != MceChargerType.None
            MceChargerType {
                id: mceChargerType
            }
        }
        Repeater {
            id: mainDigitRepeater
            anchors.fill: parent
            model: ListModel {
                ListElement {
                    x: 35.261
                    y: 118.693
                    width: 1
                    height: 1
                }
                ListElement {
                    x: 90.254
                    y: 118.693
                    width: 1
                    height: 1
                }
                ListElement {
                    x: 161.797
                    y: 118.693
                    width: 1
                    height: 1
                }
                ListElement {
                    x: 216.789
                    y: 118.693
                    width: 1
                    height: 1
                }
                ListElement {
                    x: 271.750
                    y: 134.394
                    width: 0.7907
                    height: 0.8307
                }
            }
            Image {
                id: digit
                width: parent.width
                height: parent.height
                x: model.x*parent.width/320
                y: model.y*parent.height/300
                property string value: mainDisplayValue[index]
                source: value == " " ? "" : imgPath + "main-" + (value) + ".svg"
                smooth: true
            }
        }
        Item {
            id: dotMatrixRoot
            width: 172.1*parent.width/320
            height: 52.2*parent.height/300
            y: 41.800*parent.width/320
            x: 76.525*parent.height/300
            property int columns: 23
            property int rows: 7
            Repeater {
                model: dotMatrixRoot.rows*dotMatrixRoot.columns
                Rectangle {
                    height: parent.height*0.95/dotMatrixRoot.rows //these 0.95 add a tiny spacing between pixels
                    width: parent.width*0.95/dotMatrixRoot.columns
                    antialiasing: true
                    property int row: Math.floor(index/dotMatrixRoot.columns)
                    property int column: index%dotMatrixRoot.columns
                    x: dotMatrixRoot.width*column/dotMatrixRoot.columns
                    y: dotMatrixRoot.height*row/dotMatrixRoot.rows
                    color: "#141414"
                    visible: dotMatrixTextMode ? decode.dotMatrixVisible[dotMatrixText[Math.floor(column/6)]][row][column%6] : false
                }
            }
        }
        Repeater {
            id: bottomDigitRepeater
            anchors.fill: parent
            model: ListModel {
                ListElement {
                    x: 93.209
                    y: 229.860
                }
                ListElement {
                    x: 127.690
                    y: 229.860
                }
                ListElement {
                    x: 173.840
                    y: 229.860
                }
                ListElement {
                    x: 208.322
                    y: 229.860
                }
            }
            Image {
                id: digit
                width: parent.width
                height: parent.height
                x: model.x*parent.width/320
                y: model.y*parent.height/300
                property string value: bottomDisplayValue[index]
                source: value == " " ? "" : imgPath + "bottom-" + (value) + ".svg"
                smooth: true
            }
        }
        ColorOverlay{
            anchors.fill: segmentParent
            source: segmentParent
            color: "#B3B3B3"
            visible: displayAmbient
            antialiasing: true
        }
    }
}
