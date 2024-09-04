import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import the login screen

class LoginFailureScreen extends StatelessWidget {
  final VoidCallback toggleTheme; // Add this line

  const LoginFailureScreen({super.key, required this.toggleTheme}); // Modify constructor

  @override
  Widget build(BuildContext context) {
    // Automatically navigate back to LoginScreen after a delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(toggleTheme: toggleTheme), // Pass the theme toggle
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Failed'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              size: 100,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Login Failed',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Redirecting back to login...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
