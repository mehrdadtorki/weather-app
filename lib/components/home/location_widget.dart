import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart'; // ✅ Correct package
import 'package:weather_app/logic/home/weather_bloc.dart';
import 'package:weather_app/logic/home/weather_state.dart';
import '../../logic/location/location_bloc.dart';
import '../../logic/location/location_event.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<LocationBloc>().add(FetchUserLocation());

    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        final isLoading = state is WeatherLoading || state is WeatherInitial;

        String locationName = '';
        String latLngText = '';

        if (state is WeatherLoaded) {
          locationName = state.locationName;
          latLngText =
              'Lat: ${state.latitude.toStringAsFixed(4)}, Lng: ${state.longitude.toStringAsFixed(4)}';
        } else if (state is WeatherError) {
          locationName = state.message;
        }

        return Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isLoading
                        ? SkeletonLine(style: SkeletonLineStyle(width: 130, height: 35))
                        : Text(
                            locationName,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                    const SizedBox(height: 4),
                    isLoading
                        ? SkeletonLine(style: SkeletonLineStyle(width: 180, height: 25))
                        : Text(
                            latLngText,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                          ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Static Map or Image Placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: isLoading
                    ? SkeletonAvatar(style: SkeletonAvatarStyle(height: 140, width: 140))
                    : Image.asset(
                        'assets/images/map.png',
                        height: 140,
                        width: 140,
                        fit: BoxFit.cover,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
