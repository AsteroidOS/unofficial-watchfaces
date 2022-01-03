/*
 * Copyright (C) 2021 - Timo Könnecke <github.com/eLtMosen>
 *
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
import QtGraphicalEffects 1.15

Item {
    id: root

    anchors.fill: parent
    
    property int topbottomMargin: root.height * .02
    property int leftrightMargin: root.height * .001
    property int verticalDateOffset: root.width * .006
    property int verticalFontOffset: -root.width * .43
    property int horizontalDateOffset: -root.width * .032
    property int horizontalFontOffset: -root.height * .504
    property var numeralSize: Qt.size(root.width * .7, root.height * .7)
    property string imagePath: "../watchfaces-img/digital-random-color-pop-"
    property var colorSchemes: [
        ["#230007", "#A40606", "#D7CF07", "#D98324"], ["#264653", "#2A9D8F", "#E9C46A", "#F4A261"],
        ["#564138", "#2E86AB", "#F6F5AE", "#F1F514"], ["#C84630", "#D4A0A7", "#E3E3E3", "#898989"],
        ["#32292F", "#575366", "#6E7DAB", "#5762D5"], ["#7D7ABC", "#6457A6", "#23F0C7", "#EF767A"],
        ["#FF773D", "#F19143", "#FFB238", "#FABC3C"], ["#361134", "#B0228C", "#EA3788", "#E56B70"],
        ["#D91E36", "#DA344D", "#EC5766", "#EF7674"], ["#00916E", "#EE6123", "#FEEFE5", "#FFCF00"],
        ["#995D81", "#EB8258", "#F6F740", "#D8DC6A"], ["#466060", "#57886C", "#81A684", "#F8C7CC"],
        ["#815E5B", "#685155", "#7A6F9B", "#8B85C1"], ["#252627", "#BB0A21", "#D3D4D9", "#4B88A2"],
        ["#CA7DF9", "#F896D8", "#EDF67D", "#724CF9"], ["#3D3522", "#4A442D", "#386150", "#58B09C"],
        ["#CB769E", "#ADBCA5", "#E8B9AB", "#E09891"], ["#4E4187", "#3083DC", "#F8FFE5", "#7DDE92"],
        ["#01161E", "#124559", "#598392", "#AEC3B0"], ["#922D50", "#95AFBA", "#B8C480", "#D4E79E"],
        ["#1A1423", "#3D314A", "#684756", "#96705B"], ["#04E762", "#008BF8", "#DC0073", "#F5B700"],
        ["#D0B17A", "#A89F68", "#F5FDC6", "#F5C396"], ["#2C363F", "#E75A7C", "#F2F5EA", "#D6DBD2"],
        ["#3C493F", "#7E8D85", "#F0F7F4", "#B3BFB8"], ["#8B1E3F", "#3C153B", "#89BD9E", "#F0C987"],
        ["#2E4057", "#048BA8", "#F18F01", "#99C24D"], ["#9EE37D", "#63C132", "#CFFCFF", "#AAEFDF"],
        ["#5BC0EB", "#9BC53D", "#C3423F", "#FDE74C"], ["#F08080", "#F4978E", "#F8AD9D", "#FBC4AB"],
        ["#170312", "#33032F", "#A0ACAD", "#531253"], ["#1B9AAA", "#EF476F", "#F8FFE5", "#06D6A0"],
        ["#FFC4D1", "#EFAAC4", "#6B717E", "#FFE8E1"], ["#C49792", "#AD91A3", "#FE938C", "#EDAF97"],
        ["#F7F7FF", "#C49991", "#279AF1", "#60656F"], ["#EF3E36", "#17BEBB", "#2E282A", "#EDB88B"],
        ["#481620", "#0075A2", "#00FFC5", "#ADF5FF"], ["#CEC2FF", "#B3B3F1", "#DCB6D5", "#CF8BA9"],
        ["#E89005", "#EC7505", "#D84A05", "#F42B03"], ["#3F7CAC", "#95AFBA", "#BDC4A7", "#D5E1A3"],
        ["#FCAA67", "#B0413E", "#FFFFC7", "#548687"], ["#F2F3AE", "#EDD382", "#FC9E4F", "#FF521B"],
        ["#FFAFF0", "#F092DD", "#392F5A", "#EEC8E0"], ["#5D4E60", "#826C7F", "#A88FAC", "#D4B2D8"],
        ["#638475", "#90E39A", "#DDF093", "#F6D0B1"], ["#2F4858", "#33658A", "#F6AE2D", "#55DDE0"],
        ["#18261F", "#A22C29", "#747158", "#9D9F7F"], ["#0A1045", "#00C2D1", "#F9E900", "#F6AF65"],
        ["#EC9F05", "#D76A03", "#8EA604", "#F5BB00"], ["#0C1B33", "#7A306C", "#A49B79", "#03B5AA"],
        ["#073B3A", "#0B6E4F", "#08A045", "#6BBF59"], ["#587291", "#2F97C1", "#1CCAD8", "#15E6CD"],
        ["#C5283D", "#E9724C", "#FFC857", "#481D24"], ["#E8AA14", "#6EEB83", "#E4FF1A", "#1BE7FF"],
        ["#F433AB", "#CB04A5", "#934683", "#65334D"], ["#524632", "#8F7E4F", "#C3C49E", "#D8FFDD"],
        ["#2C2C54", "#846C5B", "#F15BB5", "#00B8F5"], ["#0D1B2A", "#1B263B", "#415A77", "#778DA9"],
        ["#CC444B", "#DA5552", "#DF7373", "#E39695"], ["#504136", "#A49E8D", "#689689", "#65CDA9"]
    ]
    property int randomScheme: Math.random() * colorSchemes.length
    property int previousScheme: 0

    Image {
        id: dayDisplayLeft

        z: 1
        opacity: .96
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width * .012 + verticalDateOffset
            horizontalCenterOffset: -parent.width * .232 + horizontalDateOffset
        }
        sourceSize: Qt.size(root.width * .22, root.height * .22)
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "dd").toUpperCase().slice(0, 1) + "-num.svg"
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 3.0
            samples: 7
            color: Qt.rgba(0, 0, 0, .6)
        }
    }

    Image {
        id: dayDisplayRight

        z: 3
        opacity: .96
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width * .012 + verticalDateOffset
            horizontalCenterOffset: -parent.width * .17 + horizontalDateOffset
        }
        sourceSize: Qt.size(root.width * .22, root.height * .22)
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "dd").toUpperCase().slice(1, 2) + "-num.svg"
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 3.0
            samples: 7
            color: Qt.rgba(0, 0, 0, .6)
        }
    }

    Image {
        id: monthDisplayLeft

        z: 5
        opacity: .88
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width * .114 + verticalDateOffset
            horizontalCenterOffset: -parent.width * .232 + horizontalDateOffset
        }
        sourceSize: Qt.size(root.width * .22, root.height * .22)
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "MM").toUpperCase().slice(0, 1) + "-num.svg"
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 3.0
            samples: 7
            color: Qt.rgba(0, 0, 0, .6)
        }
    }

    Image {
        id: monthDisplayRight

        z: 7
        opacity: .88
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width * .114 + verticalDateOffset
            horizontalCenterOffset: -parent.width * .17 + horizontalDateOffset
        }
        sourceSize: Qt.size(root.width * .22, root.height * .22)
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "MM").toUpperCase().slice(1, 2) + "-num.svg"
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 3.0
            samples: 7
            color: Qt.rgba(0, 0, 0, .6)
        }
    }

    Image {
        id: dayDisplayLeftTrail

        z: 0
        visible: false
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width * .012 + verticalDateOffset
            horizontalCenterOffset: -parent.width * .232 + horizontalDateOffset
        }
        sourceSize: Qt.size(root.width * .22, root.height * .22)
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "dd").toUpperCase().slice(0, 1) + "-trail.svg"
    }

    Image {
        id: dayDisplayRightTrail

        z: 2
        visible: false
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width * .012 + verticalDateOffset
            horizontalCenterOffset: -parent.width * .17 + horizontalDateOffset
        }
        sourceSize: Qt.size(root.width * .22, root.height * .22)
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "dd").toUpperCase().slice(1, 2) + "-trail.svg"
    }

    Image {
        id: monthDisplayLeftTrail

        z: 4
        visible: false
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width * .114 + verticalDateOffset
            horizontalCenterOffset: -parent.width * .232 + horizontalDateOffset
        }
        sourceSize: Qt.size(root.width * .22, root.height * .22)
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "MM").toUpperCase().slice(0, 1) + "-trail.svg"
    }

    Image {
        id: monthDisplayRightTrail

        z: 6
        visible: false
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.width * .114 + verticalDateOffset
            horizontalCenterOffset: -parent.width * .17 + horizontalDateOffset
        }
        sourceSize: Qt.size(root.width * .22, root.height * .22)
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "MM").toUpperCase().slice(1, 2) + "-trail.svg"
    }

    Image {
        id: topLeft

        z: 8
        anchors {
            bottom: root.verticalCenter
            bottomMargin: topbottomMargin + verticalFontOffset
            right: root.horizontalCenter
            rightMargin: leftrightMargin + horizontalFontOffset
        }
        sourceSize: numeralSize
        source: use12H.value ?
                    imagePath + wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 1) + "-num.svg" :
                    imagePath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(0, 1) + "-num.svg"

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 6.0
            samples: 13
            color: Qt.rgba(0, 0, 0, .6)
        }

        Behavior on source {
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { target: topLeft; property: "anchors.bottomMargin"; to: -parent.height + verticalFontOffset; duration: 1000; easing.type: Easing.InCubic }
                    NumberAnimation { target: topLeft; property: "anchors.rightMargin"; to: -parent.width + horizontalFontOffset; duration: 1000; easing.type: Easing.InCubic }
                }
                PropertyAction {}
                ParallelAnimation {
                    NumberAnimation { target: topLeft; property: "anchors.bottomMargin"; to: topbottomMargin + verticalFontOffset; duration: 1000; easing.type: Easing.OutCubic }
                    NumberAnimation { target: topLeft; property: "anchors.rightMargin"; to: leftrightMargin + horizontalFontOffset; duration: 1000; easing.type: Easing.OutCubic }
                }
            }
        }
    }

    Image {
        id: topRight

        z: 10
        anchors {
            bottom: root.verticalCenter
            bottomMargin: topbottomMargin + verticalFontOffset
            left: root.horizontalCenter
            leftMargin: leftrightMargin
        }
        sourceSize: numeralSize
        source: use12H.value ?
                    imagePath + wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(1, 2) + "-num.svg" :
                    imagePath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(1, 2) + "-num.svg"

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 6.0
            samples: 13
            color: Qt.rgba(0, 0, 0, .6)
        }

        Behavior on source {
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { target: topRight; property: "anchors.bottomMargin"; to: -parent.height + verticalFontOffset; duration: 1000; easing.type: Easing.InCubic }
                    NumberAnimation { target: topRight; property: "anchors.leftMargin"; to: parent.width; duration: 1000; easing.type: Easing.InCubic }
                }
                PropertyAction {}
                ParallelAnimation {
                    NumberAnimation { target: topRight; property: "anchors.bottomMargin"; to: topbottomMargin + verticalFontOffset; duration: 1000; easing.type: Easing.OutCubic }
                    NumberAnimation { target: topRight; property: "anchors.leftMargin"; to: leftrightMargin; duration: 1000; easing.type: Easing.OutCubic }
                }
            }
        }
    }

    Image {
        id: bottomLeft

        z: 12
        opacity: .9
        anchors {
            top: root.verticalCenter
            topMargin: topbottomMargin
            right: root.horizontalCenter
            rightMargin: leftrightMargin + horizontalFontOffset
        }
        sourceSize: numeralSize
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(0, 1) + "-num.svg"

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 6.0
            samples: 13
            color: Qt.rgba(0, 0, 0, .6)
        }

        Behavior on source {
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { target: bottomLeft; property: "anchors.topMargin"; to: parent.height; duration: 1000; easing.type: Easing.InCubic }
                    NumberAnimation { target: bottomLeft; property: "anchors.rightMargin"; to: -parent.width + horizontalFontOffset; duration: 1000; easing.type: Easing.InCubic }
                }
                PropertyAction {}
                ParallelAnimation {
                    NumberAnimation { target: bottomLeft; property: "anchors.topMargin"; to: topbottomMargin; duration: 1000; easing.type: Easing.OutCubic }
                    NumberAnimation { target: bottomLeft; property: "anchors.rightMargin"; to: leftrightMargin + horizontalFontOffset; duration: 1000; easing.type: Easing.OutCubic }
                }
            }
        }
    }

    Image {
        id: bottomRight

        z: 14
        opacity: .9
        anchors {
            top: root.verticalCenter
            topMargin: topbottomMargin
            left: root.horizontalCenter
            leftMargin: leftrightMargin
        }
        sourceSize: numeralSize
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(1, 2) + "-num.svg"

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 6.0
            samples: 13
            color: Qt.rgba(0, 0, 0, .6)
        }

        Behavior on source {
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { target: bottomRight; property: "anchors.topMargin"; to: parent.height; duration: 1000; easing.type: Easing.InCubic }
                    NumberAnimation { target: bottomRight; property: "anchors.leftMargin"; to: parent.width; duration: 1000; easing.type: Easing.InCubic }
                }
                PropertyAction {}
                ParallelAnimation {
                    NumberAnimation { target: bottomRight; property: "anchors.topMargin"; to: topbottomMargin; duration: 1000; easing.type: Easing.OutCubic }
                    NumberAnimation { target: bottomRight; property: "anchors.leftMargin"; to: leftrightMargin; duration: 1000; easing.type: Easing.OutCubic }
                }
            }
        }

        onSourceChanged: root.randomScheme = Math.random() * colorSchemes.length
    }

    Image {
        id: topLeftTrail

        z: 7
        visible: false
        anchors {
            bottom: root.verticalCenter
            bottomMargin: topbottomMargin + verticalFontOffset
            right: root.horizontalCenter
            rightMargin: leftrightMargin + horizontalFontOffset
        }
        sourceSize: numeralSize
        source: use12H.value ?
                    imagePath + wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 1) + "-trail.svg" :
                    imagePath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(0, 1) + "-trail.svg"

        Behavior on source {
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { target: topLeftTrail; property: "anchors.bottomMargin"; to: -parent.height + verticalFontOffset; duration: 1000; easing.type: Easing.InCubic }
                    NumberAnimation { target: topLeftTrail; property: "anchors.rightMargin"; to: - parent.width + horizontalFontOffset; duration: 1000; easing.type: Easing.InCubic }
                }
                PropertyAction {}
                ParallelAnimation {
                    NumberAnimation { target: topLeftTrail; property: "anchors.bottomMargin"; to: topbottomMargin + verticalFontOffset; duration: 1000; easing.type: Easing.OutCubic }
                    NumberAnimation { target: topLeftTrail; property: "anchors.rightMargin"; to: leftrightMargin + horizontalFontOffset; duration: 1000; easing.type: Easing.OutCubic }
                }
            }
        }
    }

    Image {
        id: topRightTrail

        z: 9
        visible: false
        anchors {
            bottom: root.verticalCenter
            bottomMargin: topbottomMargin + verticalFontOffset
            left: root.horizontalCenter
            leftMargin: leftrightMargin
        }
        sourceSize: numeralSize
        source: use12H.value ?
                    imagePath + wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(1, 2) + "-trail.svg" :
                    imagePath + wallClock.time.toLocaleString(Qt.locale(), "HH").slice(1, 2) + "-trail.svg"

        Behavior on source {
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { target: topRightTrail; property: "anchors.bottomMargin"; to: -parent.height + verticalFontOffset; duration: 1000; easing.type: Easing.InCubic }
                    NumberAnimation { target: topRightTrail; property: "anchors.leftMargin"; to: parent.width; duration: 1000; easing.type: Easing.InCubic }
                }
                PropertyAction {}
                ParallelAnimation {
                    NumberAnimation { target: topRightTrail; property: "anchors.bottomMargin"; to: topbottomMargin + verticalFontOffset; duration: 1000; easing.type: Easing.OutCubic }
                    NumberAnimation { target: topRightTrail; property: "anchors.leftMargin"; to: leftrightMargin; duration: 1000; easing.type: Easing.OutCubic }
                }
            }
        }
    }

    Image {
        id: bottomLeftTrail

        z: 11
        visible: false
        anchors {
            top: root.verticalCenter
            topMargin: topbottomMargin
            right: root.horizontalCenter
            rightMargin: leftrightMargin + horizontalFontOffset
        }
        sourceSize: numeralSize
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(0, 1) + "-trail.svg"

        Behavior on source {
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { target: bottomLeftTrail; property: "anchors.topMargin"; to: parent.height; duration: 1000; easing.type: Easing.InCubic }
                    NumberAnimation { target: bottomLeftTrail; property: "anchors.rightMargin"; to: - parent.width + horizontalFontOffset; duration: 1000; easing.type: Easing.InCubic }
                }
                PropertyAction {}
                ParallelAnimation {
                    NumberAnimation { target: bottomLeftTrail; property: "anchors.topMargin"; to: topbottomMargin; duration: 1000; easing.type: Easing.OutCubic }
                    NumberAnimation { target: bottomLeftTrail; property: "anchors.rightMargin"; to: leftrightMargin + horizontalFontOffset; duration: 1000; easing.type: Easing.OutCubic }
                }
            }
        }
    }

    Image {
        id: bottomRightTrail

        z: 13
        visible: false
        anchors {
            top: root.verticalCenter
            topMargin: topbottomMargin
            left: root.horizontalCenter
            leftMargin: leftrightMargin
        }
        sourceSize: numeralSize
        source: imagePath + wallClock.time.toLocaleString(Qt.locale(), "mm").slice(1, 2) + "-trail.svg"

        Behavior on source {
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { target: bottomRightTrail; property: "anchors.topMargin"; to: parent.height; duration: 1000; easing.type: Easing.InCubic }
                    NumberAnimation { target: bottomRightTrail; property: "anchors.leftMargin"; to: parent.width; duration: 1000; easing.type: Easing.InCubic }
                }
                PropertyAction {}
                ParallelAnimation {
                    NumberAnimation { target: bottomRightTrail; property: "anchors.topMargin"; to: topbottomMargin; duration: 1000; easing.type: Easing.OutCubic }
                    NumberAnimation { target: bottomRightTrail; property: "anchors.leftMargin"; to: leftrightMargin; duration: 1000; easing.type: Easing.OutCubic }
                }
            }
        }
    }

    Text {
        id: apDisplay

        z: 14
        anchors {
            centerIn: parent
            horizontalCenterOffset: -parent.width * 0.31
            verticalCenterOffset:  -parent.width * 0.15
        }
        renderType: Text.NativeRendering
        font {
            pixelSize: root.height*0.1
            family: "Noto Sans"
            styleName: "Condensed Light"
            letterSpacing: root.height*0.0002
        }
        opacity: .92
        color: "#ffffff"
        text: wallClock.time.toLocaleString(Qt.locale(), "ap").toUpperCase()

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 6.0
            samples: 13
            color: Qt.rgba(0, 0, 0, .8)
        }
    }

    Text {
        id: yearDisplay

        z: 14
        anchors {
            centerIn: parent
            horizontalCenterOffset: -parent.width * 0.31
            verticalCenterOffset: parent.width * 0.15
        }
        renderType: Text.NativeRendering
        font {
            pixelSize: root.height*0.116
            family: "Noto Sans"
            styleName: "SemiCondensed Light"
            letterSpacing: root.height*0.0002
        }
        opacity: .92
        color: "#ffffff"
        text: wallClock.time.toLocaleString(Qt.locale(), "yy").toUpperCase()

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 6.0
            samples: 13
            color: Qt.rgba(0, 0, 0, .8)
        }
    }

    LinearGradient {
        id: topLeftGradient

        anchors.fill: parent
        smooth: true
        visible: false
        start: Qt.point(parent.width * .24, parent.height * .24)
        end: Qt.point(parent.width * .7, parent.height * .7)
        gradient: Gradient {
            GradientStop { position: 0.0; color: colorSchemes[randomScheme][0]; Behavior on color { ColorAnimation { duration: 1800 } } }
            GradientStop { position: 1.0; color: "#00000000" }
        }
    }

    LinearGradient {
        id: topRightGradient

        anchors.fill: parent
        smooth: true
        visible: false
        start: Qt.point(parent.width * .24, parent.height * .24)
        end: Qt.point(parent.width * .8, parent.height * .8)
        gradient: Gradient {
            GradientStop { position: 0.0; color: colorSchemes[randomScheme][1]; Behavior on color { ColorAnimation { duration: 1800 } } }
            GradientStop { position: 1.0; color: "#00000000" }
        }
    }

    LinearGradient {
        id: bottomLeftGradient

        anchors.fill: parent
        smooth: true
        visible: false
        start: Qt.point(parent.width * .24, parent.height * .24)
        end: Qt.point(parent.width * .6, parent.height * .6)
        gradient: Gradient {
            GradientStop { position: 0.0; color: colorSchemes[randomScheme][2]; Behavior on color { ColorAnimation { duration: 1800 } } }
            GradientStop { position: 1.0; color: "#00000000" }
        }
    }

    LinearGradient {
        id: bottomRightGradient

        anchors.fill: parent
        smooth: true
        visible: false
        start: Qt.point(parent.width * .24, parent.height * .24)
        end: Qt.point(parent.width * .6, parent.height * .6)
        gradient: Gradient {
            GradientStop { position: 0.0; color: colorSchemes[randomScheme][3]; Behavior on color { ColorAnimation { duration: 1800 } } }
            GradientStop { position: 1.0; color: "#00000000" }
        }
    }

    LinearGradient {
        id: topLeftGradientDate

        anchors.fill: parent
        smooth: true
        visible: false
        start: Qt.point(parent.width * .24, parent.height * .24)
        end: Qt.point(parent.width, parent.height)
        gradient: Gradient {
            GradientStop { position: 0.0; color: colorSchemes[randomScheme][0]; Behavior on color { ColorAnimation { duration: 1800 } } }
            GradientStop { position: 1.0; color: "#00000000" }
        }
    }

    LinearGradient {
        id: topRightGradientDate

        anchors.fill: parent
        smooth: true
        visible: false
        start: Qt.point(parent.width * .24, parent.height * .24)
        end: Qt.point(parent.width, parent.height)
        gradient: Gradient {
            GradientStop { position: 0.0; color: colorSchemes[randomScheme][1]; Behavior on color { ColorAnimation { duration: 1800 } } }
            GradientStop { position: 1.0; color: "#00000000" }
        }
    }

    LinearGradient {
        id: bottomLeftGradientDate

        anchors.fill: parent
        smooth: true
        visible: false
        start: Qt.point(parent.width * .24, parent.height * .24)
        end: Qt.point(parent.width, parent.height)
        gradient: Gradient {
            GradientStop { position: 0.0; color: colorSchemes[randomScheme][2]; Behavior on color { ColorAnimation { duration: 1800 } } }
            GradientStop { position: 1.0; color: "#00000000" }
        }
    }

    LinearGradient {
        id: bottomRightGradientDate

        anchors.fill: parent
        smooth: true
        visible: false
        start: Qt.point(parent.width * .24, parent.height * .24)
        end: Qt.point(parent.width, parent.height)
        gradient: Gradient {
            GradientStop { position: 0.0; color: colorSchemes[randomScheme][3]; Behavior on color { ColorAnimation { duration: 1800 } } }
            GradientStop { position: 1.0; color: "#00000000" }
        }
    }

    OpacityMask {
        anchors.fill: topLeftTrail
        source: topLeftGradient
        maskSource: topLeftTrail
    }

    OpacityMask {
        anchors.fill: topRightTrail
        source: topRightGradient
        maskSource: topRightTrail
    }

    OpacityMask {
        anchors.fill: bottomLeftTrail
        source: bottomLeftGradient
        maskSource: bottomLeftTrail
    }

    OpacityMask {
        anchors.fill: bottomRightTrail
        source: bottomRightGradient
        maskSource: bottomRightTrail
    }

    OpacityMask {
        opacity: 0.6
        anchors.fill: dayDisplayLeftTrail
        source: bottomLeftGradientDate
        maskSource: dayDisplayLeftTrail
    }

    OpacityMask {
        opacity: 0.6
        anchors.fill: dayDisplayRightTrail
        source: bottomRightGradientDate
        maskSource: dayDisplayRightTrail
    }

    OpacityMask {
        opacity: 0.6
        anchors.fill: monthDisplayLeftTrail
        source: topLeftGradientDate
        maskSource: monthDisplayLeftTrail
    }

    OpacityMask {
        opacity: 0.6
        anchors.fill: monthDisplayRightTrail
        source: topRightGradientDate
        maskSource: monthDisplayRightTrail
    }

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 0
        radius: 15.0
        samples: 31
        color: Qt.rgba(0, 0, 0, .3)
    }
}
