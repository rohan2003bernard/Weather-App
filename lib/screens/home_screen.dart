import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/screens/weather_details_screen.dart';

// Dummy list of city names for demonstration purposes
final List<String> cityNames = [
  'Chennai',
  'New York',
  'California',
  'Tokyo',
];

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _filteredCityNames = [];

  @override
  void initState() {
    super.initState();
    _filteredCityNames = cityNames;
  }

  void _filterCities(String query) {
    final filtered = cityNames
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredCityNames = filtered;
    });
  }

  Future<void> _searchCity() async {
    String city = _controller.text;
    if (city.isNotEmpty) {
      await Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeather(city);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherDetailsScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontFamily: 'SF-Pro-Rounded',
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
        backgroundColor: Color(0xFF3A8FDE),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFF97DA91), Color(0xFF073E55)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Enter city name',
                        labelStyle: TextStyle(
                          color: Color(0xFF726D6D),
                          fontSize: 20,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: _filterCities,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _searchCity,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredCityNames.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _filteredCityNames[index],
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'SF-Pro-Display',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      onTap: () async {
                        String city = _filteredCityNames[index];
                        await Provider.of<WeatherProvider>(context,
                                listen: false)
                            .fetchWeather(city);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeatherDetailsScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Consumer<WeatherProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return CircularProgressIndicator();
                  }
                  if (provider.errorMessage.isNotEmpty) {
                    return Text(provider.errorMessage);
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
