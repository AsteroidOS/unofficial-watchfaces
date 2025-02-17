/*
  based on 'Amazfit Ranger V2.wfz'
  author Lawrnz
  designer Osmat
  converted with amazteroid.js
  */
import QtQuick 2.9

Item {
    id: root
    property string imgPath: "../watchfaces-img/"
    property double xmul: root.width / 320
    property double ymul: root.height / 320

    Image {
        z: 0
        id: background
        source: imgPath + "amazfit-ranger-v2-background-00.png"
        opacity: displayAmbient ? 0.1 : 1
        anchors {
            centerIn: root
        }
        width: root.width
        height: root.height
    }

    Item {
        id: timehand
        z: 10
        x: 0 * xmul
        y: 0 * ymul
        width: 320 * xmul
        height: 320 * ymul

        Image {
            id: hourPng
            z: 0
            source: imgPath + "amazfit-ranger-v2-timehand-00-hour.png"
            anchors {
                centerIn: timehand
            }
            width: timehand.width
            height: timehand.height
            fillMode: Image.PreserveAspectFit
            transform: Rotation {
                origin.x: timehand.width / 2
                origin.y: timehand.height / 2
                angle: (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * 0.5)
            }
        }

        Image {
            id: minutePng
            z: 1
            source: imgPath + "amazfit-ranger-v2-timehand-00-minute.png"
            anchors {
                centerIn: timehand
            }
            width: timehand.width
            height: timehand.height
            fillMode: Image.PreserveAspectFit
            transform: Rotation {
                origin.x: timehand.width / 2
                origin.y: timehand.height / 2
                angle: (wallClock.time.getMinutes() * 6) + (wallClock.time.getSeconds() * 6 / 60)
            }
        }

        Image {
            id: secondPng
            z: 2
            visible: !displayAmbient
            source: imgPath + "amazfit-ranger-v2-timehand-00-seconds.png"
            anchors {
                centerIn: timehand
            }
            width: timehand.width
            height: timehand.height
            fillMode: Image.PreserveAspectFit
            transform: Rotation {
                origin.x: timehand.width / 2
                origin.y: timehand.height / 2
                angle: (wallClock.time.getSeconds() * 6)
            }
        }
    }

    Image {
        id: timedigital
    }

    Image {
        id: datawidget_10_4
    }

    Image {
        id: datawidget_8_4
    }

    Image {
        id: datawidget_1_4
    }

    Image {
        id: datawidget_6_2
    }

    Image {
        id: datawidget_6_1
    }
}
