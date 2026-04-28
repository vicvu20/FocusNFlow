import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoginMode = true;
  bool _isLoading = false;

  Future<void> _submitAuthForm() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter your email and password.');
      return;
    }

    if (!_authService.isCampusEmail(email)) {
      _showMessage('Please use your GSU campus email.');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLoginMode) {
        await _authService.signIn(
          email: email,
          password: password,
        );
      } else {
        await _authService.signUp(
          email: email,
          password: password,
        );
      }

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        DashboardScreen.routeName,
      );
    } catch (error) {
      _showMessage(_cleanAuthError(error.toString()));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _cleanAuthError(String error) {
    if (error.contains('email-already-in-use')) {
      return 'That email is already registered.';
    }

    if (error.contains('user-not-found')) {
      return 'No account found for that email.';
    }

    if (error.contains('wrong-password')) {
      return 'Incorrect password.';
    }

    if (error.contains('invalid-credential')) {
      return 'Invalid email or password.';
    }

    if (error.contains('weak-password')) {
      return 'Password is too weak.';
    }

    return 'Authentication failed. Please try again.';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonText = _isLoginMode ? 'Log In' : 'Create Account';
    final switchText = _isLoginMode
        ? 'Need an account? Sign up'
        : 'Already have an account? Log in';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/gsu_logo.png',
                      height: 90,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'FocusNFlow',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0039A6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Georgia State study planning made simple.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'GSU Campus Email',
                        hintText: 'example@student.gsu.edu',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitAuthForm,
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(buttonText),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              setState(() {
                                _isLoginMode = !_isLoginMode;
                              });
                            },
                      child: Text(switchText),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}