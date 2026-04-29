import 'package:flutter/material.dart';

import '../groups/groups_screen.dart';

class GlobalTimerScreen extends StatelessWidget {
  static const String routeName = '/globalTimer';

  const GlobalTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer Access'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.timer,
                    size: 60,
                    color: Color(0xFF0039A6),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Shared Pomodoro Timer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'The shared timer is connected to study groups so members can stay synchronized during collaborative study sessions.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, GroupsScreen.routeName);
                    },
                    child: const Text('Open Study Groups'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}