import 'package:flutter/cupertino.dart';
import 'package:indisk_app/api_service/models/vat_master.dart';

import '../../../../api_service/api_para.dart';
import '../../../../api_service/index.dart';
import '../../../../utils/common_utills.dart';
import '../../../../utils/global_variables.dart';

class ManagerVatViewModel with ChangeNotifier {
  Services services = Services();
  String currentVat = '';

  Future<void> getVat() async {
    showProgressDialog();
    VatMaster? master = await services.api!.getVat(params: {
      ApiParams.manager_id: gLoginDetails!.sId!,
    });
    hideProgressDialog();
    if (master != null) {
      if (master.success!) {
        currentVat = master.data!.vat.toString();

      } else {
        showRedToastMessage(master.message ?? '--');
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }

  Future<void> saveVat({required String vat}) async {
    showProgressDialog();
    VatMaster? master = await services.api!.saveVat(params: {
      ApiParams.manager_id: gLoginDetails!.sId!,
      ApiParams.vat: vat,
    });
    hideProgressDialog();
    if (master != null) {
      if (master.success!) {
        currentVat = master.data!.vat.toString();
      } else {
        showRedToastMessage(master.message ?? '--');
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }
}
