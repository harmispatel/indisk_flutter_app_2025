import 'package:flutter/material.dart';

import '../../../../database/app_preferences.dart';
import '../../../../utils/app_dimens.dart';
import '../../../../utils/common_utills.dart';
import '../../../common_widget/common_appbar.dart';
import '../../login/login_view.dart';
import 'change_password/change_password_view.dart';

class StaffProfileView extends StatefulWidget {
  const StaffProfileView({super.key});

  @override
  State<StaffProfileView> createState() => _StaffProfileViewState();
}

class _StaffProfileViewState extends State<StaffProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
                "Staff Name",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
              ),
              kSizedBoxV20,

              GestureDetector(
                onTap: (){
                  pushToScreen(ChangePasswordView());
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80,vertical: 8),
                    child: Text("Change Password",style: TextStyle(fontSize :18),),
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
                      color: Colors.red
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80,vertical: 8),
                    child: Text("Logout",style: TextStyle(fontSize :18,color: Colors.white),),
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
