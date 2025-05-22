import 'dart:developer';

import 'package:indisk_app/api_service/models/file_model.dart';
import 'package:indisk_app/api_service/models/food_category_master.dart';
import 'package:indisk_app/api_service/models/login_master.dart';
import 'package:indisk_app/api_service/models/staff_list_master.dart';

import 'api_url.dart';
import 'base_client.dart';
import 'base_services.dart';
import 'models/common_master.dart';
import 'models/food_list_master.dart';
import 'models/get_profile_master.dart';
import 'models/owner_home_master.dart';
import 'models/restaurant_details_master.dart';
import 'models/restaurant_master.dart';

class ApiServices extends BaseServices {
  AppBaseClient appBaseClient = AppBaseClient();

  @override
  Future<LoginMaster?> login({required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.LOGIN,
      postParams: params,
    );
    if (response != null) {
      try {
        return LoginMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> createManager({
    required Map<String, String> params,
    required List<FileModel> files,
    required Function(int, int)? onProgress,
  }) async {
    dynamic response = await appBaseClient.formDataApi(
        url: ApiUrl.CREATE_MANAGER,
        postParams: params,
        files: files,
        onProgress: onProgress);
    if (response != null) {
      try {
        return CommonMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> updateManager(
      {required Map<String, String> params,
      required List<FileModel> files,
      required Function(int p1, int p2)? onProgress}) async {
    // TODO: implement updateManager
    dynamic response = await appBaseClient.formDataApi(
        url: ApiUrl.UPDATE_MANAGER,
        postParams: params,
        requestMethod: "PUT",
        files: files,
        onProgress: onProgress);
    if (response != null) {
      try {
        return CommonMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<StaffListMaster?> getStaffList(
      {required Map<String, dynamic> queryParams}) async {
    dynamic response = await appBaseClient.getApiCall(
        url: ApiUrl.GET_STAFF_LIST, queryParams: queryParams ?? {});
    if (response != null) {
      try {
        return StaffListMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> deleteStaff(
      {required Map<String, dynamic> params}) async {
    // TODO: implement deleteStaff
    dynamic response = await appBaseClient.deleteApiCall(
      url: ApiUrl.DELETE_STAFF,
      postParams: params,
    );
    if (response != null) {
      try {
        return CommonMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> createFoodCategory(
      {required Map<String, String> params,
      required List<FileModel> files,
      required Function(int p1, int p2)? onProgress}) async {
    dynamic response = await appBaseClient.formDataApi(
        url: ApiUrl.CREATE_FOOD_CATEGORY,
        postParams: params,
        files: files,
        onProgress: onProgress);
    if (response != null) {
      try {
        return CommonMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> deleteFoodCategory(
      {required Map<String, dynamic> params}) async {
    // TODO: implement deleteFoodCategory
    dynamic response = await appBaseClient.deleteApiCall(
      url: ApiUrl.DELETE_FOOD_CATEGORY,
      postParams: params,
    );
    if (response != null) {
      try {
        return CommonMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<FoodCategoryMaster?> getFoodCategoryList(
      {required Map<String, dynamic> queryParams}) async {
    // TODO: implement getFoodCategoryList
    dynamic response = await appBaseClient.getApiCall(
        url: ApiUrl.GET_FOOD_CATEGORY_LIST, queryParams: queryParams ?? {});
    if (response != null) {
      try {
        return FoodCategoryMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<FoodListMaster?> getFoodList(
      {required Map<String, dynamic> params}) async {
    // TODO: implement getFoodCategoryList
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.GET_FOOD,
      postParams: params,
    );
    if (response != null) {
      try {
        return FoodListMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> updateFoodCategory(
      {required Map<String, String> params,
      required List<FileModel> files,
      required Function(int p1, int p2)? onProgress}) async {
    dynamic response = await appBaseClient.formDataApi(
        url: ApiUrl.UPDATE_FOOD_CATEGORY,
        postParams: params,
        files: files,
        onProgress: onProgress,
        requestMethod: "PUT");
    if (response != null) {
      try {
        return CommonMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> createFood(
      {required Map<String, String> params,
      required List<FileModel> files,
      required Function(int p1, int p2)? onProgress}) async {
    // TODO: implement createFood
    dynamic response = await appBaseClient.formDataApi(
        url: ApiUrl.CREATE_FOOD,
        postParams: params,
        files: files,
        onProgress: onProgress);
    if (response != null) {
      try {
        return CommonMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> deleteFood(
      {required Map<String, dynamic> params}) async {
    // TODO: implement deleteStaff
    dynamic response = await appBaseClient.deleteApiCall(
      url: ApiUrl.DELETE_FOOD,
      postParams: params,
    );
    if (response != null) {
      try {
        return CommonMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> updateFood(
      {required Map<String, String> params,
      required List<FileModel> files,
      required Function(int p1, int p2)? onProgress}) async {
    dynamic response = await appBaseClient.formDataApi(
        url: ApiUrl.UPDATE_FOOD,
        postParams: params,
        files: files,
        onProgress: onProgress,
        requestMethod: "PUT");
    if (response != null) {
      try {
        return CommonMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> createRestaurant(
      {required Map<String, String> params,
      required List<FileModel> files,
      required Function(int p1, int p2)? onProgress}) async {
    dynamic response = await appBaseClient.formDataApi(
        url: ApiUrl.RESTAURANT_CREATE,
        postParams: params,
        files: files,
        onProgress: onProgress);
    if (response != null) {
      try {
        return CommonMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<RestaurantMaster?> getRestaurantList(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.RESTAURANT_LIST,
      postParams: params,
    );
    if (response != null) {
      try {
        return RestaurantMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> deleteRestaurant(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.deleteApiCall(
      url: ApiUrl.DELETE_RESTAURANT,
      postParams: params,
    );
    if (response != null) {
      try {
        return CommonMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<OwnerHomeMaster?> getOwnerHome(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.GET_OWNER_HOME,
      postParams: params,
    );
    if (response != null) {
      try {
        return OwnerHomeMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> editRestaurant(
      {required Map<String, String> params,
      required List<FileModel> files,
      required Function(int p1, int p2)? onProgress}) async {
    dynamic response = await appBaseClient.formDataApi(
        url: ApiUrl.EDIT_RESTAURANT,
        postParams: params,
        files: files,
        onProgress: onProgress,
        requestMethod: "PUT");
    if (response != null) {
      try {
        return CommonMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> changePassword(
      {required Map<String, dynamic> params}) async {
    // TODO: implement getFoodCategoryList
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.CHANGE_PASSWORD,
      postParams: params,
    );
    if (response != null) {
      try {
        return CommonMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<GetProfileMaster?> getProfile(
      {required Map<String, dynamic> params}) async {
    // TODO: implement getFoodCategoryList
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.GET_PROFILE,
      postParams: params,
    );
    if (response != null) {
      try {
        return GetProfileMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> updateOwnerProfile(
      {required Map<String, String> params,
        required List<FileModel> files,
        required Function(int p1, int p2)? onProgress}) async {
    dynamic response = await appBaseClient.formDataApi(
        url: ApiUrl.EDIT_PROFILE,
        postParams: params,
        files: files,
        onProgress: onProgress,
        requestMethod: "POST");
    if (response != null) {
      try {
        return CommonMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<RestaurantDetailsMaster?> getRestaurantDetails(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.GET_RESTAURANT_DETAILS,
      postParams: params,
    );
    if (response != null) {
      try {
        return RestaurantDetailsMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }
}
