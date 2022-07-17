import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_wallet/screens/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartingScreenOne extends StatelessWidget {
  const StartingScreenOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.23,
            child: SvgPicture.asset('assets/startingSvg1.svg')),
        const SizedBox(height: 6),
        Text(
          'Welcome to',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.025,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'MyWallet',
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.indigo),
        ),
        const SizedBox(height: 20),
        Text(
          "Let's build a financial habit",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.025,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => StartingScreenTwo()));
          },
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.008),
            child: Text(
              'Go Ahead',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ]),
    );
  }
}

class StartingScreenTwo extends StatelessWidget {
  StartingScreenTwo({Key? key}) : super(key: key);
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.21,
          child: SvgPicture.asset('assets/startingSvg2.svg'),
        ),
        const SizedBox(height: 7),
        Text(
          'What should we call you ?',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.026,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: MediaQuery.of(context).size.height * 0.018),
          child: TextField(
            controller: nameController,
            maxLength: 15,
            decoration: const InputDecoration(
              hintText: 'Please enter your name',
              counterText: '',
            ),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              nameVerification(context);
            },
            child: Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.008),
              child: Text(
                'Get Started',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.033,
                    fontWeight: FontWeight.bold),
              ),
            )),
      ]),
    );
  }

  nameVerification(BuildContext context) {
    final name = nameController.text.trim().toUpperCase();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your name',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      addName(name);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainPage()),
          (route) => false);
    }
  }

  void addName(String name) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('name', name);
  }
}
