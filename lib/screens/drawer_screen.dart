import 'package:flutter/material.dart';
import 'package:taskie_app/pages/home_screen.dart';
import 'package:taskie_app/screens/performance_screen.dart';
import 'package:taskie_app/widgets/heat_calendar.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueAccent.shade100,
      child: ListView(
        children: [
          ListTile(
            title: const Text(
              'HOME',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: const Icon(Icons.auto_graph),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ));
            },
          ),
          ListTile(
            title: const Text(
              'Performance Calendar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: const Icon(Icons.auto_graph),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PerformanceScreen(),
                  ));
            },
          )
        ],
      ),
    );
  }
}
