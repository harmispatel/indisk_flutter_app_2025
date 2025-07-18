import 'package:flutter/cupertino.dart';
import 'package:indisk_app/api_service/models/order_history_master.dart';
import '../../../../api_service/api_para.dart';
import '../../../../api_service/index.dart';
import '../../../../api_service/models/common_master.dart';
import '../../../../api_service/models/kitchen_staff_order_master.dart';
import '../../../../utils/common_utills.dart';
import '../../../../utils/global_variables.dart';

class KitchenStaffHomeViewModel with ChangeNotifier {
  Services services = Services();
  List<KitchenStaffOrders> kitchenOrders = [];
  List<Orders> orderHistory = [];

  Future<void> getKitchenStaffOrderList() async {
    try {
      showProgressDialog();
      KitchenStaffOrderMaster? master =
          await services.api!.getKitchenStaffOrder();
      hideProgressDialog();
      if (master == null) {
        oopsMSG();
        return;
      }
      if (master.success != null && master.success!) {
        kitchenOrders = master.orders ?? [];
      } else {
        showRedToastMessage(master.message!);
      }
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      await Future.delayed(Duration(seconds: 10));
      print("Fetching Socket Data again after 10 seconds");
      getKitchenStaffOrderList();
    }
  }

  Future<void> updateFoodStatus(
      {required String orderId, required String status}) async {
    showProgressDialog();
    CommonMaster? commonMaster = await services.api!.updateFoodStatus(params: {
      ApiParams.order_id: orderId,
      ApiParams.status: status,
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

  Future<void> getKitchenStaffHistory() async {
    showProgressDialog();
    OrderHistoryMaster? master =
        await services.api!.getKitchenStaffHistory(params: {
      ApiParams.user_id: gLoginDetails!.sId!,
    });
    hideProgressDialog();
    if (master != null) {
      if (master.success!) {
        orderHistory = master.orders ?? [];
      } else {
        showRedToastMessage(master.message ?? '--');
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }
}
