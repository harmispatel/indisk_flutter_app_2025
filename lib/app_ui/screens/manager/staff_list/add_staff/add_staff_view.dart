import 'package:flutter/material.dart';
import 'package:indisk_app/api_service/models/staff_list_master.dart';
import 'package:indisk_app/app_ui/common_widget/common_appbar.dart';
import 'package:indisk_app/app_ui/common_widget/common_textfield.dart';
import 'package:indisk_app/app_ui/common_widget/primary_button.dart';
import 'package:indisk_app/main.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/common_colors.dart';
import 'add_staff_view_model.dart';

class AddStaffView extends StatefulWidget {
  final StaffListDetails? staffListDetails;

  const AddStaffView({super.key, this.staffListDetails});

  @override
  _AddStaffViewState createState() => _AddStaffViewState();
}

class _AddStaffViewState extends State<AddStaffView> {
  late AddStaffViewModel mViewModel;
  final _formKey = GlobalKey<FormState>();
  String _status = 'active';
  String _gender = 'male';
  String _role = 'waiter';
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? selectedRole;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (widget.staffListDetails != null) {
        // mViewModel.updateManager(
        //     id: widget.staffListDetails!.sId,
        //     phone: _phoneController.text.trim(),
        //     name: _nameController.text,
        //     email: _emailController.text.trim(),
        //     password: _passwordController.text,
        //     username: _usernameController.text.trim(),
        //     role: gLoginDetails!.role != AppConstants.ROLE_OWNER
        //         ? 2
        //         : selectedRole == "Manager"
        //             ? 1
        //             : 2);
      } else {
        if(isValid()){
          mViewModel.createStaff(
            phone: _phoneController.text.trim(),
            name: _nameController.text,
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            status: _status,
            address: _addressController.text.trim(),
            gender: _gender,
            role: _role
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
      if (widget.staffListDetails != null) {
        _nameController.text = widget.staffListDetails!.name!;
        _addressController.text = widget.staffListDetails!.address!;
        _phoneController.text = widget.staffListDetails!.phone!;
        _emailController.text = widget.staffListDetails!.email!;
        _passwordController.text = widget.staffListDetails!.password!;
        _status = widget.staffListDetails!.status!;
        _gender = widget.staffListDetails!.gender!;
      }
      mViewModel.resetAll();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<AddStaffViewModel>(context);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
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
                                      widget.staffListDetails!.profilePicture != null)
                                  ? NetworkImage(widget.staffListDetails!.profilePicture!)
                                  : null,
                          child: mViewModel.profileImage == null
                              ? (widget.staffListDetails != null &&
                                      widget.staffListDetails!.profilePicture != null)
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
              ),
              SizedBox(height: 20),
              _buildTextField(
                  _nameController, "${language.name}", Icons.person, false),
              _buildTextField(
                  _emailController, "${language.email}", Icons.email, false,
                  keyboardType: TextInputType.emailAddress),
              _buildTextField(
                  _phoneController, "${language.phone}", Icons.phone, false,
                  keyboardType: TextInputType.phone),
              _buildTextField(_passwordController, "${language.password}",
                  Icons.lock, true),
              _buildTextField(
                  _addressController, "Address", Icons.home, false,
                  keyboardType: TextInputType.phone),
              Text("Role", style: TextStyle(fontSize: 18),),
              Center(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _role = 'waiter';
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<String>(
                            value: 'waiter',
                            groupValue: _role,
                            onChanged: (String? value) {
                              setState(() {
                                _role = value!;
                              });
                            },
                          ),
                          Text(
                            'Waiter',
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
                          _role = 'kitchen-staff';
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<String>(
                            value: 'kitchen-staff',
                            groupValue: _role,
                            onChanged: (String? value) {
                              setState(() {
                                _role = value!;
                              });
                            },
                          ),
                          Text(
                            'Kitchen Staff',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Text("Gender", style: TextStyle(fontSize: 18),),
              // Center(
              //   child: Row(
              //     children: [
              //       InkWell(
              //         onTap: () {
              //           setState(() {
              //             _gender = 'male';
              //           });
              //         },
              //         child: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             Radio<String>(
              //               value: 'male',
              //               groupValue: _gender,
              //               onChanged: (String? value) {
              //                 setState(() {
              //                   _gender = value!;
              //                 });
              //               },
              //             ),
              //             Text(
              //               'Male',
              //               style: TextStyle(fontSize: 18),
              //             ),
              //           ],
              //         ),
              //       ),
              //       SizedBox(width: 20),
              //       InkWell(
              //         onTap: () {
              //           setState(() {
              //             _gender = 'female';
              //           });
              //         },
              //         child: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             Radio<String>(
              //               value: 'female',
              //               groupValue: _gender,
              //               onChanged: (String? value) {
              //                 setState(() {
              //                   _gender = value!;
              //                 });
              //               },
              //             ),
              //             Text(
              //               'Female',
              //               style: TextStyle(fontSize: 18),
              //             ),
              //           ],
              //         ),
              //       ),
              //       SizedBox(width: 20),
              //       InkWell(
              //         onTap: () {
              //           setState(() {
              //             _gender = 'other';
              //           });
              //         },
              //         child: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             Radio<String>(
              //               value: 'other',
              //               groupValue: _gender,
              //               onChanged: (String? value) {
              //                 setState(() {
              //                   _gender = value!;
              //                 });
              //               },
              //             ),
              //             Text(
              //               'Other',
              //               style: TextStyle(fontSize: 18),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Text("Status", style: TextStyle(fontSize: 18),),
              Center(
                child: Row(
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
    } else if (_phoneController.text.trim().isEmpty) {
      showRedToastMessage("Please Enter Phone");
      return false;
    } else if (_passwordController.text.trim().isEmpty) {
      showRedToastMessage("Please Enter Password");
      return false;
    } else if (_addressController.text.trim().isEmpty) {
      showRedToastMessage("Please Enter Address");
      return false;
    } else {
      return true;
    }
  }
}
