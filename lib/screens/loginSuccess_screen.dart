import 'package:flutter/material.dart';
import 'home_page.dart'; // Import the home page

class LoginSuccessScreen extends StatelessWidget {
  final VoidCallback toggleTheme; // Add toggleTheme parameter

  const LoginSuccessScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    // Automatically navigate to HomePage after a delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(toggleTheme: toggleTheme),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Successful'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Login Successful',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Redirecting to home...',
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
