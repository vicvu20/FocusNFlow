import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/task_model.dart';
import '../../services/firestore_service.dart';

class TasksScreen extends StatefulWidget {
  static const routeName = '/tasks';

  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final FirestoreService _firestore = FirestoreService();
  final _titleController = TextEditingController();
  final _courseController = TextEditingController();

  int _effort = 1;
  int _weight = 1;

  void _addTask() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    
    final title = _titleController.text.trim();
    final course = _courseController.text.trim();

    if (title.isEmpty || course.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter a task title and course.")),
    );
    return;
    }
    final task = Task(
      id: '',
      title: title,
      course: course,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      effort: _effort,
      weight: _weight,
    );

    await _firestore.addTask(user.uid, task);

    _titleController.clear();
    _courseController.clear();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Task added successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Tasks")),
      body: user == null
          ? const Center(child: Text("Not logged in"))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration:
                            const InputDecoration(labelText: "Task Title"),
                      ),
                      TextField(
                        controller: _courseController,
                        decoration:
                            const InputDecoration(labelText: "Course"),
                      ),
Row(
  children: [
    const Text("Weight"),
    Expanded(
      child: Slider(
        value: _weight.toDouble(),
        min: 1,
        max: 5,
        divisions: 4,
        label: _weight.toString(),
        onChanged: (value) {
          setState(() {
            _weight = value.toInt();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: _addTask,
                        child: const Text("Add Task"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<Task>>(
                    stream: _firestore.getTasks(user.uid),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      final tasks = snapshot.data!;

                      if (tasks.isEmpty) {
                        return const Center(child: Text("No tasks yet"));
                      }

                      return ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];

                          return Card(
                            child: ListTile(
                            title: Text(task.title),
                            subtitle: Text(
                            "${task.course} • Due: ${task.dueDate.month}/${task.dueDate.day}",
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
onPressed: () async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Delete Task"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );

  if (confirm == true) {
    _firestore.deleteTask(user.uid, task.id);
  }
},
                            ),
                            ), 
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}