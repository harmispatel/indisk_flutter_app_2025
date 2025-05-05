import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../api_service/models/food_category_master.dart';
import '../../../../../api_service/models/food_list_master.dart';
import '../../../../../utils/app_dimens.dart';
import '../../../../../utils/common_colors.dart';
import '../../../../../utils/common_styles.dart';
import '../../../../../utils/common_utills.dart';
import '../../../../common_widget/common_appbar.dart';
import '../../../../common_widget/form_field_label.dart';
import '../../../../common_widget/label_textfield.dart';
import '../../../../common_widget/primary_button.dart';
import '../create_food/create_food_view.dart';
import 'edit_food_view_model.dart';

class EditFoodView extends StatefulWidget {
  final FoodListData foodItem;

  const EditFoodView({super.key, required this.foodItem});

  @override
  State<EditFoodView> createState() => _EditFoodViewState();
}

class _EditFoodViewState extends State<EditFoodView> {
  late EditFoodViewModel mViewModel;

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _basePriceController = TextEditingController();
  final _foodUnitController = TextEditingController();
  final _availableQtyController = TextEditingController();
  final _preparationController = TextEditingController();
  final _preparationTimeController = TextEditingController();
  final _cookingTimeController = TextEditingController();
  final _minimumStockController = TextEditingController();
  final _contentPerSingleItemController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      mViewModel.resetAll();
      mViewModel.addQuantityPrice();
      await mViewModel.getFoodCategoryList();
      _populateFormFields();
    });
  }

  void _populateFormFields() {
    final foodItem = widget.foodItem;

    // Basic fields
    _nameController.text = foodItem.name ?? '';
    _descController.text = foodItem.description ?? '';
    _basePriceController.text = foodItem.basePrice?.toString() ?? '';
    _foodUnitController.text = foodItem.unit ?? '';
    _availableQtyController.text = foodItem.availableQty?.toString() ?? '';
    _contentPerSingleItemController.text = foodItem.contentPerSingleItem ?? '';
    _cookingTimeController.text = foodItem.cookingTime ?? '';
    _preparationController.text = foodItem.preparations?.join(', ') ?? '';
    _preparationTimeController.text = foodItem.preparationsTime ?? '';
    _minimumStockController.text = foodItem.minStockRequired?.toString() ?? '';

    mViewModel.quantities.clear();

    for (var priceQty in foodItem.pricesByQuantity!) {
      mViewModel.quantities.add(QuantityPrice(
        quantity: int.tryParse(priceQty.quantity ?? '0') ?? 0,
        price: priceQty.price ?? '',
        discountPrice: priceQty.discountPrice ?? '',
      ));
    }

    if (foodItem.foodCategory != null &&
        mViewModel.foodCategoryList.isNotEmpty) {
      mViewModel.setSelectedCategoryFromId(foodItem.foodCategory!.sId);
    }

    // Handle images
    mViewModel.setExistingImageUrls(foodItem.imageUrl ?? []);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<EditFoodViewModel>(context);

    return Scaffold(
      appBar: CommonAppbar(title: "Edit Food"),
      bottomNavigationBar: Container(
        padding: EdgeInsetsDirectional.only(
            bottom: MediaQuery.of(context).viewPadding.bottom,
            start: 20.0,
            end: 20.0),
        child: PrimaryButton(
            text: "Update",
            onPressed: () {
              if (_isValidData()) {
                mViewModel.updateFood(
                    name: _nameController.text.trim(),
                    description: _descController.text.trim(),
                    cookingTime: _cookingTimeController.text.trim(),
                    preparationTime: _preparationTimeController.text.trim(),
                    preparation: _preparationController.text.trim(),
                    minStock: _minimumStockController.text.trim(),
                    basePrice: _basePriceController.text.trim(),
                    foodUnit: _foodUnitController.text.trim(),
                    qtyAvailable: _availableQtyController.text.trim(),
                    contentPerSingleItem:
                        _contentPerSingleItemController.text.trim(),
                    id: widget.foodItem.sId);
              }
            }),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getColumnTextField(controller: _nameController, lable: "Food Name"),
            Text('Food Images', style: getSemiBoldTextStyle(fontSize: 20.0)),
            kSizedBoxV10,
            Container(
              height: 100.0,
              width: kDeviceWidth,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (index == mViewModel.allImages.length) {
                      return InkWell(
                        onTap: () {
                          mViewModel.pickImages();
                        },
                        child: Container(
                          height: 100.0,
                          width: 100.0,
                          child: Icon(Icons.add),
                          decoration: BoxDecoration(
                              color: CommonColors.cardColor,
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      );
                    }
                    final image = mViewModel.allImages[index];
                    return Container(
                      height: 100.0,
                      width: 100.0,
                      child: Container(
                        height: 100.0,
                        width: 100.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image: image is XFile
                                    ? FileImage(File(image.path))
                                    : NetworkImage(image) as ImageProvider,
                                fit: BoxFit.cover)),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return kSizedBoxH20;
                  },
                  itemCount: mViewModel.allImages.length + 1),
            ),
            kSizedBoxV20,
            FormFieldLabel(label: "Select Food Category"),
            kSizedBoxV10,
            mViewModel.foodCategoryList.isEmpty
                ? Container(
                    height: 40.0,
                    width: kDeviceWidth,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : DropdownButtonFormField<FoodCategoryDetails>(
                    value: mViewModel.foodCategoryList.firstWhere(
                      (item) =>
                          item.sId == mViewModel.selectedFoodCategory?.sId,
                      orElse: () => mViewModel
                          .foodCategoryList.first, // fallback if not found
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Select Food Category",
                      fillColor: Colors.grey[100]!,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[100]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey[100]!, width: 2),
                      ),
                    ),
                    icon: Icon(Icons.arrow_drop_down),
                    items: mViewModel.foodCategoryList
                        .map((item) => DropdownMenuItem<FoodCategoryDetails>(
                              value: item,
                              child: Text(item.name!),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        mViewModel.selectedFoodCategory = value;
                      });
                    },
                  ),
            kSizedBoxV20,
            getColumnTextField(
                controller: _descController, lable: "Description"),
            getColumnTextField(
                controller: _basePriceController,
                lable: "Base Price",
                onTextChange: (String value) {
                  mViewModel.quantities[0].price = value;
                  mViewModel.quantities[0].quantity = 1;
                  setState(() {});
                }),
            kSizedBoxV10,
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // Get the current quantity price item
                final qtyPrice = widget.foodItem.pricesByQuantity?[index];

                return Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        initialValue: qtyPrice?.quantity?.toString() ?? '',
                        decoration: InputDecoration(
                          hintText: 'Quantity',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                        ),
                        onChanged: (String value) {
                          if (value.isNotEmpty) {
                            mViewModel.quantities[index].quantity =
                                int.parse(value);
                          }
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    kSizedBoxH20,
                    Flexible(
                      child: TextFormField(
                        initialValue: qtyPrice?.price ?? '',
                        decoration: InputDecoration(
                          hintText: 'Price',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                        ),
                        onChanged: (String value) {
                          if (value.isNotEmpty) {
                            mViewModel.quantities[index].price = value;
                          }
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    kSizedBoxH20,
                    Flexible(
                      child: TextFormField(
                        initialValue: qtyPrice?.discountPrice ?? '',
                        decoration: InputDecoration(
                          hintText: 'Discount Price',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                        ),
                        onChanged: (String value) {
                          if (value.isNotEmpty) {
                            mViewModel.quantities[index].discountPrice = value;
                          }
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    if (index > 0) ...[
                      kSizedBoxH20,
                      InkWell(
                        onTap: () {
                          widget.foodItem.pricesByQuantity?.removeAt(index);
                          mViewModel.quantities.removeAt(index);
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsetsDirectional.all(10.0),
                          child: Text(
                            "Remove",
                            style: getNormalTextStyle(
                                fontSize: 10.0, fontColor: CommonColors.white),
                          ),
                          decoration: BoxDecoration(
                              color: CommonColors.red,
                              borderRadius: BorderRadius.circular(1000)),
                        ),
                      )
                    ]
                  ],
                );
              },
              separatorBuilder: (context, index) => kSizedBoxV10,
              itemCount: widget.foodItem.pricesByQuantity!.length,
            ),
            getColumnTextField(
                controller: _foodUnitController, lable: "Food Unit"),
            getColumnTextField(
                controller: _availableQtyController,
                lable: "Available Quantity"),
            getColumnTextField(
                controller: _contentPerSingleItemController,
                lable: "Content Per Single Item"),
            getColumnTextField(
                controller: _cookingTimeController,
                lable: "Cooking Time (In Minuites)"),
            getColumnTextField(
                controller: _preparationController, lable: "Preparation"),
            getColumnTextField(
                controller: _preparationTimeController,
                lable: "Prepartion Time"),
            getColumnTextField(
                controller: _minimumStockController,
                lable: "Minimum Stock Required"),
            kSizedBoxV20,
          ],
        ),
      ),
    );
  }

  Widget getColumnTextField(
      {required TextEditingController controller,
      required String lable,
      String? hinttext,
      Function(String)? onTextChange,
      TextInputType? textInputType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        LabelTextField(
            controller: controller,
            label: lable,
            hintText: hinttext ?? "",
            textInputType: textInputType ?? TextInputType.text,
            onTextChange: onTextChange ?? (String) {}),
        kSizedBoxV20
      ],
    );
  }

  bool _isValidData() {
    bool? isValidQuantityPrice = true;

    if (mViewModel.quantities.isNotEmpty) {
      mViewModel.quantities.forEach((quanityPrice) {
        if (quanityPrice.quantity == null || quanityPrice.quantity == 0) {
          isValidQuantityPrice = false;
        }
        if (quanityPrice.price == null || quanityPrice.price!.isEmpty) {
          isValidQuantityPrice = false;
        }
      });
    }

    if (_nameController.text.isEmpty) {
      showRedToastMessage("Please enter food name");
      return false;
    } else if (mViewModel.existingImageUrls.isEmpty &&
        mViewModel.images.isEmpty) {
      showRedToastMessage("Please select food image");
      return false;
    } else if (mViewModel.selectedFoodCategory == null) {
      showRedToastMessage("Please select food category");
      return false;
    } else if (_descController.text.isEmpty) {
      showRedToastMessage("Please enter food description");
      return false;
    } else if (_basePriceController.text.isEmpty) {
      showRedToastMessage("Please enter food base price");
      return false;
    } else if (!isValidQuantityPrice!) {
      showRedToastMessage("Please check your price with qauntity");
      return false;
    } else if (_foodUnitController.text.isEmpty) {
      showRedToastMessage("Please enter food unit");
      return false;
    } else if (_availableQtyController.text.isEmpty) {
      showRedToastMessage("Please enter available qauntity");
      return false;
    } else if (_contentPerSingleItemController.text.isEmpty) {
      showRedToastMessage("Please enter content per single item you provide");
      return false;
    } else if (_cookingTimeController.text.isEmpty) {
      showRedToastMessage("Please enter cooking time");
      return false;
    } else if (_preparationController.text.isEmpty) {
      showRedToastMessage("Please enter preparation required items");
      return false;
    } else if (_preparationTimeController.text.isEmpty) {
      showRedToastMessage("Please enter preparation time required");
      return false;
    } else if (_preparationTimeController.text.isEmpty) {
      showRedToastMessage("Please enter preparation time required");
      return false;
    } else if (_minimumStockController.text.isEmpty) {
      showRedToastMessage("Please enter preparation time required");
      return false;
    } else {
      return true;
    }
  }
}
