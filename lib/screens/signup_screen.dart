import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:android_app/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const SignUpScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passToggle = true;
  bool _isLoading = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> _registerUser() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String contact = _contactController.text;
    String password = _passwordController.text;

    if (name.isNotEmpty && email.isNotEmpty && contact.isNotEmpty && password.isNotEmpty) {
      if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid email format')));
        return;
      }

      if (!RegExp(r"^\d{10}$").hasMatch(contact)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid contact number')));
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Check if email or contact already exists
        var emailQuery = await _firestore.collection('users').where('email', isEqualTo: email).get();
        var contactQuery = await _firestore.collection('users').where('contact', isEqualTo: contact).get();

        if (emailQuery.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email already in use')));
          return;
        }

        if (contactQuery.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact number already in use')));
          return;
        }

        // Create user with Firebase Authentication
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Send email verification
        User? user = userCredential.user;
        if (user != null) {
          await user.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Verification email sent. Please verify your email.'),
          ));
          _startEmailVerificationCheck(user);
        }

      } catch (e) {
        print('Error registering user: ${e.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to register user: ${e.toString()}')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
    }
  }

  Future<void> _startEmailVerificationCheck(User user) async {
    bool isVerified = user.emailVerified;
    while (!isVerified) {
      await Future.delayed(const Duration(seconds: 5));
      await user.reload();
      user = FirebaseAuth.instance.currentUser!;
      isVerified = user.emailVerified;
    }

    // Email is verified, now store the data in Firestore
    String name = _nameController.text;
    String email = _emailController.text;
    String contact = _contactController.text;
    String hashedPassword = Crypt.sha256(_passwordController.text).toString();

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'contact': contact,
        'password': hashedPassword,
        'emailVerified': true,
        'createdAt': Timestamp.now(), // Optional, to track when the user was created
      });

      Navigator.pushReplacementNamed(context, '/success');
    } catch (e) {
      print('Error storing user data: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to store user data: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              widget.toggleTheme();
              setState(() {}); // Trigger a rebuild to apply theme change
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset("images/doctors.png"),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: TextField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    labelText: "Contact No",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _passToggle,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _passToggle = !_passToggle;
                        });
                      },
                      child: Icon(
                        _passToggle
                            ? CupertinoIcons.eye_slash_fill
                            : CupertinoIcons.eye_fill,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: const Color(0xFF7165D6),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: _registerUser,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(toggleTheme: widget.toggleTheme),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7165D6)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
