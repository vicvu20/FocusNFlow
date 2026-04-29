import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'tasks/tasks_screen.dart';
import 'planner/planner_screen.dart';
import 'rooms/rooms_screen.dart';
import 'groups/groups_screen.dart';
import 'timer/global_timer_screen.dart';
import 'profile/profile_screen.dart';

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
        subtitle: 'View real-time GSU study room occupancy',
        icon: Icons.meeting_room,
        routeName: RoomsScreen.routeName,
      ),
      _DashboardCard(
        title: 'Study Groups',
        subtitle: 'Create groups and chat in real time',
        icon: Icons.groups,
        routeName: GroupsScreen.routeName,
      ),
      _DashboardCard(
        title: 'Pomodoro Timer',
        subtitle: 'Access synchronized study timer',
        icon: Icons.timer,
        routeName: GlobalTimerScreen.routeName,
      ),
      _DashboardCard(
        title: 'Profile',
        subtitle: 'View student account information',
        icon: Icons.person,
        routeName: ProfileScreen.routeName,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusNFlow'),
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
      body: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0039A6),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, Panther',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Plan your week, find study rooms, and work with your group.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          ...cards.map((card) {
            return Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE8EEFF),
                  child: Icon(
                    card.icon,
                    color: const Color(0xFF0039A6),
                  ),
                ),
                title: Text(
                  card.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(card.subtitle),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pushNamed(context, card.routeName);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DashboardCard {
  final String title;
  final String subtitle;
  final IconData icon;
  final String routeName;

  _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.routeName,
  });
}