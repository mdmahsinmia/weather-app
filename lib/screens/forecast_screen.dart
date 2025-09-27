import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/weather_provider.dart';
import '../models/forecast.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  String _getWeatherIcon(String iconCode) {
    // Reuse the same icon mapping as in home_screen
    switch (iconCode[0]) {
      case '0':
        return 'sunny'; // FaSun
      case '1':
      case '2':
        return 'partly_cloudy'; // FaCloudSun
      case '3':
      case '4':
        return 'cloudy'; // FaCloud
      case '5':
      case '6':
      case '8':
        return 'rainy'; // FaCloudRain
      case '7':
        return 'foggy'; // FaSmog
      case '9':
      case 'a':
      case 'b':
        return 'thunderstorm'; // FaBolt
      case 'd':
      case 'f':
        return 'snowy'; // FaSnowflake
      default:
        return 'unknown'; // FaQuestion
    }
  }

  Widget _getIcon(String iconCode) {
    switch (_getWeatherIcon(iconCode)) {
      case 'sunny':
        return const FaIcon(FontAwesomeIcons.sun, color: Colors.orange, size: 30);
      case 'partly_cloudy':
        return const FaIcon(FontAwesomeIcons.cloudSun, color: Colors.yellow, size: 30);
      case 'cloudy':
        return const FaIcon(FontAwesomeIcons.cloud, color: Colors.grey, size: 30);
      case 'rainy':
        return const FaIcon(FontAwesomeIcons.cloudRain, color: Colors.blue, size: 30);
      case 'foggy':
        return const FaIcon(FontAwesomeIcons.smog, color: Colors.grey, size: 30);
      case 'thunderstorm':
        return const FaIcon(FontAwesomeIcons.bolt, color: Colors.yellow, size: 30);
      case 'snowy':
        return const FaIcon(FontAwesomeIcons.snowflake, color: Colors.lightBlue, size: 30);
      default:
        return const FaIcon(FontAwesomeIcons.question, color: Colors.grey, size: 30);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('5-Day Forecast'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (weatherProvider.error != null || weatherProvider.forecast == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(weatherProvider.error ?? 'No forecast data available'),
                  ElevatedButton(
                    onPressed: () => weatherProvider.fetchWeatherData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final forecast = weatherProvider.forecast!;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF74B9FF),
                  Color(0xFF0984E3),
                ],
              ),
            ),
            child: SafeArea(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: forecast.daily.length,
                itemBuilder: (context, index) {
                  final day = forecast.daily[index];
                  return Card(
                    elevation: 6,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Day and Icon
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  day.formattedDate,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _getIcon(day.iconCode),
                              ],
                            ),
                          ),
                          // Temperatures and Details
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${day.maxTemp.toInt()}°',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      ' / ',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      '${day.minTemp.toInt()}°',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  day.description,
                                  style: const TextStyle(color: Colors.white70),
                                  textAlign: TextAlign.end,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildDetailChip(
                                      icon: FontAwesomeIcons.wind,
                                      value: '${day.windSpeed.toInt()} m/s',
                                    ),
                                    _buildDetailChip(
                                      icon: FontAwesomeIcons.droplet,
                                      value: '${day.humidity}%',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailChip({required IconData icon, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}