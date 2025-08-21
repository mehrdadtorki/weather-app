import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/components/home/Future_weather_widget.dart';
import 'package:weather_app/components/home/location_widget.dart';
import 'package:weather_app/components/home/weather_details_widget.dart';
import 'package:weather_app/components/home/weather_widget.dart';
import 'package:weather_app/logic/home/weather_bloc.dart';
import 'package:weather_app/logic/home/weather_event.dart';
import 'package:weather_app/logic/home/weather_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hasFetched) {
      context.read<WeatherBloc>().add(FetchDailyWeather(lat: 24.7, lon: 17.4));
      hasFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: BeveledRectangleBorder(),
        shadowColor: Theme.of(context).colorScheme.shadow,
        leading: Icon(Icons.wb_sunny, color: Colors.grey.shade500),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: Colors.grey.shade500,
            onPressed: () {
              // Navigate to settings page
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.grey.shade500,
            onPressed: () {
              // Navigate to settings page
            },
          ),
        ],
        bottomOpacity: 0.5,
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading || state is WeatherInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  LocationWidget(),
                  SizedBox(height: 20),
                  WeatherWidget(),
                  SizedBox(height: 20),
                  WeatherDetails(),
                  SizedBox(height: 20),
                  FutureWeather(),
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
}
