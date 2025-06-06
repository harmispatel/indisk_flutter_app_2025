import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indisk_app/utils/app_dimens.dart';

import '../../../../common_widget/common_textfield.dart';
import '../../../../common_widget/primary_button.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            CommonTextField(
              labelText: "Current Password",
              prefixIcon: Icon(Icons.lock_outline),
            ),
            kSizedBoxV20,
            CommonTextField(
              labelText: "New Password",
              prefixIcon: Icon(Icons.lock_open_outlined),
            ),
            kSizedBoxV20,

            CommonTextField(
              labelText: "Confirm Password",
              prefixIcon: Icon(Icons.password),
            ),
            kSizedBoxV20,
            kSizedBoxV20,

            PrimaryButton(
              text: "Change Password",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
