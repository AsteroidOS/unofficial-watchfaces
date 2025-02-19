/*
  based on 'CASIO.wfz'
  author wangjie
  designer wangjie
  converted with amazteroid.js
  */
import QtQuick 2.9

Item {
    id: root
    property string imgPath: "../watchfaces-img/"
    property double xmul: width / 320
    property double ymul: height / 320

    Image {
        z: 0
        id: background
        source: imgPath + "casio-background-01.png"
        opacity: displayAmbient ? 0.1 : 1
        anchors {
            centerIn: parent
        }
        width: parent.width
        height: parent.height
    }

    Item {
        id: timedigital
        x: 140 * xmul
        y: 205 * xmul
        width: 120 * xmul
        height: 30 * xmul

        Rectangle {
            width: parent.width
            height: parent.height
            color: "blue"
        }
    }

    Item {
        id: datawidget_10_1
        x: 100 * xmul
        y: 55 * xmul
        width: 60 * xmul
        height: 20 * xmul

        Rectangle {
            width: parent.width
            height: parent.height
            color: "green"
        }
    }

    Item {
        id: datawidget_1_1
        x: 140 * xmul
        y: 85 * xmul
        width: 60 * xmul
        height: 20 * xmul

        Rectangle {
            width: parent.width
            height: parent.height
            color: "green"
        }
    }

    Item {
        id: datawidget_6_2
        x: 180 * xmul
        y: 150 * xmul
        width: 60 * xmul
        height: 20 * xmul

        Rectangle {
            width: parent.width
            height: parent.height
            color: "green"
        }
    }

    Item {
        id: datawidget_6_1
        x: 100 * xmul
        y: 250 * xmul
        width: 60 * xmul
        height: 20 * xmul

        Rectangle {
            width: parent.width
            height: parent.height
            color: "green"
        }
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
            source: imgPath + "casio-timehand-hour.png"
            anchors {
                centerIn: parent
            }
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * 0.5)
            }
        }

        Image {
            id: minutePng
            z: 1
            source: imgPath + "casio-timehand-minute.png"
            anchors {
                centerIn: parent
            }
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: (wallClock.time.getMinutes() * 6) + (wallClock.time.getSeconds() * 6 / 60)
            }
        }

        Image {
            id: secondPng
            z: 2
            visible: !displayAmbient
            source: imgPath + "casio-timehand-seconds.png"
            anchors {
                centerIn: parent
            }
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            transform: Rotation {
                origin.x: parent.width / 2
                origin.y: parent.height / 2
                angle: (wallClock.time.getSeconds() * 6)
            }
        }
    }
}
