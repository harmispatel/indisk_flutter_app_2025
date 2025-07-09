import 'dart:developer';

import 'package:indisk_app/api_service/models/file_model.dart';
import 'package:indisk_app/api_service/models/food_category_master.dart';
import 'package:indisk_app/api_service/models/login_master.dart';
import 'package:indisk_app/api_service/models/salep_graph_master.dart';
import 'package:indisk_app/api_service/models/sales_count_master.dart';
import 'package:indisk_app/api_service/models/staff_cart_master.dart';
import 'package:indisk_app/api_service/models/staff_list_master.dart';
import 'package:indisk_app/api_service/models/viva_payment_master.dart';

import 'api_url.dart';
import 'base_client.dart';
import 'base_services.dart';
import 'models/common_master.dart';
import 'models/food_list_master.dart';
import 'models/get_profile_master.dart';
import 'models/kitchen_staff_order_master.dart';
import 'models/order_bill_master.dart';
import 'models/order_history_master.dart';
import 'models/owner_home_master.dart';
import 'models/restaurant_details_master.dart';
import 'models/restaurant_master.dart';
import 'models/staff_home_master.dart';
import 'models/table_master.dart';
import 'models/vat_master.dart';

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
  Future<CommonMaster?> createStaff({
    required Map<String, String> params,
    required List<FileModel> files,
    required Function(int, int)? onProgress,
  }) async {
    dynamic response = await appBaseClient.formDataApi(
        url: ApiUrl.CREATE_STAFF,
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
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
        url: ApiUrl.GET_STAFF_LIST, postParams: params);
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
      {required Map<String, dynamic> params}) async {
    // TODO: implement getFoodCategoryList
    dynamic response = await appBaseClient.postApiCall(
        url: ApiUrl.GET_FOOD_CATEGORY_LIST, postParams: params ?? {});
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
      {required Map<String, dynamic> params,
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

  @override
  Future<StaffHomeMaster?> getStaffFoodList(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.GET_FOOD,
      postParams: params,
    );
    if (response != null) {
      try {
        return StaffHomeMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> addToCart(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.ADD_TO_CART,
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
  Future<StaffCartMaster?> getStaffCartList(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.GET_CART,
      postParams: params,
    );
    if (response != null) {
      try {
        return StaffCartMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> updateQuantityStaffCart(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.UPDATE_QUANTITY,
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
  Future<CommonMaster?> clearStaffCart(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.CLEAR_CART,
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
  Future<CommonMaster?> removeItemStaffCart(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.REMOVE_TO_CART,
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
  Future<CommonMaster?> addTable({required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
        url: ApiUrl.CREATE_TABLE, postParams: params ?? {});
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
  Future<TableMaster?> getTable({required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
        url: ApiUrl.GET_TABLES, postParams: params ?? {});
    if (response != null) {
      try {
        return TableMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> placeOrder(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
        url: ApiUrl.PLACE_ORDER, postParams: params ?? {});
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
  Future<KitchenStaffOrderMaster?> getKitchenStaffOrder() async {
    try {
      dynamic response = await appBaseClient.getApiCall(
        url: ApiUrl.GET_KITCHEN_STAFF_ORDERS,
      );

      if (response is Map<String, dynamic>) {
        return KitchenStaffOrderMaster.fromJson(response);
      } else if (response is String) {
        log("Unexpected string response: $response");
      }
      return null;
    } catch (e) {
      log("Error in getKitchenStaffOrder: $e");
      return null;
    }
  }

  @override
  Future<CommonMaster?> updateFoodStatus(
      {required Map<String, String> params,
      required List<FileModel> files,
      required Function(int p1, int p2)? onProgress}) async {
    // TODO: implement updateManager
    dynamic response = await appBaseClient.formDataApi(
        url: ApiUrl.UPDATE_ORDER_STATUS,
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
  Future<CommonMaster?> updateFoodAvailability(
      {required Map<String, dynamic> params,
      required List<FileModel> files,
      required Function(int p1, int p2)? onProgress}) async {
    // TODO: implement updateManager
    dynamic response = await appBaseClient.formDataApi(
        url: ApiUrl.UPDATE_AVALIBALITY_STATUS,
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
  Future<OrderHistoryMaster?> getOrderHistory(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
        url: ApiUrl.ORDER_HISTORY, postParams: params ?? {});
    if (response != null) {
      try {
        return OrderHistoryMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<VatMaster?> getVat({required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
        url: ApiUrl.GET_VAT, postParams: params ?? {});
    if (response != null) {
      try {
        return VatMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<VatMaster?> saveVat({required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
        url: ApiUrl.SAVE_VAT, postParams: params ?? {});
    if (response != null) {
      try {
        return VatMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<CommonMaster?> addFoodModifier(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
        url: ApiUrl.ADD_FOOD_MODIFIER, postParams: params ?? {});
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
  Future<OrderBillMaster?> getOrderBill(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
        url: ApiUrl.GET_TABLE_BILL, postParams: params ?? {});
    if (response != null) {
      try {
        return OrderBillMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<OrderBillMaster?> getTakeAwayOrders(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
        url: ApiUrl.GET_TAKEAWAY_ORDERS, postParams: params ?? {});
    if (response != null) {
      try {
        return OrderBillMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<SalesGraphMaster?> salesGraphApi(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.SALES_GRAPH,
      postParams: params,
    );
    if (response != null) {
      try {
        return SalesGraphMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<SalesCountMaster?> salesCountApi(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.SALES_COUNT,
      postParams: params,
    );
    if (response != null) {
      try {
        return SalesCountMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<StripePaymentMaster?> getVivaPaymentApi(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.VIVA_PAYMENT,
      postParams: params,
    );
    if (response != null) {
      try {
        return StripePaymentMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<StripePaymentMaster?> getPaymentStatusApi(
      {required Map<String, dynamic> params}) async {
    dynamic response = await appBaseClient.postApiCall(
      url: ApiUrl.UPDATE_PAYMENT_STUTUS,
      postParams: params,
    );
    if (response != null) {
      try {
        return StripePaymentMaster.fromJson(response);
      } on Exception catch (e) {
        log("Exception :: $e");
        return null;
      }
    } else {
      return null;
    }
  }
}
