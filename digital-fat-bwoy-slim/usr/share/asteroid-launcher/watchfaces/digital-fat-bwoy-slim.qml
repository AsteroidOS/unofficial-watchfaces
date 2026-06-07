// SPDX-FileCopyrightText: 2023 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: LGPL-2.1-or-later

import Qt5Compat.GraphicalEffects
// QtQuick must precede Qt5Compat.GraphicalEffects when LinearGradient is used —
// GraphicalEffects types inherit from QtQuick.Item and require it to be loaded first.
import QtQuick

Item {
    id: root

    property string imgPath: "../watchfaces-img/digital-fat-bwoy-slim-"
    property bool hourLeadingOne: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 1) === "1" : wallClock.time.toLocaleString(Qt.locale(), "HH").slice(0, 1) === "1"
    property bool hourEndingOne: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(1, 2) === "1" : wallClock.time.toLocaleString(Qt.locale(), "HH").slice(1, 2) === "1"
    property bool minuteLeadingOne: wallClock.time.toLocaleString(Qt.locale(), "mm").slice(0, 1) === "1"
    property bool minuteEndingOne: wallClock.time.toLocaleString(Qt.locale(), "mm").slice(1, 2) === "1"
    property real maxSize: Math.min(parent.width, parent.height)

    anchors.fill: parent

    Text {
        id: dowDisplay

        z: 0
        renderType: Text.NativeRendering
        visible: !displayAmbient
        color: "#ccffffff"
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "dddd").toUpperCase()
        layer.enabled: true

        font {
            pixelSize: root.maxSize * 0.08
            family: "Outfit"
            styleName: "ExtraLight"
            letterSpacing: -root.maxSize * 0.001
        }

        anchors {
            bottom: root.verticalCenter
            bottomMargin: root.maxSize * 0.286
            horizontalCenter: root.horizontalCenter
        }

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 5
            samples: 6
            color: "#bb000000"
        }

    }

    Text {
        id: apDisplay

        z: 4
        renderType: Text.NativeRendering
        visible: use12H.value
        style: Text.Outline
        styleColor: "#ddffffff"
        color: "#22ffffff"
        text: wallClock.time.toLocaleString(Qt.locale(), "ap").toUpperCase()
        layer.enabled: true

        font {
            pixelSize: root.maxSize * 0.08
            family: "NASDAQER"
            styleName: "Bold"
            letterSpacing: root.maxSize * 0.0002
        }

        anchors {
            left: topRight.right
            leftMargin: hourEndingOne ? -root.maxSize * 0.096 : root.maxSize * 0.02
            bottom: topRight.bottom
            bottomMargin: root.maxSize * 0.038
        }

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 5
            samples: 6
            color: "#bb000000"
        }

    }

    Image {
        id: topLeft

        z: 1
        visible: false
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(root.maxSize * 0.36, root.maxSize * 0.36)
        source: use12H.value ? imgPath + wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 1) + ".svg" : imgPath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(0, 1) + ".svg"

        anchors {
            right: parent.horizontalCenter
            rightMargin: hourLeadingOne ? root.maxSize * 0.094 : root.maxSize * 0.004
            bottom: parent.verticalCenter
            bottomMargin: -root.maxSize * 0.084
        }

    }

    Image {
        id: topRight

        z: 2
        visible: false
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(root.maxSize * 0.36, root.maxSize * 0.36)
        source: use12H.value ? imgPath + wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(1, 2) + ".svg" : imgPath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(1, 2) + ".svg"

        anchors {
            left: topLeft.right
            leftMargin: hourLeadingOne ? hourEndingOne ? -root.maxSize * 0.14 : -root.maxSize * 0.092 : hourEndingOne ? -root.maxSize * 0.094 : -root.maxSize * 0.064
            bottom: topLeft.bottom
        }

    }

    Image {
        id: bottomLeft

        z: 3
        visible: false
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(root.maxSize * 0.24, root.maxSize * 0.24)
        source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(0, 1) + ".svg"

        anchors {
            right: parent.horizontalCenter
            rightMargin: minuteLeadingOne ? -root.maxSize * 0.164 : -root.maxSize * 0.172
            top: parent.verticalCenter
            topMargin: root.maxSize * 0.032
        }

    }

    Image {
        id: bottomRight

        z: 4
        visible: false
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(root.maxSize * 0.24, root.maxSize * 0.24)
        source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(1, 2) + ".svg"

        anchors {
            left: bottomLeft.right
            leftMargin: minuteLeadingOne ? -root.maxSize * 0.065 : minuteEndingOne ? -root.maxSize * 0.062 : -root.maxSize * 0.04
            bottom: bottomLeft.bottom
        }

    }

    OpacityMask {
        anchors.fill: topLeft
        source: pinkColor
        maskSource: topLeft
        opacity: 0.85
        layer.enabled: true

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 3
            verticalOffset: 3
            radius: 10
            samples: 12
            color: "#bb000000"
        }

    }

    OpacityMask {
        anchors.fill: topRight
        source: pinkColor
        maskSource: topRight
        opacity: 0.85
        layer.enabled: true

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 3
            verticalOffset: 3
            radius: 10
            samples: 12
            color: "#bb000000"
        }

    }

    OpacityMask {
        anchors.fill: bottomLeft
        source: blueColor
        maskSource: bottomLeft
        opacity: 0.85
        layer.enabled: true

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 3
            verticalOffset: 3
            radius: 10
            samples: 12
            color: "#bb000000"
        }

    }

    OpacityMask {
        anchors.fill: bottomRight
        source: blueColor
        maskSource: bottomRight
        opacity: 0.85
        layer.enabled: true

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 3
            verticalOffset: 3
            radius: 10
            samples: 12
            color: "#bb000000"
        }

    }

    LinearGradient {
        id: blueColor

        anchors.fill: parent
        visible: false
        start: Qt.point(800, 0)
        end: Qt.point(0, 0)

        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#96ffFF"
            }

            GradientStop {
                position: 0.6
                color: "#51D6FF"
            }

        }

    }

    LinearGradient {
        id: pinkColor

        anchors.fill: parent
        visible: false
        start: Qt.point(800, 0)
        end: Qt.point(0, 0)

        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#FFefFF"
            }

            GradientStop {
                position: 0.6
                color: "#F9B9F2"
            }

        }

    }

    Text {
        id: dayDisplay

        z: 0
        renderType: Text.NativeRendering
        visible: !displayAmbient
        color: "#ccffffff"
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "dd").toUpperCase()
        layer.enabled: true

        font {
            pixelSize: root.maxSize * 0.2
            family: "Outfit"
            styleName: "ExtraLight"
            letterSpacing: -root.maxSize * 0.008
        }

        anchors {
            top: root.verticalCenter
            topMargin: root.maxSize * 0.06
            right: root.horizontalCenter
            rightMargin: root.maxSize * 0.112
        }

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 5
            samples: 6
            color: "#bb000000"
        }

    }

    Text {
        id: monthDisplay

        z: 0
        renderType: Text.NativeRendering
        visible: !displayAmbient
        font.pixelSize: root.maxSize * 0.08
        font.letterSpacing: -root.maxSize * 0.001
        font.family: "Outfit"
        font.styleName: "ExtraLight"
        color: "#ccffffff"
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "MMMM").toUpperCase()
        layer.enabled: true

        anchors {
            top: root.verticalCenter
            topMargin: root.maxSize * 0.286
            horizontalCenter: root.horizontalCenter
        }

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 5
            samples: 6
            color: "#bb000000"
        }

    }

}
