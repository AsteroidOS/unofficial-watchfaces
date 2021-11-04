import QtQuick 2.15
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.1

ApplicationWindow {
    id: root
    property bool displayAmbient: false
    property bool round: true
    property var testface: Qt.application.arguments[1]

    toolBar: ToolBar {
        RowLayout {
            anchors.fill: parent
            anchors.margins: spacing
            CheckBox {
                id: roundCheckBox
                text: "Round"
                Component.onCompleted: checked = round
                onCheckedChanged: round = checked; 
            }
            CheckBox {
                id: checkBox12h
                text: "12h time"
                Component.onCompleted: checked = use12H.value
                onCheckedChanged: use12H.value = checked; 
            }
            CheckBox {
                id: ambientCheckBox
                text: "Dark"
                Component.onCompleted: checked = displayAmbient
                onCheckedChanged: displayAmbient = checked; 
            }
            Item { Layout.fillWidth: true }
        }
    }

    Rectangle {
        id: myFrame
        height: 640
        width: frame.height

        Rectangle {
            id: frame
            anchors.fill: parent
            color: "black"
            focus: true
            Image {
                id: background
                visible: !displayAmbient
                source: "background.jpg"
                anchors.fill: parent
            }
            Loader {
                id: watchfaceLoader
                anchors.fill: parent
                source: testface + "/usr/share/asteroid-launcher/watchfaces/" + testface + ".qml"
            }

            layer.enabled: round
            layer.effect:  OpacityMask {
                anchors.fill: parent
                source: frame
                maskSource: Rectangle {
                    width: frame.width
                    height: frame.height
                    radius: frame.width/2
                }
            }

            Keys.onReturnPressed: myFrame.grabToImage(
            function(result) {  
                result.saveToFile(testface + (round ? "-round.jpg" : ".jpg"))
            }, Qt.size(320, 320) )
        }

        Item {
            id: use12H
            property var value: false
        }

        Item {
            id: wallClock
            property var time: new Date()
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: wallClock.time = new Date()
            }
        }
    }
}
