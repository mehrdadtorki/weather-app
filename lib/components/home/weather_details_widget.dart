import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';
import 'package:weather_app/logic/home/weather_bloc.dart';
import 'package:weather_app/logic/home/weather_state.dart';

class WeatherDetails extends StatelessWidget {
  const WeatherDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        final isLoading = state is WeatherLoading || state is WeatherInitial;

        double precipitation = 0;
        double windSpeed = 0;
        String cloudCover = '0';

        if (state is WeatherLoaded) {
          final weather = state.weather;
          precipitation = weather.precipitation;
          windSpeed = weather.windSpeed;
          cloudCover = weather.cloudCover.toString();
        }

        // Define weather items
        final List<Map<String, dynamic>> weatherItems = [
          {'icon': 'assets/images/heavyRain.png', 'value': isLoading ? null : '$precipitation mm'},
          {'icon': 'assets/images/wind.png', 'value': isLoading ? null : '$windSpeed km/h'},
          {'icon': 'assets/images/sun.png', 'value': isLoading ? null : '$cloudCover %'},
        ];

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weatherItems
                .map(
                  (item) => _WeatherDetailItem(
                    iconPath: item['icon'],
                    value: item['value'],
                    isLoading: isLoading,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class _WeatherDetailItem extends StatelessWidget {
  final String iconPath;
  final String? value;
  final bool isLoading;

  const _WeatherDetailItem({required this.iconPath, required this.value, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isLoading
            ? SkeletonLine(
                style: SkeletonLineStyle(
                  width: 50,
                  height: 50,
                  borderRadius: BorderRadius.circular(12),
                ),
              )
            : Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4.0, offset: Offset(3, 3)),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(iconPath, width: 50, height: 50, fit: BoxFit.cover),
              ),
        const SizedBox(height: 8),
        isLoading
            ? SkeletonLine(style: SkeletonLineStyle(width: 50, height: 20))
            : Text(
                value ?? '',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ],
    );
  }
}
