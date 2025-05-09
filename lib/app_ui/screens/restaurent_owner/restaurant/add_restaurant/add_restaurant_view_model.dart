import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../api_service/api_para.dart';
import '../../../../../api_service/index.dart';
import '../../../../../api_service/models/common_master.dart';
import '../../../../../api_service/models/file_model.dart';
import '../../../../../utils/common_utills.dart';
import '../../../app/app_view.dart';
import '../restaurant_list_view_model.dart';

class RestaurantViewModel with ChangeNotifier {
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

  Future<void> createRestaurant({
    required userId,
    required name,
    required email,
    required contact,
    required description,
    required tagLine,
    required websiteLink,
    required status,
  }) async {
    showProgressDialog();
    CommonMaster? commonMaster = await services.api!.createRestaurant(
        params: {
          ApiParams.restaurant_name: name,
          ApiParams.email: email,
          ApiParams.contact: contact,
          ApiParams.description: description,
          ApiParams.tagLine: tagLine,
          ApiParams.isActive: status,
          ApiParams.websiteLink: websiteLink,
          ApiParams.user_id: userId,
        },
        files: [
          FileModel(profileImage!.path, "logo")
        ],
        onProgress: (bytes, totalBytes) {
          print("Progress == ${bytes / totalBytes}");
        });
    hideProgressDialog();

    if (commonMaster != null) {
      if (commonMaster.success != null && commonMaster.success!) {
        showGreenToastMessage("${commonMaster.message}");
        Navigator.pop(mainNavKey.currentContext!, true);
        Provider.of<RestaurantListViewModel>(mainNavKey.currentContext!,
                listen: false)
            .getRestaurantList();
      } else {
        showRedToastMessage("${commonMaster.message}");
      }
    } else {
      oopsMSG();
    }
  }

  Future<void> _pickImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: imageSource);

    if (picked != null) {
      profileImage = File(picked.path);
      notifyListeners();
    }
  }
}
