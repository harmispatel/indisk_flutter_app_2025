import 'package:flutter/cupertino.dart';
import 'package:indisk_app/api_service/models/table_master.dart';

import '../../../../api_service/api_para.dart';
import '../../../../api_service/index.dart';
import '../../../../api_service/models/common_master.dart';
import '../../../../utils/common_utills.dart';
import '../../../../utils/global_variables.dart';
import '../../app/app_view.dart';

class TableViewModel with ChangeNotifier {
  Services services = Services();
  List<TableData> tablesList = [];
  bool isApiLoading = false;

  Future<void> addTable({required String tableNo}) async {
    showProgressDialog();
    CommonMaster? commonMaster = await services.api!.addTable(params: {
      ApiParams.manager_id: gLoginDetails!.sId!,
      ApiParams.table_no: tableNo,
    });
    hideProgressDialog();
    if (commonMaster != null) {
      if (commonMaster.success) {
        showGreenToastMessage(commonMaster.message);
        Navigator.pop(mainNavKey.currentContext!, true);
      } else {
        showRedToastMessage(commonMaster.message);
      }
    } else {
      oopsMSG();
    }
  }

  Future<void> getTable() async {
    isApiLoading = true;
    showProgressDialog();
    TableMaster? master = await services.api!.getTable(params: {
      ApiParams.manager_id: gLoginDetails!.sId!,
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
