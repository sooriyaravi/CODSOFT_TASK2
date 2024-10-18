import 'package:flutter/material.dart';
import 'package:todolist/storage.dart';
import 'package:intl/intl.dart';

class TaskcreationScreen extends StatefulWidget {
  final Task? task;
  final Function(Task) onTaskCreated;
  final Function(Task)? onTaskUpdated;
  const TaskcreationScreen(
      {super.key, this.task, required this.onTaskCreated, this.onTaskUpdated});

  @override
  State<TaskcreationScreen> createState() => _TaskcreationScreenState();
}

class _TaskcreationScreenState extends State<TaskcreationScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String priority = 'Medium';
  DateTime? dueDate;

  @override
  void initState() {
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      priority = widget.task!.priority ?? 'Medium';
      dueDate = widget.task!.dueDate;
    }
    super.initState();
  }

  void saveTasks() {
    Task newTask = Task(
      title: titleController.text,
      description: descriptionController.text,
      priority: priority,
      dueDate: dueDate,
    );
    if (widget.onTaskUpdated != null) {
      widget.onTaskUpdated!(newTask);
    } else {
      widget.onTaskCreated(newTask);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Add Task' : 'Edit Task',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.keyboard_arrow_left),
            color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              cursorColor: Colors.deepOrange,
              decoration: const InputDecoration(
                  labelText: 'Task Title',
                  labelStyle: TextStyle(
                    color: Colors.deepOrange,
                  )),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              cursorColor: Colors.deepOrange,
              decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  labelStyle: TextStyle(
                    color: Colors.deepOrange,
                  )),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: priority,
              items: ['Low', 'Medium', 'High'].map((String priority) {
                return DropdownMenuItem<String>(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  priority = newValue!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Priority',
                labelStyle: TextStyle(color: Colors.deepOrange),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text(
                dueDate == null
                    ? 'No due date set'
                    : 'Due Date :${DateFormat.yMMMd().format(dueDate!)}',
                style: const TextStyle(color: Colors.deepOrange),
              ),
              trailing: const Icon(
                Icons.calendar_today,
                color: Colors.deepOrange,
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    dueDate = pickedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: saveTasks,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                ),
                child: Text(widget.task == null ? 'Create Task' : 'Update Task',
                    style: const TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
