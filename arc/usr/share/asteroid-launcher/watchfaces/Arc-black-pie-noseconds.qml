Arc {
    id: watchFace
    arctextbgz: 7
    arccolor: '#000000'
    arctextcolor: '#ffffffff'
    arcsData: function() {return [
                              {key:'minutes', isPie: true, size: arcwidth, lineWidth: arcwidth  * 0.18, colorCircle: '#000000', opacity: 0.85},
                              {key:'hours', isPie: true, size: arcwidth*0.625, lineWidth: arcwidth * 0.18, colorCircle: '#000000', opacity: 1},
                          ]}
    arctimefontsize: arcwidth * 0.1
}
