import 'package:flutter/material.dart';

import '../../../common_widget/common_appbar.dart';

class StaffProfileView extends StatefulWidget {
  const StaffProfileView({super.key});

  @override
  State<StaffProfileView> createState() => _StaffProfileViewState();
}

class _StaffProfileViewState extends State<StaffProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: 'Settings',
        isBackButtonVisible: false,
      ),
    );
  }
}
