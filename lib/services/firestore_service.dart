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
}