import 'package:flutter/material.dart';
import 'package:todolist/storage.dart';

class TaskHistoryScreen extends StatefulWidget {
  final List<Task> taskHistory;
  final Function(int) onDelete;
   const TaskHistoryScreen({super.key, required this.taskHistory, required this.onDelete});
  @override
  State<TaskHistoryScreen> createState() => _TaskHistoryScreenState();
}

class _TaskHistoryScreenState extends State<TaskHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Task History',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
              )),
          backgroundColor: Colors.deepOrange,
        ),
        body: widget.taskHistory.isEmpty
            ? const Center(
                child: Text(
                  'No Task history available',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: widget.taskHistory.length,
                itemBuilder: (context, index) {
                  final task = widget.taskHistory[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    elevation: 2,
                    color: task.isCompleted
                        ? Colors.blueGrey[50]
                        : Colors.red[100],
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            widget.onDelete(index);
                            setState(() {
                              
                            });
                          },
                          icon: const Icon(Icons.delete,color: Colors.red,)),
                    ),
                  );
                }));
  }
}
