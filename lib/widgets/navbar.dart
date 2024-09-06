import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import '../screens/message_screen.dart';
import '../screens/schedule_screen.dart';
import '../screens/settings.dart';
import '../screens/gemini_scree.dart'; // Corrected the import name

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
    final theme = Theme.of(context);

    return BottomNavigationBar(
      backgroundColor: Colors.teal[800], // New background color
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.amberAccent, // New selected item color
      unselectedItemColor: Colors.white70, // New unselected item color
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
      ),
      currentIndex: widget.selectedIndex,
      onTap: (index) {
        if (widget.selectedIndex != index) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return _screens[index];
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: "Home",
          tooltip: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.chat_bubble_text_fill),
          label: "Messages",
          tooltip: "Messages",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: "Schedule",
          tooltip: "Schedule",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
          tooltip: "Settings",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy), // Use an appropriate icon for Gemini AI
          label: "Gemini AI",
          tooltip: "Gemini AI",
        ),
      ],
    );
  }

  final List<Widget> _screens = [
    HomeScreen(),
    MessageScreen(),
    ScheduleScreen(),
    SettingsScreen(),
    GeminiAIScreen(toggleTheme: () {}),
  ];
}
