import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tarea_6/post/post.dart';

class Clima extends StatefulWidget {
  const Clima({super.key});

  @override
  State<Clima> createState() => _ClimaState();
}

var _ciudad = '', _temp = 0.00, _desc = '', _icon = '';

Future<void> actualizarDatos() async {
  
  double latitud = 15.75;
  double longitud = -86.78;
  String lang = 'sp';
  String units = 'metric';

  var url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
    'lat': '$latitud',
    'lon': '$longitud',
    'lang': lang,
    'units': units,
    'appid': '3e4b42a80ce129bc972ff5454ef6bb5c',
  });

  try {
    var jsonPost = await http.get(url);
    if (jsonPost.statusCode == 200) {
      final posts = postFromJson(jsonPost.body);
      _ciudad = posts.name;
      _temp = posts.main.temp;
      _desc = posts.weather[0].description;
      _icon = posts.weather[0].icon;
    } else {
      print(
          'No se pudo conectar con el servidor, Codigo: ${jsonPost.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

class _ClimaState extends State<Clima> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 5), (Timer timer) {
      actualizarDatos();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            color: Colors.blue,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: const Text(
              'El Clima',
              style: TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Align(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Ciudad:', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 5),
                  Text(_ciudad, style: const TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Temperatura:', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 5),
                  Text('$_temp °C', style: const TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Descripción:', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 5),
                  Text(_desc, style: const TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 10),
              Image.network(
                'https://openweathermap.org/img/wn/$_icon.png',
                width: 80,
                height: 80,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await actualizarDatos();
                },
                child: const Text('Refrescar'),
                ),
            ],
          )),
        )
      ]),
    );
  }
}
