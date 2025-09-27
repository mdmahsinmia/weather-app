import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/current_weather.dart';
import '../models/forecast.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _apiKey = 'YOUR_OPENWEATHERMAP_API_KEY'; // Replace with your actual API key
  static const String _units = 'metric'; // For Celsius

  // Fetch current weather by city name or lat/lon
  Future<CurrentWeather?> getCurrentWeather(double? lat, double? lon) async {
    try {
      String url;
      if (lat != null && lon != null) {
        url = '$_baseUrl/weather?lat=$lat&lon=$lon&units=$_units&appid=$_apiKey';
      } else {
        throw Exception('Location coordinates are required');
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CurrentWeather.fromJson(data);
      } else {
        throw Exception('Failed to load current weather: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching current weather: $e');
      return null;
    }
  }

  // Fetch 5-day forecast by lat/lon
  Future<Forecast?> getForecast(double lat, double lon) async {
    try {
      final url = '$_baseUrl/forecast?lat=$lat&lon=$lon&units=$_units&appid=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Forecast.fromJson(data);
      } else {
        throw Exception('Failed to load forecast: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching forecast: $e');
      return null;
    }
  }

  // Instructions for user: To use this service, sign up for a free API key at https://openweathermap.org/api
  // Replace 'YOUR_OPENWEATHERMAP_API_KEY' with your actual key.
  // Make sure to handle API limits (1000 calls/day for free tier).
  // For production, consider storing the API key securely, e.g., in environment variables or flutter_dotenv.
}