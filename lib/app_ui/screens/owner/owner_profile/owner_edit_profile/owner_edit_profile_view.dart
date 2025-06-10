import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../api_service/models/get_profile_master.dart';
import '../../../../../main.dart';
import '../../../../../utils/common_colors.dart';
import '../../../../../utils/common_utills.dart';
import '../../../../common_widget/common_appbar.dart';
import '../../../../common_widget/common_textfield.dart';
import '../../../../common_widget/primary_button.dart';
import 'owner_edit_profile_view_model.dart';

class OwnerEditProfileView extends StatefulWidget {
  final ProfileData profileData;

  const OwnerEditProfileView({super.key, required this.profileData});

  @override
  State<OwnerEditProfileView> createState() => _OwnerEditProfileViewState();
}

class _OwnerEditProfileViewState extends State<OwnerEditProfileView> {
  late OwnerEditProfileViewModel mViewModel;
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  String gender = 'male';

  @override
  void initState() {
    // TODO: implement initState
    _emailController.text = widget.profileData.email ?? '';
    _nameController.text = widget.profileData.username ?? '';
    gender = widget.profileData.gender ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<OwnerEditProfileViewModel>(context);
    return Scaffold(
      appBar: CommonAppbar(
        title: "Edit Profile",
        isBackButtonVisible: true,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsetsDirectional.only(
            bottom: MediaQuery.of(context).viewPadding.bottom),
        child: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: PrimaryButton(
              text: "Update Profile",
              onPressed: () {
                if (isValid()) {
                  mViewModel.updateProfile(
                      email: _emailController.text.trim(), userName: _nameController.text.trim(), gender: gender);
                }
              },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: mViewModel.showImagePickerOptions,
                child: SizedBox(
                  height: 150.0,
                  width: 150.0,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: mViewModel.profileImage != null
                            ? FileImage(mViewModel.profileImage!)
                            : (widget.profileData.image != null &&
                                    widget.profileData.image != null)
                                ? NetworkImage(widget.profileData.image ?? '')
                                : null,
                        child: mViewModel.profileImage == null
                            ? (widget.profileData.image != null &&
                                    widget.profileData.image != null)
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
                          child: Center(
                            child: Icon(Icons.edit),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildTextField(
                _emailController, language.email, Icons.email, false, true),
            _buildTextField(
                _nameController, language.userName, Icons.person, false, false),
            SizedBox(height: 20),
            Text(
              'Gender',
              style: TextStyle(fontSize: 18),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        gender = 'male';
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: 'male',
                          groupValue: gender,
                          onChanged: (String? value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                        Text(
                          'Male',
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
                        gender = 'female';
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: 'female',
                          groupValue: gender,
                          onChanged: (String? value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                        Text(
                          'Female',
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
    bool isObscure,
    bool readOnly, {
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
        readOnly: readOnly,
        enabled: isEnable,
      ),
    );
  }

  bool isValid() {
    if (_nameController.text.trim().isEmpty) {
      showRedToastMessage("Please Enter Name");
      return false;
    } else {
      return true;
    }
  }
}
