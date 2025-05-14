import 'package:indisk_app/api_service/models/file_model.dart';
import 'package:indisk_app/api_service/models/food_category_master.dart';
import 'package:indisk_app/api_service/models/login_master.dart';

import 'models/common_master.dart';
import 'models/food_list_master.dart';
import 'models/owner_home_master.dart';
import 'models/restaurant_master.dart';
import 'models/staff_list_master.dart';

abstract class BaseServices {
  Future<LoginMaster?> login({required Map<String, dynamic> params});
  Future<CommonMaster?> createManager({
    required Map<String, String> params,
    required List<FileModel> files,
    required Function(int, int)? onProgress,
  });

  Future<CommonMaster?> updateManager({
    required Map<String, String> params,
    required List<FileModel> files,
    required Function(int, int)? onProgress,
  });

  Future<StaffListMaster?> getStaffList(
      {required Map<String, dynamic> queryParams});

  Future<CommonMaster?> deleteStaff({required Map<String, dynamic> params});

  Future<CommonMaster?> createFoodCategory({
    required Map<String, String> params,
    required List<FileModel> files,
    required Function(int, int)? onProgress,
  });

  Future<CommonMaster?> updateFoodCategory({
    required Map<String, String> params,
    required List<FileModel> files,
    required Function(int, int)? onProgress,
  });

  Future<FoodCategoryMaster?> getFoodCategoryList(
      {required Map<String, dynamic> queryParams});

  Future<CommonMaster?> deleteFoodCategory(
      {required Map<String, dynamic> params});

  Future<CommonMaster?> createFood({
    required Map<String, String> params,
    required List<FileModel> files,
    required Function(int, int)? onProgress,
  });

  Future<CommonMaster?> updateFood({
    required Map<String, String> params,
    required List<FileModel> files,
    required Function(int, int)? onProgress,
  });

  Future<FoodListMaster?> getFoodList({required Map<String, dynamic> params});

  Future<CommonMaster?> deleteFood({required Map<String, dynamic> params});

  Future<CommonMaster?> createRestaurant(
      {required Map<String, String> params,
      required List<FileModel> files,
      required Function(int p1, int p2)? onProgress});

  Future<RestaurantMaster?> getRestaurantList(
      {required Map<String, dynamic> params});

  Future<CommonMaster?> deleteRestaurant(
      {required Map<String, dynamic> params});

  Future<OwnerHomeMaster?> getOwnerHome({required Map<String, dynamic> params});
}
