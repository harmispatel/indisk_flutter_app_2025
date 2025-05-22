import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/common_utills.dart';
import '../../../../../utils/global_variables.dart';
import '../../../../common_widget/common_appbar.dart';
import '../../../../common_widget/common_textfield.dart';
import '../../../../common_widget/primary_button.dart';
import 'change_password_view_model.dart';

class OwnerChangePasswordView extends StatefulWidget {
  const OwnerChangePasswordView({super.key});

  @override
  State<OwnerChangePasswordView> createState() =>
      _OwnerChangePasswordViewState();
}

class _OwnerChangePasswordViewState extends State<OwnerChangePasswordView> {
  late ChangePasswordViewModel mViewModel;

  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _isCurrentPassVisible = false;
  bool _isNewPassVisible = false;
  bool _isConfirmPassVisible = false;

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<ChangePasswordViewModel>(context);

    return Scaffold(
      appBar: CommonAppbar(
        title: 'Change Password',
        isBackButtonVisible: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            _buildTextField(
              _currentPassController,
              "Current Password",
              Icons.lock,
              _isCurrentPassVisible ? Icons.visibility : Icons.visibility_off,
              !_isCurrentPassVisible,
              onSuffixIconPressed: () {
                setState(() {
                  _isCurrentPassVisible = !_isCurrentPassVisible;
                });
              },
            ),
            _buildTextField(
              _newPassController,
              "New Password",
              Icons.password,
              _isNewPassVisible ? Icons.visibility : Icons.visibility_off,
              !_isNewPassVisible,
              onSuffixIconPressed: () {
                setState(() {
                  _isNewPassVisible = !_isNewPassVisible;
                });
              },
            ),
            _buildTextField(
              _confirmPassController,
              "Confirm Password",
              Icons.password,
              _isConfirmPassVisible ? Icons.visibility : Icons.visibility_off,
              !_isConfirmPassVisible,
              onSuffixIconPressed: () {
                setState(() {
                  _isConfirmPassVisible = !_isConfirmPassVisible;
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsetsDirectional.only(
            bottom: MediaQuery
                .of(context)
                .viewPadding
                .bottom),
        child: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: PrimaryButton(
            text: 'Change Password',
            onPressed: () {
              if (isValid()) {
                mViewModel.changePasswordApi(
                    email: gLoginDetails!.email!,
                    currentPassword: _currentPassController.text.trim(),
                    newPassword: _newPassController.text.trim());
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller,
      String label,
      IconData icon,
      IconData suffixIcon,
      bool isObscure, {
        TextInputType keyboardType = TextInputType.text,
        bool isEnable = true,
        VoidCallback? onSuffixIconPressed,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: CommonTextField(
        controller: controller,
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: IconButton(
          icon: Icon(suffixIcon),
          onPressed: onSuffixIconPressed,
        ),
        obscureText: isObscure,
        keyboardType: keyboardType,
        enabled: isEnable,
      ),
    );
  }

  bool isValid() {
    if (_currentPassController.text
        .trim()
        .isEmpty) {
      showRedToastMessage("Please Enter Current Password");
      return false;
    } else if (_newPassController.text
        .trim()
        .isEmpty) {
      showRedToastMessage("Please Enter New Password");
      return false;
    } else
    if (_confirmPassController.text.trim() != _newPassController.text.trim()) {
      showRedToastMessage("Password and Confirm password must be Same ");
      return false;
    } else {
      return true;
    }
  }
}