// SPDX-FileCopyrightText: 2021 Timo Könnecke <github.com/moWerk>
// SPDX-License-Identifier: LGPL-2.1-or-later

import Qt5Compat.GraphicalEffects
import QtQuick

Item {
    id: root

    property string currentHour: ''
    property string hourColor: ''
    property var neonColor: ["#99FF00E3", "#993500FF", "#9901FE01", "#99FFFE37", "#99FF8600", "#99ED0003", "#9900ffff", "#9938FF12", "#99007FFF", "#99FAAB00"]
    property string imgPath: "../watchfaces-img/analog-words-80s-"

    Component.onCompleted: {
        root.currentHour = wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2);
        root.hourColor = Math.floor(Math.random() * neonColor.length);
    }

    Image {
        id: backplate

        z: 0
        source: imgPath + "backplate.svg"
        opacity: displayAmbient ? 0.3 : 0.5
        anchors.centerIn: root
        width: root.width
        height: root.height
    }

    Image {
        id: hourOverlay

        z: 1
        source: imgPath + wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) + ".svg"
        anchors.centerIn: root
        width: root.width
        height: root.height
        layer.enabled: true

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 14
            samples: 9
            color: neonColor[hourColor]
        }

    }

    Image {
        id: hourSVG

        z: 0
        source: imgPath + "hour.svg"
        anchors.centerIn: root
        width: root.width
        height: root.height
        layer.enabled: true

        transform: Rotation {
            origin.x: root.width / 2
            origin.y: root.height / 2
            angle: (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * 0.5)
        }

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 1
            verticalOffset: 1
            radius: 8
            samples: 9
            color: neonColor[hourColor]
        }

    }

    Image {
        id: minuteSVG

        z: 3
        source: imgPath + "minute.svg"
        width: root.width
        height: root.height
        layer.enabled: true

        anchors {
            centerIn: root
        }

        transform: Rotation {
            origin.x: root.width / 2
            origin.y: root.height / 2
            angle: (wallClock.time.getMinutes() * 6) + (wallClock.time.getSeconds() * 6 / 60)
        }

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 2
            radius: 8
            samples: 10
            color: neonColor[hourColor]
        }

    }

    Image {
        id: secondSVG

        z: 4
        visible: !displayAmbient
        source: imgPath + "second.svg"
        width: root.width
        height: root.height
        layer.enabled: true

        anchors {
            centerIn: root
        }

        transform: Rotation {
            origin.x: root.width / 2
            origin.y: root.height / 2
            angle: (wallClock.time.getSeconds() * 6)
        }

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 6
            verticalOffset: 6
            radius: 5
            samples: 8
            color: "#66000000"
        }

    }

    Connections {
        function onTimeChanged() {
            if (!visible)
                return ;

            var h = wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2);
            if (root.currentHour !== h) {
                root.currentHour = h;
                root.hourColor = Math.floor(Math.random() * neonColor.length);
            }
        }

        target: wallClock
    }

}
