Arc {
    id: watchFace
    arccolor: '#000000'
    arctextcolor: '#ffffffff'
    arcsData: function() {
        return [
        {key:'hours', size: arcwidth*0.625, lineWidth: arcwidth * 0.18, colorCircle: '#000000'},
        {key:'minutes', size: arcwidth, lineWidth: arcwidth  * 0.18, colorCircle: '#000000', opacity: 0.85},
    ]

    }
    arctimefontsize: arcwidth * 0.1
}
