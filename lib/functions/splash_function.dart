import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taskie_app/pages/home_screen.dart';

class Utils {
  void splashFunctions(BuildContext context) {
    Timer(
        const Duration(
          seconds: 5,
        ), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
    });
  }
}
