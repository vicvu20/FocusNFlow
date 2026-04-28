import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';
import 'screens/auth/auth_gate.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/tasks/tasks_screen.dart';
import 'screens/planner/planner_screen.dart';
import 'screens/rooms/rooms_screen.dart';
import 'screens/groups/groups_screen.dart';
import 'services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  runApp(const FocusNFlowApp());
}

class FocusNFlowApp extends StatefulWidget {
  const FocusNFlowApp({super.key});

  @override
  State<FocusNFlowApp> createState() => _FocusNFlowAppState();
}

class _FocusNFlowAppState extends State<FocusNFlowApp> {
  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  Future<void> _initFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();

    String? token = await messaging.getToken();

    final user = FirebaseAuth.instance.currentUser;

    if (token != null && user != null) {
      await FirestoreService().saveFcmToken(user.uid, token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusNFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: AuthGate.routeName,
      routes: {
        AuthGate.routeName: (context) => const AuthGate(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        DashboardScreen.routeName: (context) => const DashboardScreen(),
        TasksScreen.routeName: (context) => const TasksScreen(),
        PlannerScreen.routeName: (context) => const PlannerScreen(),
        RoomsScreen.routeName: (context) => const RoomsScreen(),
        GroupsScreen.routeName: (context) => const GroupsScreen(),
      },
    );
  }
}