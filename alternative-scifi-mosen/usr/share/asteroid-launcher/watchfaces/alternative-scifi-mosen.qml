/*
 * Copyright (C) 2018 - Timo Könnecke <el-t-mo@arcor.de>
 *               2016 - Florent Revest <revestflo@gmail.com>
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

/*
* Based on Florents 005-scifi stock watchface, treid to keep the scifi theme with a different touch.
* Bigger monotype font (Xolonium) and fixed am/pm display by slicing to two chars.
* Calculated ctx.shadows with variable px size for better display in watchface-settings
*/

import QtQuick 2.1

Item {
    id: rootitem

    function twoDigits(x) {
        if (x<10) return "0"+x;
        else      return x;
    }

    function prepareContext(ctx) {
        ctx.reset()
        ctx.fillStyle = "white"
        ctx.shadowColor = Qt.rgba(0, 0, 0, 0.80)
        ctx.shadowOffsetX = parent.height*0.00625
        ctx.shadowOffsetY = parent.height*0.00625 //2 px on 320x320
        ctx.shadowBlur = parent.height*0.0156  //5 px on 320x320
    }

    Canvas {
        id: dowCanvas
        anchors.fill: parent
        renderTarget: Canvas.FramebufferObject

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.shadowBlur = parent.height*0.00625 //2 px on 320x320
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"

            var bold = "0 "
            var px = "px "

            var centerX = width*0.373
            var centerY = height/2*0.57
            var verticalOffset = height*0.05

            var text;
            text = wallClock.time.toLocaleString(Qt.locale(), "dddd").toUpperCase()

            var fontSize = height*0.051
            var fontFamily = "Xolonium"
            ctx.font = bold + fontSize + px + fontFamily;
            ctx.fillText(text, centerX, centerY+verticalOffset);
        }
    }

    Canvas {
        id: hourCanvas
        anchors.fill: parent
        renderTarget: Canvas.FramebufferObject

        property var hour: 0

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.textAlign = "right"
            ctx.textBaseline = "right"

            var bold = "60 "
            var px = "px "

            var centerX = width/2*1.25
            var centerY = height/2
            var verticalOffset = height*0.12

            var text;
            text = twoDigits(hour)

            var fontSize = height*0.36
            var fontFamily = "Xolonium"
            ctx.font = bold + fontSize + px + fontFamily;
            ctx.fillText(text, centerX, centerY+verticalOffset);
        }
    }

    Canvas {
        id: minuteCanvas
        anchors.fill: parent
        renderTarget: Canvas.FramebufferObject

        property var minute: 0

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.shadowBlur = 3
            ctx.textAlign = "left"
            ctx.textBaseline = "left"

            var thin = "0 "
            var px = "px "

            var centerX = width/2*1.268
            var centerY = height/2
            var verticalOffset = height*0.112

            var text;
            text = wallClock.time.toLocaleString(Qt.locale(), "mm")

            var fontSize = height*0.17
            var fontFamily = "Xolonium"
            ctx.font = thin + fontSize + px + fontFamily;
            ctx.fillText(text, centerX, centerY+verticalOffset);
        }
    }

    Canvas {
        id: amPmCanvas
        anchors.fill: parent
        renderTarget: Canvas.FramebufferObject
        property var am: false

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.shadowBlur = parent.height*0.00625 //2 px on 320x320
            ctx.textAlign = "left"
            ctx.textBaseline = "left"

            var bold = "64 "
            var px = "px "

            var centerX = width/2*1.29
            var centerY = height/2*0.83
            var verticalOffset = height*0.05

            var text;
            text = wallClock.time.toLocaleString(Qt.locale(), "ap").toUpperCase()

            var fontSize = height*0.057
            var fontFamily = "Xolonium"
            ctx.font = bold + fontSize + px + fontFamily;
            if(use12H.value) ctx.fillText(text, centerX, centerY+verticalOffset);
        }
    }
    Canvas {
        id: dateCanvas
        anchors.fill: parent
        renderTarget: Canvas.FramebufferObject

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.shadowBlur = parent.height*0.00625 //2 px on 320x320
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"

            var thin = "0 "
            var px = "px "

            var centerX = width*0.626
            var centerY = height/2*1.27
            var verticalOffset = height*0.05

            var text;
            text = wallClock.time.toLocaleString(Qt.locale(), "dd MMMM").toUpperCase()

            var fontSize = height*0.051
            var fontFamily = "Xolonium"
            ctx.font = thin + fontSize + px + fontFamily;
            ctx.fillText(text, centerX, centerY+verticalOffset);
        }
    }
    Connections {
        target: wallClock
        onTimeChanged: {
            var hour = wallClock.time.getHours()
            var minute = wallClock.time.getMinutes()
            var date = wallClock.time.getDate()
            var am = hour < 12
            if(use12H.value) {
                hour = hour % 12
                if (hour == 0) hour = 12;
            }
            if(hourCanvas.hour != hour) {
                hourCanvas.hour = hour
                hourCanvas.requestPaint()
            } if(minuteCanvas.minute != minute) {
                minuteCanvas.minute = minute
                minuteCanvas.requestPaint()
                dateCanvas.requestPaint()
                dowCanvas.requestPaint()
            } if(amPmCanvas.am != am) {
                amPmCanvas.am = am
                amPmCanvas.requestPaint()
            }
        }
    }

    Component.onCompleted: {
        var hour = wallClock.time.getHours()
        var minute = wallClock.time.getMinutes()
        var am = hour < 12
        if(use12H.value) {
            hour = hour % 12
            if (hour == 0) hour = 12
        }
        hourCanvas.hour = hour
        hourCanvas.requestPaint()
        minuteCanvas.minute = minute
        minuteCanvas.requestPaint()
        dateCanvas.requestPaint()
        dowCanvas.requestPaint()
        amPmCanvas.am = am
        amPmCanvas.requestPaint()
    }

    Connections {
        target: localeManager
        onChangesObserverChanged: {
            hourCanvas.requestPaint()
            minuteCanvas.requestPaint()
            dateCanvas.requestPaint()
            dowCanvas.requestPaint()
            amPmCanvas.requestPaint()
        }
    }
}
