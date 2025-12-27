/*
 * File name: location_service.dart
 * Location permission handling service
 */

import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

class LocationService extends GetxService {
  /// Check if location permission is granted
  Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();

    if (status.isDenied) {
      return false;
    } else if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // Open app settings if permanently denied
      openAppSettings();
      return false;
    }
    return false;
  }

  /// Check and request location permission if needed
  Future<bool> checkAndRequestLocationPermission() async {
    final isGranted = await isLocationPermissionGranted();

    if (isGranted) {
      return true;
    } else {
      return await requestLocationPermission();
    }
  }

  /// Request multiple permissions at once (location + fine location)
  Future<Map<Permission, PermissionStatus>> requestLocationPermissions() async {
    final statuses = await [
      Permission.location,
      Permission.locationWhenInUse,
    ].request();

    return statuses;
  }
}
