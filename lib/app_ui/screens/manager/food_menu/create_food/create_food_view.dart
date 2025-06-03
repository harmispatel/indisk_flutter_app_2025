import 'dart:io';

import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/common_widget/common_appbar.dart';
import 'package:indisk_app/app_ui/common_widget/form_field_label.dart';
import 'package:indisk_app/app_ui/common_widget/label_textfield.dart';
import 'package:indisk_app/app_ui/common_widget/primary_button.dart';
import 'package:indisk_app/utils/app_dimens.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:provider/provider.dart';

import '../../../../../api_service/models/food_category_master.dart';
import '../../../../../utils/common_styles.dart';
import 'create_food_view_model.dart';

class CreateFoodView extends StatefulWidget {
  const CreateFoodView({super.key});

  @override
  State<CreateFoodView> createState() => _CreateFoodViewState();
}

class _CreateFoodViewState extends State<CreateFoodView> {
  late CreateFoodViewModel mViewModel;
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _basePriceController = TextEditingController();
  final _foodUnitController = TextEditingController();
  final _availableQtyController = TextEditingController();
  final _totalQtyController = TextEditingController();
  bool isActive = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () {
      mViewModel.resetAll();
      mViewModel.addQuantityPrice();
      mViewModel.getFoodCategoryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<CreateFoodViewModel>(context);
    return Scaffold(
      appBar: CommonAppbar(title: "Create Food"),
      bottomNavigationBar: Container(
        padding: EdgeInsetsDirectional.only(
            bottom: MediaQuery.of(context).viewPadding.bottom,
            start: 20.0,
            end: 20.0),
        child: PrimaryButton(
            text: "Save",
            onPressed: () {
              if (_isValidData()) {
                mViewModel.createFoodCategory(
                    name: _nameController.text.trim(),
                    description: _descController.text.trim(),
                    basePrice: _basePriceController.text.trim(),
                    foodUnit: _foodUnitController.text.trim(),
                    qtyAvailable: _availableQtyController.text.trim(),
                    isAvailable: isActive.toString(),
                    totalAvailable: _totalQtyController.text.trim(),
                );
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
                    if (index == mViewModel.images.length) {
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
                                image: FileImage(
                                    File(mViewModel.images[index].path)),
                                fit: BoxFit.cover)),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return kSizedBoxH20;
                  },
                  itemCount: mViewModel.images.length + 1),
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
                    value: mViewModel.selectedFoodCategory,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FormFieldLabel(label: "Quantity Price"),
                ElevatedButton(
                    onPressed: () {
                      mViewModel.quantities.add(QuantityPrice(
                          quantity: 0,
                          // discountPrice: "",
                          price: ""));
                      setState(() {});
                    },
                    child: Text("ADD+"))
              ],
            ),
            kSizedBoxV10,
            ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Flexible(
                        child: TextFormField(
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
                          // enabled: index != 0,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      kSizedBoxH20,
                      Flexible(
                        child: TextFormField(
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
                          //  enabled: index != 0,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      kSizedBoxH20,
                      // Flexible(
                      //   child: TextFormField(
                      //     decoration: InputDecoration(
                      //       hintText: 'Discount Price',
                      //       filled: true,
                      //       fillColor: Colors.grey[100],
                      //       border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(12),
                      //           borderSide: BorderSide.none),
                      //     ),
                      //     onChanged: (String value) {
                      //       if (value.isNotEmpty) {
                      //         mViewModel.quantities[index].discountPrice =
                      //             value;
                      //       }
                      //     },
                      //     //  enabled: index != 0,
                      //     keyboardType: TextInputType.number,
                      //   ),
                      // ),
                      if (index > 0) ...[
                        kSizedBoxH20,
                        InkWell(
                          onTap: () {
                            mViewModel.quantities.removeLast();
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsetsDirectional.all(10.0),
                            child: Text(
                              "Remove+",
                              style: getNormalTextStyle(
                                  fontSize: 10.0,
                                  fontColor: CommonColors.white),
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
                separatorBuilder: (context, index) {
                  return kSizedBoxV10;
                },
                itemCount: mViewModel.quantities.length),
            getColumnTextField(
                controller: _foodUnitController, lable: "Food Unit"),
            getColumnTextField(
                controller: _totalQtyController,
                lable: "Total Quantity"),
            getColumnTextField(
                controller: _availableQtyController,
                lable: "Available Quantity"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                Switch(
                  value: isActive,
                  onChanged: (val) => setState(() => isActive = val),
                  activeColor: CommonColors.primaryColor,
                ),
              ],
            ),
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
    } else if (mViewModel.fileList.isEmpty) {
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
      showRedToastMessage("Please check your price with quantity");
      return false;
    } else if (_foodUnitController.text.isEmpty) {
      showRedToastMessage("Please enter food unit");
      return false;
    } else if (_totalQtyController.text.isEmpty) {
      showRedToastMessage("Please enter total quantity");
      return false;
    } else if (_availableQtyController.text.isEmpty) {
      showRedToastMessage("Please enter available quantity");
      return false;
    }   else {
      return true;
    }
  }
}

class QuantityPrice {
  int? quantity;
  String? price;
  // String? discountPrice;

  QuantityPrice({this.quantity, this.price,
    // this.discountPrice
  });

  QuantityPrice.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    price = json['price'];
    // discountPrice = json['discount_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    // data['discount_price'] = this.discountPrice;
    return data;
  }
}
