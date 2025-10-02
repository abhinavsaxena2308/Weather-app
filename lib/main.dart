import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'weather_service.dart';
import 'widgets.dart';
import 'weather_model.dart';

void main() {
  runApp(const SkyGradientApp());
}

class SkyGradientApp extends StatelessWidget {
  const SkyGradientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SkyGradient Weather",
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final WeatherService _service = WeatherService();
  WeatherData? _weather;
  bool _loading = false;

  late AnimationController _animController;
  late Animation<Color?> _colorAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(seconds: 8))
      ..repeat(reverse: true);
    _colorAnim = ColorTween(begin: Colors.deepPurple, end: Colors.purpleAccent).animate(_animController);
  }

  Future<void> _search() async {
    final city = _controller.text.trim();
    if (city.isEmpty) return;

    setState(() => _loading = true);
    final data = await _service.fetchWeather(city);
    setState(() {
      _weather = data;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_colorAnim.value!, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Text("SkyGradient Weather",
                          style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 6),
                      Text("Your aesthetic weather companion",
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.white70)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Enter city... ",
                                hintStyle: const TextStyle(color: Colors.white60),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onSubmitted: (_) => _search(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: _loading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Icon(Icons.search, color: Colors.white),
                            onPressed: _loading ? null : _search,
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (_weather != null) WeatherCard(weather: _weather!),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
