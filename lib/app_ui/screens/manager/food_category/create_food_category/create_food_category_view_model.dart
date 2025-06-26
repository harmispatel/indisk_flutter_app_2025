import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:indisk_app/api_service/api_para.dart';
import 'package:indisk_app/api_service/index.dart';
import 'package:indisk_app/api_service/models/common_master.dart';
import 'package:indisk_app/api_service/models/file_model.dart';
import 'package:indisk_app/app_ui/screens/app/app_view.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:indisk_app/utils/global_variables.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../food_category_list/food_category_list_view_model.dart';

class CreateFoodCategoryViewModel extends ChangeNotifier {
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

  Future<void> createFoodCategory({name, decsription, String? isActive}) async {
    showProgressDialog();
    CommonMaster? commonMaster =
        await services.api!.createFoodCategory(params: {
      ApiParams.name: name,
      ApiParams.description: decsription,
      ApiParams.is_active: isActive!,
      ApiParams.manager_id: gLoginDetails!.sId!,
    }, files: [
      FileModel(profileImage!.path, "image_url")
    ], onProgress: (bytes, totalBytes) {});
    hideProgressDialog();

    if (commonMaster != null) {
      if (commonMaster.success != null && commonMaster.success!) {
        showGreenToastMessage("${commonMaster.message}");
        Navigator.pop(mainNavKey.currentContext!, true);
        Provider.of<FoodCategoryListViewModel>(mainNavKey.currentContext!,
                listen: false)
            .getFoodCategoryList();
      } else {
        showRedToastMessage("${commonMaster.message}");
      }
    } else {
      oopsMSG();
    }
  }

  Future<void> updateFoodCategory(
      {id, name, decsription, String? isActive}) async {
    showProgressDialog();
    CommonMaster? commonMaster =
        await services.api!.updateFoodCategory(params: {
      ApiParams.name: name,
      ApiParams.description: decsription,
      ApiParams.is_active: isActive!,
      ApiParams.manager_id: gLoginDetails!.sId!,
      ApiParams.id: id,
    }, files: [
      if (profileImage != null) FileModel(profileImage!.path, "image_url")
    ], onProgress: (bytes, totalBytes) {});
    hideProgressDialog();

    if (commonMaster != null) {
      if (commonMaster.success) {
        showGreenToastMessage("${commonMaster.message}");
        Navigator.pop(mainNavKey.currentContext!, true);
        Provider.of<FoodCategoryListViewModel>(mainNavKey.currentContext!,
                listen: false)
            .getFoodCategoryList();
      } else {
        showRedToastMessage("${commonMaster.message}");
      }
    } else {
      oopsMSG();
    }
  }

  void resetAll() {
    profileImage = null;
  }
}
