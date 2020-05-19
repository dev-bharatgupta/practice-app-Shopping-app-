import 'package:flutter/material.dart';

class Aisehi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            colors: [
              Colors.orangeAccent,
              Colors.deepOrangeAccent,
              Colors.orangeAccent
            ],
            end: Alignment.bottomRight),
      ),
      child: Center(
        child: LinearProgressIndicator(),
      ),
    ));
  }
}
