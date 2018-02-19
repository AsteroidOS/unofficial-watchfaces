Arc {
    id: watchFace
    arctextbgz: 7
    arcsData: function() {return [
                              {key:'seconds', isPie: true, size: arcwidth, lineWidth: arcwidth * 0.12, colorCircle: watchFace.arccolor, opacity: 0.6},
                              {key:'minutes', isPie: true, size: arcwidth*0.75, lineWidth: arcwidth  * 0.12, colorCircle: watchFace.arccolor, opacity: 0.7},
                              {key:'hours', isPie: true, size: arcwidth*0.5, lineWidth: arcwidth * 0.12, colorCircle: watchFace.arccolor, opacity: 1},
                          ]}
}
