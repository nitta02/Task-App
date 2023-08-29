import 'package:hive/hive.dart';
import 'package:taskie_app/models/task_model.dart';

class DataBaseBox {
  static Box<TaskModel> getData() => Hive.box('taskie_app');
}
