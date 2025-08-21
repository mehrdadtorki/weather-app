import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final loc.Location _location = loc.Location();

  LocationBloc() : super(LocationInitial()) {
    on<FetchUserLocation>((event, emit) async {
      emit(LocationLoading());

      try {
        bool serviceEnabled = await _location.serviceEnabled();
        if (!serviceEnabled) {
          serviceEnabled = await _location.requestService();
          if (!serviceEnabled) throw Exception('Location service disabled.');
        }

        var permissionGranted = await _location.hasPermission();
        if (permissionGranted == loc.PermissionStatus.denied) {
          permissionGranted = await _location.requestPermission();
          if (permissionGranted != loc.PermissionStatus.granted) {
            throw Exception('Location permission denied.');
          }
        }

        final locationData = await _location.getLocation();

        // final latitude = locationData.latitude!;
        // final longitude = locationData.longitude!;

        final latitude = 35.720071486642276;
        final longitude = 51.39228189520745;

        final placemarks = await placemarkFromCoordinates(latitude, longitude);
        final place = placemarks.first;

        final locationName = '${place.locality}, ${place.country}';

        emit(LocationLoaded(locationName: locationName, latitude: latitude, longitude: longitude));
      } catch (e) {
        emit(LocationError('Failed to get location: $e'));
      }
    });
  }
}
