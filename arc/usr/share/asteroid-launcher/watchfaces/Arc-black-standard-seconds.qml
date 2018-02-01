Arc {
    id: watchFace
    arccolor: '#000000'
    arctextcolor: '#ffffffff'
    arcsData: function() {return [
                              {key:'hours', size: arcwidth*0.5, lineWidth: arcwidth * 0.12, colorCircle: '#000000', opacity: 1},
                              {key:'minutes', size: arcwidth*0.75, lineWidth: arcwidth  * 0.12, colorCircle: '#000000', opacity: 0.85},
                              {key:'seconds', size: arcwidth, lineWidth: arcwidth * 0.12, colorCircle: '#000000', opacity: 0.7},
                          ]}
}
