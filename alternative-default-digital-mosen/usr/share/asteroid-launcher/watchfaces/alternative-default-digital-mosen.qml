/*
 * Copyright (C) 2018 - Timo Könnecke <el-t-mo@arcor.de>
 *               2017 - Florent Revest <revestflo@gmail.com>
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

/*
 * Based on Florents 000-default-digital stock watchface with added seconds.
 * Heavily quantizised to geometric proportions.
 * Fixed am/pm display by slicing to two chars.
 * Calculated ctx.shadows with variable px size for better display in watchface-settings
 */

import QtQuick 2.1

Item {
    function twoDigits(x) {
        if (x<10) return "0"+x;
        else      return x;
    }

    function prepareContext(ctx) {
        ctx.reset()
        ctx.reset()
        ctx.fillStyle = "white"
        ctx.textAlign = "center"
        ctx.textBaseline = 'middle';
        ctx.shadowColor = Qt.rgba(0, 0, 0, 0.80)
        ctx.shadowOffsetX = parent.height*0.00625
        ctx.shadowOffsetY = parent.height*0.00625 //2 px on 320x320
        ctx.shadowBlur = parent.height*0.0156  //5 px on 320x320
    }

    Canvas {
        id: hourCanvas
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject 

        property var hour: 0

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)

            ctx.font = "64 " + height*0.385 + "px Roboto"
            ctx.fillText(twoDigits(hour), width*0.3, height*0.54)
        }
    }

    Canvas {
        id: minuteCanvas
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject 

        property var minute: 0

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.shadowBlur = parent.height*0.00937 //3 px on 320x320
            ctx.font = "24 " + height*0.222 + "px Roboto"
            ctx.fillText(twoDigits(minute),
                         width*0.642,
                         height*0.47);
        }
    }

    Canvas {
        id: secondCanvas
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject

        property var second: 0

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.shadowBlur = parent.height*0.00625 //2 px on 320x320
            ctx.textAlign = "right"
            ctx.textBaseline = "right"

            ctx.font = "22 " + height*0.111 + "px Roboto"
            ctx.fillText(twoDigits(second),
                         width*0.902,
                         height*0.419);
        }
    }

    Canvas {
        id: amPmCanvas
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject 
        visible: use12H.value

        property var am: false

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.shadowBlur = parent.height*0.00625 //2 px on 320x320
            ctx.textAlign = "right"
            ctx.textBaseline = "right"

            ctx.font = "14 " + height*0.08 + "px Raleway"
            ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "AP").slice(0, 2),
                         width*0.902,
                         height*0.5135);
        }
    }

    Canvas {
        id: monthCanvas
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject

        property var date: 0

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.shadowBlur = parent.height*0.00625 //2 px on 320x320
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"
            var ctx = getContext("2d")

            ctx.font = "20 " + height*0.111 + "px Raleway"
            ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "MMM").slice(0, 3).toUpperCase(),
                         width*0.642,
                         height*0.615);
        }
    }

    Canvas {
        id: dateCanvas
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject 

        property var date: 0

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.shadowBlur = parent.height*0.00625 //2 px on 320x320
            ctx.textAlign = "right"
            ctx.textBaseline = "right"
            var ctx = getContext("2d")

            ctx.font = "42 " + height*0.112 + "px Roboto"
            ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "dd"),
                         width*0.902,
                         height*0.612);
        }
    }

    Connections {
        target: wallClock
        onTimeChanged: {
            var hour = wallClock.time.getHours()
            var minute = wallClock.time.getMinutes()
            var second = wallClock.time.getSeconds()
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
            } if(secondCanvas.second != second) {
                secondCanvas.second = second
                secondCanvas.requestPaint()
            } if(dateCanvas.date != date) {
                dateCanvas.date = date
                dateCanvas.requestPaint()
            } if(monthCanvas.date != date) {
                monthCanvas.date = date
                monthCanvas.requestPaint()
            } if(amPmCanvas.am != am) {
                amPmCanvas.am = am
                amPmCanvas.requestPaint()
            }
        }
    }

    Component.onCompleted: {
        var hour = wallClock.time.getHours()
        var minute = wallClock.time.getMinutes()
        var second = wallClock.time.getSeconds()
        var date = wallClock.time.getDate()
        var am = hour < 12
        if(use12H.value) {
            hour = hour % 12
            if (hour == 0) hour = 12
        }
        hourCanvas.hour = hour
        hourCanvas.requestPaint()
        minuteCanvas.minute = minute
        minuteCanvas.requestPaint()
        secondCanvas.second = second
        secondCanvas.requestPaint()
        dateCanvas.date = date
        dateCanvas.requestPaint()
        monthCanvas.date = date
        monthCanvas.requestPaint()
        amPmCanvas.am = am
        amPmCanvas.requestPaint()
    }
}
