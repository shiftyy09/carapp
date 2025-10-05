import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
void main() {
  runApp(const CarMaintenanceApp());
}

class CarMaintenanceApp extends StatelessWidget {
  const CarMaintenanceApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autó Karbantartás',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 164, 0),
          brightness: Brightness.dark,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
