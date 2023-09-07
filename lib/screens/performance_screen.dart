import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:taskie_app/box/database_box.dart';
import 'package:taskie_app/models/task_model.dart';
import 'package:taskie_app/screens/drawer_screen.dart';
import 'package:taskie_app/widgets/custom_text.dart';
import 'package:taskie_app/widgets/heat_calendar.dart';
import 'package:velocity_x/velocity_x.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  DateTime focusDateTime = DateTime.now();
  DateTime? selectedDate;

  late Future<String?> startDateFuture;
  late Map<DateTime, int> datasets;

  final boxOpen = Hive.openBox<TaskModel>('taskie_app');

  @override
  void initState() {
    super.initState();
    selectedDate = focusDateTime;
    startDateFuture = _loadStartDate();
  }

  Future<String?> _loadStartDate() async {
    final box = await boxOpen;
    return box.get('dateTime') as String?;
  }

  Future<void> _loadDatasets() async {
    final box = await boxOpen;
    final taskList = box.values.toList();
    datasets = _convertToHeatMapData(taskList);
    setState(() {});
  }

  Map<DateTime, int> _convertToHeatMapData(List<TaskModel> taskList) {
    final Map<DateTime, int> data = {};
    // Your logic to convert taskList to data map
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerScreen(),
      appBar: AppBar(
        title: titleItem(),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              5.heightBox,
              FutureBuilder<String?>(
                future: startDateFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return FutureBuilder<void>(
                      future: _loadDatasets(),
                      builder: (context, datasetSnapshot) {
                        if (datasetSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (datasetSnapshot.hasError) {
                          return Text('Error: ${datasetSnapshot.error}');
                        } else {
                          final startDate = snapshot.data ?? '';
                          return MonthlySummary(
                            datasets: datasets,
                            startDate: startDate,
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleItem() {
    return const Row(
      children: [
        CustomText(
          text: 'PERFORMANCE CALENDAR',
        ),
      ],
    );
  }
}
