import 'package:flutter/material.dart';
import 'package:app_sonoro/screens/login_screen.dart';
import 'package:app_sonoro/screens/home_screen.dart';
import 'package:app_sonoro/screens/chart_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detector Sonoro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/chart': (context) => ChartScreen(),
      },
    );
  }
}
