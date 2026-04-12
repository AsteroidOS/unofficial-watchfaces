/*
 * Copyright (C) 2026 - Timo Könnecke <github.com/moWerk>
 *               2018 - Timo Könnecke <el-t-mo@arcor.de>
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

import QtQuick 2.1

Item {
    id: root

    // ── Shared geometry ───────────────────────────────────────────────────────
    readonly property real barY: parent.height / 2
    readonly property real barH: parent.height * 0.2
    readonly property real barWidth: parent.width * (0.7 / 3)
    readonly property real lineH: parent.width * 0.008

    // ── Static dark background band ───────────────────────────────────────────
    Rectangle {
        x: 0
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

        z: 6
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

        z: 6
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

        z: 6
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
