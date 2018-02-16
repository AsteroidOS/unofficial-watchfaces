Arc {
    id: watchFace
    arctextbgz: 7
    arccolor: '#000000'
    arctextcolor: '#ffffffff'
    arcsData: function() {return [
                              {key:'seconds', isPie: true, size: arcwidth, lineWidth: arcwidth * 0.12, colorCircle: '#000000', opacity: 0.7},
                              {key:'minutes', isPie: true, size: arcwidth*0.75, lineWidth: arcwidth  * 0.12, colorCircle: '#000000', opacity: 0.85},
                              {key:'hours', isPie: true, size: arcwidth*0.5, lineWidth: arcwidth * 0.12, colorCircle: '#000000', opacity: 1},
                          ]}
}
