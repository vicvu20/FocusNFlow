import 'package:flutter/material.dart';

import '../../services/firestore_service.dart';
import 'chat_screen.dart';

class GroupsScreen extends StatefulWidget {
  static const routeName = '/groups';

  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final FirestoreService firestore = FirestoreService();
  final TextEditingController controller = TextEditingController();

Future<void> _createGroup() async {
  final groupName = controller.text.trim();

  if (groupName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter a group name.")),
    );
    return;
  }

  await firestore.createGroup(groupName);
  controller.clear();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Group created successfully.")),
  );
}

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Groups'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Group Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _createGroup,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: firestore.getGroups(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final groups = snapshot.data!.docs;

                if (groups.isEmpty) {
                  return const Center(child: Text('No study groups yet'));
                }

                return ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    final data = group.data();

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text(data['name'] ?? 'Study Group'),
                        subtitle: const Text('Tap to open group chat'),
                        trailing: const Icon(Icons.chat),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(groupId: group.id),
                            ),
                          );
                        },
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