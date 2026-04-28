import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/firestore_service.dart';

class TimerScreen extends StatefulWidget {
  final String groupId;

  const TimerScreen({super.key, required this.groupId});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final FirestoreService firestore = FirestoreService();
  final TextEditingController goalController = TextEditingController();

  Timer? localTimer;
  int remaining = 1500;
  bool isRunning = false;
  String goal = 'Focus study session';

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    localTimer?.cancel();

    setState(() {
      isRunning = true;
    });

    firestore.startTimer(widget.groupId, remaining);

    localTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remaining <= 0) {
        timer.cancel();
        firestore.stopTimer(widget.groupId, 0);
        return;
      }

      setState(() {
        remaining--;
      });

      firestore.startTimer(widget.groupId, remaining);
    });
  }

  void _stopTimer() {
    localTimer?.cancel();

    setState(() {
      isRunning = false;
    });

    firestore.stopTimer(widget.groupId, remaining);
  }

  void _resetTimer() {
    localTimer?.cancel();

    setState(() {
      remaining = 1500;
      isRunning = false;
    });

    firestore.resetTimer(widget.groupId);
  }

  Future<void> _saveGoal() async {
    final newGoal = goalController.text.trim();

    if (newGoal.isEmpty) return;

    await firestore.updateTimerGoal(widget.groupId, newGoal);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal updated')),
      );
    }

    goalController.clear();
  }

  @override
  void dispose() {
    localTimer?.cancel();
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Study Timer'),
      ),
      body: StreamBuilder(
        stream: firestore.getTimer(widget.groupId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            final data = snapshot.data!.data()!;
            final timerData = data['timer'];

            if (timerData != null) {
              remaining = timerData['remaining'] ?? remaining;
              isRunning = timerData['isRunning'] ?? isRunning;
              goal = timerData['goal'] ?? goal;
            }
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Current Goal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        goal,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Text(
                        _formatTime(remaining),
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0039A6),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isRunning ? 'Timer is running' : 'Timer is paused',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isRunning ? null : _startTimer,
                              child: const Text('Start'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isRunning ? _stopTimer : null,
                              child: const Text('Stop'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: _resetTimer,
                        child: const Text('Reset to 25:00'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      TextField(
                        controller: goalController,
                        decoration: const InputDecoration(
                          labelText: 'Session Goal',
                          hintText: 'Example: Finish Chapter 5 notes',
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _saveGoal,
                        child: const Text('Update Shared Goal'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}