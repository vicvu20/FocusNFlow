import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'tasks/tasks_screen.dart';
import 'planner/planner_screen.dart';
import 'rooms/rooms_screen.dart';

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
        routeName: TasksScreen.routeName,
      ),
      _DashboardCard(
        title: 'Weekly Planner',
        subtitle: 'Generate study blocks using smart rules',
        icon: Icons.calendar_month,
        routeName: PlannerScreen.routeName,
      ),
      _DashboardCard(
        title: 'Study Rooms',
        subtitle: 'View real-time room occupancy',
        icon: Icons.meeting_room,
        routeName: RoomsScreen.routeName,
      ),
      _DashboardCard(
        title: 'Study Groups',
        subtitle: 'Coming next',
        icon: Icons.groups,
        routeName: null,
      ),
      _DashboardCard(
        title: 'Pomodoro Timer',
        subtitle: 'Coming next',
        icon: Icons.timer,
        routeName: null,
      ),
      _DashboardCard(
        title: 'Profile',
        subtitle: 'Coming next',
        icon: Icons.person,
        routeName: null,
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
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              }
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
                if (card.routeName == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${card.title} coming soon')),
                  );
                  return;
                }

                Navigator.pushNamed(context, card.routeName!);
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
  final String? routeName;

  _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.routeName,
  });
}