import 'package:flutter/material.dart';
import 'constants.dart';
import 'db/database_helper.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// WAJIB → supaya .isSlotBooked dan insertBooking TIDAK error
  await DatabaseHelper.instance.init();

  runApp(const SmartParkingApp());
}

class SmartParkingApp extends StatelessWidget {
  const SmartParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Smart Parking",
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: kPrimaryGreen,
        useMaterial3: false,
      ),
      home: const OnboardingScreen(),
    );
  }
}
