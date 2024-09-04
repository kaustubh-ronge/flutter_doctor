import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/gemini_scree.dart';
import '../screens/gemini_scree.dart'; // Corrected the import name
import '../screens/home_page.dart';
import '../screens/message_screen.dart';
import '../screens/schedule_screen.dart';
import '../screens/settings.dart';

class NavBar extends StatefulWidget {
  final VoidCallback toggleTheme;
  final int selectedIndex; // Add this property

  NavBar({required this.toggleTheme, this.selectedIndex = 0}); // Add default value

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFF005EB8),
      unselectedItemColor: Colors.black54,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      currentIndex: widget.selectedIndex, // Use widget.selectedIndex
      onTap: (index) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => _screens[index]),
        );
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.chat_bubble_text_fill),
          label: "Messages",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: "Schedule",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy), // Use an appropriate icon for Gemini AI
          label: "Gemini AI",
        ),
      ],
    );
  }

  final List<Widget> _screens = [
    HomeScreen(toggleTheme: () {}),
    MessageScreen(),
    ScheduleScreen(),
    SettingsScreen(),
    GeminiAIScreen(toggleTheme: () {}),
  ];
}
