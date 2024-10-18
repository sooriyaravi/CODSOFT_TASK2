import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskStorage {
  Future<List<Task>> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      List<dynamic> tasksList = jsonDecode(tasksString);
      return tasksList.map((task) => Task.fromMap(task)).toList();
    }
    return [];
  }

  Future<void> saveTasks(List<Task> tasks) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> tasksList =
        tasks.map((task) => task.toMap()).toList();
    await pref.setString('tasks', jsonEncode(tasksList));
  }
}

class Task {
  String title;
  String description;
  bool isCompleted;
  DateTime? dueDate;
  Task(
      {required this.title,
      this.description = '',
      this.isCompleted = false,
      this.dueDate,
      required String priority});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description ': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      priority: '',
    );
  }
  get priority => null;
}
