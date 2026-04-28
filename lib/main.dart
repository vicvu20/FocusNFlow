import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'screens/auth/auth_gate.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/tasks/tasks_screen.dart';
import 'screens/planner/planner_screen.dart';
import 'screens/rooms/rooms_screen.dart';
import 'screens/groups/groups_screen.dart';
import 'services/firestore_service.dart';

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
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();

    final String? token = await messaging.getToken();
    final user = FirebaseAuth.instance.currentUser;

    if (token != null && user != null) {
      await FirestoreService().saveFcmToken(user.uid, token);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color gsuBlue = Color(0xFF0039A6);

    return MaterialApp(
      title: 'FocusNFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: gsuBlue,
          primary: gsuBlue,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: gsuBlue,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
        cardTheme: CardThemeData(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: gsuBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
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