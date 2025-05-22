import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/app_dimens.dart';
import '../../../../utils/common_utills.dart';
import '../../../../utils/global_variables.dart';
import 'owner_change_password/owner_change_password_view.dart';
import 'owner_edit_profile/owner_edit_profile_view.dart';
import 'owner_profile_view_model.dart';

class OwnerProfileView extends StatefulWidget {
  const OwnerProfileView({super.key});

  @override
  State<OwnerProfileView> createState() => _OwnerProfileViewState();
}

class _OwnerProfileViewState extends State<OwnerProfileView> {
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: viewModel.isApiLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(viewModel.profileData?.image ?? 'https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg',fit: BoxFit.fill,),
                    ),
                    kSizedBoxV10,
                    Text(
                      viewModel.profileData?.username ?? '',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    kSizedBoxV5,
                    Text(
                      gLoginDetails!.email!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    kSizedBoxV20,
                    SizedBox(
                      width: kDeviceWidth,
                      child: InkWell(
                        onTap: () {
                          pushToScreen(OwnerEditProfileView(profileData: viewModel.profileData!,));
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                Icon(Icons.keyboard_arrow_right),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    kSizedBoxV10,
                    SizedBox(
                      width: kDeviceWidth,
                      child: InkWell(
                        onTap: () {
                          pushToScreen(OwnerChangePasswordView());
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Text(
                                  'Change Password',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                Icon(Icons.keyboard_arrow_right),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
