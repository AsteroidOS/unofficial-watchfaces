// SPDX-FileCopyrightText: 2022 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: LGPL-2.1-or-later

import Nemo.Mce
import Qt5Compat.GraphicalEffects
import QtQuick
import org.asteroid.controls

Item {
    id: root

    property real rad: 0.01745
    property string userColor: "#65AFFF" // green: #9BE564 / orange: #EA9010 / blue: #65AFFF

    anchors.centerIn: parent
    width: parent.width
    height: parent.height
    layer.enabled: true

    MceBatteryLevel {
        id: batteryChargePercentage
    }

    Item {
        id: batteryBox

        property int value: batteryChargePercentage.percent

        onValueChanged: batteryArc.requestPaint()
        anchors.centerIn: parent
        width: parent.width * 0.85
        height: parent.height * 0.88

        Canvas {
            id: batteryArc

            z: 1
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.lineWidth = root.height * 0.009;
                ctx.lineCap = "round";
                ctx.strokeStyle = userColor;
                ctx.beginPath();
                ctx.arc(parent.width / 2, parent.height / 2, parent.width * 0.456, 270 * rad, ((batteryChargePercentage.percent / 100 * 360) + 270) * rad, false);
                ctx.stroke();
                ctx.closePath();
            }
        }

        Text {
            id: batteryDisplay

            z: 2
            renderType: Text.NativeRendering
            color: userColor
            text: batteryChargePercentage.percent + "%"

            anchors {
                centerIn: parent
                verticalCenterOffset: -root.height * 0.21
            }

            font {
                pixelSize: root.height * 0.12
                family: "Outfit"
                styleName: "Light"
            }

        }

    }

    Text {
        id: hourDisplay

        renderType: Text.NativeRendering
        color: userColor
        horizontalAlignment: Text.AlignHCenter
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) : wallClock.time.toLocaleString(Qt.locale(), "HH")

        anchors {
            centerIn: root
            horizontalCenterOffset: -root.height * 0.15
        }

        font {
            pixelSize: root.height * 0.22
            letterSpacing: root.height * 0.006
            family: "Outfit"
            styleName: "Medium"
        }

    }

    Text {
        id: minuteDisplay

        renderType: Text.NativeRendering
        color: userColor
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")

        anchors {
            centerIn: root
            horizontalCenterOffset: root.height * 0.15
        }

        font {
            pixelSize: root.height * 0.22
            letterSpacing: root.height * 0.006
            family: "Outfit"
            styleName: "Light"
        }

    }

    Text {
        id: monthDisplay

        renderType: Text.NativeRendering
        color: userColor
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "ddd MMM dd").replace(".", "").toUpperCase() + "<br>" + wallClock.time.toLocaleString(Qt.locale(), "ap").toUpperCase()

        anchors {
            centerIn: root
            verticalCenterOffset: root.height * 0.22
        }

        font {
            pixelSize: root.height * 0.054
            letterSpacing: root.height * 0.006
            family: "Outfit"
            styleName: "Regular"
        }

    }

    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 4
        verticalOffset: 4
        radius: 10
        samples: 9
        color: "#99000000"
    }

}
