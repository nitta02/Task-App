import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskie_app/models/task_model.dart';

class TableCalendarWidget extends StatefulWidget {
  const TableCalendarWidget({super.key});

  @override
  State<TableCalendarWidget> createState() => _TableCalendarWidgetState();
}

class _TableCalendarWidgetState extends State<TableCalendarWidget> {
  final taskDetails = TextEditingController();
  double? customHeight, customWidth;
  // bool isdone = false;
  DateTime focusdateTime = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;
  // Map<DateTime, List<TaskModel>> events = { };
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = focusdateTime;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: focusdateTime,
      calendarFormat: calendarFormat,
      onFormatChanged: (format) {
        if (calendarFormat != format) {
          setState(() {
            calendarFormat = format;
          });
        }
      },
      firstDay: DateTime(2000),
      lastDay: DateTime(2050),
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(selectedDate, selectedDay)) {
          setState(() {
            selectedDate = selectedDay;
            focusdateTime = focusedDay;
          });
        }
      },
      selectedDayPredicate: (day) {
        return isSameDay(selectedDate, day);
      },
      onPageChanged: (focusedDay) {
        focusdateTime = focusedDay;
      },
    );
  }
}
