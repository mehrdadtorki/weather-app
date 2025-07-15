import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/services/weather_services.dart';

import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherServices weatherService;

  WeatherBloc(this.weatherService) : super(WeatherInitial()) {
    on<FetchDailyWeather>((event, emit) async {
      emit(WeatherLoading());
      try {
        final response = await weatherService.fetchCombinedWeather(
          latitude: event.lat,
          longitude: event.lon,
        );

        print('✅ API response: $response');

        final model = WeatherModel.fromJson(response);
        emit(WeatherLoaded(model));
      } catch (e) {
        emit(WeatherError('Failed to fetch weather: $e'));
      }
    });
  }
}
