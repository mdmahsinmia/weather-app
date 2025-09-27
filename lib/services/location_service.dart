import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable them.');
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied, we cannot request permissions.');
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 10));

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  // For production, handle platform-specific configurations in AndroidManifest.xml and Info.plist
  // Android: Add permissions in android/app/src/main/AndroidManifest.xml
  // <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  // <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
  // iOS: Add in ios/Runner/Info.plist
  // <key>NSLocationWhenInUseUsageDescription</key>
  // <string>This app needs location access to provide weather data.</string>
}