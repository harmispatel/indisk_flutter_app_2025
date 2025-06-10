import 'package:flutter/material.dart';

import '../../../../database/app_preferences.dart';
import '../../../../utils/app_dimens.dart';
import '../../../../utils/common_utills.dart';
import '../../../../utils/global_variables.dart';
import '../../../common_screen/change_password/change_password_view.dart';
import '../../login/login_view.dart';

class KitchenStaffProfileView extends StatefulWidget {
  const KitchenStaffProfileView({super.key});

  @override
  State<KitchenStaffProfileView> createState() =>
      _KitchenStaffProfileViewState();
}

class _KitchenStaffProfileViewState extends State<KitchenStaffProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: 120,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Image.network(
                    "https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg"),
              ),
              kSizedBoxV20,
              Text(
                gLoginDetails!.username ?? "Kitchen Staff Name",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
              ),
              kSizedBoxV20,
              GestureDetector(
                onTap: () {
                  pushToScreen(ChangePasswordView());
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 80, vertical: 8),
                    child: Text(
                      "Change Password",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              kSizedBoxV20,
              GestureDetector(
                onTap: () async {
                  await SP.instance.removeLoginDetails();
                  pushAndRemoveUntil(LoginView());
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.red),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 80, vertical: 8),
                    child: Text(
                      "Logout",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
