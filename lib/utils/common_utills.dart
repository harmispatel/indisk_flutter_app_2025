import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:indisk_app/api_service/models/login_master.dart';
import 'package:indisk_app/app_ui/screens/app/app_view.dart';
import 'package:indisk_app/app_ui/screens/manager/manager_dashboard/manager_dasbboard_view.dart';
import 'package:indisk_app/app_ui/screens/restaurent_owner/owner_dashboard/owner_dashoboard.dart';
import 'package:indisk_app/utils/app_constants.dart';
import 'package:intl/intl.dart';

import '../app_ui/screens/staff/staff_dashboard/staff_dasboard_view.dart';
import 'common_styles.dart';
import 'global_variables.dart';
import 'local_images.dart';

pushToScreen(Widget screen) {
  Navigator.push(mainNavKey.currentContext!,
      CupertinoPageRoute(builder: (context) {
    return screen;
  }));

  // Navigator.push(
  //   mainNavKey.currentContext!,
  //   PageRouteBuilder(
  //     pageBuilder: (_, __, ___) => screen,
  //     transitionDuration: Duration(seconds: 1),
  //     transitionsBuilder: (_, a, __, c) => SlideTransition(position: ),
  //   ),
  // );
}

pushAndRemoveUntil(Widget screen) {
  Navigator.pushAndRemoveUntil(
    mainNavKey.currentContext!,
    CupertinoPageRoute(builder: (context) {
      return screen;
    }),
    (route) => false,
  );
}

pushReplacement(Widget screen) {
  Navigator.pushReplacement(
    mainNavKey.currentContext!,
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
    ),
  );
}

hideKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

String getFormattedDate(DateTime dateTime, String format) {
  try {
    //final DateFormat formatter = DateFormat('d MMM y, HH:mm');
    final DateFormat formatter = DateFormat(format);
    final String formatted = formatter.format(dateTime);
    return formatted;
  } catch (e) {
    log("error: ${e.toString()}");
  }
  return "--";
}

// String formatApiDateTime(DateTime dateTime, {bool? isTesting = true}) {
//   try {
//     final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
//     final String formatted = formatter.format(dateTime.toUtc());
//     return formatted;
//   } catch (e) {
//     log("error: ${e.toString()}");
//   }
//   return "--";
// }

String formatUiDateTime(String dateTime) {
  try {
    DateTime tempDateTime;
    if (dateTime.contains("T")) {
      tempDateTime =
          DateFormat("yyyy-MM-ddTHH:mm:ss").parse(dateTime, true).toLocal();
    } else {
      tempDateTime =
          DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTime, true).toLocal();
    }

    final DateFormat formatter = DateFormat('dd MMM, yy hh:mm:ss a');

    final String formatted = formatter.format(tempDateTime);
    return formatted;
  } catch (e) {
    print("Error DateTime $dateTime");
    log("error: ${e.toString()}");
  }
  return "--";
}

String reportDateTime(String dateTime) {
  try {
    DateTime tempDateTime;
    if (dateTime.contains("T")) {
      tempDateTime =
          DateFormat("yyyy-MM-ddTHH:mm:ss").parse(dateTime, true).toLocal();
    } else {
      tempDateTime = DateFormat("yyyy-MM-dd").parse(dateTime, true).toLocal();
    }

    final DateFormat formatter = DateFormat('dd MMM, yy');

    final String formatted = formatter.format(tempDateTime);
    return formatted;
  } catch (e) {
    print("Error DateTime $dateTime");
    log("error: ${e.toString()}");
  }
  return "--";
}

ImageProvider getImageProvider({String? imagePath}) {
  if (imagePath == null || imagePath.isEmpty) {
    return AssetImage(LocalImages.appLogo);
  } else if (imagePath.startsWith("http")) {
    return NetworkImage(imagePath);
  } else if (imagePath.startsWith("assets")) {
    return AssetImage(imagePath);
  } else {
    return FileImage(File(imagePath));
  }
}

void showSnackBar(
  String? message, {
  Color? color,
}) {
  ScaffoldMessenger.of(mainNavKey.currentContext!).hideCurrentSnackBar();
  ScaffoldMessenger.of(mainNavKey.currentContext!).showSnackBar(
    SnackBar(
      elevation: 0,
      content: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color ?? Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          message!,
          textAlign: TextAlign.center,
        ),
      ),
      padding: const EdgeInsets.all(5),
      backgroundColor: Colors.transparent,
    ),
  );
}

