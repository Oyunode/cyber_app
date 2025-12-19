import 'package:flutter/material.dart';
import 'app_state.dart';
import 'screens/login_screen.dart';
import 'screens/start_screen.dart';

class CyberAwarenessApp extends StatelessWidget {
  const CyberAwarenessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final isLoggedIn = appState.currentUser != null;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cyber Awareness',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF8E7CFF),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF5F3FF),
          ),
          // энд CONST ЮУ Ч БАЙХГҮЙ
          home: isLoggedIn ? const StartScreen() : const LoginScreen(),
        );
      },
    );
  }
}
