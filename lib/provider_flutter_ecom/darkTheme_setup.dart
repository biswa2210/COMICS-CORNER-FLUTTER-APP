import 'package:flutter/material.dart';
import 'package:flutter_ecom_project/sharedPrefs/sharedprefs_darkTheme_set.dart';
class DarkThemeSetup with ChangeNotifier{
  DarkThemeSetSharedPrefs darkprefs = DarkThemeSetSharedPrefs();
  bool _darkTheme = false;
  bool get darkTheme=>_darkTheme;
  set darkTheme(bool value){
    _darkTheme = value;
    darkprefs.setDarkTheme(value);
    notifyListeners();
  }
}