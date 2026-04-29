import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 45,
            child: Icon(Icons.person, size: 45),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              title: const Text('Campus Email'),
              subtitle: Text(user?.email ?? 'No Email'),
            ),
          ),
          Card(
            child: const ListTile(
              title: Text('University'),
              subtitle: Text('Georgia State University'),
            ),
          ),
          Card(
            child: const ListTile(
              title: Text('App Purpose'),
              subtitle: Text('Collaborative Study Planning'),
            ),
          ),
        ],
      ),
    );
  }
}