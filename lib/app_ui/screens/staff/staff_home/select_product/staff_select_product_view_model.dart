import 'package:flutter/cupertino.dart';
import 'package:indisk_app/api_service/models/food_category_master.dart';
import 'package:indisk_app/api_service/models/staff_cart_master.dart';

import '../../../../../api_service/api_para.dart';
import '../../../../../api_service/index.dart';
import '../../../../../api_service/models/common_master.dart';
import '../../../../../api_service/models/staff_home_master.dart';
import '../../../../../utils/common_utills.dart';
import '../../../../../utils/global_variables.dart';
import '../../../app/app_view.dart';

class StaffSelectProductViewModel with ChangeNotifier {
  Services services = Services();
  bool? isApiLoading = false;
  bool? isCartApiLoading = false;
  bool? isFoodCategoryLoading = false;
  List<StaffHomeData> staffFoodList = [];
  List<StaffCartData> staffCartFoodList = [];
  String subTotal = '';
  String cartQty = '';
  String gst = '';
  String cartTotal = '';

  List<FoodCategoryDetails> foodCategoryList = [];

  Future<void> placeOrderApi(
      {required String tableNo}) async {
    isApiLoading = true;
    showProgressDialog();
    CommonMaster? master = await services.api!.placeOrder(params: {
      ApiParams.user_id: gLoginDetails!.sId!,
      ApiParams.table_no: tableNo,
    });
    hideProgressDialog();
    isApiLoading = false;
    if (master != null) {
      if (master.success) {
        Navigator.pop(mainNavKey.currentContext!, true);
      } else {
        showRedToastMessage(master.message);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }

  Future<void> getFoodCategoryList() async {
    isFoodCategoryLoading = true;
    isCartApiLoading = true;

    notifyListeners();
    foodCategoryList.clear();
    try {
      FoodCategoryMaster? staffListMaster = await services.api!
          .getFoodCategoryList(
              params: {ApiParams.staff_id: gLoginDetails?.sId});

      isFoodCategoryLoading = false;

      if (staffListMaster != null) {
        if (staffListMaster.success != null && staffListMaster.success!) {
          foodCategoryList.addAll(staffListMaster.data ?? []);
        } else {
          showRedToastMessage(
              staffListMaster.message ?? 'Failed to load categories');
        }
      } else {
        oopsMSG();
      }
    } catch (e) {
      isFoodCategoryLoading = false;
      showRedToastMessage('Error loading categories');
      debugPrint('Error loading categories: $e');
    }
    notifyListeners();
  }

  Future<void> getStaffFoodList({required bool isManageable}) async {
    isApiLoading = true;

    notifyListeners();
    staffFoodList.clear();
    StaffHomeMaster? staffListMaster = await services.api!
        .getStaffFoodList(params: {ApiParams.staff_id: gLoginDetails!.sId!, ApiParams.is_manageable: isManageable});
    isApiLoading = false;
    notifyListeners();

    if (staffListMaster != null) {
      if (staffListMaster.success != null && staffListMaster.success!) {
        staffFoodList = staffListMaster.data!;

      } else {
        showRedToastMessage(staffListMaster.message!);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }

  Future<void> addToCart({required String productId, required String tableNo}) async {
    showProgressDialog();
    isCartApiLoading = true;

    CommonMaster? master = await services.api!.addToCart(params: {
      ApiParams.user_id: gLoginDetails!.sId!,
      ApiParams.product_id: productId,
      ApiParams.table_no: tableNo,
      ApiParams.quantity: 1
    });
    hideProgressDialog();

    if (master != null) {
      if (master.success) {
        getStaffCartList(tableNo: tableNo);
      } else {
        showRedToastMessage(master.message);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }

  Future<void> getStaffCartList({required String tableNo}) async {
    isCartApiLoading = true;
    notifyListeners();
    staffCartFoodList.clear();
    StaffCartMaster? master = await services.api!
        .getStaffCartList(params: {ApiParams.user_id: gLoginDetails!.sId!, ApiParams.table_no: tableNo});
    isCartApiLoading = false;

    notifyListeners();

    if (master != null) {
      if (master.success != null && master.success!) {
        staffCartFoodList = master.cart ?? [];
        subTotal = master.subtotal.toString();
        cartQty = master.totalQuantity.toString();
        gst = master.gst5Percent.toString();
        cartTotal = master.totalWithGst.toString();
      } else {
        showRedToastMessage(master.message!);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }

  Future<void> updateQuantity(
      {required String productId, required String type, required String tableNo}) async {
    showProgressDialog();
    CommonMaster? master = await services.api!.updateQuantityStaffCart(params: {
      ApiParams.user_id: gLoginDetails!.sId!,
      ApiParams.product_id: productId,
      ApiParams.table_no: tableNo,
      ApiParams.type: type
    });
    hideProgressDialog();

    if (master != null) {
      if (master.success) {
        for (var cartItem in staffCartFoodList) {
          if (cartItem.foodItemId == productId) {
            if (type == 'increase') {
              cartItem.quantity = (cartItem.quantity ?? 0) + 1;
            } else if (type == 'decrease' && (cartItem.quantity ?? 0) > 0) {
              cartItem.quantity = (cartItem.quantity ?? 0) - 1;
            }
            break;
          }
        }

        for (var product in staffFoodList) {
          if (product.id == productId) {
            product.cartCount = staffCartFoodList
                    .firstWhere((item) => item.foodItemId == productId,
                        orElse: () => StaffCartData(quantity: 0))
                    .quantity ??
                0;
            break;
          }
        }
        getStaffCartList(tableNo: tableNo);
      } else {
        showRedToastMessage(master.message);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }

  Future<void> clearCart({required String tableNo}) async {
    showProgressDialog();
    CommonMaster? master = await services.api!.clearStaffCart(params: {
      ApiParams.user_id: gLoginDetails!.sId!,
      ApiParams.table_no: tableNo,
    });
    hideProgressDialog();

    if (master != null) {
      if (master.success) {
        getStaffFoodList(isManageable: false);
        getStaffCartList(tableNo: tableNo);
      } else {
        showRedToastMessage(master.message);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }

  Future<void> removeItemFromCart({required String productId, required String tableNo}) async {
    showProgressDialog();
    CommonMaster? master = await services.api!.removeItemStaffCart(params: {
      ApiParams.user_id: gLoginDetails!.sId!,
      ApiParams.product_id: productId,
      ApiParams.table_no: tableNo,
    });
    hideProgressDialog();

    if (master != null) {
      if (master.success) {
        getStaffCartList(tableNo: tableNo);
        for (var product in staffFoodList) {
          if (product.id == productId) {
            product.cartCount = staffCartFoodList
                    .firstWhere((item) => item.foodItemId == productId,
                        orElse: () => StaffCartData(quantity: 0))
                    .quantity ??
                0;
            break;
          }
        }
      } else {
        showRedToastMessage(master.message);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }

  Future<void> updateFoodAvailability(
      {required String productId, required bool status}) async {
    showProgressDialog();
    CommonMaster? commonMaster = await services.api!.updateFoodAvailability(params: {
      ApiParams.id: productId,
      ApiParams.is_available: status,
    }, files: [], onProgress: (bytes, totalBytes) {});
    hideProgressDialog();
    if (commonMaster != null) {
      if (commonMaster.success) {
        // showGreenToastMessage(commonMaster.message);
      } else {
        showRedToastMessage(commonMaster.message);
      }
    } else {
      oopsMSG();
    }
  }
}