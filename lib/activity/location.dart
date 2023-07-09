import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<Position> getUserLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are disabled, handle it accordingly
    return Future.error('Location services are disabled.');
  }

  // Check for location permission
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    // Location permissions are permanently denied, handle it accordingly
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  if (permission == LocationPermission.denied) {
    // Request location permissions
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      // Location permissions are denied, handle it accordingly
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }

  // Get current position
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  return position;
}

Future<String> getCityName(Position position) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark placemark = placemarks.first;
    return placemark.locality ?? 'Unknown City';
  } catch (e) {
    return 'Could not fetch city name';
  }
}
