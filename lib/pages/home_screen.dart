import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskie_app/box/database_box.dart';
import 'package:taskie_app/models/task_model.dart';
import 'package:taskie_app/widgets/custom_container.dart';
import 'package:taskie_app/widgets/custom_text.dart';
import 'package:taskie_app/widgets/heat_calendar.dart';
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

  @override
  Widget build(BuildContext context) {
    customHeight = MediaQuery.of(context).size.height;
    customWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                titleItem(),
                IconButton(
                    onPressed: () {
                      customShowDialog();
                    },
                    icon: const Icon(
                      Icons.add_box,
                    ))
              ],
            ),
            10.heightBox,
            // taskDATELists(),
            Container(
                padding: EdgeInsets.symmetric(
                  horizontal: customHeight! * 0.03,
                  vertical: customWidth! * 0.005,
                ),
                child: const HeatCalendar()),
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
          var data = value.values.toList().cast<TaskModel>();
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(5.0),
                child: ListTile(
                  title: Text(
                    data[index].task.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        isdone = !isdone;
                      });
                    },
                    icon: Icon(
                      isdone ? Icons.check_box : Icons.check_box_outline_blank,
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
                                await editTask(
                                    data[index], data[index].task.toString());
                              },
                              child: const Text('EDIT'),
                            ),
                            TextButton(
                              onPressed: () {
                                deleteTask(data[index]);
                                Navigator.pop(context);
                              },
                              child: const Text('DELETE'),
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
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

  // void updateTask(TaskModel taskModel){
  //   taskModel.isDone= !taskModel.isDone;
  //   taskModel.save();
  // }

  // void updateTaskDetails(TaskModel taskModel){
  //   taskModel.task = taskDetails.text;
  //   taskModel.save();
  // }

  // void updateTaskDateTime(TaskModel taskModel){
  //   taskModel.dateTime = dateTime;
  //   taskModel.save();
  // }

  // void updateTaskColor(TaskModel taskModel){taskModel.color = color;
  //   taskModel.save();
  // }

  // void updateTaskPriority(TaskModel taskModel){
  //   taskModel.priority= priority;
  //   taskModel.save();
  // }

  // void updateTaskReminder(TaskModel taskModel){
  //   taskModel.reminder= reminder;
  //   taskModel.save();
  // }

  // void updateTaskReminderTime(TaskModel taskModel){
  //    = reminderTime;
  //   taskModel.save();
  // }

  // void updateTaskReminderDate(TaskModel taskModel){
  //   taskModel.reminderDate
  // }
}
