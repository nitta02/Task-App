import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:taskie_app/box/database_box.dart';
import 'package:taskie_app/models/task_model.dart';

class HeatCalendar extends StatefulWidget {
  const HeatCalendar({super.key});

  @override
  State<HeatCalendar> createState() => _HeatCalendarState();
}

class _HeatCalendarState extends State<HeatCalendar> {
  final taskDetails = TextEditingController();
  double? customHeight, customWidth;
  bool isdone = false;
  final DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return HeatMapCalendar(
      // borderRadius: 30,
      datasets: {
        // DateTime(2023, 8, 24): 5,
        // DateTime(2023, 8, 25): 4,
        DateTime(2023, 8, 26): 1,
        DateTime(2023, 8, 27): 2,
        // DateTime(2023, 8, 28): 6,
        DateTime(2023, 8, 29): 3,
        // DateTime(2023, 8, 30): 8,
      },

      textColor: Colors.black,
      weekTextColor: Colors.black,
      monthFontSize: 20,
      // startDate: DateTime.now(),
      // size: 45,
      // endDate: DateTime.now().add(Duration(days: 30)),
      colorMode: ColorMode.opacity,
      // showText: false,
      // scrollable: true,
      colorsets: const {
        1: Color.fromRGBO(20, 2, 179, 8),
        2: Color.fromRGBO(40, 2, 179, 8),
        3: Color.fromRGBO(64, 10, 171, 0.973),
        4: Color.fromRGBO(80, 2, 179, 8),
        5: Color.fromRGBO(100, 2, 179, 8),
        6: Color.fromRGBO(120, 2, 179, 8),
        7: Color.fromRGBO(140, 2, 179, 8),
        8: Color.fromRGBO(160, 2, 179, 8),
        9: Color.fromRGBO(180, 2, 179, 8),
        10: Color.fromRGBO(200, 2, 179, 8),
      },
      onClick: (value) async {
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(value.toString())));
        await customShowDialog();
      },
    );
  }

  Future<void> customShowDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ADD NEW TASK?'),
          backgroundColor: Colors.white,
          content: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              hintText: 'NEW TASK',
            ),
            controller: taskDetails,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final data = TaskModel(
                      task: taskDetails.text,
                      isDone: isdone,
                      dateTime: dateTime,
                    );

                    final box = DataBaseBox.getData();
                    box.add(data);

                    data.save();

                    // print(box);
                    taskDetails.clear();

                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
