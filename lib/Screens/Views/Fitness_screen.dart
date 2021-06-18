import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class FitnessScreen extends StatefulWidget {
  final User user;
  FitnessScreen(this.user);

  @override
  _FitnessScreenState createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
    );
  }
}
