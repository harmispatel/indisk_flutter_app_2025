import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../api_service/api_para.dart';
import '../../../../../api_service/index.dart';
import '../../../../../api_service/models/common_master.dart';
import '../../../../../api_service/models/file_model.dart';
import '../../../../../utils/common_utills.dart';
import '../../../app/app_view.dart';

class OwnerEditProfileViewModel with ChangeNotifier {
  File? profileImage;
  final Services services = Services();

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

  Future<void> updateProfile({
    required email,
    required userName,
    required gender,
  }) async {
    showProgressDialog();
    CommonMaster? commonMaster = await services.api!.updateOwnerProfile(
        params: {
          ApiParams.email: email,
          ApiParams.username: userName,
          ApiParams.gender: gender,
        },
        files: [
          if(profileImage != null)
          FileModel(profileImage!.path, "image")
        ],
        onProgress: (bytes, totalBytes) {
          print("Progress == ${bytes / totalBytes}");
        });
    hideProgressDialog();

    if (commonMaster != null) {
      if (commonMaster.success != null && commonMaster.success!) {
        showGreenToastMessage(commonMaster.message);
        Navigator.pop(mainNavKey.currentContext!, true);
      } else {
        showRedToastMessage(commonMaster.message);
      }
    } else {
      oopsMSG();
    }
  }
}
