import 'package:flutter/material.dart';
import '../models/current_weather.dart';
import '../models/forecast.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  CurrentWeather? _currentWeather;
  Forecast? _forecast;
  bool _isLoading = false;
  String? _error;

  CurrentWeather? get currentWeather => _currentWeather;
  Forecast? get forecast => _forecast;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();

  Future<void> fetchWeatherData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get location
      final position = await _locationService.getCurrentLocation();
      if (position == null) {
        _error = 'Unable to get location. Please check permissions.';
      } else {
        // Fetch current weather
        _currentWeather = await _weatherService.getCurrentWeather(
          position.latitude,
          position.longitude,
        );

        // Fetch forecast
        _forecast = await _weatherService.getForecast(
          position.latitude,
          position.longitude,
        );

        if (_currentWeather == null || _forecast == null) {
          _error = 'Failed to load weather data. Please check your internet connection.';
        }
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}