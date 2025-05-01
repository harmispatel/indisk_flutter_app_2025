import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_service/models/login_master.dart';





class SP {
/* -------------------------------------------- Preference Constants -------------------------------------------- */

  // Constants for Preference-Name
  final String keyLoginDetails = "KEY_LOGIN_DETAILS";
  final String keyRestaurentDetails = "KEY_RESTAURENT_DETAILS";

  final String role = "role";
  final String keyLanguageCode = "KEY_LANGUAGE_CODE";

  final String keyFCMToken = "keyFCMToken";



  static final SP instance = SP.internal();

  factory SP() => instance;

  static SharedPreferences? _pref;

  SP.internal();

  static Future<SharedPreferences> initPref() async {
    _pref = await SharedPreferences.getInstance();
    return _pref!;
  }

  Future<bool> setUserDetails(String value) {
    return _pref!.setString(keyLoginDetails, value);
  }

  Future<LoginDetails?> getUserDetails() async {
    try {
      String? loginStr = await _pref!.getString(keyLoginDetails);

      if (loginStr != null && loginStr.isNotEmpty) {
        return LoginDetails.fromJson(jsonDecode(loginStr));
      }
    } on Exception catch (e) {
      // TODO
      return null;
    }

    return null;
  }


  Future<bool> setRestaurentDetails(String value) {
    return _pref!.setString(keyRestaurentDetails, value);
  }

  Future<RestaurantDetails?> getRestaurentDetails() async {
    try {
      String? loginStr = await _pref!.getString(keyRestaurentDetails);

      if (loginStr != null && loginStr.isNotEmpty) {
        return RestaurantDetails.fromJson(jsonDecode(loginStr));
      }
    } on Exception catch (e) {
      // TODO
      return null;
    }

    return null;
  }

  Future<void>   removeLoginDetails() async{
   await _pref!.remove(keyLoginDetails);
  }



  Future<bool> setRole(String value) {
    return _pref!.setString(role, value);
  }

  Future<String?> getRole() async {
    String? stringData = await _pref!.getString(role);
    if (stringData != null && stringData.isNotEmpty) {
      return stringData;
    }
    return null;
  }

  Future<bool> setFCMToken(String value) async {
    return _pref!.setString(keyFCMToken, value);
  }

  // Method to get FCM token
  String getFCMToken() {
    return _pref!.getString(keyFCMToken) ?? "";
  }

  // Method to set language code
  Future<bool> setLanguageCode(String value) {
    return _pref!.setString(keyLanguageCode, value);
  }

  // Method to get Language code
  String getLanguageCode() {
    return _pref!.getString(keyLanguageCode) ?? "";
  }

  Future<bool> clear() {
    return _pref!.clear();
  }



  Future<bool> removeRole() async {
    return await _pref!.remove(role);
  }
}
