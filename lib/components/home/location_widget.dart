import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  loc.LocationData? _locationData;
  final loc.Location _location = loc.Location();

  String? _locationName;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return;
      }

      var permissionGranted = await _location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) return;
      }

      final locationData = await _location.getLocation();

      setState(() {
        _locationData = locationData;
      });

      if (locationData.latitude != null && locationData.longitude != null) {
        final placemarks = await placemarkFromCoordinates(
          locationData.latitude!,
          locationData.longitude!,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          setState(() {
            _locationName = '${place.locality}, ${place.country}';
          });
        }
      }
    } catch (e) {
      setState(() {
        _locationName = 'Location unavailable';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _locationData == null || _locationName == null;

    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Location Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isLoading ? 'Locating...' : _locationName ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              if (_locationData != null)
                Text(
                  'Lat: ${_locationData!.latitude?.toStringAsFixed(4)}, '
                  'Lng: ${_locationData!.longitude?.toStringAsFixed(4)}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
            ],
          ),

          // Static Map Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/map.png',
              height: 140,
              width: 140,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
