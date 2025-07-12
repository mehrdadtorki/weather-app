import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/components/home/weather_widget.dart';
import 'package:weather_app/logic/home/weather_bloc.dart';
import 'package:weather_app/logic/home/weather_event.dart';
import 'package:weather_app/logic/home/weather_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherInitial) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<WeatherBloc>().add(
                    FetchDailyWeather(lat: 35.7, lon: 51.4),
                  );
                },
                child: const Text('Load Weather'),
              ),
            );
          } else if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoaded) {
            final w = state.weather;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WeatherWidget(),
                  Text(
                    '🕒 Time: ${w.currentTime}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text('🌡 Temperature: ${w.currentTemperature}°C'),
                  Text('🌤 Condition: ${w.getWeatherCondition()}'),
                  Text('💨 Wind: ${w.windSpeed} km/h'),
                  Text('🌧 Precipitation: ${w.precipitation} mm'),
                  Text('☁️ Cloud Cover: ${w.cloudCover}%'),
                  const SizedBox(height: 20),
                  const Text(
                    'Today\'s Forecast:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: w.todayHourly.length,
                      itemBuilder: (context, index) {
                        final hour = w.todayHourly[index];
                        return ListTile(
                          title: Text(hour.time),
                          subtitle: Text(
                            '${hour.temperature}°C - ${_getConditionFromCode(hour.weatherCode)}',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is WeatherError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  String _getConditionFromCode(int code) {
    if (code == 0) return 'Sunny';
    if ([1, 2, 3].contains(code)) return 'Cloudy';
    if ([61, 63, 65].contains(code)) return 'Rainy';
    return 'Unknown';
  }
}
