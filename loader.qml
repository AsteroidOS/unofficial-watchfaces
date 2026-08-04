import Qt5Compat.GraphicalEffects
import QtCore
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.2
import WatchfaceConfig 1.0

ApplicationWindow {
    id: appRoot

    property bool displayAmbient: ambientCheckBox.checked && !WatchfaceConfig.captureMode
    property bool nightstand: nightstandCheckBox.checked
    property var nameOfWatchfaceToBeTested: WatchfaceConfig.watchfaceName
    property var backgroundImage: WatchfaceConfig.backgroundImage
    property var backgroundRoundImage: WatchfaceConfig.backgroundRoundImage
    property var relativeRootDir: WatchfaceConfig.relativeRootDir
    readonly property var initialStaticTime: new Date('2021-12-02T13:37:42')
    readonly property real mouseWheelScale: 1 / 15

    title: nameOfWatchfaceToBeTested
    minimumWidth: 640 + controls.width
    minimumHeight: 640
    visible: true

    QtObject {
        id: global

        property real heartrate: 0
        property real battery: 50
        property real compassAzimuth: 0
        property int batteryChargeState: 0
        property int batteryChargerType: 0
    }

    QtObject {
        id: burnInProtectionManager

        property real widthOffset: 0
        property real heightOffset: 0
    }

    QtObject {
        id: compositor

        signal displayAmbientEntered()
        signal displayAmbientLeft()
    }

    // Headless capture: wait until the face has actually loaded, let bindings
    // and Canvas painting settle a few ticks, then grab one square transparent
    // frame and quit. Capture state is applied through bindings on
    // WatchfaceConfig.captureMode rather than by toggling the persisted GUI
    // controls, so a batch run neither depends on the developer's last saved
    // interactive settings nor overwrites them.
    Timer {
        id: captureTimer

        property int settleTicks: 0

        running: WatchfaceConfig.captureMode && watchfaceLoader.status === Loader.Ready
        interval: 400
        repeat: true
        onTriggered: {
            if (++settleTicks < 3)
                return ;

            running = false;
            watchfaceDisplayFrame.grabToImage(function(result) {
                result.saveToFile(appRoot.nameOfWatchfaceToBeTested + "-trans.png");
                Qt.quit();
            }, Qt.size(384, 384));
        }
    }

    Settings {
        property alias round: roundCheckBox.checked
        property alias nonSquare: nonSquare.checked
        property alias displayAmbient: ambientCheckBox.checked
        property alias halfSize: halfSize.checked
        property alias twelveHour: twelveHourCheckBox.checked
        property alias staticTime: setStaticTimeCheckBox.checked
    }

    Binding {
        target: global
        property: "heartrate"
        value: heartRate.value
    }

    Binding {
        target: global
        property: "battery"
        value: WatchfaceConfig.captureMode ? 96 : batteryCharge.value
    }

    Binding {
        target: global
        property: "compassAzimuth"
        value: compassAzimuth.value
    }

    RowLayout {
        spacing: 0

        ToolBar {
            id: controls

            Layout.fillHeight: true
            padding: 5

            ColumnLayout {
                RowLayout {
                    Layout.alignment: Qt.AlignCenter

                    Button {
                        id: reloadButton

                        flat: false
                        text: "\u27f2"
                        ToolTip.visible: hovered
                        ToolTip.delay: 600
                        ToolTip.text: qsTr("Reload qml code")
                        onClicked: {
                            watchfaceLoader.source = appRoot.relativeRootDir + appRoot.nameOfWatchfaceToBeTested + ".qml?" + Math.random();
                        }
                    }

                    Button {
                        id: screenshotButton

                        flat: false
                        text: qsTr("Screenshot")
                        ToolTip.visible: hovered
                        ToolTip.delay: 600
                        ToolTip.text: qsTr("Take a 640px screenshot and store it as PNG image")
                        onClicked: roundCheckBox.checked ? watchfaceDisplayFrame.snapshot("-screenshot.png") : watchfaceDisplayFrame.snapshot(".png")
                    }

                    Button {
                        id: previewButton

                        property real sequencer: 0

                        function transSnapshots() {
                            if (sequencer === 1) {
                                watchfaceDisplayFrame.color = "transparent";
                                background.source = "";
                                frame.color = "transparent";
                                watchfaceDisplayFrame.snapshot("-trans.png");
                            }
                            if (sequencer === 2) {
                                background.source = appRoot.backgroundImage;
                                roundCheckBox.checked = false;
                                watchfaceDisplayFrame.snapshot(".png");
                            }
                            if (sequencer === 3) {
                                background.source = appRoot.backgroundRoundImage;
                                roundCheckBox.checked = true;
                                watchfaceDisplayFrame.snapshot("-round.png");
                            }
                            if (sequencer === 4) {
                                background.source = appRoot.backgroundImage;
                                frame.color = "black";
                                sequencer = 0;
                                snapshotsTimer.running = false;
                            }
                        }

                        flat: false
                        text: qsTr("Generate previews")
                        ToolTip.visible: hovered
                        ToolTip.delay: 600
                        ToolTip.text: qsTr("Generate preview images for the .thumbnails and watchfacepreview folders")
                        onClicked: snapshotsTimer.running = true

                        Timer {
                            id: snapshotsTimer

                            interval: 500
                            running: false
                            repeat: true
                            onTriggered: {
                                previewButton.sequencer++;
                                previewButton.transSnapshots();
                            }
                        }

                    }

                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignCenter

                    RowLayout {
                        Layout.alignment: Qt.AlignCenter

                        CheckBox {
                            id: roundCheckBox

                            font.pixelSize: 30
                            text: "\u25EF"
                            ToolTip.visible: hovered
                            ToolTip.delay: 600
                            ToolTip.text: qsTr("Show the watchface as it would look on a round watch")
                            checked: true
                        }

                        CheckBox {
                            id: nonSquare

                            font.pixelSize: 30
                            text: "\u25AF"
                            ToolTip.visible: hovered
                            ToolTip.delay: 600
                            ToolTip.text: qsTr("Show the watchface as it would look on a non-square watch")
                        }

                        CheckBox {
                            id: ambientCheckBox

                            font.pixelSize: 40
                            text: "\u263D"
                            ToolTip.visible: hovered
                            ToolTip.delay: 600
                            ToolTip.text: qsTr("Switch to AmbientMode on black background")
                        }

                        CheckBox {
                            id: halfSize

                            text: qsTr("320px")
                            ToolTip.visible: hovered
                            ToolTip.delay: 600
                            ToolTip.text: qsTr("Scale down view to 320x320px from 640px")
                        }

                        CheckBox {
                            id: referenceCheckBox

                            text: qsTr("ref")
                            ToolTip.visible: hovered
                            ToolTip.delay: 600
                            ToolTip.text: qsTr("Overlay the upstream gallery thumbnail to align positions")
                        }

                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignCenter

                        CheckBox {
                            id: nightstandCheckBox

                            text: qsTr("Nightstand")
                            ToolTip.visible: hovered
                            ToolTip.delay: 600
                            ToolTip.text: qsTr("Switch to Nightstand mode")
                        }

                        CheckBox {
                            id: twelveHourCheckBox

                            text: qsTr("12h")
                            ToolTip.delay: 600
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Switch to 2x 12h day format with am/pm")
                        }

                        CheckBox {
                            id: setStaticTimeCheckBox

                            text: qsTr("Set Time")
                            ToolTip.delay: 600
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Set a custom time by draging the tumblers or use the mouse wheel above them")
                            checked: false
                        }

                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter

                        Frame {
                            padding: 0

                            Row {
                                Tumbler {
                                    id: monthsTumbler

                                    enabled: setStaticTimeCheckBox.checked
                                    currentIndex: appRoot.initialStaticTime.getMonth()
                                    model: 12

                                    WheelHandler {
                                        property: "currentIndex"
                                        rotationScale: appRoot.mouseWheelScale
                                    }

                                    delegate: Label {
                                        text: appRoot.locale.standaloneMonthName(index, Locale.ShortFormat)
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                }

                                Tumbler {
                                    id: daysTumbler

                                    enabled: setStaticTimeCheckBox.checked
                                    currentIndex: appRoot.initialStaticTime.getDate() - 1
                                    model: 31

                                    WheelHandler {
                                        property: "currentIndex"
                                        rotationScale: appRoot.mouseWheelScale
                                    }

                                    delegate: Label {
                                        text: index + 1
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                }

                            }

                        }

                        Frame {
                            padding: 0

                            Row {
                                Tumbler {
                                    id: hoursTumbler

                                    enabled: setStaticTimeCheckBox.checked
                                    currentIndex: appRoot.initialStaticTime.getHours()
                                    model: 24

                                    WheelHandler {
                                        property: "currentIndex"
                                        rotationScale: appRoot.mouseWheelScale
                                    }

                                }

                                Tumbler {
                                    id: minutesTumbler

                                    enabled: setStaticTimeCheckBox.checked
                                    currentIndex: appRoot.initialStaticTime.getMinutes()
                                    model: 60

                                    WheelHandler {
                                        property: "currentIndex"
                                        rotationScale: appRoot.mouseWheelScale
                                    }

                                }

                                Tumbler {
                                    id: secondsTumbler

                                    enabled: setStaticTimeCheckBox.checked
                                    currentIndex: appRoot.initialStaticTime.getSeconds()
                                    model: 60

                                    WheelHandler {
                                        property: "currentIndex"
                                        rotationScale: appRoot.mouseWheelScale
                                    }

                                }

                            }

                        }

                    }

                }

                Frame {
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter

                        Text {
                            text: qsTr("batteryCharge")
                        }

                        Slider {
                            id: batteryCharge

                            width: 700
                            from: 0
                            value: 50
                            to: 100
                            ToolTip.visible: hovered
                            ToolTip.delay: 600
                            ToolTip.text: qsTr("Represents the state of charge of the battery")

                            Repeater {
                                model: 25

                                delegate: Rectangle {
                                    anchors.bottom: parent.bottom
                                    x: parent.horizontalPadding + parent.availableWidth * index / 24
                                    implicitWidth: 1
                                    implicitHeight: 8
                                    color: "brown"
                                }

                            }

                            Text {
                                text: "0"
                                anchors.left: parent.left
                            }

                            Text {
                                text: "100"
                                anchors.right: parent.right
                            }

                        }

                        Text {
                            text: batteryCharge.value.toFixed(0)
                        }

                    }

                }

                Frame {
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter

                        Text {
                            text: qsTr("HeartRate")
                        }

                        Slider {
                            id: heartRate

                            width: 700
                            from: 45
                            value: 60
                            to: 220
                            ToolTip.visible: hovered
                            ToolTip.delay: 600
                            ToolTip.text: qsTr("Represents user's heart rate in bpm")

                            Repeater {
                                model: 25

                                delegate: Rectangle {
                                    anchors.bottom: parent.bottom
                                    x: parent.horizontalPadding + parent.availableWidth * index / 24
                                    implicitWidth: 1
                                    implicitHeight: 8
                                    color: "brown"
                                }

                            }

                            Text {
                                text: heartRate.from
                                anchors.left: parent.left
                            }

                            Text {
                                text: heartRate.to
                                anchors.right: parent.right
                            }

                        }

                        Text {
                            text: heartRate.value.toFixed(0)
                        }

                    }

                }

                Frame {
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter

                        Text {
                            text: qsTr("Heading")
                        }

                        Slider {
                            id: compassAzimuth

                            width: 700
                            from: 0
                            value: 0
                            to: 360
                            ToolTip.visible: hovered
                            ToolTip.delay: 600
                            ToolTip.text: qsTr("Represents azimuth to true north in degrees")

                            Repeater {
                                model: 25

                                delegate: Rectangle {
                                    anchors.bottom: parent.bottom
                                    x: parent.horizontalPadding + parent.availableWidth * index / 24
                                    implicitWidth: 1
                                    implicitHeight: 8
                                    color: "brown"
                                }

                            }

                            Text {
                                text: compassAzimuth.from
                                anchors.left: parent.left
                            }

                            Text {
                                text: compassAzimuth.to
                                anchors.right: parent.right
                            }

                        }

                        Text {
                            text: compassAzimuth.value.toFixed(0)
                        }

                    }

                }

                Frame {
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter

                        Text {
                            text: qsTr("featureSlider")
                        }

                        Slider {
                            id: featureSlider

                            width: 700
                            from: 0
                            value: 0.5
                            to: 1
                            ToolTip.visible: hovered
                            ToolTip.delay: 600
                            ToolTip.text: qsTr("Can be used to test a feature such as battery level.\nDevelopers can temporarily use 'featureSlider.value' in watchface code.")

                            Repeater {
                                model: 25

                                delegate: Rectangle {
                                    anchors.bottom: parent.bottom
                                    x: parent.horizontalPadding + parent.availableWidth * index / 24
                                    implicitWidth: 1
                                    implicitHeight: 8
                                    color: "brown"
                                }

                            }

                            Text {
                                text: "0.0"
                                anchors.left: parent.left
                            }

                            Text {
                                text: "1.0"
                                anchors.right: parent.right
                            }

                        }

                        Text {
                            text: featureSlider.value.toFixed(3)
                        }

                    }

                }

            }

            background: Rectangle {
                color: "lightblue"
            }

        }

        Rectangle {
            id: watchfaceDisplayFrame

            function snapshot(suffix) {
                var refWasOn = referenceCheckBox.checked;
                referenceCheckBox.checked = false;
                watchfaceDisplayFrame.grabToImage(function(result) {
                    result.saveToFile(appRoot.nameOfWatchfaceToBeTested + suffix);
                    referenceCheckBox.checked = refWasOn;
                }, Qt.size(640, 640));
            }

            // Capture is always the full transparent square, whatever
            // geometry the GUI toggles last held.
            color: WatchfaceConfig.captureMode ? "transparent" : "white"
            height: WatchfaceConfig.captureMode ? 640 : (halfSize.checked ? 320 : 640)
            width: WatchfaceConfig.captureMode ? height : (nonSquare.checked ? height * 0.85 : height)

            Rectangle {
                id: frame

                anchors.fill: parent
                color: WatchfaceConfig.captureMode ? "transparent" : "black"
                focus: true
                layer.enabled: roundCheckBox.checked && !WatchfaceConfig.captureMode
                Keys.onReturnPressed: watchfaceDisplayFrame.snapshot()

                Image {
                    id: background

                    visible: !appRoot.displayAmbient && !WatchfaceConfig.captureMode
                    source: appRoot.backgroundImage
                    anchors.fill: parent
                }

                Loader {
                    id: watchfaceLoader

                    anchors.fill: parent
                    source: appRoot.relativeRootDir + appRoot.nameOfWatchfaceToBeTested + ".qml"
                }

                Image {
                    id: referenceOverlay

                    z: 100
                    anchors.fill: parent
                    source: roundCheckBox.checked ? WatchfaceConfig.galleryThumbnailRound : WatchfaceConfig.galleryThumbnail
                    opacity: referenceCheckBox.checked ? 0.5 : 0
                    // An alignment aid only: never part of a capture, and
                    // snapshot() hides it around the grab.
                    visible: opacity > 0 && !WatchfaceConfig.captureMode
                }

                layer.effect: OpacityMask {
                    anchors.fill: parent
                    source: frame

                    maskSource: Rectangle {
                        width: frame.width
                        height: frame.height
                        radius: frame.width / 2
                    }

                }

            }

            Item {
                id: use12H

                property bool value: twelveHourCheckBox.checked && !WatchfaceConfig.captureMode
            }

            Item {
                id: wallClock

                property var time: WatchfaceConfig.captureMode ? new Date(WatchfaceConfig.captureTime) : getDisplayTime()

                function getDisplayTime(statictime) {
                    var displayTime = new Date();
                    if (setStaticTimeCheckBox.checked) {
                        displayTime.setHours(hoursTumbler.currentIndex, minutesTumbler.currentIndex, secondsTumbler.currentIndex);
                        displayTime.setMonth(monthsTumbler.currentIndex, daysTumbler.currentIndex + 1);
                    }
                    return displayTime;
                }

                Timer {
                    interval: 1000
                    running: !WatchfaceConfig.captureMode
                    repeat: true
                    onTriggered: wallClock.time = wallClock.getDisplayTime()
                }

            }

        }

    }

}
