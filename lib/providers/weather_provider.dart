import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  Map<String, dynamic>? _weatherData;
  String _errorMessage = '';
  bool _isLoading = false;
  String? _lastSearchedCity;

  WeatherProvider() {
    _loadLastSearchedCity();
  }

  Map<String, dynamic>? get weatherData => _weatherData;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  String? get lastSearchedCity => _lastSearchedCity;

  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    notifyListeners();

    try {
      _weatherData = await WeatherService.fetchWeather(city);

      _saveLastSearchedCity(city);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveLastSearchedCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSearchedCity', city);
    _lastSearchedCity = city;
  }

  Future<void> _loadLastSearchedCity() async {
    final prefs = await SharedPreferences.getInstance();
    _lastSearchedCity = prefs.getString('lastSearchedCity');
    if (_lastSearchedCity != null) {
      await fetchWeather(_lastSearchedCity!);
    }
  }
}
