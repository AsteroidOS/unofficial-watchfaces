/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
 *               2021 - Timo Könnecke <el-t-mo@arcor.de>
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
    id: root

    property real radian: 0.01745
    property string currentColor: "black"
    property string userColor: ""

    function growShrink() {
        circleDoubleClickCover.width = root.width * 0.8;
        circleDoubleClickCover.height = root.width * 0.8;
        shrink.start();
    }

    Component.onCompleted: {
        var second = wallClock.time.getSeconds();
        var minute = wallClock.time.getMinutes();
        circlePulse.width = (second % 2) ? root.width * 0.5 : root.width * 0.65;
        circlePulse.height = (second % 2) ? root.height * 0.5 : root.height * 0.65;
        secondCanvas.second = second;
        secondCanvas.minute = minute;
        secondCanvas.requestPaint();
    }

    ParallelAnimation {
        id: shrink

        NumberAnimation {
            target: circleDoubleClickCover
            property: "height"
            to: root.width * 0.5
            duration: 300
        }

        NumberAnimation {
            target: circleDoubleClickCover
            property: "width"
            to: root.width * 0.5
            duration: 300
        }

    }

    Rectangle {
        id: circleTransBack

        z: 0
        antialiasing: true
        visible: !displayAmbient
        x: root.width / 2 - width / 2
        y: root.height / 2 - width / 2
        color: Qt.rgba(1, 1, 1, 0.3)
        width: root.width * 0.65
        height: root.height * 0.65
        radius: width * 0.5
        state: currentColor

        states: State {
            name: "black"

            PropertyChanges {
                target: circleTransBack
                color: Qt.rgba(0, 0, 0, 0.3)
            }

        }

        transitions: Transition {
            from: ""
            to: "black"
            reversible: true

            ColorAnimation {
                duration: 300
            }

        }

    }

    Canvas {
        id: secondCanvas

        property int second: 0
        property int minute: 0
        property var colorctx: Qt.rgba(0, 0, 0, 0.6)

        z: 1
        visible: !displayAmbient
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        onPaint: {
            var ctx = getContext("2d");
            var rot = (second - 15) * 6;
            var start = minute * 5.9;
            ctx.reset();
            ctx.beginPath();
            ctx.arc(root.width / 2, root.height / 2, root.width * 0.214, (rot + start - 15) * radian, (-90 + start - 15) * radian, false);
            ctx.lineWidth = root.width * 0.22;
            ctx.strokeStyle = colorctx;
            ctx.stroke();
        }
    }

    Rectangle {
        id: circlePulse

        z: 2
        visible: !displayAmbient
        antialiasing: true
        x: root.width / 2 - width / 2
        y: root.height / 2 - width / 2
        color: Qt.rgba(1, 1, 1, 1)
        width: root.width * 0.5
        height: root.height * 0.5
        radius: width * 0.5
        state: currentColor

        Behavior on width {
            NumberAnimation {
                easing.type: Easing.OutExpo
                duration: 1000
            }

        }

        Behavior on height {
            NumberAnimation {
                easing.type: Easing.OutExpo
                duration: 1000
            }

        }

        states: State {
            name: "black"

            PropertyChanges {
                target: circlePulse
                color: Qt.rgba(0, 0, 0, 1)
            }

        }

        transitions: Transition {
            from: ""
            to: "black"
            reversible: true

            ColorAnimation {
                duration: 300
            }

        }

    }

    Rectangle {
        id: circleDoubleClickCover

        property int toggle: 1

        z: 3
        antialiasing: true
        x: root.width / 2 - width / 2
        y: root.height / 2 - width / 2
        color: "white"
        width: root.width * 0.5
        height: root.height * 0.5
        radius: width * 0.5
        state: currentColor

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: {
                if (circleDoubleClickCover.toggle === 1) {
                    currentColor = "";
                    secondCanvas.colorctx = Qt.rgba(1, 1, 1, 0.6);
                    secondCanvas.requestPaint();
                    circleDoubleClickCover.toggle = 0;
                } else {
                    currentColor = "black";
                    secondCanvas.colorctx = Qt.rgba(0, 0, 0, 0.6);
                    secondCanvas.requestPaint();
                    circleDoubleClickCover.toggle = 1;
                }
                growShrink();
            }
        }

        states: State {
            name: "black"

            PropertyChanges {
                target: circleDoubleClickCover
                color: "black"
            }

        }

        transitions: Transition {
            from: ""
            to: "black"
            reversible: true

            ColorAnimation {
                duration: 300
            }

        }

    }

    Rectangle {
        id: minuteCircle

        property real rotM: (wallClock.time.getMinutes() - 15) / 60
        property real centerX: root.width / 2 - width / 2
        property real centerY: root.height / 2 - height / 2

        z: 4
        antialiasing: true
        x: centerX + Math.cos(rotM * 2 * Math.PI) * root.width * 0.3
        y: centerY + Math.sin(rotM * 2 * Math.PI) * root.width * 0.3
        color: "white"
        width: root.width * 0.24
        height: root.height * 0.24
        radius: width * 0.5
        state: currentColor

        Behavior on x {
            NumberAnimation {
                easing.type: Easing.OutExpo
                duration: 300
            }

        }

        Behavior on y {
            NumberAnimation {
                easing.type: Easing.OutExpo
                duration: 300
            }

        }

        states: State {
            name: "black"

            PropertyChanges {
                target: minuteCircle
                color: "black"
            }

        }

        transitions: Transition {
            from: ""
            to: "black"
            reversible: true

            ColorAnimation {
                duration: 300
            }

        }

    }

    Text {
        id: minuteDisplay

        property real rotM: (wallClock.time.getMinutes() - 15) / 60
        property real centerX: root.width / 2 - width / 2
        property real centerY: root.height / 2 - height / 2

        z: 5
        font.pixelSize: root.height / 7.4
        font.family: "SourceSansPro"
        font.styleName: "Regular"
        color: "black"
        x: centerX + Math.cos(rotM * 2 * Math.PI) * root.width * 0.3
        y: centerY + Math.sin(rotM * 2 * Math.PI) * root.width * 0.3
        text: wallClock.time.toLocaleString(Qt.locale(), "mm")
        state: currentColor

        Behavior on text {
            SequentialAnimation {
                NumberAnimation {
                    target: minuteDisplay
                    property: "opacity"
                    to: 0
                    duration: 100
                }

                PropertyAction {
                }

                NumberAnimation {
                    target: minuteDisplay
                    property: "opacity"
                    to: 1
                    duration: 100
                }

            }

        }

        Behavior on x {
            NumberAnimation {
                easing.type: Easing.OutExpo
                duration: 300
            }

        }

        Behavior on y {
            NumberAnimation {
                easing.type: Easing.OutExpo
                duration: 300
            }

        }

        states: State {
            name: "black"

            PropertyChanges {
                target: minuteDisplay
                color: "white"
            }

        }

        transitions: Transition {
            from: ""
            to: "black"
            reversible: true

            ColorAnimation {
                duration: 300
            }

        }

    }

    Text {
        id: hourDisplay

        z: 6
        font.pixelSize: root.height * 0.36
        font.family: "SourceSansPro"
        font.styleName: "Semibold"
        font.letterSpacing: -root.height * 0.026
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "black"
        text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) : wallClock.time.toLocaleString(Qt.locale(), "HH")
        state: currentColor

        anchors {
            horizontalCenter: root.horizontalCenter
            verticalCenter: root.verticalCenter
            horizontalCenterOffset: -root.width * 0.001
            verticalCenterOffset: root.width * 0.0015
        }

        Behavior on text {
            SequentialAnimation {
                NumberAnimation {
                    target: hourDisplay
                    property: "opacity"
                    to: 0
                    duration: 100
                }

                PropertyAction {
                }

                NumberAnimation {
                    target: hourDisplay
                    property: "opacity"
                    to: 1
                    duration: 100
                }

            }

        }

        states: State {
            name: "black"

            PropertyChanges {
                target: hourDisplay
                color: "white"
            }

        }

        transitions: Transition {
            from: ""
            to: "black"
            reversible: true

            ColorAnimation {
                duration: 300
            }

        }

    }

    Connections {
        function onDisplayAmbientEntered() {
            if (currentColor === "black") {
                currentColor = "";
                userColor = "black";
            } else {
                userColor = "";
            }
            growShrink();
        }

        function onDisplayAmbientLeft() {
            if (userColor === "black")
                currentColor = "black";
            else
                currentColor = "";
            growShrink();
        }

        target: compositor
    }

    Connections {
        function onTimeChanged() {
            var second = wallClock.time.getSeconds();
            var minute = wallClock.time.getMinutes();
            circlePulse.width = (second % 2) ? root.width * 0.5 : root.width * 0.65;
            circlePulse.height = (second % 2) ? root.height * 0.5 : root.height * 0.65;
            if (secondCanvas.second !== second) {
                secondCanvas.second = second;
                secondCanvas.minute = minute;
                secondCanvas.requestPaint();
            }
        }

        target: wallClock
    }

}
