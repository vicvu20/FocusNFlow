import 'package:flutter/material.dart';

import '../../services/firestore_service.dart';

class SessionScreen extends StatefulWidget {
  final String groupId;

  const SessionScreen({super.key, required this.groupId});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final FirestoreService firestore = FirestoreService();
  final TextEditingController controller = TextEditingController();

  DateTime selectedTime = DateTime.now();

  Future<void> _pickTime() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _createSession() async {
    if (controller.text.trim().isEmpty) return;

    await firestore.createSession(
      groupId: widget.groupId,
      title: controller.text.trim(),
      time: selectedTime,
    );

    controller.clear();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Sessions')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Session Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date: ${selectedTime.month}/${selectedTime.day}',
                      ),
                    ),
                    TextButton(
                      onPressed: _pickTime,
                      child: const Text('Pick Date'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _createSession,
                  child: const Text('Create Session'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: firestore.getSessions(widget.groupId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final sessions = snapshot.data!.docs;

                if (sessions.isEmpty) {
                  return const Center(child: Text('No sessions yet'));
                }

                return ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index].data();

                    return ListTile(
                      title: Text(session['title']),
                      subtitle: Text(
                        session['time'].toDate().toString(),
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