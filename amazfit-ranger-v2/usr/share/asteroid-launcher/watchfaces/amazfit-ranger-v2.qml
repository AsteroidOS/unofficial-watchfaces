
/*
  based on 'Amazfit Ranger V2.wfz' by Lawrnz & Osmat
  converted with amazteroid.js
  */
import QtQuick 2.9

Item {
    id: root
    property string imgPath: "../watchfaces-img/amazfit-ranger-v2-"

    Image {
        z: 0
        id: background
        source: imgPath + "background-00.png"
        opacity: displayAmbient ? 0.1 : 1
        anchors {
            centerIn: root
        }
        width: root.width
        height: root.height
    }

    Image {
        id: hourPNG
        z: 2
        source: imgPath + "hour.png"
        anchors {
            centerIn: root
        }
        width: root.width
        height: root.height
        fillMode: Image.PreserveAspectFit
        transform: Rotation {
            origin.x: root.width / 2
            origin.y: root.height / 2
            angle: (wallClock.time.getHours() * 30) + (wallClock.time.getMinutes() * 0.5)
        }
    }

    Image {
        id: minuteSVG
        z: 3
        source: imgPath + "minute.png"
        anchors {
            centerIn: root
        }
        width: root.width
        height: root.height
        fillMode: Image.PreserveAspectFit
        transform: Rotation {
            origin.x: root.width / 2
            origin.y: root.height / 2
            angle: (wallClock.time.getMinutes() * 6) + (wallClock.time.getSeconds() * 6 / 60)
        }
    }

    Image {
        id: secondSVG
        z: 4
        visible: !displayAmbient
        source: imgPath + "seconds.png"
        anchors {
            centerIn: root
        }
        width: root.width
        height: root.height
        fillMode: Image.PreserveAspectFit
        transform: Rotation {
            origin.x: root.width / 2
            origin.y: root.height / 2
            angle: (wallClock.time.getSeconds() * 6)
        }
    }
}
