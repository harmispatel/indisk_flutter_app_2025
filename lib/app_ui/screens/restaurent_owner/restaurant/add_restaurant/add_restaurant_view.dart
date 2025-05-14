import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/common_colors.dart';
import '../../../../../utils/common_utills.dart';
import '../../../../../utils/global_variables.dart';
import '../../../../common_widget/common_appbar.dart';
import '../../../../common_widget/common_textfield.dart';
import '../../../../common_widget/primary_button.dart';
import 'add_restaurant_view_model.dart';

class AddRestaurantView extends StatefulWidget {
  const AddRestaurantView({super.key});

  @override
  State<AddRestaurantView> createState() => _AddRestaurantViewState();
}

class _AddRestaurantViewState extends State<AddRestaurantView> {
  late RestaurantViewModel mViewModel;
  String _status = 'active';
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _cuisineController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<RestaurantViewModel>(context);

    return Scaffold(
      appBar: CommonAppbar(
        title: "Add Restaurant",
        isBackButtonVisible: true,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsetsDirectional.only(
            bottom: MediaQuery.of(context).viewPadding.bottom),
        child: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: PrimaryButton(
            text: 'Add Restaurant',
            onPressed: () {
              if (isValid()) {
                mViewModel.createRestaurant(
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                  phone: _contactController.text.trim(),
                  description: _descriptionController.text.trim(),
                  status: _status,
                  ownerId: gLoginDetails!.sId!,
                  password: _passController.text.trim(),
                  address: _addressController.text.trim(),
                  location: _locationController.text.trim(),
                  cuisineType: _cuisineController.text.trim(),
                );
              }
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: mViewModel.showImagePickerOptions,
              child: Container(
                height: 150.0,
                width: 150.0,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: mViewModel.profileImage != null
                          ? FileImage(mViewModel.profileImage!)
                          // : (widget.staffListDetails != null &&
                          //         widget.staffListDetails!.image != null)
                          //     ? NetworkImage(widget.staffListDetails!.image!)
                          : null,
                      // child: mViewModel.profileImage == null
                      //     ? (widget.staffListDetails != null &&
                      //             widget.staffListDetails!.image != null)
                      //         ? null
                      //         : Icon(Icons.camera_alt, size: 40)
                      //     : null,
                      child: Icon(Icons.camera_alt, size: 40),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Container(
                          height: 50.0,
                          width: 50.0,
                          padding: EdgeInsetsDirectional.all(5.0),
                          decoration: BoxDecoration(
                              color: CommonColors.primaryColor,
                              shape: BoxShape.circle),
                          child: Center(child: Icon(Icons.edit))),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildTextField(_nameController, "Name", Icons.restaurant, false),
            _buildTextField(
                _emailController, "Email", Icons.email_rounded, false,
                keyboardType: TextInputType.emailAddress),
            _buildTextField(_passController, "Password", Icons.password, true),
            _buildTextField(_contactController, "Contact", Icons.phone, false,
                keyboardType: TextInputType.phone),
            _buildTextField(
                _addressController, "Address", Icons.business, false),
            _buildTextField(_descriptionController, "Description",
                Icons.description, false),
            _buildTextField(_locationController, "Location",
                Icons.location_on_outlined, false),
            _buildTextField(_cuisineController, "Cuisine type",
                Icons.restaurant_menu, false),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _status = 'active';
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: 'active',
                          groupValue: _status,
                          onChanged: (String? value) {
                            setState(() {
                              _status = value!;
                            });
                          },
                        ),
                        Text(
                          'Active',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),

                  // Inactive option
                  InkWell(
                    onTap: () {
                      setState(() {
                        _status = 'inactive';
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: 'inactive',
                          groupValue: _status,
                          onChanged: (String? value) {
                            setState(() {
                              _status = value!;
                            });
                          },
                        ),
                        Text(
                          'Inactive',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    bool isObscure, {
    TextInputType keyboardType = TextInputType.text,
    bool isEnable = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: CommonTextField(
        controller: controller,
        labelText: label,
        prefixIcon: Icon(icon),
        obscureText: isObscure,
        keyboardType: keyboardType,
        enabled: isEnable,
      ),
    );
  }

  bool isValid() {
    if (mViewModel.profileImage == null) {
      showRedToastMessage("Please select image");
      return false;
    } else if (_nameController.text.trim().isEmpty) {
      showRedToastMessage("Please Enter Name");
      return false;
    } else if (_emailController.text.trim().isEmpty) {
      showRedToastMessage("Please Enter Email Address");
      return false;
    } else if (_passController.text.trim().isEmpty) {
      showRedToastMessage("Please Enter Password");
      return false;
    } else if (_contactController.text.trim().isEmpty) {
      showRedToastMessage("Please Enter Contact Number");
      return false;
    } else if (_addressController.text.trim().isEmpty) {
      showRedToastMessage("Please Enter Address");
      return false;
    } else if (_descriptionController.text.trim().isEmpty) {
      showRedToastMessage("Please Enter Description");
      return false;
    } else if (_locationController.text.trim().isEmpty) {
      showRedToastMessage("Please Enter Location");
      return false;
    } else if (_cuisineController.text.trim().isEmpty) {
      showRedToastMessage("Please Enter Cuisine type");
      return false;
    } else {
      return true;
    }
  }
}
