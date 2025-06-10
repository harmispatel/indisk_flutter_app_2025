import 'package:flutter/cupertino.dart';
import 'package:indisk_app/api_service/models/common_master.dart';

import '../../../../../api_service/api_para.dart';
import '../../../../../api_service/index.dart';
import '../../../../../database/app_preferences.dart';
import '../../../../../utils/common_utills.dart';
import '../../screens/login/login_view.dart';

class ChangePasswordViewModel with ChangeNotifier {
  final Services services = Services();

  Future<void> changePasswordApi({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    showProgressDialog();
    try {
      CommonMaster? master = await services.api!.changePassword(params: {
        ApiParams.email: email,
        ApiParams.currentPassword: currentPassword,
        ApiParams.newPassword: newPassword,
      });

      hideProgressDialog();

      if (master == null) {
        showRedToastMessage('Failed to change password. Please try again.');
        return;
      }

      if (master.success == true) {
        showGreenToastMessage(master.message);
        await SP.instance.removeLoginDetails();
        pushAndRemoveUntil(LoginView());
      } else {
        showRedToastMessage(master.message);
      }
    } catch (e) {
      hideProgressDialog();
      showRedToastMessage('An error occurred: $e');
    } finally {
      notifyListeners();
    }
  }
}
