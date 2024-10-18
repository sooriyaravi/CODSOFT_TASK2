import 'package:flutter/material.dart';
import 'package:todolist/storage.dart';
import 'package:todolist/taskcreation.dart';
import 'package:todolist/history.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  List<Task> taskhistory = [];
  TaskStorage storage = TaskStorage();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    tasks = await storage.loadTasks();
    setState(() {});
  }

  void saveTasks() async {
    await storage.saveTasks(tasks);
  }

  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      if (tasks[index].isCompleted) {
        taskhistory.add(tasks[index]);
      }
      saveTasks();
    });
  }

  void deleteTask(int index) {
    setState(() {
      taskhistory.add(tasks[index]);
      tasks.removeAt(index);
      saveTasks();
    });
  }

  void deleteTaskFromHistory(int index) {
    setState(() {
      taskhistory.removeAt(index);
      saveTasks();
    });
  }

  double getCompletedPercentage() {
    if (tasks.isEmpty) {
      return 0;
    }
    int completedTasks = tasks.where((task) => task.isCompleted).length;
    return completedTasks / tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'To-Do-List',
          style: TextStyle(color: Colors.deepOrange),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskHistoryScreen(
                    taskHistory: taskhistory,
                    onDelete: deleteTaskFromHistory,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.history,
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LinearProgressIndicator(
              value: getCompletedPercentage(),
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 28, 220, 25)),
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'asset/img/todolist.webp',
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'No Tasks Available',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        elevation: 4,
                        color: task.isCompleted
                            ? Colors.green[100]
                            : const Color.fromARGB(255, 219, 200, 202),
                        child: ListTile(
                          title: Text(task.title,
                              style: TextStyle(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontWeight: FontWeight.bold,
                              )),
                          subtitle: Text(
                            task.description.isNotEmpty
                                ? task.description
                                : 'No description',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.deepOrange,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TaskcreationScreen(
                                              task: task,
                                              onTaskUpdated: (updatedTask) {
                                                setState(() {
                                                  tasks[index] = updatedTask;
                                                  saveTasks();
                                                });
                                              },
                                              onTaskCreated: (task) {},
                                            )),
                                  );
                                },
                              ),
                              IconButton(
                                  onPressed: () => deleteTask(index),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                          onTap: () => toggleTaskCompletion(index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TaskcreationScreen(onTaskCreated: (newTask) {
                setState(() {
                  tasks.add(newTask);
                  saveTasks();
                });
              }),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
