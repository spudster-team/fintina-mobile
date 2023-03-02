import 'dart:async';

import 'package:flutter/material.dart';

import 'home_page.dart';

class OnbroadingPage extends StatefulWidget {
  const OnbroadingPage({Key? key}) : super(key: key);

  @override
  State<OnbroadingPage> createState() => _OnbroadingPageState();
}

class _OnbroadingPageState extends State<OnbroadingPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return const HomePage();
      }), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg.jpg',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          const Center(
            child: Text(
              'Fintina',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            // child: Image.asset('assets/images/logo.png'),
          ),
        ],
      ),
    );
  }
}
