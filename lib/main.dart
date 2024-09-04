import 'package:android_app/screens/schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:android_app/screens/failure_screen.dart';
import 'package:android_app/screens/login_screen.dart';
import 'package:android_app/screens/welcome_screen.dart';
import 'package:android_app/screens/success_screen.dart';
import 'package:android_app/screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? _darkTheme : _lightTheme,
      home: WelcomeScreen(toggleTheme: _toggleTheme), // Pass the toggle function to WelcomeScreen
      routes: {
        '/success': (context) => SuccessScreen(),
        '/failure': (context) => FailureScreen(),
        '/login': (context) => LoginScreen(toggleTheme: _toggleTheme),
        '/signup': (context) => SignUpScreen(toggleTheme: _toggleTheme),
        '/schedule':(context)=> ScheduleScreen(),
      },
    );
  }

  ThemeData get _lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
      ),
      iconTheme: IconThemeData(color: Colors.black),
    );
  }

  ThemeData get _darkTheme {
    return ThemeData(
      primarySwatch: Colors.blueGrey,
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: Colors.white),
    );
  }
}
