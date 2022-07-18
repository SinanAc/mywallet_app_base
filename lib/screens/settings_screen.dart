// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:my_wallet/data_base/db_functions.dart';
import 'package:my_wallet/widgets/dark_theme.dart';
import 'package:my_wallet/widgets/notifications.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

ValueNotifier<bool> darkThemePreference = ValueNotifier(false);

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkStatus = false;
  void listNotifications() => NotificationFunctions.onNotifications;

  @override
  void initState() {
    super.initState();
    NotificationFunctions.init(initScheduled: true);
    listNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              ListTile(
                title: const Text('Dark Mode'),
                leading: const Icon(
                  Icons.dark_mode_outlined,
                  color: Colors.blue,
                ),
                trailing: Switch(
                    value: themeChange.darkTheme,
                    onChanged: (bool value) {
                      darkModeCheck(value);
                      setState(() {
                        darkStatus = value;
                      });
                      themeChange.darkTheme = value;
                    }),
              ),
              settingsList(
                title: 'Set Reminder',
                icon: Icons.notifications_active_outlined,
              ),
              settingsList(
                title: 'Delete Reminder',
                icon: Icons.delete_outline,
              ),
              settingsList(
                title: 'Reset App',
                icon: Icons.restore,
              ),
              settingsList(
                title: 'About us',
                icon: Icons.info_outline,
              ),
              settingsList(
                title: 'Share to Friends',
                icon: Icons.share_outlined,
              ),
            ],
          )),
    );
  }

  Widget settingsList({String? title, IconData? icon}) {
    return ListTile(
      title: Text(title!),
      leading: Icon(icon, color: Colors.blue),
      onTap: () async {
        title == 'Set Reminder'
            ? setReminder()
            : title == 'Delete Reminder'
                ? deleteReminder()
                : title == 'Reset App'
                    ? resetVerification()
                    : title == 'About us'
                        ? about()
                        : await Share.share('https://play.google.com/store/apps/details?id=com.fouvty.mywallet');
      },
    );
  }

  setReminder() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime == null) {
      return;
    } else {
      await NotificationFunctions.showNotification(
          title: 'You have a Reminder',
          body: "Did you add your transactions today? Start adding now",
          payload: 'reminder',
          selectedHour: selectedTime.hour,
          selectedMinute: selectedTime.minute);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            selectedTime.hour >= 12
                ? "You will get a reminder at ${selectedTime.hour > 12 ? selectedTime.hour - 12 : selectedTime.hour} : ${selectedTime.minute ==0? selectedTime.minute : selectedTime.minute < 10 ? '0${selectedTime.minute}' : selectedTime.minute } PM"
                : "You will get a reminder at ${selectedTime.hour == 0 ? 12 : selectedTime.hour > 12 ? selectedTime.hour - 12 : selectedTime.hour }:${selectedTime.minute ==0? selectedTime.minute : selectedTime.minute < 10 ? '0${selectedTime.minute}' : selectedTime.minute } AM",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.grey,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  deleteReminder() async {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Delete Reminder',
                style: TextStyle(
                  color: Colors.red,
                )),
            content: const Text(
                'Are you sure to want to delete? This action will delete your scheduled reminder !!'),
            actions: [
              TextButton(
                child: const Text('Cancel',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Delete',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
                onPressed: () {
                  NotificationFunctions.deleteAllNotifications();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Reminder has been deleted',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.grey,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

  void darkModeCheck(value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('dark', value);
    darkThemePreference.value = value;
    darkThemePreference.notifyListeners();
  }

  resetVerification() async {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text(
              'Reset !!',
              style: TextStyle(color: Colors.red),
            ),
            content: const Text(
                'Are you sure to want to reset? This action will clear all the data !!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Cancel',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {
                  appReset(context);
                },
                child: const Text('Reset',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        });
  }

  about() {
    showAboutDialog(
        context: context,
        applicationName: 'MyWallet',
        applicationVersion: 'version : 1.0.0',
        applicationIcon: SizedBox(
            height: MediaQuery.of(context).size.height * 0.11,
            child: Image.asset('assets/appLogoo.png')),
        applicationLegalese: '©2022 MyWallet',
        children: [
          const SizedBox(height: 10),
          const Text(
              'My Wallet is a simple app to manage your money easily. It is a free app and you can use it without any cost.'),
        ]);
  }
}
