import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/common_screen/profile/profile_view_model.dart';
import 'package:provider/provider.dart';
import '../../../database/app_preferences.dart';
import '../../../utils/app_dimens.dart';
import '../../../utils/common_utills.dart';
import '../../../utils/global_variables.dart';
import '../../screens/login/login_view.dart';
import '../change_password/change_password_view.dart';
import '../edit_profile/edit_profile_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ProfileViewModel? mViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mViewModel = Provider.of<ProfileViewModel>(context, listen: false);
      mViewModel?.getProfileApi(email: gLoginDetails!.email!).catchError((e) {
        print("init error: $e");
      }).then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = mViewModel ?? Provider.of<ProfileViewModel>(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: viewModel.isApiLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          viewModel.profileData?.image ??
                              'https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg',
                          fit: BoxFit.fill,
                        ),
                      ),
                      kSizedBoxV10,
                      Text(
                        viewModel.profileData?.username ?? 'Name',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      kSizedBoxV5,
                      Text(
                        viewModel.profileData?.email ?? 'Email',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      kSizedBoxV20,
                      GestureDetector(
                        onTap: () {
                          pushToScreen(EditProfileView(
                            profileData: viewModel.profileData!,
                          )).then((value) {
                            mViewModel?.getProfileApi(email: gLoginDetails!.email!);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade200),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 110, vertical: 8),
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      kSizedBoxV10,
                      GestureDetector(
                        onTap: () {
                          pushToScreen(ChangePasswordView());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade200),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 8),
                            child: Text(
                              "Change Password",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      kSizedBoxV10,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 8),
                            child: Text(
                              "Logout",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
