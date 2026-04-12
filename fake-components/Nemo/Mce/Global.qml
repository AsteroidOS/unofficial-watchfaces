import QtQuick 2.9
pragma Singleton

Item {
    // simulated battery things
    property int battery: 64
    property int batteryChargeState: 1
    property int batteryChargerType: 1
    // simulated heartrate monitor
    property int heartrate: 62
    property bool hrmSensorActive: false
    // simulated compass
    property real compassAzimuth: 48
    property bool compassActive: true
    // simultated wifi connection
    property bool wifiPowered: true
}
