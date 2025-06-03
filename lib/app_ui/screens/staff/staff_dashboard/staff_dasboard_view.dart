import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/screens/login/login_view.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:indisk_app/utils/common_utills.dart';
import '../../../../database/app_preferences.dart';
import '../../../common_widget/common_appbar.dart';
import '../staff_home/staff_home_view.dart';
import '../staff_profile/staff_profile_view.dart';

class StaffDashboardView extends StatefulWidget {
  const StaffDashboardView({super.key});

  @override
  State<StaffDashboardView> createState() => _StaffDashboardViewState();
}

class _StaffDashboardViewState extends State<StaffDashboardView> {
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
      body: Row(
        children: [
          Container(
            width: 80,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey.shade300, width: 2),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildNavItem(Icons.home, 0),
                _buildNavItem(Icons.view_list, 1),
                _buildNavItem(Icons.group, 2),
                _buildNavItem(Icons.bar_chart, 3),
                _buildNavItem(Icons.settings, 4),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (int? currentPage) {
                _selectedIndex = currentPage!;
                setState(() {});
              },
              children: [
                StaffHomeView(),
                Container(),
                Container(),
                Container(),
                StaffProfileView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Icon(
          icon,
          color: isSelected ? CommonColors.primaryColor : Colors.grey,
          size: 30,
        ),
      ),
    );
  }
}