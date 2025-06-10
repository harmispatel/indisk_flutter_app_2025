import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:indisk_app/api_service/api_para.dart';
import 'package:indisk_app/api_service/index.dart';
import 'package:indisk_app/app_ui/screens/manager/manager_dashboard/manager_dasbboard_view.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:indisk_app/utils/global_variables.dart';

import '../../../database/app_preferences.dart';
import '../kitchen_staff/kitchen_staff_dashboard/kitchen_staff_dashboard_view.dart';
import '../owner/owner_dashboard/owner_dashoboard.dart';
import '../staff/staff_dashboard/staff_dasboard_view.dart';

class LoginViewModel extends ChangeNotifier {
  Services services = Services();

  Future<void> loginApi(
      {required String username,
      required String password,
      required String role}) async {
    try {
      showProgressDialog();

      final loginMaster = await services.api?.login(params: {
        ApiParams.email: username,
        ApiParams.password: password,
        ApiParams.role: role
      });

      hideProgressDialog();

      if (loginMaster == null) {
        showRedToastMessage(loginMaster?.message ?? "Invalid credentials");
        return;
      }

      if (loginMaster.success == false) {
        // Handle failed login with server message
        showRedToastMessage(loginMaster.message ?? "Invalid credentials");
        return;
      }

      // Successful login handling
      showGreenToastMessage(loginMaster.message ?? "Login successful");

      // Store user details
      if (loginMaster.data != null) {
        gLoginDetails = loginMaster.data;
        await SP.instance.setUserDetails(jsonEncode(loginMaster.data!));
      } else {
        showRedToastMessage("Missing user data in response");
        return;
      }

      // Store restaurant details if available
      if (loginMaster.restaurantDetails != null) {
        gRestaurantDetails = loginMaster.restaurantDetails;
        await SP.instance.setRestaurentDetails(
          jsonEncode(loginMaster.restaurantDetails!),
        );
      }

      // Navigate based on role
      switch (gLoginDetails?.role?.toLowerCase()) {
        case "manager":
          pushAndRemoveUntil(ManagerDashboardView());
          break;
        case "staff":
          pushAndRemoveUntil(StaffDashboardView());
          break;
        case "kitchenstaff":
          pushAndRemoveUntil(KitchenStaffDashboardView());
          break;
        default:
          pushAndRemoveUntil(OwnerDashboard());
      }
    } catch (e) {
      hideProgressDialog();
      showRedToastMessage("Login failed: ${e.toString()}");
    }
  }
}
