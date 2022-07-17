import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  static const themeStatus = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeStatus, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeStatus) ?? false;
  }

}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      fontFamily: 'commonFont',
      
      primarySwatch: isDarkTheme ? Colors.grey : Colors.indigo,
      primaryColor: isDarkTheme ? Colors.black : Colors.white,

      backgroundColor: isDarkTheme ? Colors.black : const Color(0xffF1F5FB),

      primaryColorDark: Colors.grey[900],
      primaryColorLight: Colors.indigo,

      indicatorColor: isDarkTheme ? Colors.indigo : const Color(0xffCBDCF8),

      hintColor: isDarkTheme ? const Color(0xffCBDCF8) : Colors.grey,

      highlightColor: isDarkTheme ? const Color(0xff372901) : Colors.grey,

      focusColor:
          isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),

      disabledColor: Colors.grey,

      cardColor: isDarkTheme ? Colors.grey[900] : Colors.white60,

      appBarTheme: AppBarTheme(
        color: isDarkTheme ? Colors.grey[900] : Colors.indigo,
      ),

      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],

      textSelectionTheme: TextSelectionThemeData(
          selectionColor: isDarkTheme ? Colors.white : Colors.black),

      dialogBackgroundColor: isDarkTheme ? Colors.grey[800] : Colors.white,

      dialogTheme: DialogTheme(
        backgroundColor: isDarkTheme ? Colors.grey.shade900 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: isDarkTheme ? Colors.grey[900] : Colors.indigo,
      ),

      timePickerTheme: TimePickerThemeData(
        backgroundColor:isDarkTheme? Colors.grey[900] : Colors.white,
         )
    );
  }
}
