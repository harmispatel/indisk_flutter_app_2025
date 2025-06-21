import 'package:flutter/cupertino.dart';

import '../../../api_service/api_para.dart';
import '../../../api_service/index.dart';
import '../../../api_service/models/get_profile_master.dart';
import '../../../utils/common_utills.dart';

class ProfileViewModel with ChangeNotifier{
  final Services services = Services();
  ProfileData? profileData;
  bool isApiLoading = false;

  Future<void> getProfileApi({
    required String email,
  }) async {
    isApiLoading = true;

    showProgressDialog();
    try {
      GetProfileMaster? master = await services.api!.getProfile(params: {
        ApiParams.email: email,
      });

      hideProgressDialog();
      isApiLoading = false;

      if (master == null) {
        showRedToastMessage('Failed get profile, Please try again.');
        return;
      }

      if (master.success == true) {
        profileData = master.data;
      } else {
        showRedToastMessage(master.message ?? 'Failed get profile');
      }
    } catch (e) {
      hideProgressDialog();
      showRedToastMessage('An error occurred: $e');
    } finally {
      notifyListeners();
    }
  }
}