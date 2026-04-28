import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // USERS
  Future<void> createUserProfile(AppUser user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  // TASKS
  Future<void> addTask(String uid, Task task) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .add(task.toMap());
  }

  Stream<List<Task>> getTasks(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> deleteTask(String uid, String taskId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  // STUDY PLANNER LOGIC
  List<Task> generateStudyPlan(List<Task> tasks) {
    final now = DateTime.now();

    tasks.sort((a, b) {
      final aScore = _calculateScore(a, now);
      final bScore = _calculateScore(b, now);
      return bScore.compareTo(aScore);
    });

    return tasks;
  }

  int _calculateScore(Task task, DateTime now) {
    final daysLeft = task.dueDate.difference(now).inDays.clamp(0, 30);

    final deadlineScore = (30 - daysLeft) * 2;
    final effortScore = task.effort * 3;
    final weightScore = task.weight * 4;

    return deadlineScore + effortScore + weightScore;
  }
}