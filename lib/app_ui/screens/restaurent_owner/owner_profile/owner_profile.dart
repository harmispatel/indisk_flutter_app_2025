import 'package:flutter/material.dart';

import '../../../../utils/app_dimens.dart';
import '../../../../utils/common_utills.dart';
import 'owner_change_password/owner_change_password_view.dart';

class OwnerProfile extends StatefulWidget {
  const OwnerProfile({super.key});

  @override
  State<OwnerProfile> createState() => _OwnerProfileState();
}

class _OwnerProfileState extends State<OwnerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                    "https://cdn3.iconfinder.com/data/icons/avatars-collection/256/22-512.png"),
              ),
              kSizedBoxV10,
              Text(
                'Owner Name',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              kSizedBoxV5,
              Text(
                'owner_email_123@gmail.com',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              kSizedBoxV20,
              SizedBox(
                width: kDeviceWidth,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Text(
                          'Edit Profile',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Icon(Icons.keyboard_arrow_right),
                      ],
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
                                fontSize: 16, fontWeight: FontWeight.w500),
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
