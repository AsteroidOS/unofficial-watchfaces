import QtQuick

Text {
    // Mirrors org.asteroid.controls Label: white text at the platform default
    // size (Dims.defaultFontSize ~= 6% of a 640px harness frame).
    color: "white"
    font.pixelSize: 38
    elide: Text.ElideRight
}
