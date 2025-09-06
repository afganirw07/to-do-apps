import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_list_flutter/screens/login_screen.dart';
import 'package:to_do_list_flutter/screens/register_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SizedBox(
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'To Do List',
                  textStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  speed: const Duration(milliseconds: 150),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 500),
              displayFullTextOnTap: true,
            ),

            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Lottie.asset('assets/animation/Splash.json'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      splashIconSize: 350,
      duration: 5000,
      nextScreen: Supabase.instance.client.auth.currentSession == null
          ? const LoginScreens()
          : const Register(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
