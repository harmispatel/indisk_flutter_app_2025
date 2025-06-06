import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../api_service/api_para.dart';
import '../../../../../api_service/index.dart';
import '../../../../../api_service/models/common_master.dart';
import '../../../../../api_service/models/file_model.dart';
import '../../../../../api_service/models/food_category_master.dart';
import '../../../../../utils/common_utills.dart';
import '../../../../../utils/global_variables.dart';
import '../../../app/app_view.dart';
import '../create_food/create_food_view.dart';

class EditFoodViewModel with ChangeNotifier {
  Services services = Services();

  List<XFile> images = [];
  List<QuantityPrice> quantities = [];
  List<FileModel> fileList = [];
  bool isActive = true;

  final picker = ImagePicker();

  List<FoodCategoryDetails> foodCategoryList = [];

  FoodCategoryDetails? selectedFoodCategory;

  bool? isApiLoading = false;

  List<String> existingImageUrls = [];

  void setExistingImageUrls(List<String> urls) {
    existingImageUrls = urls;
    notifyListeners();
  }

  List<dynamic> get allImages {
    return [...existingImageUrls, ...images];
  }

  void setSelectedCategoryFromId(String? categoryId) {
    if (categoryId != null && foodCategoryList.isNotEmpty) {
      selectedFoodCategory = foodCategoryList.firstWhere(
        (category) => category.sId == categoryId,
        orElse: () => foodCategoryList.first,
      );
      notifyListeners();
    }
  }

  void resetAll() {
    foodCategoryList.clear();
    quantities.clear();
    selectedFoodCategory = null;
  }

  Future<void> updateFood({
    required name,
    required description,
    required basePrice,
    required foodUnit,
    required qtyAvailable,
    required totalAvailable,
    required isAvailable,
    required id,
    required image,
  }) async {
    showProgressDialog();

    // Prepare files list - only include new images if they exist
    List<FileModel> filesToUpload = [];
    if (fileList.isNotEmpty) {
      // If user has selected new images, use those
      filesToUpload = [FileModel(fileList.first.filePath, "image")];
    } else if (image != null && image is String && image.startsWith('http')) {
      // If keeping existing image (URL), don't include it in files to upload
      filesToUpload = [];
    }

    CommonMaster? commonMaster = await services.api!.updateFood(
      params: {
        ApiParams.id: id,
        ApiParams.name: name,
        ApiParams.description: description,
        ApiParams.base_price: basePrice,
        ApiParams.prices_by_quantity: jsonEncode(quantities),
        ApiParams.category: selectedFoodCategory?.sId ?? '',
        ApiParams.is_available: isAvailable,
        ApiParams.created_by: gLoginDetails!.sId!,
        ApiParams.unit: foodUnit,
        ApiParams.total_qty: totalAvailable,
        ApiParams.available_qty: qtyAvailable,
      },
      files: filesToUpload,
      onProgress: (bytes, totalBytes) {
        print("Progress == ${bytes / totalBytes}");
      },
    );

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

  Future<void> pickImages() async {
    showModalBottomSheet(
      context: mainNavKey.currentContext!,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () async {
                  final picked =
                      await picker.pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    images.add(picked);
                    fileList.add(FileModel(picked.path, ApiParams.image_url));
                    notifyListeners();
                  }
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  final picked = await picker.pickMultiImage();
                  if (picked.isNotEmpty) {
                    images.addAll(picked);
                    picked.forEach((pickedXFile) {
                      fileList.add(
                          FileModel(pickedXFile.path, ApiParams.image_url));
                    });
                    notifyListeners();
                  }
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getFoodCategoryList() async {
    isApiLoading = true;
    notifyListeners();
    foodCategoryList.clear();
    FoodCategoryMaster? staffListMaster = await services.api!
        .getFoodCategoryList(
            params: {ApiParams.manager_id: gLoginDetails!.sId});
    isApiLoading = false;
    notifyListeners();

    if (staffListMaster != null) {
      if (staffListMaster.success != null && staffListMaster.success!) {
        foodCategoryList.addAll(staffListMaster.data!);
        if (selectedFoodCategory == null && foodCategoryList.isNotEmpty) {
          selectedFoodCategory = foodCategoryList.first;
        }
      } else {
        showRedToastMessage(staffListMaster.message!);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }

  void addQuantityPrice() {
    quantities.add(QuantityPrice(
      price: "0", quantity: 1,
      // discountPrice: "0"
    ));
    notifyListeners();
  }
}
