import 'package:flutter/material.dart';
import 'package:indisk_app/api_service/models/food_category_master.dart';
import 'package:indisk_app/app_ui/common_widget/common_appbar.dart';
import 'package:indisk_app/app_ui/common_widget/primary_button.dart';
import 'package:indisk_app/app_ui/screens/manager/food_category/create_food_category/create_food_category_view_model.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:provider/provider.dart';

class CreateFoodCategoryView extends StatefulWidget {
  final FoodCategoryDetails? foodCategoryDetails;

  const CreateFoodCategoryView({Key? key, this.foodCategoryDetails});

  @override
  _CreateFoodCategoryViewState createState() => _CreateFoodCategoryViewState();
}

class _CreateFoodCategoryViewState extends State<CreateFoodCategoryView> {
  late CreateFoodCategoryViewModel mViewModel;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  bool isActive = true;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.foodCategoryDetails != null) {
        mViewModel.updateFoodCategory(
          id: widget.foodCategoryDetails!.sId,
            name: _nameController.text, decsription: _descController.text,isActive: isActive.toString());
      } else {
        if (mViewModel.profileImage != null) {
          mViewModel.createFoodCategory(
              name: _nameController.text, decsription: _descController.text,isActive: isActive.toString());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select an category image')),
          );
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      if (widget.foodCategoryDetails != null) {
        _nameController.text = widget.foodCategoryDetails!.name!;
        _descController.text = widget.foodCategoryDetails!.description!;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<CreateFoodCategoryViewModel>(context);
    return Scaffold(
      appBar: CommonAppbar(
        title: "Create Food Category",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          color: CommonColors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: mViewModel.showImagePickerOptions,
                      child: widget.foodCategoryDetails != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                onTap: (){
                                  mViewModel.showImagePickerOptions();
                                },
                                child: Image.network(
                                  widget.foodCategoryDetails!.imageUrl!,
                                  height: 160,
                                  width: 160,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : mViewModel.profileImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: InkWell(
                                    onTap: (){
                                      mViewModel.showImagePickerOptions();
                                    },
                                    child: Image.file(
                                      mViewModel.profileImage!,
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 160,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.grey[100],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.camera_alt_outlined,
                                            size: 40, color: Colors.grey),
                                        SizedBox(height: 8),
                                        Text('Tap to select image',
                                            style: TextStyle(
                                                color: Colors.grey[700]))
                                      ],
                                    ),
                                  ),
                                ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text('Category Name',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Burgers',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                    ),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Please enter a name'
                        : null,
                  ),
                  SizedBox(height: 16),
                  Text('Description',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  TextFormField(
                    controller: _descController,
                    minLines: 2,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: 'Short description of this category',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                    ),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Please enter a description'
                        : null,
                  ),
                  SizedBox(height: 16),
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
                  SizedBox(height: 20),
                  PrimaryButton(text: "Save Category", onPressed: _submitForm)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
