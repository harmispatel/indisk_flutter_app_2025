import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:indisk_app/api_service/api_para.dart';
import 'package:indisk_app/api_service/index.dart';
import 'package:indisk_app/api_service/models/common_master.dart';
import 'package:indisk_app/api_service/models/file_model.dart';
import 'package:indisk_app/api_service/models/login_master.dart';
import 'package:indisk_app/api_service/models/staff_list_master.dart';
import 'package:indisk_app/app_ui/screens/app/app_view.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:indisk_app/utils/global_variables.dart';

class StaffListViewModel extends ChangeNotifier {
  Services services = Services();

  List<StaffListDetails> staffList = [];

  Future<void> getStaffList() async {
    showProgressDialog();
    staffList.clear();
    StaffListMaster? staffListMaster =
        await services.api!.getStaffList(params: {
      ApiParams.manager_id: gLoginDetails?.sId!,
    });
    hideProgressDialog();

    if (staffListMaster != null) {
      if (staffListMaster.success != null && staffListMaster.success!) {
        staffList.addAll(staffListMaster.data!);
      } else {
        // showRedToastMessage(staffListMaster.message!);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }

  Future<void> deleteStaff({String? staffId}) async {
    showProgressDialog();
    CommonMaster? staffListMaster =
        await services.api!.deleteStaff(params: {ApiParams.id: staffId});
    hideProgressDialog();

    if (staffListMaster != null) {
      if (staffListMaster.success != null && staffListMaster.success!) {
        showGreenToastMessage("Staff deleted successfully!");
        staffList.removeWhere((staffDetails) => staffDetails.sId == staffId);
      } else {
        showRedToastMessage(staffListMaster.message!);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }
}
