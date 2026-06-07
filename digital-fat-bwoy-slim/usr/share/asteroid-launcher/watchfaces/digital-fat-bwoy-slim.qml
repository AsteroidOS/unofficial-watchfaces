// SPDX-FileCopyrightText: 2023 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtGraphicalEffects 1.12
import QtQuick 2.9

Item {
    id: root

    property string imgPath: "../watchfaces-img/digital-fat-bwoy-slim-"
    property bool hourLeadingOne: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 1) === "1" : wallClock.time.toLocaleString(Qt.locale(), "HH").slice(0, 1) === "1"
    property bool hourEndingOne: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(1, 2) === "1" : wallClock.time.toLocaleString(Qt.locale(), "HH").slice(1, 2) === "1"
    property bool minuteLeadingOne: wallClock.time.toLocaleString(Qt.locale(), "mm").slice(0, 1) === "1"
    property bool minuteEndingOne: wallClock.time.toLocaleString(Qt.locale(), "mm").slice(1, 2) === "1"

    anchors.centerIn: parent
    width: parent.width
    height: parent.height

    Text {
        id: dowDisplay

        z: 0
        renderType: Text.NativeRendering
        visible: !displayAmbient
        font.pixelSize: root.height * 0.08
        font.family: "Outfit"
        font.styleName: "ExtraLight"
        font.letterSpacing: -root.height * 0.001
        color: "#ccffffff"
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "dddd").toUpperCase()
        layer.enabled: true

        anchors {
            bottom: root.verticalCenter
            bottomMargin: root.height * 0.286
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
        font.pixelSize: root.height * 0.08
        font.family: "NASDAQER"
        font.styleName: "Bold"
        style: Text.Outline
        styleColor: "#ddffffff"
        font.letterSpacing: root.height * 0.0002
        color: "#22ffffff"
        text: wallClock.time.toLocaleString(Qt.locale(), "ap").toUpperCase()
        layer.enabled: true

        anchors {
            left: topRight.right
            leftMargin: hourEndingOne ? -parent.width * 0.096 : parent.width * 0.02
            bottom: topRight.bottom
            bottomMargin: parent.width * 0.038
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
        sourceSize: Qt.size(parent.width * 0.36, parent.height * 0.36)
        source: use12H.value ? imgPath + wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 1) + ".svg" : imgPath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(0, 1) + ".svg"

        anchors {
            right: parent.horizontalCenter
            rightMargin: hourLeadingOne ? parent.width * 0.094 : parent.width * 0.004
            bottom: parent.verticalCenter
            bottomMargin: -parent.width * 0.084
        }

    }

    Image {
        id: topRight

        z: 2
        visible: false
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(parent.width * 0.36, parent.height * 0.36)
        source: use12H.value ? imgPath + wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(1, 2) + ".svg" : imgPath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(1, 2) + ".svg"

        anchors {
            left: topLeft.right
            leftMargin: hourLeadingOne ? hourEndingOne ? -parent.width * 0.14 : -parent.width * 0.092 : hourEndingOne ? -parent.width * 0.094 : -parent.width * 0.064
            bottom: topLeft.bottom
        }

    }

    Image {
        id: bottomLeft

        z: 3
        visible: false
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(parent.width * 0.24, parent.height * 0.24)
        source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(0, 1) + ".svg"

        anchors {
            right: parent.horizontalCenter
            rightMargin: minuteLeadingOne ? -parent.width * 0.164 : -parent.width * 0.172
            top: parent.verticalCenter
            topMargin: parent.width * 0.032
        }

    }

    Image {
        id: bottomRight

        z: 4
        visible: false
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(parent.width * 0.24, parent.height * 0.24)
        source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(1, 2) + ".svg"

        anchors {
            left: bottomLeft.right
            leftMargin: minuteLeadingOne ? -parent.width * 0.065 : minuteEndingOne ? -parent.width * 0.062 : -parent.width * 0.04
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
        font.pixelSize: root.height * 0.2
        font.family: "Outfit"
        font.styleName: "ExtraLight"
        font.letterSpacing: -root.height * 0.008
        color: "#ccffffff"
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "dd").toUpperCase()
        layer.enabled: true

        anchors {
            top: root.verticalCenter
            topMargin: root.height * 0.06
            right: root.horizontalCenter
            rightMargin: root.height * 0.112
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
        font.pixelSize: root.height * 0.08
        font.letterSpacing: -root.height * 0.001
        font.family: "Outfit"
        font.styleName: "ExtraLight"
        color: "#ccffffff"
        horizontalAlignment: Text.AlignHCenter
        text: wallClock.time.toLocaleString(Qt.locale(), "MMMM").toUpperCase()
        layer.enabled: true

        anchors {
            top: root.verticalCenter
            topMargin: root.height * 0.286
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
