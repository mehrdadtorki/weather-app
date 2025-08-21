import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart'; // ✅ correct package
import 'package:weather_app/logic/home/weather_bloc.dart';
import 'package:weather_app/logic/home/weather_state.dart';
import 'package:weather_app/utils/utils.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        final isLoading = state is WeatherLoading || state is WeatherInitial;

        double temperature = 0;
        double feelsLike = 0;
        String weatherCondition = '';
        String currentTime = '';

        if (state is WeatherLoaded) {
          final weather = state.weather;
          temperature = weather.currentTemperature;
          feelsLike = weather.apparentTemperature;
          weatherCondition = weather.getWeatherCondition();
          currentTime = weather.currentTime;
        }

        return SizedBox(
          height: 200,
          child: isLoading
              ? SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 200,
                    width: MediaQuery.sizeOf(context).width,
                    borderRadius: BorderRadius.circular(30),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Background
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue.shade300, Colors.blue.shade500],
                          ),
                        ),
                      ),

                      // Weather image
                      Positioned(
                        left: 50,
                        top: -40,
                        child: Image.asset(
                          Utils.imageMap[weatherCondition] ?? Utils.imageMap[null]!,
                          width: 140,
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Temperature
                      Positioned(
                        right: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            isLoading
                                ? SkeletonListView()
                                : GradientText(
                                    '$temperature°',
                                    gradientDirection: GradientDirection.ttb,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Nunito',
                                      fontSize: 40,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    colors: [Colors.white, Colors.white70],
                                  ),
                            const SizedBox(height: 4),
                            isLoading
                                ? SkeletonListView()
                                : Text(
                                    'Feels like $feelsLike°',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Nunito',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ],
                        ),
                      ),

                      // Condition & Time
                      Positioned(
                        left: 50,
                        bottom: 30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isLoading
                                ? SkeletonListView()
                                : Text(
                                    weatherCondition,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Nunito',
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                            const SizedBox(height: 4),
                            isLoading
                                ? SkeletonListView()
                                : Text(
                                    Utils.currentTime(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Nunito',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ],
                        ),
                      ),

                      // Windwave icon
                      Positioned(
                        right: 50,
                        bottom: 10,
                        child: isLoading
                            ? SkeletonListView()
                            : Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/windwave.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