void oopsMSG() {
  if (connectivity) {
    ScaffoldMessenger.of(mainNavKey.currentContext!).hideCurrentSnackBar();
    ScaffoldMessenger.of(mainNavKey.currentContext!).showSnackBar(
      SnackBar(
        elevation: 0,
        content: Text(
          "Opps something went wrong!!",
          textAlign: TextAlign.center,
          style: getNormalTextStyle(
            fontSize: 16,
            fontColor: Colors.white,
          ),
        ),
        padding: const EdgeInsets.all(5),
        backgroundColor: Colors.red,
      ),
    );
  }
}

bool isValidEmail(String email) {
  Pattern pattern =
      r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$";
  RegExp regex = RegExp(pattern.toString());
  return (!regex.hasMatch(email)) ? false : true;
}

bool isShowing = false;

void showProgressDialog({from}) {
  isShowing = true;
  showCupertinoDialog(
    barrierDismissible: false,
// useSafeArea: true,
    context: mainNavKey.currentContext!,
    builder: (context) {
      return PopScope(
        canPop: false,
        child: Center(
          child: SpinKitRotatingCircle(
            color: Colors.white,
            size: 50.0,
          ),
        ),
      );
    },
  ).timeout(
    const Duration(seconds: 60),
    onTimeout: () {
      hideProgressDialog();
      oopsMSG();
    },
  );
}

void hideProgressDialog() {
  if (isShowing) {
    Navigator.of(mainNavKey.currentContext!, rootNavigator: true).pop('dialog');
    isShowing = false;
  }
}

void showToastMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void showGreenToastMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void showRedToastMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Color getStatusColor(String status) {
  if (status == "Pending") {
    return Colors.orange;
  } else if (status == "Completed") {
    return Colors.green;
  } else if (status == "Accepted") {
    return Colors.green;
  } else {
    return Colors.blue;
  }
}

DateTime convertUtcToLocal(String stringDate) {
  return DateFormat("yyyy-MM-dd HH:mm:ss").parse(stringDate, true).toLocal();
}

String convertDateToString(DateTime stringDate) {
  return DateFormat("yyyy-MM-dd HH:mm:ss").format(stringDate);
}

String getFormatTime(String stringDate) {
  return DateFormat("hh:mm a").format(
      DateFormat("yyyy-MM-dd hh:mm:ss").parse(stringDate, true).toLocal());
}

String getLocalFormatTime(String stringDate) {
  return DateFormat("hh:mm a")
      .format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(stringDate).toLocal());
}

DateTime getTimeFromStringHour(DateTime dateTime, String hour) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day,
      int.parse(hour.split(":")[0]), int.parse(hour.split(":")[1]));
}

formattedTime({required int timeInSecond}) {
  int sec = timeInSecond % 60;
  int min = ((timeInSecond / 60) % 60).floor();
  int hr = (timeInSecond / 3600).floor();
  String minute = min.toString().length <= 1 ? "0$min" : "$min";
  String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  String hour = hr.toString().length <= 1 ? "0$hr" : "$hr";
  return "$hour: $minute : $second";
}

bool isValidPhoneNumber(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{11,12}$)';
  RegExp regExp = RegExp(pattern);
  if (value.length == 0) {
    return false;
  } else if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

void redirectBasedOnRole({required LoginDetails loginDetails}) {
  if (loginDetails.role == AppConstants.ROLE_OWNER) {
    pushAndRemoveUntil(OwnerDashboard());
    print("Logged User Id............${loginDetails!.sId}");
    print("Logged User Role..........${loginDetails!.role}");

  } else if (loginDetails.role == AppConstants.ROLE_MANAGER) {
    pushAndRemoveUntil(ManagerDashboardView());
    print("Logged User Id............${loginDetails!.sId}");
    print("Logged User Role..........${loginDetails!.role}");

  } else if (loginDetails.role == AppConstants.ROLE_STAFF) {
    pushAndRemoveUntil(StaffDashboardView());
    print("Logged User Id............${loginDetails!.sId}");
    print("Logged User Role..........${loginDetails!.role}");

  }
}
