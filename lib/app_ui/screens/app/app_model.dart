import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../database/app_preferences.dart';
import '../../../language/app_localizations.dart';
import '../../../main.dart';
import '../../../utils/app_constants.dart';


class AppModel with ChangeNotifier {
  bool darkTheme = false;
  String locale = AppConstants.LANGUAGE_ENGLISH;

  ConnectivityResult connectionStatus = ConnectivityResult.none;
  AppLifecycleState appState = AppLifecycleState.resumed;

  LanguageDataModel? selectedLanguageDataModel;
  List<LanguageDataModel> localeLanguageList = [];

  String selectedLanguage = "";



  void changeLanguage() async {
    String prefLocal = SP.instance.getLanguageCode();
    if (prefLocal.isEmpty) {
      prefLocal = this.locale;

    } else {
      this.locale = prefLocal;

    }

    notifyListeners();
  }

  void updateAppLifeCycleState(AppLifecycleState state) {
    appState = state;
    notifyListeners();
  }

  void updateTheme(bool theme) {
    darkTheme = theme;
    notifyListeners();
  }

  Future<void> setLanguage() async {
    selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: AppConstants.LANGUAGE_DANISH);
    selectedLanguage = getSelectedLanguageModel(defaultLanguage: AppConstants.LANGUAGE_DANISH)!.languageCode!;
    language = await AppLocalizations().load(Locale(selectedLanguage));
  }


}
