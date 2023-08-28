import 'package:flutter/material.dart';
import 'package:taskie_app/pages/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  var box = await Hive.openBox('taskie_app');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Phudu-Regular',
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
