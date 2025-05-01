import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:indisk_app/api_service/api_para.dart';
import 'package:indisk_app/api_service/index.dart';
import 'package:indisk_app/api_service/models/common_master.dart';
import 'package:indisk_app/api_service/models/file_model.dart';
import 'package:indisk_app/app_ui/screens/app/app_view.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:indisk_app/utils/global_variables.dart';
import 'package:provider/provider.dart';

import '../../../../../api_service/models/food_category_master.dart';
import '../food_list/food_list_view_model.dart';
import 'create_food_view.dart';

class CreateFoodViewModel extends ChangeNotifier {
  Services services = Services();

  List<XFile> images = [];
  List<QuantityPrice> quantities = [];
  List<FileModel> fileList = [];
  bool isActive = true;

  final picker = ImagePicker();

  List<FoodCategoryDetails> foodCategoryList = [];

  FoodCategoryDetails? selectedFoodCategory;

  bool? isApiLoading = false;

  Future<void> createFoodCategory({
    required name,
    required description,
    required cookingTime,
    required preparationTime,
    required preparation,
    required minStock,
    required basePrice,
    required discountPrice,
    required foodUnit,
    required qtyAvailable,
    required contentPerSingleItem,
  }) async {
    showProgressDialog();
    CommonMaster? commonMaster = await services.api!.createFood(
        params: {
          ApiParams.name: name,
          ApiParams.description: description,
          ApiParams.restaurant_id: gRestaurentDetails!.sId!,
          ApiParams.created_by: gLoginDetails!.sId!,
          ApiParams.food_category: selectedFoodCategory!.sId!,
          ApiParams.cooking_time: cookingTime,
          ApiParams.prices_by_quantity: jsonEncode(quantities),
          ApiParams.preparations_time: preparationTime,
          ApiParams.preparations: preparation,
          ApiParams.min_stock_required: minStock,
          ApiParams.base_price: basePrice,
          ApiParams.unit: foodUnit,
          ApiParams.available_qty: qtyAvailable,
          ApiParams.content_per_single_item: contentPerSingleItem,
          ApiParams.priority: "1",
          ApiParams.shifting_constant: "1.5",
        },
        files: fileList,
        onProgress: (bytes, totalBytes) {
          print("Progress == ${bytes / totalBytes}");
        });
    hideProgressDialog();

    if (commonMaster != null) {
      if (commonMaster.success != null && commonMaster.success!) {
        showGreenToastMessage("${commonMaster.message}");
        Navigator.pop(mainNavKey.currentContext!, true);
        Provider.of<FoodListViewModel>(mainNavKey.currentContext!,
                listen: false)
            .getFoodList();
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
      ApiParams.restaurant_id: gRestaurentDetails!.sId!,
      ApiParams.id: id,
    }, files: fileList, onProgress: (bytes, totalBytes) {});
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

  void resetAll() {
    foodCategoryList.clear();
    quantities.clear();
    selectedFoodCategory = null;
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
            queryParams: {ApiParams.restaurant_id: gRestaurentDetails!.sId});
    isApiLoading = false;
    notifyListeners();

    if (staffListMaster != null) {
      if (staffListMaster.success != null && staffListMaster.success!) {
        foodCategoryList.addAll(staffListMaster.data!);
      } else {
        showRedToastMessage(staffListMaster.message!);
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }

  void addQuantityPrice() {
    quantities.add(QuantityPrice(price: "0", quantity: 1, discountPrice: "0"));
    notifyListeners();
  }
}
