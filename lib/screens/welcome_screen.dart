import 'package:flutter/material.dart';
import 'package:android_app/screens/signup_screen.dart';
import 'package:android_app/screens/login_screen.dart';

import '../widgets/navbar.dart';


class WelcomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  WelcomeScreen({required this.toggleTheme});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Navigate to NavBarRoots instead of Scaffold with NavBarRoots
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavBar(toggleTheme: () {  },), // Updated navigation
                    ),
                  );
                },
                child: const Text(
                  "SKIP",
                  style: TextStyle(
                    color: Color(0xFF7165D6),
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset("images/doctors.png"), // Ensure this path is correct
            ),
            const SizedBox(height: 50),
            ShiningText(
              text: "Doctors Appointment",
              controller: _controller,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 10),
            ShiningText(
              text: "Appointment Your Doctor",
              controller: _controller,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  color: const Color(0xFF7165D6),
                  borderRadius: BorderRadius.circular(50),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(toggleTheme: widget.toggleTheme),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: const Color(0xFF7165D6),
                  borderRadius: BorderRadius.circular(50),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(toggleTheme: widget.toggleTheme),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShiningText extends StatelessWidget {
  final String text;
  final AnimationController controller;
  final double fontSize;
  final FontWeight fontWeight;

  ShiningText({
    required this.text,
    required this.controller,
    this.fontSize = 35.0,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [Colors.pink, Colors.orange, Colors.purple],
              stops: [0.1, 0.5, 0.9],
              begin: Alignment(-1.0 + controller.value * 2, 0),
              end: Alignment(1.0 - controller.value * 2, 0),
            ).createShader(bounds);
          },
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: fontWeight,
              letterSpacing: 1,
              wordSpacing: 2,
              shadows: [
                Shadow(
                  blurRadius: 20.0,
                  color: Colors.pink.withOpacity(0.3),
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  blurRadius: 20.0,
                  color: Colors.orange.withOpacity(0.3),
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  blurRadius: 20.0,
                  color: Colors.purple.withOpacity(0.3),
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
