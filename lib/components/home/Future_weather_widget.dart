import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart'; // Using skeletons package
import 'package:weather_app/logic/home/weather_bloc.dart';
import 'package:weather_app/logic/home/weather_state.dart';
import 'package:weather_app/utils/utils.dart';

class FutureWeather extends StatefulWidget {
  const FutureWeather({super.key});

  @override
  State<FutureWeather> createState() => _FutureWeatherState();
}

class _FutureWeatherState extends State<FutureWeather> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentHour(List<dynamic> hourlyWeather) {
    final index = hourlyWeather.indexWhere((item) => Utils.checkTime(item.time));
    if (index != -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final double itemWidth = 90; // estimated item width (with padding)
        final double screenWidth = MediaQuery.of(context).size.width;
        final double offset = itemWidth * index - screenWidth / 2 + itemWidth / 2;
        _scrollController.animateTo(
          offset.clamp(0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is! WeatherLoaded) {
          return SizedBox(height: 150, child: _buildLoadingSkeleton());
        }

        final hourlyWeather = state.weather.todayHourly;

        _scrollToCurrentHour(hourlyWeather);

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Today", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    "Next Hours >",
                    style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: hourlyWeather.length,
                  itemBuilder: (context, i) {
                    final item = hourlyWeather[i];
                    final isCurrentHour = Utils.checkTime(item.time);
                    final timeText = Utils.extractTime(item.time);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCurrentHour ? Colors.blue : Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              timeText,
                              style: TextStyle(
                                color: isCurrentHour ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset(
                              Utils.imageMap[Utils.getWeatherConditionFromCode(item.weatherCode)] ??
                                  Utils.imageMap['Unknown']!,
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              '${item.temperature}°',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isCurrentHour ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Horizontal skeleton loader
  Widget _buildLoadingSkeleton() {
    return SkeletonItem(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  SkeletonLine(style: SkeletonLineStyle(width: 30, height: 10)),
                  SkeletonAvatar(style: SkeletonAvatarStyle(width: 50, height: 50)),
                  SkeletonLine(style: SkeletonLineStyle(width: 20, height: 10)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
