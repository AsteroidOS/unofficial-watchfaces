// need this for Global
import Nemo.Mce
import QtQuick

Item {
    property string path
    property bool active: Global.hrmSensorActive
    property alias reading: reading

    Item {
        id: reading

        property int bpm: Global.heartrate

        onBpmChanged: parent.readingChanged()
    }

}
