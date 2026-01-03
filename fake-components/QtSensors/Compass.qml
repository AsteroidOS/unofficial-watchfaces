import QtQuick 2.9
// need this for Global
import Nemo.Mce 1.0

Item {
    property bool active: Global.compassActive
    property alias reading: reading
    Item {
        id: reading
        property real azimuth: Global.compassAzimuth
        onAzimuthChanged: parent.readingChanged()
    }
}
