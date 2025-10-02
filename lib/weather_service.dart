import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_model.dart';

class WeatherService {
  final String apiKey = "YOUR_API_KEY"; // Replace with your API key
  final String baseUrl = "https://api.openweathermap.org/data/2.5";

  Future<WeatherData?> fetchWeather(String city) async {
    try {
      // Current weather
      final currentResp = await http.get(Uri.parse(
          "$baseUrl/weather?q=$city&appid=$apiKey&units=metric"));
      if (currentResp.statusCode != 200) return null;
      final currentData = jsonDecode(currentResp.body);

      // Forecast (5-day, 3-hour)
      final forecastResp = await http.get(Uri.parse(
          "$baseUrl/forecast?q=$city&appid=$apiKey&units=metric"));
      if (forecastResp.statusCode != 200) return null;
      final forecastData = jsonDecode(forecastResp.body);

      // Convert 3-hour data to daily forecast (7 days max)
      final List<ForecastDay> forecastList = [];
      final Map<String, ForecastDay> dailyMap = {};

      for (var item in forecastData['list']) {
        final dt = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        final dayKey = "${dt.year}-${dt.month}-${dt.day}";
        final temp = (item['main']['temp'] as num).toDouble();
        final tempMax = (item['main']['temp_max'] as num).toDouble();
        final tempMin = (item['main']['temp_min'] as num).toDouble();
        final desc = item['weather'][0]['main'];
        final icon = item['weather'][0]['icon'];

        if (!dailyMap.containsKey(dayKey)) {
          dailyMap[dayKey] = ForecastDay(
            date: dt,
            tempMax: tempMax,
            tempMin: tempMin,
            description: desc,
            icon: icon,
          );
        } else {
          // Update max/min if needed
          final existing = dailyMap[dayKey]!;
          dailyMap[dayKey] = ForecastDay(
            date: dt,
            tempMax: tempMax > existing.tempMax ? tempMax : existing.tempMax,
            tempMin: tempMin < existing.tempMin ? tempMin : existing.tempMin,
            description: desc,
            icon: icon,
          );
        }
      }

      forecastList.addAll(dailyMap.values.take(7));

      return WeatherData(
        city: currentData['name'],
        temp: (currentData['main']['temp'] as num).toDouble(),
        description: currentData['weather'][0]['main'],
        humidity: currentData['main']['humidity'],
        wind: (currentData['wind']['speed'] as num).toDouble(),
        forecast: forecastList,
      );
    } catch (e) {
      print("Error fetching weather: $e");
      return null;
    }
  }
}
