// need this for Global
import Nemo.Mce
import QtQuick

Item {
    property bool active: Global.compassActive
    property alias reading: reading

    Item {
        id: reading

        property real azimuth: Global.compassAzimuth

        onAzimuthChanged: parent.readingChanged()
    }

}
