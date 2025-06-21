import 'package:flutter/material.dart';

import '../../../../utils/common_colors.dart';
import '../../../common_screen/profile/profile_view.dart';
import '../kitchen_staff_home/kitchen_staff_home_view.dart';
import '../kitchen_staff_profile/kitchen_staff_profile_view.dart';

class KitchenStaffDashboardView extends StatefulWidget {
  const KitchenStaffDashboardView({super.key});

  @override
  State<KitchenStaffDashboardView> createState() => _KitchenStaffDashboardViewState();
}

class _KitchenStaffDashboardViewState extends State<KitchenStaffDashboardView> {
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
              color: Colors.grey[100],
              border: Border(right: BorderSide(color: Colors.grey.shade300, width: 2),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildNavItem(Icons.home, 0),
                _buildNavItem(Icons.category, 1),
                _buildNavItem(Icons.fastfood, 2),
                _buildNavItem(Icons.settings, 4),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(), // Disable swiping
              controller: _pageController,
              onPageChanged: (int? currentPage) {
                _selectedIndex = currentPage!;
                setState(() {});
              },
              children: [
                KitchenStaffHomeView(),
                Container(),
                Container(),
                ProfileView(),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Icon(
          icon,
          color: isSelected ? CommonColors.primaryColor : Colors.grey,
          size: 30,
        ),
      ),
    );
  }
}


