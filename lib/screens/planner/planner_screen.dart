import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/task_model.dart';
import '../../services/firestore_service.dart';

class PlannerScreen extends StatelessWidget {
  static const routeName = '/planner';

  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final firestore = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text("Weekly Study Plan")),
      body: user == null
          ? const Center(child: Text("Not logged in"))
          : StreamBuilder<List<Task>>(
              stream: firestore.getTasks(user.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tasks = snapshot.data!;
                final plannedTasks =
                    firestore.generateStudyPlan(List.from(tasks));

                if (plannedTasks.isEmpty) {
                  return const Center(child: Text("No tasks to plan"));
                }

                return ListView.builder(
                  itemCount: plannedTasks.length,
                  itemBuilder: (context, index) {
                    final task = plannedTasks[index];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(task.title),
                        subtitle: Text(
                          "${task.course} | Effort: ${task.effort} | Weight: ${task.weight}",
                        ),
                        trailing: Text(
                          "${task.dueDate.month}/${task.dueDate.day}",
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}