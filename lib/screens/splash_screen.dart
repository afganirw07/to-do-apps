import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_list_flutter/screens/login_screen.dart';
import 'package:to_do_list_flutter/screens/register_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Widget nextPage;

  @override
  void initState() {
    super.initState();

    nextPage = Supabase.instance.client.auth.currentSession == null
        ? const LoginScreens()
        : const Register();

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeftWithFade, 
          duration: const Duration(milliseconds: 800),
          reverseDuration: const Duration(milliseconds: 800),
          child: nextPage,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'To Do List',
                  textStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Colors.black,
                  ),
                  speed: const Duration(milliseconds: 150),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 300),
              displayFullTextOnTap: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Lottie.asset(
                'assets/animation/Splash.json',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
