import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatCalendar extends StatefulWidget {
  const HeatCalendar({super.key});

  @override
  State<HeatCalendar> createState() => _HeatCalendarState();
}

class _HeatCalendarState extends State<HeatCalendar> {
  @override
  Widget build(BuildContext context) {
    return HeatMapCalendar(
      borderRadius: 25,
      margin: EdgeInsets.all(5.0),
      
      datasets: {
        DateTime(2023, 8, 24): 5,
        DateTime(2023, 8, 25): 4,
        DateTime(2023, 8, 26): 1,
        DateTime(2023, 8, 27): 2,
        DateTime(2023, 8, 28): 10,
        DateTime(2023, 8, 29): 3,
        DateTime(2023, 8, 30): 6,
      },
      textColor: Colors.black,
      weekTextColor: Colors.black,
      monthFontSize: 25,
      // startDate: DateTime.now(),
      // size: 45,
      // endDate: DateTime.now().add(Duration(days: 30)),
      colorMode: ColorMode.opacity,
      // showText: false,
      // scrollable: true,
      colorsets: {
        1: Color.fromRGBO(20, 2, 179, 8),
        2: Color.fromRGBO(40, 2, 179, 8),
        3: Color.fromRGBO(60, 2, 179, 8),
        4: Color.fromRGBO(80, 2, 179, 8),
        5: Color.fromRGBO(100, 2, 179, 8),
        6: Color.fromRGBO(120, 2, 179, 8),
        7: Color.fromRGBO(140, 2, 179, 8),
        8: Color.fromRGBO(160, 2, 179, 8),
        9: Color.fromRGBO(180, 2, 179, 8),
        10: Color.fromRGBO(200, 2, 179, 8),
      },
      onClick: (value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value.toString())));
      },
    );
  }
}
