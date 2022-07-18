import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_wallet/screens/add_screen.dart';
import 'package:my_wallet/screens/charts/chart_screen.dart';
import 'package:my_wallet/screens/home_screen.dart';
import 'package:my_wallet/screens/settings_screen.dart';
import 'package:my_wallet/screens/view_all_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0;

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.category_outlined,
    Icons.pie_chart_rounded,
    Icons.settings_outlined,
  ];

  final bottomNavNameList = <String>[
    'Home',
    'View All',
    'Charts',
    'Settings',
  ];

  final screenList = <Widget>[
    const HomeScreen(),
    const ViewAllScreen(),
    const ChartScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screenList[_bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddScreen();
          }));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: darkThemePreference,
        builder: (BuildContext context, bool isDark, Widget? _) {
          return AnimatedBottomNavigationBar.builder(
            itemCount: 4,
            tabBuilder: (int index, bool isActive) {
              final color = isActive
                  ? Colors.white
                  : isDark
                      ? const Color.fromARGB(255, 117, 105, 105)
                      : const Color.fromARGB(255, 146, 146, 146);
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconList[index],
                    size: 24,
                    color: color,
                  ),
                  AutoSizeText(
                    bottomNavNameList[index],
                    maxLines: 1,
                    style: TextStyle(color: color, fontSize: 5),
                    group: autoSizeGroup,
                  )
                ],
              );
            },
            backgroundColor: isDark ? Colors.grey[900] : Colors.indigo,
            activeIndex: _bottomNavIndex,
            splashSpeedInMilliseconds: 300,
            gapLocation: GapLocation.center,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
            onTap: (index) => setState(() => _bottomNavIndex = index),
          );
        },
      ),
    );
  }
}
