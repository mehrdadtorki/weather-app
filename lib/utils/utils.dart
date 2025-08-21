import 'package:intl/intl.dart';

class Utils {
  static String getWeatherConditionFromCode(int code) {
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

  static Map<dynamic, String> imageMap = {
    'Clear sky': 'assets/images/sun.png', // clear daytime
    'Cloudy': 'assets/images/sunSlowRain.png', // partly cloudy
    'Fog': 'assets/images/windWave.png', // fog/windy
    'Drizzle': 'assets/images/sunRaint.png', // light rain/drizzle
    'Freezing Drizzle': 'assets/images/sunHeavyRain.png', // heavier freezing drizzle
    'Rain': 'assets/images/heavyRain.png', // normal/heavy rain
    'Freezing Rain': 'assets/images/nightRain.png', // icy rain
    'Snowfall': 'assets/images/umbrella.png', // placeholder for snow
    'Snow Grains': 'assets/images/umbrella.png', // similar to snow
    'Rain Showers': 'assets/images/sunHeavyRain.png', // showers
    'Snow Showers': 'assets/images/umbrella.png', // placeholder
    'Thunderstorm': 'assets/images/thunder.png', // storm
    'Thunderstorm with Hail': 'assets/images/nightThunder.png', // hail/thunder
    'Unknown': 'assets/images/starCLear.png',
  };

  // formate date
  static String formateDate(DateTime date) {
    String formattedDate = DateFormat('EEEE d MMM').format(date);
    return formattedDate;
  }

  // extract date only
  static String extractDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('d').format(dateTime);
    return formattedDate;
  }

  static String extractDay(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('EEEE').format(dateTime);
    return formattedDate.substring(0, 3);
  }

  // formate time with am/pm
  static String formateTime(String time) {
    DateFormat dateFormat = DateFormat('hh:mm a');
    DateTime dateTime = DateTime.parse('2023-08-08T$time');
    String timeIn12HourFormat = dateFormat.format(dateTime);
    return timeIn12HourFormat;
  }

  //current time
  static String currentTime() {
    DateFormat dateFormat = DateFormat('hh:mm a');
    DateTime now = DateTime.now();
    String time = dateFormat.format(now);
    return time;
  }

  // formate time without
  static String formateTimeWithout(String time) {
    DateFormat dateFormat = DateFormat('hh:mm');
    DateTime dateTime = DateTime.parse('2023-08-08T$time');
    String timeIn12HourFormat = dateFormat.format(dateTime);
    return timeIn12HourFormat;
  }

  static bool checkTime(String time) {
    try {
      final parsedTime = DateFormat('HH:mm').parse(time);
      final now = DateTime.now();
      return parsedTime.hour == now.hour;
    } catch (_) {
      return false;
    }
  }

  static String extractTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat('HH:mm').format(dateTime); // 00:00 format
  }
}
