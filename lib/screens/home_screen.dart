import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskie_app/functions/box/database_box.dart';
import 'package:taskie_app/models/task_model.dart';
import 'package:taskie_app/screens/drawer_screen.dart';
import 'package:taskie_app/widgets/custom_container.dart';
import 'package:taskie_app/widgets/custom_text.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? customHeight, customWidth;
  bool isdone = false;
  final DateTime dateTime = DateTime.now();
  final boxOpen = Hive.openBox<TaskModel>('taskie_app');
  final taskDetails = TextEditingController();
  DateTime focusdateTime = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;
  Map<DateTime, List<TaskModel>> events = {};
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = focusdateTime;
    updateCalendarEvents();
  }

  @override
  Widget build(BuildContext context) {
    customHeight = MediaQuery.of(context).size.height;
    customWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const DrawerScreen(),
      appBar: AppBar(
        elevation: 0.0,
        title: titleItem(),
        actions: [
          IconButton(
              onPressed: () {
                customShowDialog();
              },
              icon: const Icon(
                Icons.add_box,
              ))
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: customHeight! * 0.01,
          vertical: customWidth! * 0.015,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [],
            // ),
            5.heightBox,
            // taskDATELists(),
            // Container(
            //     padding: EdgeInsets.symmetric(
            //       horizontal: customHeight! * 0.03,
            //       vertical: customWidth! * 0.005,
            //     ),
            //     child: const HeatCalendar()),
            tableCalendarWidget(),
            10.heightBox,
            titleItem2(),
            10.heightBox,
            tasksItem(),
          ],
        ),
      )),
    );
  }

  Widget titleItem() {
    return Row(
      children: [
        const CustomText(
          text: 'DATE',
        ),
        15.widthBox,
        CustomText(
            text:
                '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}')
      ],
    );
  }

  Widget taskDATELists() {
    return CustomContainer(
      height: customHeight! * 0.3,
      width: customWidth! * 0.95,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              text: dateTime.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget titleItem2() {
    return const CustomText(
      text: 'TODAY TASKS',
    );
  }

  Widget tasksItem() {
    return Expanded(
      child: ValueListenableBuilder<Box<TaskModel>>(
        valueListenable: DataBaseBox.getData().listenable(),
        builder: (context, value, child) {
          updateCalendarEvents();
          // var data = value.values.toList().cast<TaskModel>();
          final selectedTasks = events[selectedDate] ?? [];
          return ListView.builder(
            itemCount: selectedTasks.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5.0,
                margin: const EdgeInsets.all(10.0),
                child: Slidable(
                  endActionPane:
                      ActionPane(motion: const StretchMotion(), children: [
                    SlidableAction(
                      backgroundColor: Colors.red,
                      flex: 5,
                      onPressed: (context) async {
                        deleteTask(selectedTasks[index]);
                      },
                      icon: Icons.delete,
                    )
                  ]),
                  child: ListTile(
                    title: Text(
                      selectedTasks[index].task.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    leading: IconButton(
                      onPressed: () {
                        setState(() {
                          isdone = !isdone;
                        });
                      },
                      icon: Icon(
                        isdone
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                      ),
                    ),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text('OPTIONS'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await editTask(selectedTasks[index],
                                      selectedTasks[index].task.toString());
                                },
                                style: const ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                  Colors.grey,
                                )),
                                child: const Text(
                                  'EDIT',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // TextButton(
                              //   onPressed: () {
                              //     deleteTask(data[index]);
                              //     Navigator.pop(context);
                              //   },
                              //   child: const Text('DELETE'),
                              // )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget tableCalendarWidget() {
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
                  onPressed: () async {
                    if (taskDetails.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Required Task Details')),
                      );
                      Navigator.pop(context);
                    } else {
                      addTaskToCalendar(
                        selectedDate!,
                        taskDetails.text,
                        isdone,
                      );

                      // print(box);
                      taskDetails.clear();

                      Navigator.pop(context);
                    }
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

  void deleteTask(TaskModel taskModel) async {
    final box = DataBaseBox.getData();
    await box.delete(taskModel);
    taskModel.delete();
  }

  Future<void> editTask(TaskModel taskModel, String task) async {
    taskDetails.text = task;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('EDIT'),
          backgroundColor: Colors.white,
          content: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
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
                  onPressed: () async {
                    taskModel.task = taskDetails.text.toString();
                    taskModel.save();

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

  Future<void> addTaskToCalendar(
      DateTime date, String taskDetails, bool isDone) async {
    final data = TaskModel(
      task: taskDetails,
      isDone: isDone,
      dateTime: date,
    );

    final box = await boxOpen;
    await box.add(data);
    data.save();
  }

  void updateCalendarEvents() {
    final box = DataBaseBox.getData();
    final tasks = box.values.toList().cast<TaskModel>();

    events.clear();

    for (final task in tasks) {
      final taskDate = task.dateTime;
      if (!events.containsKey(taskDate)) {
        events[taskDate] = [];
      }
      events[taskDate]!.add(task);
    }
  }
}
