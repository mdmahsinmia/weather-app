import 'package:intl/intl.dart';

class DailyForecast {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final double tempDay;
  final int humidity;
  final double windSpeed;
  final String description;
  final String iconCode;
  final double pressure;

  DailyForecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.tempDay,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.iconCode,
    required this.pressure,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['dt_txt']);
    return DailyForecast(
      date: date,
      tempMin: (json['main']['temp_min'] ?? 0).toDouble(),
      tempMax: (json['main']['temp_max'] ?? 0).toDouble(),
      tempDay: (json['main']['temp'] ?? 0).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      iconCode: json['weather'][0]['icon'] ?? '',
      pressure: json['main']['pressure'] ?? 0,
    );
  }

  String get formattedDate => DateFormat('MMM dd').format(date);

  Map<String, dynamic> toJson() {
    return {
      'dt_txt': date.toIso8601String(),
      'main': {
        'temp_min': tempMin,
        'temp_max': tempMax,
        'temp': tempDay,
        'humidity': humidity,
        'pressure': pressure,
      },
      'wind': {'speed': windSpeed},
      'weather': [
        {'description': description, 'icon': iconCode}
      ],
    };
  }
}

class Forecast {
  final List<DailyForecast> dailyForecasts;

  Forecast({required this.dailyForecasts});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final List<DailyForecast> forecasts = [];
    final list = json['list'] as List<dynamic>;
    for (var item in list) {
      // Filter for daily forecasts (every 24h, starting from day)
      if (item['dt_txt'].toString().contains(' 12:00:00')) { // Midday for daily
        forecasts.add(DailyForecast.fromJson(item));
      }
    }
    return Forecast(dailyForecasts: forecasts);
  }

  Map<String, dynamic> toJson() {
    return {
      'list': dailyForecasts.map((f) => f.toJson()).toList(),
    };
  }
}