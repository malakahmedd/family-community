// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:search/home_screen.dart';
import 'package:search/login_screen.dart';
import 'package:search/user_search_page.dart';

import 'FamilyMember.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
       /* '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      '/search': (context) => UserSearchPage(),*/
              '/addFamilyMember': (context) => AddFamilyMemberScreen(),

      },
    );
  }
}
