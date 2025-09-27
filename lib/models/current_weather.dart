class CurrentWeather {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final double visibility;

  CurrentWeather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.visibility,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weather = (json['weather'] as List<dynamic>).first as Map<String, dynamic>;
    final coord = json['coord'] as Map<String, dynamic>?;

    return CurrentWeather(
      cityName: json['name'] ?? 'Unknown',
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      humidity: main['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      description: weather['description'] ?? 'Unknown',
      visibility: (json['visibility'] as num?)?.toDouble() ?? 10.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'main': {
        'temp': temperature.round(),
        'feels_like': feelsLike.round(),
        'humidity': humidity,
      },
      'wind': {'speed': windSpeed},
      'weather': [
        {'description': description},
      ],
      'visibility': visibility.round(),
    };
  }
}