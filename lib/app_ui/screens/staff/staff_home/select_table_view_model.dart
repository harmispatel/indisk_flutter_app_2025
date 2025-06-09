import 'package:flutter/cupertino.dart';

import '../../../../api_service/api_para.dart';
import '../../../../api_service/index.dart';
import '../../../../api_service/models/table_master.dart';
import '../../../../utils/common_utills.dart';
import '../../../../utils/global_variables.dart';

class SelectTableViewModel with ChangeNotifier {
  Services services = Services();
  List<TableData> tablesList = [];
  bool isApiLoading = false;

  Future<void> getTable() async {
    isApiLoading = true;
    showProgressDialog();
    TableMaster? master = await services.api!.getTable(params: {
      ApiParams.staff_id: gLoginDetails!.sId!,
    });
    hideProgressDialog();
    isApiLoading = false;
    if (master != null) {
      if (master.success!) {
        tablesList = master.data ?? [];
      } else {
        showRedToastMessage(master.message ?? 'Error to get tables');
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }
}
