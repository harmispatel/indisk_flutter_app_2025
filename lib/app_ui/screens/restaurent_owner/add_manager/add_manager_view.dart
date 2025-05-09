import 'package:flutter/material.dart';
import 'package:indisk_app/api_service/models/staff_list_master.dart';
import 'package:indisk_app/app_ui/common_widget/common_appbar.dart';
import 'package:indisk_app/app_ui/common_widget/common_textfield.dart';
import 'package:indisk_app/app_ui/common_widget/primary_button.dart';
import 'package:indisk_app/main.dart';
import 'package:indisk_app/utils/app_constants.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:indisk_app/utils/global_variables.dart';
import 'package:provider/provider.dart';

import '../../../../utils/common_colors.dart';
import 'add_manager_view_model.dart';

class AddManagerView extends StatefulWidget {
  final StaffListDetails? staffListDetails;

  const AddManagerView({super.key, this.staffListDetails});

  @override
  _AddManagerViewState createState() => _AddManagerViewState();
}

class _AddManagerViewState extends State<AddManagerView> {
  late AddManagerViewModel mViewModel;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? selectedRole;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (widget.staffListDetails != null) {
        mViewModel.updateManager(
            id: widget.staffListDetails!.sId,
            phone: _phoneController.text.trim(),
            name: _nameController.text,
            email: _emailController.text.trim(),
            password: _passwordController.text,
            username: _usernameController.text.trim(),
            role: gLoginDetails!.role != AppConstants.ROLE_OWNER
                ? 2
                : selectedRole == "Manager"
                    ? 1
                    : 2);
      } else {
        if (mViewModel.profileImage != null) {
          mViewModel.createManager(
              phone: _phoneController.text.trim(),
              name: _nameController.text,
              email: _emailController.text.trim(),
              password: _passwordController.text,
              username: _usernameController.text.trim(),
              role: gLoginDetails!.role != AppConstants.ROLE_OWNER
                  ? 2
                  : selectedRole == "Manager"
                      ? 1
                      : 2);
        } else {
          showRedToastMessage("Please select profile photo");
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      if (widget.staffListDetails != null) {
        _nameController.text = widget.staffListDetails!.name!;
        _usernameController.text = widget.staffListDetails!.username!;
        _phoneController.text = widget.staffListDetails!.phone!;
        _emailController.text = widget.staffListDetails!.email!;
        _passwordController.text = widget.staffListDetails!.password!;
        if (widget.staffListDetails!.role == 1) {
          selectedRole = "Manager";
        } else if (widget.staffListDetails!.role == 2) {
          selectedRole = "Waiter";
        }
      }
      mViewModel.resetAll();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<AddManagerViewModel>(context);
    return Scaffold(
      appBar: CommonAppbar(
        title: "Add Staff",
        isBackButtonVisible: true,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsetsDirectional.only(
            bottom: MediaQuery.of(context).viewPadding.bottom),
        child: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: PrimaryButton(
              text: widget.staffListDetails != null
                  ? "Update Employee"
                  : "Save Employee",
              onPressed: _submit),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
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
                            : (widget.staffListDetails != null &&
                                    widget.staffListDetails!.image != null)
                                ? NetworkImage(widget.staffListDetails!.image!)
                                : null,
                        child: mViewModel.profileImage == null
                            ? (widget.staffListDetails != null &&
                                    widget.staffListDetails!.image != null)
                                ? null
                                : Icon(Icons.camera_alt, size: 40)
                            : null,
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
              _buildTextField(
                  _nameController, "${language.name}", Icons.person, false),
              _buildTextField(_usernameController, "${language.userName}",
                  Icons.account_box, false),
              _buildTextField(
                  _phoneController, "${language.phone}", Icons.phone, false,
                  keyboardType: TextInputType.phone),
              _buildTextField(
                  _emailController, "${language.email}", Icons.email, false,
                  keyboardType: TextInputType.emailAddress),
              _buildTextField(_passwordController, "${language.password}",
                  Icons.lock, true),
              if (gLoginDetails!.role == AppConstants.ROLE_OWNER)
                Container(
                  margin: EdgeInsetsDirectional.symmetric(vertical: 10.0),
                  padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: CommonColors.grey, width: 1.0)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedRole,
                      hint: Text("Select Role"),
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: <String>['Manager', 'Waiter'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {
                        selectedRole = _;
                        setState(() {});
                      },
                    ),
                  ),
                )
            ],
          ),
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
}
