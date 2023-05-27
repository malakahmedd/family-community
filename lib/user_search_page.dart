// ignore: unused_import
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  List<Map<dynamic, dynamic>> _users = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
  final databaseReference = FirebaseDatabase.instance.reference().child('users');
  databaseReference
      .orderByChild('name')
      .startAt(_searchController.text.toLowerCase())
      .endAt('${_searchController.text.toLowerCase()}\\uf8ff')
      .onValue
      .listen((DatabaseEvent event) {
    setState(() {
      _users = [];
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          _users.add(value);
        });
      }
    });
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search users...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_users[index]['name']),
            subtitle: Text(_users[index]['email']),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Handle user selection here
            },
          );
        },
      ),
    );
  }
}