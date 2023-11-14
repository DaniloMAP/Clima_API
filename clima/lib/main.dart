import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicativo de Clima',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String apiKey = 'c6ed25b27582a8b0bd05c70b931fe106';
  String city = 'São Paulo';
  double temperature = 0.0;
  TextEditingController cityController = TextEditingController();

  void updateWeather() {
    setState(() {
      city = cityController.text;
    });
    fetchWeather();
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  fetchWeather() async {
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=${Uri.encodeFull(city)}&appid=$apiKey&units=metric');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        temperature = data['main']['temp'];
      });
    } else {
      print('Erro ao buscar dados do clima.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima em $city'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.lightBlue, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'Digite uma cidade',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  onSubmitted: (_) => updateWeather(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateWeather,
                child: Text('Verificar Clima'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  onPrimary: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Temperatura: $temperature °C',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 20),
              Icon(
                Icons.cloud, // Ícone de nuvem como exemplo
                size: 50,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
