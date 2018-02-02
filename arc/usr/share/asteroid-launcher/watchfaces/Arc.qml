/*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Lesser General Public License as
* published by the Free Software Foundation, either version 2.1 of the
* License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

/*
 * This watchface has arcs for hands and a battery indicator
 */

import QtQuick 2.1
import org.freedesktop.contextkit 1.0
import org.asteroid.utils 1.0

Item {
    id: watchFace

    property var timeBinding: wallClock.time

    // 'api': a bunch of configurable things for variant watchfaces
    property alias arcwrapper: wrapper
    property alias arcwidth: wrapper.width
    property color arccolor: '#ffffff' //outerCorner.color
    property color arctextcolor: '#000000'// dateDisplay.color
    property color arcbatterylowcolor: "#aaa"//batteryGradientStop.color
    property alias arcopacity: arcList.opacity
    property string arcdateformat: "<b>ddd</b><br>d<br>MMM"
    property double arctimefontsize: wrapper.height * 0.078
    property double arcdatefontsize: wrapper.height/16
    property double arctextbgz: 0
    property var arcsData: function() {return [
        {key:'hours', size: arcwidth*0.5, lineWidth: arcwidth * 0.12, colorCircle: watchFace.arccolor, opacity: 1},
        {key:'minutes', size: arcwidth*0.75, lineWidth: arcwidth  * 0.12, colorCircle: watchFace.arccolor, opacity: 0.85},
        {key:'seconds', size: arcwidth, lineWidth: arcwidth * 0.12, colorCircle: watchFace.arccolor, opacity: 0.7},
    ]}
    // /'api'

    Item {
        id: wrapper

        //anchors = launcher won't start
        //assuming width = height
        width: parent.width * 0.95
        height: width
        x: (parent.width - width) / 2
        y: x
        Rectangle {
            id: textBg
            color: 'transparent'
            anchors.verticalCenter: parent.verticalCenter
            x: (parent.width - height) / 2
            height: parent.width  * 0.25
            width: (watchFace.width + height) / 2
            layer.enabled: true
            opacity: 0.32
            z:arctextbgz

            Rectangle {
                id: outerCorner
                color: watchFace.arccolor
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: innerCorner.horizontalCenter
                anchors.right: parent.right
                radius: height * 0.05
                z: 1
            }

            Rectangle {
                id: innerCorner
                color: watchFace.arccolor
                height: parent.height
                width: height
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                radius: height / 2
                z:2
                clip: true

                Rectangle {
                    width: parent.width
                    height: parent.height

                    clip: true
                    rotation: 180
                    radius: parent.radius
                    z:2
                    color: watchFace.arccolor

                    gradient: Gradient {
                        GradientStop {
                            position: 0.00
                            color: watchFace.arccolor
                        }
                        GradientStop {
                            position: Math.max(0.01, (batteryChargePercentage.value/100) - 0.011)
                            color: watchFace.arccolor
                        }
                        GradientStop {
                            id: batteryGradientStop
                            position: Math.min(0.99, (batteryChargePercentage.value/100) + 0.011)
                            color: watchFace.arcbatterylowcolor
                        }
                        GradientStop {
                            position: 1.00
                            color: watchFace.arcbatterylowcolor
                        }
                    }
                }
            }
        }

        Text {
            id: dateDisplay
            z: 8
            font.pixelSize: watchFace.arcdatefontsize
            color: watchFace.arctextcolor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            lineHeight: 0.7
            anchors.centerIn: parent
            text: Qt.formatDate(timeBinding, watchFace.arcdateformat)
            style: Text.Raised
            styleColor: watchFace.arccolor
        }

        ListView {

            id: arcList
            anchors.fill: parent
            opacity: 1
            interactive: false
            delegate: Loader {
                sourceComponent: arc
                anchors.top: parent.top
                property int index: model.index
            }
            model: ListModel { id: model}

            function update(){
                model.clear()
                var arcsDataArr = arcsData()
                for(var i in arcsDataArr) {
                    model.append(arcsDataArr[i])
                }
            }

            Component.onCompleted: {
                update()

            }
            onWidthChanged: {
                update()
            }
        }


        Component {
            id: arc

            Item {
                id: arcItem

                function updateModelBinding(){
                    var i = index
                    var data = model.get(i)
                    arcItem.width = data.size
                    if(data.showBackground){
                        if(data.colorBackground){
                            arcItem.colorBackground = data.colorBackground
                        }
                        arcItem.showBackground = data.showBackground
                    }
                    if(data.opacity) {
                        canvas.opacity = data.opacity
                    }

                    if(data.isPie) {
                        arcItem.isPie = true
                    }
                    if(data.lineWidth) {
                        arcItem.lineWidth = data.lineWidth
                    }
                    if(data.colorCircle) {
                        console.log('color circle', '' + data.colorCircle,data.colorCircle.r)
                        if(data.colorCircle.r) {
                            arcItem.colorCircle = 'rgba('+data.colorCircle.r*255+','+data.colorCircle.g*255+','+data.colorCircle.b*255+','+data.colorCircle.a*255+')'
                        } else {
                            arcItem.colorCircle = data.colorCircle
                        }
                    }
                    if(data.beginAnimation) {
                        arcItem.beginAnimation = data.beginAnimation
                    }
                    if(data.endAnimation) {
                        arcItem.endAnimation = data.endAnimation
                    }

                    if(data.animationDuration) {
                        arcItem.animationDuration = data.animationDuration
                    }

                    if(data.key) {
                        arcItem.key = data.key
                    }

                }
                Component.onCompleted: {
                    updateModelBinding()
                }

                width: 50
                height: width
                x: (arcList.width - width)/2
                y: (arcList.height - height)/2
                property string key:''
                // The size of the circle in pixel
                property real arcBegin: 0            // start arc angle in degree
                property var cache: ([-1,-1,-1])
                property real cachedArcEnd: -1
                property real arcEnd: {
                    var data = model.get(index)
                    var type = data.key
                    if(type === 'hours') {
                        return  ((timeBinding.getHours()%12) * 30)// + (timeBinding.getMinutes() / 2)
                    } else if(type === 'minutes') {
                        return  (timeBinding.getMinutes() * 6)
                    }
                    return (timeBinding.getSeconds() * 6)
                }
                // end arc angle in degree
                property real arcOffset: 0           // rotation
                property bool isPie: false           // paint a pie instead of an arc
                property bool showBackground: false  // a full circle as a background of the arc
                property real lineWidth: 20          // width of the line
                property string colorCircle: "#CC3333"
                property string colorBackground: "#779933"

                property alias beginAnimation: animationArcBegin.enabled
                property alias endAnimation: animationArcEnd.enabled

                property int animationDuration: 200
                property string name: ''
                onArcBeginChanged: canvas.requestPaint()
                onArcEndChanged: canvas.requestPaint()

                Behavior on arcBegin {
                    id: animationArcBegin
                    enabled: false
                    NumberAnimation {
                        duration: arcItem.animationDuration
                        easing.type: Easing.InOutCubic
                    }
                }

                Behavior on arcEnd {
                    id: animationArcEnd
                    enabled: false
                    NumberAnimation {
                        duration: arcItem.animationDuration
                        easing.type: Easing.InOutCubic
                    }
                }
                Canvas {
                    id: canvas
                    anchors.fill: parent
                    rotation: -90 + arcItem.arcOffset

                    onPaint: {
                        if(parent.arcEnd === parent.cachedArcEnd) {
                            return
                        }
                        parent.cachedArcEnd = parent.arcEnd

                        var ctx = getContext("2d")
                        var x = width / 2
                        var y = height / 2
                        var start = Math.PI * (parent.arcBegin / 180)
                        var end = Math.PI * (parent.arcEnd / 180)
                        ctx.reset()

                        if (arcItem.isPie) {
                            if (arcItem.showBackground) {
                                ctx.beginPath()
                                ctx.fillStyle = arcItem.colorBackground
                                ctx.moveTo(x, y)
                                ctx.arc(x, y, width / 2, 0, Math.PI * 2, false)
                                ctx.lineTo(x, y)
                                ctx.fill()
                            }
                            ctx.beginPath()
                            ctx.fillStyle = arcItem.colorCircle
                            ctx.moveTo(x, y)
                            ctx.arc(x, y, width / 2, start, end, false)
                            ctx.lineTo(x, y)
                            ctx.fill()
                        } else {
                            if (arcItem.showBackground) {
                                ctx.beginPath()
                                ctx.arc(x, y, (width / 2) - parent.lineWidth / 2, 0, Math.PI * 2, false)
                                ctx.lineWidth = arcItem.lineWidth
                                ctx.strokeStyle = arcItem.colorBackground
                                ctx.stroke()
                            }
                            ctx.beginPath()
                            ctx.arc(x, y, (width / 2) - parent.lineWidth / 2, start, end, false)
                            ctx.lineWidth = arcItem.lineWidth
                            ctx.strokeStyle = arcItem.colorCircle
                            ctx.stroke()
                        }
                    }

                }
                Text {
                    text: {

                        var data = model.get(index)
                        var type = data.key
                        if(type === 'hours') {
                            return ("0" + timeBinding.getHours()).slice(-2)
                        } else if(type === 'minutes') {
                            return  ("0" + timeBinding.getMinutes()).slice(-2)
                        }
                        return ("0" + timeBinding.getSeconds()).slice(-2)
                    }
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: (arcItem.lineWidth - width) / 2


                    font.bold: true
                    font.pixelSize: watchFace.arctimefontsize
                    color: watchFace.arctextcolor
                    z:8
                    style: Text.Raised
                    styleColor: watchFace.arccolor
                }
            }
        }

    }
    ContextProperty {
        id: batteryChargePercentage
        key: "Battery.ChargePercentage"
        value: "100"
        Component.onCompleted: batteryChargePercentage.subscribe()
    }

    ContextProperty {
        id: batteryIsCharging
        key: "Battery.IsCharging"
        value: false
    }

}
