
import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/screens/login/login_view.dart';
import 'package:indisk_app/utils/common_utills.dart';

import '../../../../database/app_preferences.dart';
import '../../../common_widget/common_appbar.dart';
import '../../restaurent_owner/staff_list/staff_list_view.dart';
import '../manager_home/manager_home_view.dart';


class ManagerDashboardView extends StatefulWidget {
  const ManagerDashboardView({super.key});

  @override
  State<ManagerDashboardView> createState() => _ManagerDashboardViewState();
}

class _ManagerDashboardViewState extends State<ManagerDashboardView> {
  int _selectedIndex = 0;

  final _pageController = PageController();


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: 'Manager Dashboard',
        isBackButtonVisible: false,
        actions: [
          InkWell(
            onTap: () async {
              await SP.instance.removeLoginDetails();
              pushAndRemoveUntil(LoginView());
            },
            child: Icon(Icons.logout),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Sale',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
      body: PageView(
        physics: ClampingScrollPhysics(),
        controller: _pageController,
        onPageChanged: (int? currentPage) {
          _selectedIndex = currentPage!;
          setState(() {});
        },
        children: [
          ManagerHomeView(),Container(),StaffListView(),Container()
        ],
      ),
    );
  }
}
