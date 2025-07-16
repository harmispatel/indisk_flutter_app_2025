import 'package:flutter/material.dart';
import 'package:indisk_app/api_service/models/food_category_master.dart';
import 'package:indisk_app/api_service/models/order_bill_master.dart';
import 'package:indisk_app/api_service/models/staff_cart_master.dart';
import 'package:indisk_app/api_service/models/viva_payment_master.dart';
import 'package:indisk_app/app_ui/screens/staff/staff_dashboard/staff_dasboard_view.dart';
import '../../../../../api_service/api_para.dart';
import '../../../../../api_service/index.dart';
import '../../../../../api_service/models/common_master.dart';
import '../../../../../api_service/models/staff_home_master.dart';
import '../../../../../utils/common_utills.dart';
import '../../../../../utils/global_variables.dart';

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
  List<OrderBillItems> orderedItems = [];
  Summary? summary;
  String stripePaymentUrl = '';
  String vivaTerminalPaymentUrl = '';
  String stripePaymentId = '';
  String orderId = '';
  List<FoodCategoryDetails> foodCategoryList = [];
  BuildContext? context;

  Future<void> getTableBill({
    required String orderNo,
    required String orderType,
    required String tableNo,
  }) async {
    print('Fetching bill for order: $orderNo');
    showProgressDialog();

    try {
      OrderBillMaster? master = await services.api!.getOrderBill(params: {
        ApiParams.order_id: orderNo,
        ApiParams.order_type: orderType,
        ApiParams.table_no: tableNo,
      });
      if (master != null) {
        print('Bill API Response: ${master.toJson()}');
        if (master.success!) {
          orderedItems = master.items ?? [];
          summary = master.summary;
          orderId = master.orderId ?? orderNo;
          print('Bill loaded successfully for order: $orderId');
        } else {
          print('Bill API Error: ${master.message}');
          showRedToastMessage(master.message!);
        }
      } else {
        print('Bill API returned null');
        oopsMSG();
      }
    } catch (e) {
      print('Error in getTableBill: $e');
      showRedToastMessage('Failed to load bill details');
    } finally {
      hideProgressDialog();
      notifyListeners();
    }
  }

  Future<String?> placeOrderApi({required String tableNo}) async {
    isApiLoading = true;
    showProgressDialog();

    try {
      CommonMaster? master = await services.api!.placeOrder(params: {
        ApiParams.user_id: gLoginDetails!.sId!,
        ApiParams.table_no: tableNo,
      });

      if (master != null) {
        if (master.success) {
          // Store the order ID from the nested order object
          orderId = master.orderId!;
          print('Extracted Order ID: $orderId');
          if (orderId == null) {
            debugPrint('Warning: Order ID is null in API response');
          }
          notifyListeners();
          return orderId;
        } else {
          showRedToastMessage(master.message);
        }
      } else {
        oopsMSG();
      }
    } catch (e) {
      debugPrint('Error in placeOrderApi: $e');
      showRedToastMessage('Failed to place order');
    } finally {
      hideProgressDialog();
      isApiLoading = false;
    }
    return null;
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
    StaffHomeMaster? staffListMaster = await services.api!.getStaffFoodList(
        params: {
          ApiParams.staff_id: gLoginDetails!.sId!,
          ApiParams.is_manageable: isManageable
        });
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

  Future<void> addToCart({
    required String productId,
    required String tableNo,
    required List<String> variantIds,
    required String? discountId,
    required List<String> modifierIds,
    required List<String> topupIds,
    required String specialInstruction,
  }) async {
    showProgressDialog();
    isCartApiLoading = true;
    notifyListeners();

    try {
      final params = {
        'user_id': gLoginDetails!.sId!,
        'product_id': productId,
        'table_no': tableNo,
        'varient': variantIds,
        'discount': discountId,
        'modifier': modifierIds,
        'topup': topupIds,
        'special_instruction': specialInstruction,
        'quantity': 1
      };

      print('API Params:');
      print(params);

      CommonMaster? master = await services.api!.addToCart(params: params);

      if (master != null && master.success) {
        getStaffCartList(tableNo: tableNo);
      } else {
        showRedToastMessage(master?.message ?? 'Failed to add to cart');
      }
    } catch (e) {
      showRedToastMessage('Error: ${e.toString()}');
    } finally {
      hideProgressDialog();
      isCartApiLoading = false;
      notifyListeners();
    }
  }

  Future<void> getStaffCartList({required String tableNo}) async {
    isCartApiLoading = true;
    notifyListeners();
    staffCartFoodList.clear();
    StaffCartMaster? master = await services.api!.getStaffCartList(params: {
      ApiParams.user_id: gLoginDetails!.sId!,
      ApiParams.table_no: tableNo
    });
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
      {required String productId,
      required String type,
      required String tableNo}) async {
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
                    .firstWhere((item) => item?.foodItemId == productId,
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

  Future<void> removeItemFromCart(
      {required String productId, required String tableNo}) async {
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
    CommonMaster? commonMaster =
        await services.api!.updateFoodAvailability(params: {
      ApiParams.id: productId,
      ApiParams.is_available: status,
    }, files: [], onProgress: (bytes, totalBytes) {});
    hideProgressDialog();
    if (commonMaster != null) {
      if (commonMaster.success) {
        showGreenToastMessage(commonMaster.message);
      } else {
        showRedToastMessage(commonMaster.message);
      }
    } else {
      oopsMSG();
    }
  }

  Future<void> getVivaPaymentApi(
      {required String tableNo, required String orderId}) async {
    showProgressDialog();
    Map<String, dynamic> params = <String, dynamic>{
      ApiParams.table_no: tableNo,
      ApiParams.orderId: orderId,
    };
    try {
      StripePaymentMaster? master =
          await services.api!.getVivaPaymentApi(params: params);
      if (master == null) {
        oopsMSG();
        print("Get Viva Payment oops: null response");
      } else if (master.success == false) {
        showRedToastMessage(master.message.toString());
        print("VivaPay API Error: ${master.message}");
      } else if (master.success!) {
        stripePaymentUrl = master.checkoutUrl ?? '';
        print("VivaPay Payment URL: $stripePaymentUrl");
        getUpdatePaymentApi(
            tableNo: tableNo,
            status: "paid",
            paymentType: "viva",
            orderId: orderId);
        showGreenToastMessage("Payment URL generated successfully");
      }
    } catch (e) {
      print("Exception in VivaPay API: $e");
    } finally {
      hideProgressDialog();
      notifyListeners();
    }
  }

  Future<void> getVivaTerminalPaymentApi({
    required String terminalId,
    required String tableNo,
    required String orderId,
  }) async {
    showProgressDialog();
    Map<String, dynamic> params = <String, dynamic>{
      ApiParams.terminalId: terminalId,
      ApiParams.table_no: tableNo,
      ApiParams.orderId: orderId,
    };
    try {
      StripePaymentMaster? master =
          await services.api!.getVivaTerminalPaymentApi(params: params);
      if (master == null) {
        oopsMSG();
        print("Get Viva Terminal Payment oops: null response");
      } else if (master.success == false) {
        showRedToastMessage(master.message.toString());
        print("Viva Terminal Payment API Error: ${master.message}");
      } else if (master.success!) {
        vivaTerminalPaymentUrl = master.checkoutUrl ?? '';
        print("Viva Terminal Payment URL: $vivaTerminalPaymentUrl");
        getUpdatePaymentApi(
            tableNo: tableNo,
            status: "paid",
            paymentType: "viva-terminal",
            orderId: orderId);
        showGreenToastMessage(
            "Viva Terminal Payment URL generated successfully");
      }
    } catch (e) {
      print("Exception in Viva Terminal Payment API: $e");
    } finally {
      hideProgressDialog();
      notifyListeners();
    }
  }

  Future<void> getUpdatePaymentApi({
    required String tableNo,
    required String status,
    required String paymentType,
    required String orderId,
  }) async {
    showProgressDialog();

    Map<String, dynamic> params = <String, dynamic>{
      ApiParams.table_no: tableNo,
      ApiParams.status: status,
      ApiParams.paymentType: paymentType,
      ApiParams.orderId: orderId,
    };
    try {
      StripePaymentMaster? master =
          await services.api!.getPaymentStatusApi(params: params);
      if (master == null) {
        oopsMSG();
        print("Get getUpdatePaymentApi Payment oops: null response");
      } else if (master.success == false) {
        showRedToastMessage(
            master.message?.toString() ?? "Payment update failed");
        print("getUpdatePaymentApi API Error: ${master.message}");
      } else if (master.success == true) {
        Navigator.pushAndRemoveUntil(
          context!,
          MaterialPageRoute(
            builder: (context) => StaffDashboardView(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print("getUpdatePaymentApi : $e");
    } finally {
      hideProgressDialog();
      notifyListeners();
    }
  }

  Future<void> handlePaymentCompletion(String transactionId) async {
    showProgressDialog();
    hideProgressDialog();
    showGreenToastMessage(
        "Payment completed successfully! Transaction ID: $transactionId");
    notifyListeners();
  }

  void handlePaymentFailure(String error) {
    showRedToastMessage("Payment failed: $error");
    notifyListeners();
  }
}
