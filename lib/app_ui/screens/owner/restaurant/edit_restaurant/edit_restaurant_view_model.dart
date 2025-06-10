import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../api_service/api_para.dart';
import '../../../../../api_service/index.dart';
import '../../../../../api_service/models/common_master.dart';
import '../../../../../api_service/models/file_model.dart';
import '../../../../../utils/common_utills.dart';
import '../../../app/app_view.dart';

class RestaurantEditModel with ChangeNotifier {
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

  Future<void> editRestaurant({
    required ownerId,
    required email,
    required phone,
    required name,
    required address,
    required status,
    required description,
    required location,
    required cuisineType,
  }) async {
    showProgressDialog();
    CommonMaster? commonMaster = await services.api!.editRestaurant(
        params: {
          ApiParams.owner_id: ownerId,
          ApiParams.email: email,
          ApiParams.phone: phone,
          ApiParams.name: name,
          ApiParams.address: address,
          ApiParams.status: status,
          ApiParams.description: description,
          ApiParams.location: location,
          ApiParams.cuisine_type: cuisineType,
        },
        files: [
          FileModel(profileImage!.path, "image")
        ],
        onProgress: (bytes, totalBytes) {
          print("Progress == ${bytes / totalBytes}");
        });
    hideProgressDialog();

    if (commonMaster != null) {
      if (commonMaster.success != null && commonMaster.success!) {
        showGreenToastMessage("${commonMaster.message}");
        Navigator.pop(mainNavKey.currentContext!, true);
      } else {
        showRedToastMessage("${commonMaster.message}");
      }
    } else {
      oopsMSG();
    }
  }
}
