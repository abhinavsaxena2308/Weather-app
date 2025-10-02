class ForecastDay {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final String description;
  final String icon;

  ForecastDay({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.description,
    required this.icon,
  });
}

class WeatherData {
  final String city;
  final double temp;
  final String description;
  final int humidity;
  final double wind;
  final List<ForecastDay> forecast;

  WeatherData({
    required this.city,
    required this.temp,
    required this.description,
    required this.humidity,
    required this.wind,
    required this.forecast,
  });
}
