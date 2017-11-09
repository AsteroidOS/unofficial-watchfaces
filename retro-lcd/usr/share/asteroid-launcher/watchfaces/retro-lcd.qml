import QtQuick 2.1

Canvas {
    id: rootitem
    anchors.fill: parent
    contextType: "2d"
    antialiasing: true
    smooth: true
    renderTarget: Canvas.FramebufferObject

    onPaint: {
        var ctx = getContext("2d");
        ctx.reset();
        ctx.fillStyle = "#252525";
        ctx.textBaseline = 'middle';
        var centerX = rootitem.width * 0.5;
        var centerY = rootitem.height * 0.5;

		var ourTime = wallClock.time.getHours();
		var ourMins = wallClock.time.getMinutes();
		var ourSecs = wallClock.time.getSeconds();
		var ourDOW = Qt.formatDate(wallClock.time, "ddd").substr(0, 2);
		var ourDay = Qt.formatDate(wallClock.time, "dd").substr(0, 2).replace("0", " ");
		
		function fontSizeCalc(ourSize) {
			var ratio = ourSize / 280;
			var size = rootitem.width * ratio;
			return size|0;
		}
		
		if (use12H.value) {
			if (ourTime >= 12) {
				ourTime -= 12;
				ctx.textAlign = "center";
				ctx.font = "bold " + fontSizeCalc(12) + "px " + "Roboto";
				ctx.fillText("PM", centerX - (centerX * 0.55), centerY - (centerY * 0.09));
			}

			if (ourTime == 0) ourTime = 12;
		}
		
		if (ourMins < 10) ourMins = "0" + ourMins;
		if (ourSecs < 10) ourSecs = "0" + ourSecs;
		
        var fontFamily = "'Digital-7 Mono'";
        ctx.textAlign = "right";
        ctx.font = "50 " + fontSizeCalc(62) + "px " + fontFamily;
        ctx.fillText(ourTime, centerX - (centerX * 0.153), centerY + (centerY * 0.05));
        
        ctx.font = "50 " + fontSizeCalc(62) + "px " + fontFamily;
        ctx.fillText(ourMins, centerX + (centerX * 0.33), centerY + (centerY * 0.05));
        
        ctx.font = "50 " + fontSizeCalc(42) + "px " + fontFamily;
        ctx.fillText(ourSecs, centerX + (centerX * 0.643), centerY + (centerY * 0.123));
        
        ctx.font = "50 " + fontSizeCalc(30) + "px " + fontFamily;
        ctx.fillText(ourDOW, centerX + (centerX * 0.06), centerY - (centerY * 0.22));
        
        ctx.font = "50 " + fontSizeCalc(35) + "px " + fontFamily;
        ctx.fillText(ourDay, centerX + (centerX * 0.62), centerY - (centerY * 0.21));
        
        ctx.textAlign = "center";
        ctx.font = "50 " + fontSizeCalc(46) + "px " + "Roboto";
        ctx.fillText(":", centerX - (centerX * 0.113), centerY + (centerY * 0.15));
    }
     
    Connections {
        target: wallClock
        onTimeChanged: rootitem.requestPaint()
	}
}
