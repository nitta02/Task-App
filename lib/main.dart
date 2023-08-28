import 'package:flutter/material.dart';
import 'package:taskie_app/pages/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.amberAccent,
          titleSpacing: 1.8,
        ),
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomePage(),
    );
  }
}
