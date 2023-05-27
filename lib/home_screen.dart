import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: unused_import, implementation_imports
import 'package:flutter/src/widgets/container.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'hello, Your\'re Signed in',
              style: TextStyle(fontSize: 22),
            ),
            Text(
              user.email!,
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: (() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }),
              color: Colors.cyan,
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}