import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/weather_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch weather data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false).fetchWeatherData();
    });
  }

  String _getWeatherIcon(String iconCode) {
    // Simple mapping for weather icons using FontAwesome (requires font_awesome_flutter)
    // For production, use a weather icons package or download SVG from OpenWeatherMap
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
        return 'snowy'; // FaSnowflake
      default:
        return 'unknown'; // FaQuestion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (weatherProvider.error != null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weatherProvider.error!,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        weatherProvider.clearError();
                        weatherProvider.fetchWeatherData();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final currentWeather = weatherProvider.currentWeather;
          if (currentWeather == null) {
            return const Scaffold(
              body: Center(child: Text('No weather data available')),
            );
          }

          // Gradient background based on weather
          Color startColor = Colors.blue.shade400;
          Color endColor = Colors.cyan.shade300;
          if (currentWeather.description.contains('rain')) {
            startColor = Colors.indigo.shade700;
            endColor = Colors.blueGrey.shade600;
          } else if (currentWeather.description.contains('sun')) {
            startColor = Colors.orange.shade400;
            endColor = Colors.yellow.shade300;
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [startColor, endColor],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // City name
                  Text(
                    currentWeather.cityName,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Weather description
                  Text(
                    currentWeather.description.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Temperature card
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.thermostat,
                            size: 50,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${currentWeather.temperature.toInt()}°C',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Feels like ${currentWeather.feelsLike.toInt()}°C',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Other weather info row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoCard(
                        icon: FontAwesomeIcons.wind,
                        label: 'Wind',
                        value: '${currentWeather.windSpeed.toInt()} m/s',
                      ),
                      _buildInfoCard(
                        icon: FontAwesomeIcons.droplet,
                        label: 'Humidity',
                        value: '${currentWeather.humidity}%',
                      ),
                      _buildInfoCard(
                        icon: FontAwesomeIcons.eye,
                        label: 'Visibility',
                        value: '${currentWeather.visibility} km',
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Refresh button
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton.icon(
                      onPressed: () => weatherProvider.fetchWeatherData(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh Weather'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            FaIcon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// Note: For weather icons, consider adding weather_icons package or mapping OpenWeatherMap icons to SVG assets.
// Platform permissions for location are required (see location_service.dart comments).
// In the Column children, after the other weather info row, before Spacer():
const SizedBox(height: 30),
// Forecast navigation button
ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForecastScreen()),
    );
  },
  icon: const Icon(Icons.today, color: Colors.white),
  label: const Text(
    '5-Day Forecast',
    style: TextStyle(color: Colors.white),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    elevation: 0,
    shadowColor: Colors.transparent,
    side: const BorderSide(color: Colors.white30),
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
  ),
),
const SizedBox(height: 20),