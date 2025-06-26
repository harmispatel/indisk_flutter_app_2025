import 'package:flutter/cupertino.dart';

import '../../../../../api_service/api_para.dart';
import '../../../../../api_service/index.dart';
import '../../../../../api_service/models/restaurant_details_master.dart';
import '../../../../../utils/common_utills.dart';
import '../../../../../utils/global_variables.dart';

class RestaurantDetailsViewModel with ChangeNotifier {
  final Services services = Services();

  RestaurantDetailsData? restaurantDetailsData;
  bool isApiLoading = false;
  String? errorMessage;

  Future<void> getRestaurantDetailsApi({required String restaurantId}) async {
    try {
      showProgressDialog();

      final master = await services.api!.getRestaurantDetails(
        params: {
          ApiParams.owner_id: gLoginDetails!.sId!,
          ApiParams.restaurant_id: restaurantId
        },
      );

      hideProgressDialog();

      if (master != null && master.success == true) {
        restaurantDetailsData = master.data;
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
