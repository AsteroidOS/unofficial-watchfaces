import QtQuick

Item {
    id: sensorRoot

    property bool active: false
    property alias reading: reading

    Item {
        id: reading

        property int stepCount: 0

        onStepCountChanged: sensorRoot.readingChanged()
        Component.onCompleted: stepCount = 4200
    }

}
