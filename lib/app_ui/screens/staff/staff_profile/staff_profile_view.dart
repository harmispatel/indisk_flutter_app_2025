import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../database/app_preferences.dart';
import '../../../../utils/app_dimens.dart';
import '../../../../utils/common_utills.dart';
import '../../../../utils/global_variables.dart';
import '../../../common_screen/change_password/change_password_view.dart';
import '../../login/login_view.dart';
import '../../owner/owner_profile/owner_profile_view_model.dart';

class StaffProfileView extends StatefulWidget {
  const StaffProfileView({super.key});

  @override
  State<StaffProfileView> createState() => _StaffProfileViewState();
}

class _StaffProfileViewState extends State<StaffProfileView> {
  OwnerProfileViewModel? mViewModel;

  @override
  void initState() {
    super.initState();
    print("DashboardPage initState");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Initializing dashboard data");
      mViewModel = Provider.of<OwnerProfileViewModel>(context, listen: false);
      mViewModel?.getProfileApi(email: gLoginDetails!.email!).catchError((e) {
        print("Dashboard init error: $e");
      }).then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = mViewModel ?? Provider.of<OwnerProfileViewModel>(context);
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
                viewModel.profileData?.username ?? "Staff Name",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
              ),
              kSizedBoxV5,
              Text(
                viewModel.profileData?.email ?? 'Staff Email',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
