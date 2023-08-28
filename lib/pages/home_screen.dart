import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    customHeight = MediaQuery.of(context).size.height;
    customWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
            titleItem(),
            10.heightBox,
            taskDATELists(),
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
    return CustomText(
      text: 'DATE',
    );
  }

  Widget taskDATELists() {
    return CustomContainer(
      height: customHeight! * 0.3,
      width: customWidth! * 0.95,
    );
  }

  Widget titleItem2() {
    return CustomText(
      text: 'TODAY TASKS',
    );
  }

  Widget tasksItem() {
    return Expanded(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(5.0),
            child: ListTile(
              title: Text('Tasks'),
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
            ),
          );
        },
      ),
    );
  }
}
