// https://openweathermap.org/weather-conditions
var iconNameByOwmCode = {
    '200': 'ios-thunderstorm',
    '201': 'ios-thunderstorm',
    '202': 'ios-thunderstorm',
    '210': 'ios-thunderstorm',
    '211': 'ios-thunderstorm',
    '212': 'ios-thunderstorm',
    '221': 'ios-thunderstorm',
    '230': 'ios-thunderstorm',
    '231': 'ios-thunderstorm',
    '232': 'ios-thunderstorm',
    
    '300': 'ios-rainy',
    '301': 'ios-rainy',
    '302': 'ios-rainy',
    '310': 'ios-rainy',
    '311': 'ios-rainy',
    '312': 'ios-rainy',
    '313': 'ios-rainy',
    '314': 'ios-rainy',
    '321': 'ios-rainy',
    
    '500': 'ios-rainy',
    '501': 'ios-rainy',
    '502': 'ios-rainy',
    '503': 'ios-rainy',
    '504': 'ios-rainy',
    '511': 'ios-snow',
    '520': 'ios-rainy',
    '521': 'ios-rainy',
    '522': 'ios-rainy',
    '531': 'ios-rainy',
    
    '600': 'ios-snow',
    '601': 'ios-snow',
    '602': 'ios-snow',
    '611': 'ios-snow',
    '612': 'ios-snow',
    '615': 'ios-snow',
    '616': 'ios-snow',
    '620': 'ios-snow',
    '621': 'ios-snow',
    '622': 'ios-snow',
    
    '701': 'ios-cloudy',
    '711': 'ios-cloudy',
    '721': 'ios-cloudy',
    '731': 'ios-cloudy',
    '741': 'ios-cloudy',
    '751': 'ios-cloudy',
    '761': 'ios-cloudy',
    
    '800': 'ios-sunny',
    '801': 'ios-partly-sunny',
    '802': 'ios-cloudy',
    '803': 'ios-cloudy',
    '804': 'ios-cloudy',
    
    '903': 'ios-snow',
    '904': 'ios-flame',
    '905': 'ios-sunny',
    '906': 'ios-snow',
    
    '950': 'ios-sunny',
    '951': 'ios-sunny',
    '952': 'ios-sunny',
    '953': 'ios-sunny',
    '954': 'ios-sunny',
    '955': 'ios-sunny',
    '956': 'ios-sunny',
};

function getIconName(iconName) {
    var iconCodeParts = iconNameByOwmCode[iconName]
    if (!iconCodeParts)
        return 'ios-alert';
    return iconCodeParts
}

