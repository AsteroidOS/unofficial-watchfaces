Arc {
    id: watchFace

    arcsData: function() {
        return [
        {key:'hours', size: arcwidth*0.625, lineWidth: arcwidth * 0.18, colorCircle: watchFace.arccolor},
        {key:'minutes', size: arcwidth, lineWidth: arcwidth  * 0.18, colorCircle: watchFace.arccolor, opacity: 0.85},
    ]

    }
    arctimefontsize: arcwidth * 0.1
}
