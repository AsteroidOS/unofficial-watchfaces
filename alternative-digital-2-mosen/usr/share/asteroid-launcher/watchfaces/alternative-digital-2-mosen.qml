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
 * Based on Florents 003-alternative-digital-2 stock watchface.
 * Heavily quantizised to geometric proportions.
 * Fixed am/pm display by slicing to two chars.
 * Calculated ctx.shadows with variable px size for better display in watchface-settings
 */

import QtQuick 2.1

Item {
    function twoDigits(x) {
        if (x<10) return "0" + x;
        else      return x;
    }

    function prepareContext(ctx) {
        ctx.reset()
        ctx.fillStyle = "white"
        ctx.textAlign = "center"
        ctx.textBaseline = 'middle';
        ctx.shadowColor = Qt.rgba(0, 0, 0, 0.80)
        ctx.shadowOffsetX = parent.height * 0.00625
        ctx.shadowOffsetY = parent.height * 0.00625 //2 px on 320x320
        ctx.shadowBlur = parent.height * 0.0156  //5 px on 320x320
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

            ctx.font = "57 " + parent.height*0.39 + "px Roboto"
            ctx.fillText(twoDigits(hour),
                         parent.width * 0.5,
                         parent.height * 0.34);
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

            ctx.font = "24 " + parent.height*0.38 + "px Roboto"
            ctx.fillText(twoDigits(minute),
                         parent.width * 0.5,
                         parent.height * 0.74);
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
            ctx.shadowBlur = parent.height * 0.00625 //2 px on 320x320
            ctx.textAlign = "left"
            ctx.textBaseline = "left"
            ctx.font = "60 " + parent.height * 0.09 + "px Raleway"
            ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "dd"),
                         parent.width / 10 * 1.75,
                         parent.height * 0.505);
        }
    }

    Canvas {
        id: monthCanvas
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.FramebufferObject

        property var month: 0

        onPaint: {
            var ctx = getContext("2d")
            prepareContext(ctx)
            ctx.shadowBlur = parent.height * 0.00625 //2 px on 320x320
            ctx.textAlign = "center"
            ctx.font = "40 " +parent.height * 0.07 + "px Raleway"
            ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "MMMM").toUpperCase(),
                         parent.width/2,
                         parent.height * 0.509);
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
            ctx.shadowBlur = parent.height * 0.00625 //2 px on 320x320
            ctx.textAlign = "right"
            ctx.textBaseline = "right"
            ctx.font = "72 " +parent.height*0.072 + "px Raleway"
            ctx.fillText(wallClock.time.toLocaleString(Qt.locale(), "AP").slice(0, 2),
                         parent.width/10 * 8.3,
                         parent.height * 0.509);
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
            } if(dateCanvas.date != date) {
                dateCanvas.date = date
                dateCanvas.requestPaint()
            } if(monthCanvas.month != date) {
                monthCanvas.month = date
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
        dateCanvas.date = date
        dateCanvas.requestPaint()
        monthCanvas.month = date
        monthCanvas.requestPaint()
        amPmCanvas.am = am
        amPmCanvas.requestPaint()
    }

    Connections {
        target: localeManager
        onChangesObserverChanged: {
            hourCanvas.requestPaint()
            minuteCanvas.requestPaint()
            dateCanvas.requestPaint()
            monthCanvas.requestPaint()
            amPmCanvas.requestPaint()
        }
    }
}

