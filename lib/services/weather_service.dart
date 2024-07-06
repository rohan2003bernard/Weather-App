import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const _apiKey = '083c571257bd499dff906a31f9de5355';
  static const _baseUrl = 'http://api.openweathermap.org/data/2.5/weather';

  static Future<Map<String, dynamic>> fetchWeather(String city) async {
    final response = await http
        .get(Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
