import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indisk_app/api_service/index.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'app_ui/screens/app/app_view.dart';
import 'database/app_preferences.dart';
import 'language/languages.dart';

late BaseLanguage language;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  await SP.initPref();
  await initialize(aLocaleLanguageList: languageList());
  Services().configAPI();
  await Future.delayed(const Duration(milliseconds: 300));
  runApp(AppView());
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(
        id: 1,
        name: 'English',
        subTitle: 'English',
        languageCode: 'en',
        fullLanguageCode: 'en_en-US',
        flag: 'assets/flag/ic_us.png'),
    LanguageDataModel(
        id: 2,
        name: 'Danish',
        subTitle: 'Danish',
        languageCode: 'da',
        fullLanguageCode: 'da-DK',
        flag: 'assets/flag/ic_de.png'),
  ];
}
