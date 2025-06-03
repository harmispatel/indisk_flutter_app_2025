import 'dart:async';
import 'package:flutter/material.dart';
import 'package:indisk_app/api_service/models/login_master.dart';
import 'package:indisk_app/app_ui/screens/login/login_view.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:indisk_app/utils/global_variables.dart';

import '../../../database/app_preferences.dart';
import '../language_screen/languages_view.dart';

class SplashViewModel with ChangeNotifier {
  late BuildContext context;

  String? languageCode;

  bool? isFirstLaunch = true;
  String? role;

  LoginDetails? loginDetails;
  RestaurantDetails? restaurantDetails;

  Future<void> attachedContext(BuildContext context) async {
    this.context = context;

    role = await SP.instance.getRole();
    languageCode = await SP.instance.getLanguageCode();
    loginDetails = await SP.instance.getUserDetails();
    restaurantDetails = await SP.instance.getRestaurentDetails();
    gLoginDetails = loginDetails;
    gRestaurantDetails = restaurantDetails;

    startTimer();
  }

  startTimer() async {
    Future.delayed(const Duration(seconds: 2), () async {
      if (languageCode == null || languageCode!.isEmpty) {
        pushAndRemoveUntil(LanguagesView());
      } else {
        if (loginDetails != null) {
          redirectBasedOnRole(loginDetails: loginDetails!);
        } else {
          pushAndRemoveUntil(LoginView());
        }
      }
    });
  }
}
