import QtQuick 2.9

Item {

    height: 640
    width: 640
    property bool displayAmbient: false

    Image {
        source: "background.jpg"
        width: 640
        height: 640
    }

    Item {
        id: use12H
        property var value: @@@12h@@@
    }

    Item {
        property var time: new Date()
        id: wallClock
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: wallClock.time = new Date()
        }
    }

    Loader {
        id: watchfaceLoader
        height: 640
        width: 640
        source: "@@@watchface@@@"
    }
}
