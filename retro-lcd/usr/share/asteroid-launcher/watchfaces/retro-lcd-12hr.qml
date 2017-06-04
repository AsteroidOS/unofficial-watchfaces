import QtQuick 2.1

Canvas {
    id: rootitem
    anchors.fill: parent
    contextType: "2d"
    antialiasing: true
    smooth: true

    onPaint: {
        var ctx = getContext("2d");
        ctx.reset();
        ctx.fillStyle = "#252525";
        ctx.textAlign = "right";
        ctx.textBaseline = 'middle';
        var centerX = rootitem.width * 0.5;
        var centerY = rootitem.height * 0.5;

		var ourTime = wallClock.time.getHours();
		var ourMins = wallClock.time.getMinutes();
		var ourSecs = wallClock.time.getSeconds();
		var ourDOW = Qt.formatDate(wallClock.time, "ddd").substr(0, 2);
		var ourDay = Qt.formatDate(wallClock.time, "dd").substr(0, 2).replace("0", " ");
		var amPm = "AM";
		
		function fontSizeCalc(ourSize) {
			var ratio = ourSize / 280;
			var size = rootitem.width * ratio;
			return size|0;
		}
		
		if (ourTime >= 12) {
			amPm = "PM";
			ourTime -= 12;
		}

		if (ourTime == 0) ourTime = 12;
		
		if (ourMins < 10) ourMins = "0" + ourMins;
		if (ourSecs < 10) ourSecs = "0" + ourSecs;
		
        var fontFamily = "'Digital-7 Mono'";
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
        
        if (amPm == "PM") {
			ctx.textAlign = "center";
			ctx.font = "bold " + fontSizeCalc(12) + "px " + "Roboto";
			ctx.fillText(amPm, centerX - (centerX * 0.55), centerY - (centerY * 0.09));
		}
    }
     
    Connections {
        target: wallClock
        onTimeChanged: rootitem.requestPaint()
	}
}
