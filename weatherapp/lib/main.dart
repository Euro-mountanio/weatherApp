import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(0, 38, 59, 176)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter project '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _TemperatureHumidityDisplayState();
}

class _TemperatureHumidityDisplayState extends State<MyHomePage> {
  double temperature = 0.0;
  double humidity = 0.0;
  bool isLoading = false;
  Map<String, dynamic>? weatherData;

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final jsondata = await http.get(Uri.parse(
          'http://172.16.60.155:8015/api/show_temperature')); // Replace with your API endpoint

      if (jsondata.statusCode == 200) {
        final data = jsonDecode(jsondata.body);
        temperature = data['temperature'];
        humidity = data['humidity'];
        weatherData = jsonDecode(jsondata.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Weather '),
        backgroundColor: const Color.fromARGB(9, 32, 99, 200),
      ),
      body: Center(
          child: Container(
        color: Colors.blue,
        width: 400,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  Text(
                    'Temperature: ${temperature.toStringAsFixed(2)} °C',
                    style: const TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Humidity: ${humidity.toStringAsFixed(2)} %',
                    style: const TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
          ],
        ),
      )),
    );
  }
}
