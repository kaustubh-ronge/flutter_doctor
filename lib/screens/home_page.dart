import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/navbar.dart'; // Update with your project path
import '../components/carousel.dart'; // Import the carousel component

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? _darkTheme : _lightTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Container(
          key: ValueKey<bool>(_isDarkMode),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hello User",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage("images/doctor1.jpg"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _isDarkMode ? Colors.green : const Color(0xFF005EB8),
                          borderRadius: BorderRadius.circular(12),
                          gradient: _isDarkMode
                              ? LinearGradient(
                            colors: [Colors.green, Colors.teal],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                              : LinearGradient(
                            colors: [Color(0xFF005EB8), Color(0xFF003D80)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.add,
                                color: _isDarkMode ? Colors.green : const Color(0xFF005EB8),
                                size: 35,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              "Clinic Visit",
                              style: TextStyle(
                                fontSize: 18,
                                color: theme.textTheme.bodyLarge?.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Make an appointment",
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ImageCarousel(),
                  const SizedBox(height: 20),
                  // Specialty Cards Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Specialties",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 150,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _SpecialtyCard(
                                title: "Cardiology",
                                icon: Icons.favorite,
                                startColor: Colors.red,
                                endColor: Colors.pink,
                              ),
                              _SpecialtyCard(
                                title: "Dentistry",
                                icon: Icons.north,
                                startColor: Colors.blue,
                                endColor: Colors.lightBlue,
                              ),
                              _SpecialtyCard(
                                title: "Orthopedics",
                                icon: Icons.accessibility,
                                startColor: Colors.green,
                                endColor: Colors.lightGreen,
                              ),
                              _SpecialtyCard(
                                title: "Dermatology",
                                icon: Icons.psychology,
                                startColor: Colors.orange,
                                endColor: Colors.deepOrange,
                              ),
                              _SpecialtyCard(
                                title: "Pediatrics",
                                icon: Icons.child_care,
                                startColor: Colors.purple,
                                endColor: Colors.pinkAccent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Popular Doctors",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return Center(child: Text('No doctors found.', style: TextStyle(color: theme.textTheme.bodyLarge?.color)));
                      }

                      final doctors = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: doctors.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final doctor = doctors[index].data() as Map<String, dynamic>;
                          final name = doctor['name'] ?? 'Unknown Name';
                          final speciality = doctor['speciality'] ?? 'Unknown Speciality';
                          final rating = doctor['rating']?.toString() ?? '0.0';

                          return Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blueGrey.shade700, Colors.blueGrey.shade900],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Icon(
                                Icons.local_hospital,
                                size: 60,
                                color: theme.iconTheme.color,
                              ),
                              title: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              subtitle: Text(
                                speciality,
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    rating,
                                    style: TextStyle(
                                      color: theme.textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavBar(toggleTheme: () { _toggleTheme(); },),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleTheme,
        child: Icon(
          _isDarkMode ? Icons.brightness_7 : Icons.brightness_6,
          color: Colors.white,
        ),
      ),
    );
  }

  ThemeData get _lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black87),
      ),
      iconTheme: IconThemeData(color: Colors.black),
    );
  }

  ThemeData get _darkTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: Colors.black,
      cardColor: Colors.grey[800],
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      iconTheme: IconThemeData(color: Colors.white),
    );
  }
}

class _SpecialtyCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color startColor;
  final Color endColor;

  _SpecialtyCard({
    required this.title,
    required this.icon,
    required this.startColor,
    required this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 50,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


