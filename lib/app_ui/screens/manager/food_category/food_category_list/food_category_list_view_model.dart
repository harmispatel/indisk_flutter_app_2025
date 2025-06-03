import 'package:flutter/material.dart';
import 'package:indisk_app/api_service/api_para.dart';
import 'package:indisk_app/api_service/index.dart';
import 'package:indisk_app/api_service/models/common_master.dart';
import 'package:indisk_app/api_service/models/food_category_master.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:indisk_app/utils/global_variables.dart';

class FoodCategoryListViewModel extends ChangeNotifier {
  Services services = Services();

  List<FoodCategoryDetails> foodCategoryList = [];

  bool? isApiLoading = false;

  Future<void> getFoodCategoryList() async {
    isApiLoading = true;
    notifyListeners();
    foodCategoryList.clear();
    FoodCategoryMaster? staffListMaster = await services.api!
        .getFoodCategoryList(
            params: {ApiParams.manager_id: gLoginDetails?.sId});
    isApiLoading = false;
    notifyListeners();

    if (staffListMaster != null) {
      if (staffListMaster.success != null && staffListMaster.success!) {
        foodCategoryList.addAll(staffListMaster.data!);
      } else {
        // showRedToastMessage(staffListMaster.message!);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }

  Future<void> deleteFoodCategory({String? staffId}) async {
    showProgressDialog();
    CommonMaster? staffListMaster =
        await services.api!.deleteFoodCategory(params: {ApiParams.id: staffId});
    hideProgressDialog();

    if (staffListMaster != null) {
      if (staffListMaster.success != null && staffListMaster.success!) {
        foodCategoryList
            .removeWhere((staffDetails) => staffDetails.sId == staffId);
      } else {
        showRedToastMessage(staffListMaster.message!);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }
}
