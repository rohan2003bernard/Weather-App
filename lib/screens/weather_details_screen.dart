import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';

class WeatherDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherData = Provider.of<WeatherProvider>(context).weatherData;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontFamily: 'SF-Pro-Rounded',
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
        backgroundColor: Color(0xFF3A8FDE),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              final provider =
                  Provider.of<WeatherProvider>(context, listen: false);
              await provider.fetchWeather(weatherData!['name']);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFF97DA91), Color(0xFF073E55)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Text(
                  weatherData?['name'],
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'SF-Pro-Display',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '${weatherData?['main']['temp']}°C',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'SF-Pro-Display',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  weatherData?['weather'][0]['description'],
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 16),
                Image.network(
                  'http://openweathermap.org/img/wn/${weatherData?['weather'][0]['icon']}@2x.png',
                ),
                SizedBox(height: 16),
                Text(
                  'Humidity: ${weatherData?['main']['humidity']}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'SF-Pro-Text',
                    fontWeight: FontWeight.w300,
                    height: 0,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Wind Speed: ${weatherData?['wind']['speed']} m/s',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'SF-Pro-Text',
                    fontWeight: FontWeight.w300,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
