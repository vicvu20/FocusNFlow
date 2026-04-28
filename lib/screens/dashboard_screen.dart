import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '/dashboard';

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_DashboardCard> cards = [
      _DashboardCard(
        title: 'Tasks',
        subtitle: 'Add assignments and track deadlines',
        icon: Icons.checklist,
      ),
      _DashboardCard(
        title: 'Weekly Planner',
        subtitle: 'Generate study blocks using smart rules',
        icon: Icons.calendar_month,
      ),
      _DashboardCard(
        title: 'Study Rooms',
        subtitle: 'View real-time room occupancy',
        icon: Icons.meeting_room,
      ),
      _DashboardCard(
        title: 'Study Groups',
        subtitle: 'Create groups, chat, and schedule sessions',
        icon: Icons.groups,
      ),
      _DashboardCard(
        title: 'Pomodoro Timer',
        subtitle: 'Sync shared study timer with group members',
        icon: Icons.timer,
      ),
      _DashboardCard(
        title: 'Profile',
        subtitle: 'Manage your student profile and uploads',
        icon: Icons.person,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusNFlow Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(card.icon),
              ),
              title: Text(
                card.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(card.subtitle),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // navigation later
              },
            ),
          );
        },
      ),
    );
  }
}

class _DashboardCard {
  final String title;
  final String subtitle;
  final IconData icon;

  _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}