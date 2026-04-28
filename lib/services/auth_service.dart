import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  bool isCampusEmail(String email) {
    final trimmedEmail = email.trim().toLowerCase();

    return trimmedEmail.endsWith('@student.gsu.edu') ||
        trimmedEmail.endsWith('@gsu.edu');
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    if (!isCampusEmail(email)) {
      throw Exception('Please use a valid campus email address.');
    }

    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final user = credential.user;

    if (user != null) {
      final newUser = AppUser(
        uid: user.uid,
        email: user.email ?? '',
        createdAt: Timestamp.now().toDate().toString(),
      );

      await FirestoreService().createUserProfile(newUser);
    }

    return credential;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    if (!isCampusEmail(email)) {
      throw Exception('Please use a valid campus email address.');
    }

    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}