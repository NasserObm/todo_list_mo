import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    animationWelcome();
  }

  void animationWelcome() {
    Timer(const Duration(seconds: 5), () {
      context.go('/connection');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffD8EAEC), Color(0xffba7264)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Todo-List',
              style: GoogleFonts.nanumBrushScript(
                color: const Color(0xfff0dcd8),
                fontSize: 55,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
                width: 70,
                height: 70,
                child: Image.asset('assets/img/notebook.png')),
          ],
        ),
      ),
    );
  }
}
