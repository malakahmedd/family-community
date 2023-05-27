import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyMember {
  String name;
  int age;
  String email;
  String phone;

  FamilyMember({required this.name, required this.age, required this.email, required this.phone});

  // Convert aFamilyMember object to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'email': email,
      'phone': phone,
    };
  }
}

class FamilyMembersScreen extends StatefulWidget {
  @override
  _FamilyMembersScreenState createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Stream of family members from Firestore collection
  late Stream<QuerySnapshot> _familyMembersStream;

  @override
  void initState() {
    super.initState();

    // Set up the stream of family members from Firestore
    _familyMembersStream = firestore.collection('familyMembers').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Members'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _familyMembersStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Display the list of family members from Firestore
          return ListView.builder(
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              final document = snapshot.data!.docs[index];
              final familyMember = FamilyMember(
                name: document['name'],
                age: document['age'],
                email: document['email'],
                phone: document['phone'],
              );

              return ListTile(
                title: Text(familyMember.name),
                subtitle: Text('${familyMember.age} years old'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the screen to add a new family member
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFamilyMemberScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddFamilyMemberScreen extends StatefulWidget {
  @override
  _AddFamilyMemberScreenState createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _name;
  late int _age;
  late String _email;
  late String _phone;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create a new FamilyMember object with the user input
      final newFamilyMember = FamilyMember(
        name: _name,
        age: _age,
        email: _email,
        phone: _phone,
      );

      // Add the new family member to the Firestore collection
      firestore.collection('familyMembers').add(newFamilyMember.toMap());

      // Navigate back to the familymembers screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Family Member'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Age',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an age';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _age = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                onSaved: (value) {
                  _phone = value!;
                },
              ),
              SizedBox(height: 16.0),

            /*  RaisedButton(
                onPressed: _submitForm,
                child: Text('Save'),*/
        /*  ),*/
            ],
          ),
        ),
      ),
    );
  }
}