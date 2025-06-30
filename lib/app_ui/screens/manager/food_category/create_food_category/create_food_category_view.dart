import 'dart:io';
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

  @override
  void initState() {
    super.initState();
    mViewModel = Provider.of<CreateFoodCategoryViewModel>(context, listen: false);

    // Initialize with existing data if editing
    if (widget.foodCategoryDetails != null) {
      _nameController.text = widget.foodCategoryDetails!.name ?? '';
      _descController.text = widget.foodCategoryDetails!.description ?? '';
      isActive = bool.tryParse(widget.foodCategoryDetails!.isActive ?? 'true') ?? true;

      // Initialize the view model with existing image
      mViewModel.initializeWithExistingImage(widget.foodCategoryDetails!.imageUrl);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.foodCategoryDetails != null) {
        // Update existing category
        mViewModel.updateFoodCategory(
          id: widget.foodCategoryDetails!.sId!,
          name: _nameController.text,
          decsription: _descController.text,
          isActive: isActive.toString(),
        );
      } else {
        // Create new category
        if (mViewModel.profileImage != null) {
          mViewModel.createFoodCategory(
            name: _nameController.text,
            decsription: _descController.text,
            isActive: isActive.toString(),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a category image')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    mViewModel.resetAll(); // Reset the view model when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: widget.foodCategoryDetails != null
            ? "Edit Food Category"
            : "Create Food Category",
      ),
      body: Consumer<CreateFoodCategoryViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 6,
              color: CommonColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: viewModel.showImagePickerOptions,
                          child: _buildImageWidget(viewModel),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text('Category Name', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'e.g. Burgers',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? 'Please enter a name'
                            : null,
                      ),
                      SizedBox(height: 16),
                      Text('Description', style: TextStyle(fontWeight: FontWeight.w600)),
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
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? 'Please enter a description'
                            : null,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Active', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          Switch(
                            value: isActive,
                            onChanged: (val) => setState(() => isActive = val),
                            activeColor: CommonColors.primaryColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      PrimaryButton(
                        text: "Save Category",
                        onPressed: _submitForm,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageWidget(CreateFoodCategoryViewModel viewModel) {
    if (viewModel.profileImage != null) {
      return _buildImageContainer(
        child: Image.file(
          viewModel.profileImage!,
          height: 160,
          width: 160,
          fit: BoxFit.cover,
        ),
      );
    } else if (widget.foodCategoryDetails != null &&
        widget.foodCategoryDetails!.imageUrl != null) {
      return _buildImageContainer(
        child: Image.network(
          widget.foodCategoryDetails!.imageUrl!,
          height: 160,
          width: 160,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderIcon();
          },
        ),
      );
    } else {
      return _buildImageContainer(
        child: _buildPlaceholderIcon(),
      );
    }
  }

  Widget _buildImageContainer({required Widget child}) {
    return Container(
      height: 160,
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey),
        SizedBox(height: 8),
        Text('Tap to select image', style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }
}