/*
 * Copyright (C) 2026 - Luca Barbera <github.com/lbarbera>
 * 2018 - Timo Könnecke <el-t-mo@arcor.de>
 * 2017 - Mario Kicherer <dev@kicherer.org>
 * 2016 - Sylvia van Os <iamsylvie@openmailbox.org>
 * 2015 - Florent Revest <revestflo@gmail.com>
 * 2012 - Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
 * Enhanced from Analog-Railway to include smooth animations, new Ambient mode, and Nightstand power meter
 */

import QtQuick 2.9
import Nemo.Mce 1.0

Item {
    id: root
    anchors.fill: parent

    property bool isDark: {
        var ambient = false; var night = false;
        try { ambient = displayAmbient; } catch(e) { ambient = false; }
        try { night = nightstandMode; } catch(e) { night = false; }
        return ambient || night;
    }

    MceBatteryLevel { id: batteryChargePercentage }

    property real animatedSoC: nightstandMode ? (batteryChargePercentage.percent / 100.0) : 0.0
    Behavior on animatedSoC {
        NumberAnimation {
            duration: (batteryChargePercentage.percent / 100.0) * 3000
            easing.type: Easing.Linear
        }
    }

    onAnimatedSoCChanged: if (nightstandMode) indices.requestPaint();

    readonly property var batteryColors: [ "red", "yellow", Qt.rgba(.318, 1, .051, .9)]
    
    function getStrokeColor(index, total) {
        if (!nightstandMode) return root.isDark ? "white" : "black";
        var pos = index / total;
        if (pos <= root.animatedSoC && root.animatedSoC > 0) {
            var chargeIndex = Math.floor(batteryChargePercentage.percent / 33.35);
            return batteryColors[Math.min(Math.max(chargeIndex, 0), 2)];
        }
        return "white";
    }

    Timer {
        id: engine
        interval: 33 
        running: !root.isDark
        repeat: true
        onTriggered: {
            var now = new Date(); var s = now.getSeconds(); var ms = now.getMilliseconds()
            var progress = ms / 1000
            var easedProgress = progress - (Math.sin(progress * 2 * Math.PI) / (2 * Math.PI))
            secondHand.stop2goAngle = Math.min((s + easedProgress) * (360 / 58), 360)
            secondHand.requestPaint()
            updateTime(now, s + easedProgress)
        }
    }

    Connections {
        target: wallClock
        onTimeChanged: if (root.isDark) updateTime(wallClock.time, 0)
    }

    function updateTime(now, smoothSeconds) {
        var h = now.getHours(); var m = now.getMinutes()
        var displayMin = (!root.isDark && smoothSeconds >= 58) ? (m + 1) : m
        if (minuteHand.minute !== displayMin || hourHand.hour !== h) {
            minuteHand.minute = displayMin; hourHand.hour = h; hourHand.minute = displayMin
            bgCircle.requestPaint(); indices.requestPaint(); hourHand.requestPaint(); minuteHand.requestPaint()
        }
    }

    Canvas {
        id: bgCircle
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        smooth: true
        onPaint: {
            var ctx = getContext("2d"); ctx.reset()
            ctx.fillStyle = root.isDark ? "black" : "white"
            ctx.beginPath(); ctx.arc(width/2, height/2, width*0.49, 0, 2*Math.PI, false); ctx.fill()
        }
    }

    Canvas {
        id: indices
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        smooth: true
        onPaint: {
            var ctx = getContext("2d"); ctx.reset()
            // 1-min
            ctx.lineWidth = width*0.015
            for (var k=0; k < 60; k++) {
                ctx.save(); ctx.translate(width/2, height/2); ctx.rotate(k * Math.PI / 30)
                if ((k % 5) !== 0) {
                    ctx.strokeStyle = root.getStrokeColor(k, 60)
                    ctx.beginPath(); ctx.moveTo(0, -height*0.43); ctx.lineTo(0, -height*0.48); ctx.stroke()
                }
                ctx.restore()
            }
            // 5-min
            ctx.lineWidth = width*0.024
            for (var j=0; j < 12; j++) {
                ctx.save(); ctx.translate(width/2, height/2); ctx.rotate(j * Math.PI / 6)
                ctx.strokeStyle = root.getStrokeColor(j, 12)
                ctx.beginPath(); ctx.moveTo(0, -height*0.37); ctx.lineTo(0, -height*0.48); ctx.stroke()
                ctx.restore()
            }
            // Hours
            ctx.lineWidth = width*0.028
            for (var i=0; i < 4; i++) {
                ctx.save(); ctx.translate(width/2, height/2); ctx.rotate(i * Math.PI / 2)
                ctx.strokeStyle = root.getStrokeColor(i, 4)
                ctx.beginPath(); ctx.moveTo(0, -height*0.34); ctx.lineTo(0, -height*0.48); ctx.stroke()
                ctx.restore()
            }
        }
    }

    Canvas {
        id: hourHand
        property int hour: 0
        property int minute: 0
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        smooth: true
        onPaint: {
            var ctx = getContext("2d"); ctx.reset(); ctx.fillStyle = root.isDark ? "white" : "black"
            ctx.translate(width/2, height/2)
            ctx.rotate(((hour + minute/60) / 12) * 2 * Math.PI - Math.PI/2)
            ctx.fillRect(-width*0.06, -height*0.025, width*0.36, height*0.05)
        }
    }

    Canvas {
        id: minuteHand
        property int minute: 0
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        smooth: true
        onPaint: {
            var ctx = getContext("2d"); ctx.reset(); ctx.fillStyle = root.isDark ? "white" : "black"
            ctx.translate(width/2, height/2)
            ctx.rotate((minute/60) * 2 * Math.PI - Math.PI/2)
            ctx.fillRect(-width*0.08, -height*0.02, width*0.51, height*0.04)
        }
    }

    Canvas {
        id: secondHand
        visible: { try { return !displayAmbient; } catch(e) { return true; } }
        property real stop2goAngle: 0
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        smooth: true
        onPaint: {
            if (!visible || root.isDark) return;
            var ctx = getContext("2d"); ctx.reset(); var angleRad = (stop2goAngle * Math.PI / 180) - (Math.PI / 2)
            ctx.strokeStyle = "red"; ctx.fillStyle = "red"; ctx.lineWidth = height*0.018
            ctx.beginPath(); ctx.moveTo(width/2, height/2); ctx.lineTo(width/2 + Math.cos(angleRad - Math.PI)*width*0.1, height/2 + Math.sin(angleRad - Math.PI)*width*0.1); ctx.stroke()
            ctx.beginPath(); ctx.moveTo(width/2, height/2); ctx.lineTo(width/2 + Math.cos(angleRad)*width*0.35, height/2 + Math.sin(angleRad)*width*0.35); ctx.stroke()
            ctx.beginPath(); ctx.arc(width/2 + Math.cos(angleRad)*width*0.34, height/2 + Math.sin(angleRad)*width*0.34, height*0.045, 0, 2*Math.PI, false); ctx.fill()
            ctx.beginPath(); ctx.arc(width/2, height/2, height*0.015, 0, 2*Math.PI, false); ctx.fill()
        }
    }

    Rectangle {
        id: dimOverlay
        anchors.fill: parent; color: "black"; opacity: root.isDark ? 0.4 : 0.0; z: 10
        Behavior on opacity { NumberAnimation { duration: 1000; easing.type: Easing.InOutQuad } }
    }

    Connections {
        target: batteryChargePercentage
        onPercentChanged: if (nightstandMode) indices.requestPaint();
    }

    onIsDarkChanged: { bgCircle.requestPaint(); indices.requestPaint(); hourHand.requestPaint(); minuteHand.requestPaint() }
    Component.onCompleted: updateTime(wallClock.time, 0)
}
