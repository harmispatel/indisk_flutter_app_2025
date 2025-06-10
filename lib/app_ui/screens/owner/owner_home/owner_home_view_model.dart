import 'package:flutter/cupertino.dart';

import '../../../../api_service/api_para.dart';
import '../../../../api_service/index.dart';
import '../../../../api_service/models/owner_home_master.dart';
import '../../../../utils/common_utills.dart';
import '../../../../utils/global_variables.dart';

class OwnerHomeViewModel with ChangeNotifier {
  final Services services = Services();

  OwnerHomeData? homeData;
  bool isApiLoading = false;
  String? errorMessage;

  Future<void> getOwnerHomeApi() async {
    try {
      // Check if user is logged in
      if (gLoginDetails == null || gLoginDetails?.sId == null) {
        errorMessage = "User not logged in";
        isApiLoading = false;
        notifyListeners();
        return;
      }

      isApiLoading = true;
      errorMessage = null;
      notifyListeners();

      final master = await services.api!.getOwnerHome(
        params: {ApiParams.owner_id: gLoginDetails!.sId!},
      );

      isApiLoading = false;

      if (master != null && master.success == true) {
        homeData = master.data;
      } else {
        errorMessage = "Something went wrong";
        showRedToastMessage(errorMessage!);
      }
    } catch (e) {
      isApiLoading = false;
      errorMessage = "Failed to load data: ${e.toString()}";
      showRedToastMessage(errorMessage!);
    } finally {
      notifyListeners();
    }
  }
}
