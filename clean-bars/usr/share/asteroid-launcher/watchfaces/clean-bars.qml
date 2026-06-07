// SPDX-FileCopyrightText: 2018 Timo Könnecke <github.com/moWerk>
// SPDX-FileCopyrightText: 2016 Sylvia van Os <iamsylvie@openmailbox.org>
// SPDX-FileCopyrightText: 2015 Florent Revest <revestflo@gmail.com>
// SPDX-FileCopyrightText: 2012 Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
// SPDX-FileCopyrightText: 2012 Aleksey Mikhailichenko <a.v.mich@gmail.com>
// SPDX-FileCopyrightText: 2012 Arto Jalkanen <ajalkane@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick

Item {
    id: root

    property real maxSize: Math.min(width, height)
    readonly property real barY: maxSize / 2
    readonly property real barH: maxSize * 0.2
    readonly property real barWidth: maxSize * (0.7 / 3)
    readonly property real lineH: maxSize * 0.008

    anchors.fill: parent

    Item {
        id: faceBox

        width: root.maxSize
        height: root.maxSize
        anchors.centerIn: parent

        // ── Static dark background band ───────────────────────────────────────────
        Rectangle {
            y: root.barY - root.barH
            width: parent.width
            height: root.barH
            color: Qt.rgba(0, 0, 0, 0.5)
        }

        // ── Hour bar ──────────────────────────────────────────────────────────────
        Rectangle {
            id: hourFill

            x: parent.width * (1.3 / 12)
            y: root.barY
            width: root.barWidth
            height: wallClock.time.getHours() / 24 * root.barH
            color: Qt.rgba(1, 0, 0, 0.6)
        }

        Rectangle {
            x: hourFill.x
            y: root.barY + hourFill.height - root.lineH
            width: root.barWidth
            height: root.lineH
            color: Qt.rgba(1, 0, 0, 1)
        }

        // ── Minute bar ────────────────────────────────────────────────────────────
        Rectangle {
            id: minuteFill

            x: parent.width * (2.3 / 6)
            y: root.barY
            width: root.barWidth
            height: wallClock.time.getMinutes() / 60 * root.barH
            color: Qt.rgba(1, 1, 0, 0.6)
        }

        Rectangle {
            x: minuteFill.x
            y: root.barY + minuteFill.height - root.lineH
            width: root.barWidth
            height: root.lineH
            color: Qt.rgba(1, 1, 0, 1)
        }

        // ── Second bar ────────────────────────────────────────────────────────────
        Rectangle {
            id: secondFill

            x: parent.width * (4 / 6.5) * 1.07
            y: root.barY
            width: root.barWidth
            height: wallClock.time.getSeconds() / 60 * root.barH
            color: Qt.rgba(0, 1, 1, 0.6)
        }

        Rectangle {
            x: secondFill.x
            y: root.barY + secondFill.height - root.lineH
            width: root.barWidth
            height: root.lineH
            color: Qt.rgba(0, 1, 1, 1)
        }

        // ── Text ──────────────────────────────────────────────────────────────────
        Text {
            id: hourDisplay

            renderType: Text.NativeRendering
            font.pixelSize: parent.height * 0.2
            font.family: "CPMono_v07"
            font.styleName: "Bold"
            color: Qt.rgba(1, 1, 1, 1)
            horizontalAlignment: Text.AlignHCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: -parent.height * 0.029
            x: parent.width / 4.5 - width / 2
            text: use12H.value ? wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) : wallClock.time.toLocaleString(Qt.locale(), "HH")
        }

        Text {
            id: minuteDisplay

            renderType: Text.NativeRendering
            font.pixelSize: parent.height * 0.2
            font.family: "CPMono_v07"
            font.styleName: "Plain"
            color: Qt.rgba(1, 1, 1, 1)
            horizontalAlignment: Text.AlignHCenter
            text: wallClock.time.toLocaleString(Qt.locale(), "mm")

            anchors {
                bottom: parent.verticalCenter
                bottomMargin: -parent.height * 0.029
                horizontalCenter: parent.horizontalCenter
            }

        }

        Text {
            id: secondDisplay

            renderType: Text.NativeRendering
            font.pixelSize: parent.height * 0.2
            font.family: "CPMono_v07"
            font.styleName: "Light"
            color: Qt.rgba(1, 1, 1, 1)
            horizontalAlignment: Text.AlignHCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: -parent.height * 0.029
            x: parent.width / 6.5 * 5 - width / 2
            text: wallClock.time.toLocaleString(Qt.locale(), "ss")
        }

    }

}
