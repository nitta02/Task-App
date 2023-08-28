// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class TaskModel {
  @HiveField(0)
  final List<String> task;

  @HiveField(1)
  final bool isDone;

  TaskModel({
    required this.task,
    required this.isDone,
  });
}
