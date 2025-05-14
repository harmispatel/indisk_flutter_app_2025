import 'package:flutter/material.dart';

import '../../../../common_widget/common_appbar.dart';
import '../../../../common_widget/common_textfield.dart';
import '../../../../common_widget/primary_button.dart';

class OwnerChangePasswordView extends StatefulWidget {
  const OwnerChangePasswordView({super.key});

  @override
  State<OwnerChangePasswordView> createState() =>
      _OwnerChangePasswordViewState();
}

class _OwnerChangePasswordViewState extends State<OwnerChangePasswordView> {
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                _currentPassController, "Current Password", Icons.lock, false),
            _buildTextField(
                _newPassController, "New Password", Icons.password, false),
            _buildTextField(_confirmPassController, "Confirm Password",
                Icons.password, false),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsetsDirectional.only(
            bottom: MediaQuery.of(context).viewPadding.bottom),
        child: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: PrimaryButton(
            text: 'Change Password',
            onPressed: () {},
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
