String getWeatherConditionFromCode(int code) {
  const Map<String, List<int>> conditionMap = {
    'Clear sky': [0],
    'Cloudy': [1, 2, 3],
    'Fog': [45, 48],
    'Drizzle': [51, 53, 55],
    'Freezing Drizzle': [56, 57],
    'Rain': [61, 63, 65],
    'Freezing Rain': [66, 67],
    'Snowfall': [71, 73, 75],
    'Snow Grains': [77],
    'Rain Showers': [80, 81, 82],
    'Snow Showers': [85, 86],
    'Thunderstorm': [95],
    'Thunderstorm with Hail': [96, 99],
  };

  for (final entry in conditionMap.entries) {
    if (entry.value.contains(code)) {
      return entry.key;
    }
  }

  return 'Unknown';
}
