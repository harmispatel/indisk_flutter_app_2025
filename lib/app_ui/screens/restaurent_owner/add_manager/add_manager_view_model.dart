import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:indisk_app/api_service/api_para.dart';
import 'package:indisk_app/api_service/index.dart';
import 'package:indisk_app/api_service/models/common_master.dart';
import 'package:indisk_app/api_service/models/file_model.dart';
import 'package:indisk_app/api_service/models/login_master.dart';
import 'package:indisk_app/app_ui/screens/app/app_view.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:indisk_app/utils/global_variables.dart';

class AddManagerViewModel extends ChangeNotifier {
  Services services = Services();

  File? profileImage;



  void showImagePickerOptions() {
    showModalBottomSheet(
      context: mainNavKey.currentContext!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.close, color: Colors.red),
                title: Text('Cancel', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: imageSource);

    if (picked != null) {
      profileImage = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> createManager({name, username, phone, email, password,role}) async {
    showProgressDialog();
    CommonMaster? commonMaster = await services.api!.createManager(params: {
      ApiParams.name: name,
      ApiParams.username: username,
      ApiParams.phone: phone,
      ApiParams.email: email,
      ApiParams.password: password,
      ApiParams.is_blocked: "false",
      ApiParams.restaurant_id: gRestaurantDetails!.sId!,
      ApiParams.created_by: gLoginDetails!.sId!,
      ApiParams.role: role.toString(),
    }, files: [
      FileModel(profileImage!.path, "image")
    ], onProgress: (bytes, totalBytes) {});
    hideProgressDialog();

    if (commonMaster != null) {
      if (commonMaster.success != null && commonMaster.success!) {
        showGreenToastMessage("${commonMaster.message}");
        Navigator.pop(mainNavKey.currentContext!,true);
      } else {
        showRedToastMessage("${commonMaster.message}");
      }
    } else {
      oopsMSG();
    }
  }


  Future<void> updateManager({id,name, username, phone, email, password,role}) async {
    showProgressDialog();
    CommonMaster? commonMaster = await services.api!.updateManager(params: {
      ApiParams.id: id,
      ApiParams.name: name,
      ApiParams.username: username,
      ApiParams.phone: phone,
      ApiParams.email: email,
      ApiParams.password: password,
      ApiParams.is_blocked: "false",
      ApiParams.restaurant_id: gRestaurantDetails!.sId!,
      ApiParams.created_by: gLoginDetails!.sId!,
      ApiParams.role: role.toString(),
    }, files: [
     if(profileImage != null) FileModel(profileImage!.path, "image")
    ], onProgress: (bytes, totalBytes) {});
    hideProgressDialog();

    if (commonMaster != null) {
      if (commonMaster.success != null && commonMaster.success!) {
        showGreenToastMessage("${commonMaster.message}");
        Navigator.pop(mainNavKey.currentContext!,true);
      } else {
        showRedToastMessage("${commonMaster.message}");
      }
    } else {
      oopsMSG();
    }
  }


  void resetAll(){
    profileImage = null;
  }
}
