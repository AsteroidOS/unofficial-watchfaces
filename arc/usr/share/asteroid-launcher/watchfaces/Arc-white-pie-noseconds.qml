Arc {
    id: watchFace
    arctextbgz: 7
    arcsData: function() {return [
                              {key:'minutes', isPie: true, size: arcwidth, lineWidth: arcwidth  * 0.18, colorCircle: watchFace.arccolor, opacity: 0.85},
                              {key:'hours', isPie: true, size: arcwidth*0.625, lineWidth: arcwidth * 0.18, colorCircle: watchFace.arccolor},
                          ]}
    arctimefontsize: arcwidth * 0.1
}
