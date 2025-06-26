import 'package:flutter/cupertino.dart';

import '../../../../api_service/api_para.dart';
import '../../../../api_service/index.dart';
import '../../../../api_service/models/common_master.dart';
import '../../../../api_service/models/order_history_master.dart';
import '../../../../utils/common_utills.dart';
import '../../../../utils/global_variables.dart';

class OrderHistoryViewModel with ChangeNotifier {
  Services services = Services();
  List<Orders> orderHistory = [];

  Future<void> getOrderHistory() async {
    showProgressDialog();
    OrderHistoryMaster? master = await services.api!.getOrderHistory(params: {
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
        getOrderHistory();
      } else {
        showRedToastMessage(commonMaster.message);
      }
    } else {
      oopsMSG();
    }
  }
}
