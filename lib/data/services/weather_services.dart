import '../api/api_client.dart';
import '../models/weather_model.dart';

class WeatherServices {
  final ApiClient _api = ApiClient();

  Future<Map<String, dynamic>> fetchCombinedWeather({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _api.get(
      query: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current_weather': 'true',
        'hourly':
            'temperature_2m,weathercode,cloudcover,precipitation,apparent_temperature,precipitation_probability',
        'timezone': 'auto',
      },
    );
    return response;
  }
}
