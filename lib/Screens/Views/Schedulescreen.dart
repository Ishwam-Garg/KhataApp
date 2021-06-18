import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ScheduleScreen extends StatefulWidget {
  final User user;
  ScheduleScreen(this.user);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
    );
  }
}
