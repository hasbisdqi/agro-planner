import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const AgroPlannerApp());
}

class AgroPlannerApp extends StatelessWidget {
  const AgroPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agro Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
