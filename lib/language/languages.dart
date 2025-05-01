import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage? of(BuildContext context) =>
      Localizations.of<BaseLanguage>(context, BaseLanguage);

  String get appName;
  String get userName;
  String get password;
  String get pleaseEnterUsername;
  String get pleaseEnterPassword;
  String get login;
  String get loginToContinue;
  String get noInternet;
  String get chooseYourPrefferedLanguage;
  String get confirm;
  String get name;
  String get phone;
  String get email;
  String get plsSelectProfilePicture;


}
