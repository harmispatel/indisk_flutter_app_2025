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
    FoodListMaster? master = await services.api!
        .getFoodList(params: {ApiParams.manager_id: gLoginDetails!.sId!});
    isApiLoading = false;
    notifyListeners();

    if (master != null) {
      if (master.success != null && master.success!) {
        foodList = master.data ?? [];
      } else {
        showRedToastMessage(master.message!);
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
      if (staffListMaster.success) {
        getFoodList();
      } else {
        showRedToastMessage(staffListMaster.message);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }

  Future<void> addFoodModifier({
    required String productId,
    required List<Map<String, dynamic>> discount,
    required List<Map<String, dynamic>> varient,
    required List<Map<String, dynamic>> modifier,
    required List<Map<String, dynamic>> topup,
  }) async {
    showProgressDialog();

    // Prepare the parameters with proper structure
    final params = {
      'id': productId,
      'discount': discount.map((d) {
        // Only include _id if it's a valid MongoDB ID (24 character hex string)
        final map = {
          'isEnable': d['isEnable'],
          'percentage': d['percentage'],
          'description': d['description'],
        };
        if (d['_id'] != null && d['_id'].toString().length == 24) {
          map['_id'] = d['_id'];
        }
        return map;
      }).toList(),
      'varient': varient.map((v) {
        final map = {
          'varientName': v['varientName'] ?? 'Varient ${v['price']}', // Add variantName
          'price': v['price'],
        };
        if (v['_id'] != null && v['_id'].toString().length == 24) {
          map['_id'] = v['_id'];
        }
        return map;
      }).toList(),
      'modifier': modifier.map((m) {
        final map = {
          'modifierName': m['modifierName'],
          'price': m['price'],
        };
        if (m['_id'] != null && m['_id'].toString().length == 24) {
          map['_id'] = m['_id'];
        }
        return map;
      }).toList(),
      'topup': topup.map((t) {
        final map = {
          'topupName': t['topupName'],
          'price': t['price'],
        };
        if (t['_id'] != null && t['_id'].toString().length == 24) {
          map['_id'] = t['_id'];
        }
        return map;
      }).toList(),
    };

    CommonMaster? master = await services.api!.addFoodModifier(params: params);
    hideProgressDialog();

    if (master != null) {
      if (master.success) {
        // Success case
        showGreenToastMessage('Modifiers updated successfully');
      } else {
        showRedToastMessage(master.message ?? 'Failed to update modifiers');
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
