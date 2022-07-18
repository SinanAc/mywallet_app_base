// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_wallet/data_base/db_functions.dart';
import 'package:my_wallet/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refreshUi();
    return Scaffold(
      body: Center(
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.14,
            child: Image.asset('assets/appLogoo.png')),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Text('My Wallet',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () => checkings(context));
  }

  checkings(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    darkThemePreference.value = pref.getBool('dark') ?? false;
    darkThemePreference.notifyListeners();
    final addedName = pref.getString('name');
    if (addedName == null) {
      Navigator.pushReplacementNamed(context, '/startingScreen');
    } else {
      Navigator.pushReplacementNamed(context, '/mainPage');
    }
  }
}
