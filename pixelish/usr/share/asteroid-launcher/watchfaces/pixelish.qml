/*
 * Copyright (C) 2021 - Timo Könnecke <github.com/eLtMosen>
 * Copyright (C) 2022 - Commenter25 <github.com/Commenter25>
 *
 * All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
 
/* based off digital-shifted */

import QtQuick 2.9
import QtGraphicalEffects 1.15

Item {
	id: root
	
	property real arcEnd: wallClock.time.getSeconds() * 6
	onArcEndChanged: canvas.requestPaint()

	/* Uncomment this block for smooth seconds 
	TODO: fix animating looping back to 0 */
	/*
	Behavior on arcEnd {
			id: animationArcEnd
			enabled: true
			NumberAnimation {
					duration: 1000
					easing.type: Easing.Linear
			}
	}
	*/
	

	Canvas {
			id: canvas
			visible: !displayAmbient
			anchors.fill: parent
			rotation: -90
			onPaint: {
					var ctx = getContext("2d")
					var x = root.width / 2
					var y = root.height / 2
					var start = 0
					var end = Math.PI * (parent.arcEnd / 180)
					ctx.reset()
					ctx.beginPath()
					ctx.lineCap="round"
					ctx.arc(x, y, (root.width / 2) - parent.height*0.124 / 2, start, end, false)
					ctx.lineWidth = parent.height * 0.03
					ctx.strokeStyle = "#CCC"
					ctx.stroke()
			}
			layer.enabled: true
	}


	Text {
			id: colon

			renderType: Text.NativeRendering
			horizontalAlignment: Text.AlignHCenter
			color: "#ffffff"
			font {
				pixelSize: root.height * .28
				family: "Open Sans"
			}

			anchors {
					centerIn: root
					horizontalCenterOffset: root.width * 0.01
					verticalCenterOffset: root.width * -0.05
			}
			text: wallClock.time.toLocaleString(Qt.locale(), ":")
	}

	Text {
			id: hourDisplay

			renderType: Text.NativeRendering
			horizontalAlignment: Text.AlignHCenter
			color: "#ffffff"
			font {
					pixelSize: root.height * .25
					letterSpacing: root.height * .004
					family: "Open Sans"
			}

			anchors {
					right: colon.left
					bottom: colon.bottom
			}

			/* TODO: allow removal of leading zero */
			text: use12H.value ?
								wallClock.time.toLocaleString(Qt.locale(), "hh ap").slice(0, 2) :
								wallClock.time.toLocaleString(Qt.locale(), "HH")
	}

	Text {
		id: minDisplay

		renderType: Text.NativeRendering
		horizontalAlignment: Text.AlignHCenter
		color: "#ffffff"
		font {
				pixelSize: root.height * .25
				letterSpacing: root.height * .004
				family: "Open Sans"
		}

		anchors {
				left: colon.right
				bottom: colon.bottom
		}

		text: wallClock.time.toLocaleString(Qt.locale(), "mm")
	}

	Text {
			id: monthDisplay

			renderType: Text.NativeRendering
			horizontalAlignment: Text.AlignHCenter
			color: "#ffffff"
			font {
				pixelSize: root.height * .07
				letterSpacing: root.height * .006
				family: "Open Sans"
			}

			anchors {
					horizontalCenter: root.horizontalCenter
					top: colon.bottom
					topMargin: root.height * -0.15 /* -0.04 for build, -0.15 for qmlscene */
			}
			text: wallClock.time.toLocaleString(Qt.locale(), "ddd, MMM dd").replace(".","")
	}

	layer.enabled: true
	layer.effect: DropShadow {
			transparentBorder: true
			horizontalOffset: 4
			verticalOffset: 4
			radius: 7.0
			samples: 15
			color: "#99000000"
	}
}
