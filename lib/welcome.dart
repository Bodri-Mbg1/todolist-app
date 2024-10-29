import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todolist_app/pages/page1.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 8), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Page1()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Center(
          child: Image.asset(
            'asstes/TODOLIST-1.gif', // Chemin de votre GIF
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 400),
          child: Image.asset('asstes/TODOLIST2.png'),
        )
      ]),
    );
  }
}
