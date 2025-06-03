import 'package:flutter/material.dart';
import 'package:indisk_app/api_service/api_para.dart';
import 'package:indisk_app/api_service/index.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:indisk_app/utils/global_variables.dart';

import '../../../../../api_service/models/common_master.dart';
import '../../../../../api_service/models/food_list_master.dart';

class FoodListViewModel extends ChangeNotifier {
  Services services = Services();

  List<FoodListData> foodList = [];

  bool isApiLoading = false;

  Future<void> getFoodList({int? role}) async {
    isApiLoading = true;
    notifyListeners();
    foodList.clear();
    FoodListMaster? staffListMaster = await services.api!
        .getFoodList(params: {ApiParams.manager_id: gLoginDetails!.sId!});
    isApiLoading = false;
    notifyListeners();

    if (staffListMaster != null) {
      if (staffListMaster.success != null && staffListMaster.success!) {
        foodList.addAll(staffListMaster.data!);
      } else {
        showRedToastMessage(staffListMaster.message!);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }

  Future<void> deleteFood({String? id}) async {
    showProgressDialog();
    CommonMaster? staffListMaster = await services.api!.deleteFood(
        params: {ApiParams.id: id, ApiParams.user_id: gLoginDetails!.sId!});
    hideProgressDialog();

    if (staffListMaster != null) {
      if (staffListMaster.success != null && staffListMaster.success!) {
        getFoodList();
      } else {
        showRedToastMessage(staffListMaster.message!);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }

// Future<void> deleteFoodCategory({String? staffId}) async {
//   showProgressDialog();
//   CommonMaster? staffListMaster = await services.api!
//       .deleteFoodCategory(params: {
//     ApiParams.id : staffId
//   });
//   hideProgressDialog();
//
//   if (staffListMaster != null) {
//     if (staffListMaster.success != null && staffListMaster.success!) {
//       foodCategoryList.removeWhere((staffDetails) =>  staffDetails.sId == staffId);
//     }else{
//       showRedToastMessage(staffListMaster.message!);
//     }
//   } else {
//     oopsMSG();
//   }
//   notifyListeners();
// }
}
