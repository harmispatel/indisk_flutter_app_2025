import 'package:flutter/cupertino.dart';

import '../../../../api_service/api_para.dart';
import '../../../../api_service/index.dart';
import '../../../../api_service/models/common_master.dart';
import '../../../../api_service/models/restaurant_master.dart';
import '../../../../utils/common_utills.dart';
import '../../../../utils/global_variables.dart';

class RestaurantListViewModel with ChangeNotifier {
  Services services = Services();
  List<RestaurantData> restaurantList = [];

  bool isApiLoading = false;

  Future<void> getRestaurantList({int? role}) async {
    isApiLoading = true;
    notifyListeners();
    restaurantList.clear();
    RestaurantMaster? staffListMaster = await services.api!
        .getRestaurantList(params: {ApiParams.owner_id: gLoginDetails!.sId!});
    isApiLoading = false;
    notifyListeners();

    if (staffListMaster != null) {
      if (staffListMaster.success != null && staffListMaster.success!) {
        restaurantList.addAll(staffListMaster.data!);
      } else {
        showRedToastMessage(staffListMaster.message!);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }

  Future<void> deleteRestaurant({String? id}) async {
    showProgressDialog();
    CommonMaster? staffListMaster = await services.api!.deleteRestaurant(
        params: {ApiParams.id: id, ApiParams.owner_id: gLoginDetails!.sId!});
    hideProgressDialog();

    if (staffListMaster != null) {
      if (staffListMaster.success != null && staffListMaster.success!) {
        getRestaurantList();
      } else {
        showRedToastMessage(staffListMaster.message!);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }
}
