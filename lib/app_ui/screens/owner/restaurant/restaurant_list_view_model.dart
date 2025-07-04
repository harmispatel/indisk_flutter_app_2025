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
  bool isLoading = false;
  String? errorMessage;

  Future<void> getRestaurantList({int? role}) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await services.api!
          .getRestaurantList(params: {ApiParams.owner_id: gLoginDetails!.sId!});

      if (response != null) {
        if (response.success != null && response.success!) {
          restaurantList = response.data ?? [];
        } else {
          errorMessage = response.message ?? 'Failed to load restaurants';
          showRedToastMessage(errorMessage!);
        }
      } else {
        errorMessage = 'Unexpected error occurred';
        oopsMSG();
      }
    } catch (e) {
      errorMessage = 'Failed to load restaurants: ${e.toString()}';
      showRedToastMessage(errorMessage!);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteRestaurant({String? id}) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await services.api!.deleteRestaurant(
          params: {ApiParams.id: id, ApiParams.owner_id: gLoginDetails!.sId!});

      if (response != null) {
        if (response.success) {
          await getRestaurantList(); // Refresh the list after deletion
          showGreenToastMessage(response.message ?? 'Restaurant deleted successfully');
          return true;
        } else {
          errorMessage = response.message ?? 'Failed to delete restaurant';
          showRedToastMessage(errorMessage!);
          return false;
        }
      } else {
        errorMessage = 'Unexpected error occurred';
        oopsMSG();
        return false;
      }
    } catch (e) {
      errorMessage = 'Failed to delete restaurant: ${e.toString()}';
      showRedToastMessage(errorMessage!);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

// class RestaurantListViewModel with ChangeNotifier {
//   Services services = Services();
//   List<RestaurantData> restaurantList = [];
//
//
//   Future<void> getRestaurantList({int? role}) async {
//     showProgressDialog();
//
//     RestaurantMaster? staffListMaster = await services.api!
//         .getRestaurantList(params: {ApiParams.owner_id: gLoginDetails!.sId!});
//     hideProgressDialog();
//
//
//     if (staffListMaster != null) {
//       if (staffListMaster.success != null && staffListMaster.success!) {
//         restaurantList = staffListMaster.data!;
//       } else {
//         showRedToastMessage(staffListMaster.message!);
//       }
//     } else {
//       oopsMSG();
//     }
//     notifyListeners();
//   }
//
//   Future<void> deleteRestaurant({String? id}) async {
//     showProgressDialog();
//     CommonMaster? staffListMaster = await services.api!.deleteRestaurant(
//         params: {ApiParams.id: id, ApiParams.owner_id: gLoginDetails!.sId!});
//     hideProgressDialog();
//
//     if (staffListMaster != null) {
//       if (staffListMaster.success) {
//         getRestaurantList();
//       } else {
//         showRedToastMessage(staffListMaster.message);
//       }
//     } else {
//       oopsMSG();
//     }
//     notifyListeners();
//   }
// }
