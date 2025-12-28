import QtQuick 2.9
// need this for Global
import Nemo.Mce 1.0

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
