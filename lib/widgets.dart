import 'package:flutter/material.dart';
import 'weather_model.dart';
import 'package:intl/intl.dart';

String weatherIcon(String code) {
  switch (code) {
    case '01d':
    case '01n':
      return '☀️';
    case '02d':
    case '02n':
      return '🌤';
    case '03d':
    case '03n':
    case '04d':
    case '04n':
      return '☁️';
    case '09d':
    case '09n':
      return '🌧';
    case '10d':
    case '10n':
      return '🌦';
    case '11d':
    case '11n':
      return '🌩';
    case '13d':
    case '13n':
      return '❄️';
    case '50d':
    case '50n':
      return '🌫';
    default:
      return '☁️';
  }
}

class WeatherCard extends StatelessWidget {
  final WeatherData weather;
  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main Weather Card
        Card(
          color: Colors.white.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(weather.city,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("${weather.temp.toStringAsFixed(1)}°C",
                    style: const TextStyle(
                        color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(weather.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 20)),
                const SizedBox(height: 12),
                Text("Humidity: ${weather.humidity}%", style: const TextStyle(color: Colors.white)),
                Text("Wind: ${weather.wind} m/s", style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // 7-Day Forecast Cards (horizontal scroll)
        SizedBox(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weather.forecast.length,
            itemBuilder: (context, index) {
              final day = weather.forecast[index];
              final dayName = DateFormat.E().format(day.date);
              return Container(
                width: 120,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(dayName, style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 6),
                    Text(weatherIcon(day.icon), style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 6),
                    Text("${day.tempMax.toInt()}°C / ${day.tempMin.toInt()}°C",
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(day.description,
                        style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
