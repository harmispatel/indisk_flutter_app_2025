import 'package:flutter/material.dart';
import 'package:indisk_app/utils/common_colors.dart';
import '../../../common_screen/profile/profile_view.dart';
import '../food_category/food_category_list/food_category_list_view.dart';
import '../food_menu/food_list/food_list_view.dart';
import '../manager_home/manager_home_view.dart';
import '../manager_profile/manager_profile_view.dart';
import '../staff_list/staff_list_view.dart';
import '../tables/tables_view.dart';

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
                _buildNavItem(Icons.table_bar_rounded, 3),
                _buildNavItem(Icons.group, 4),
                _buildNavItem(Icons.settings, 5),
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
                ManagerHomeView(),
                FoodCategoryListView(),
                FoodListView(),
                TablesView(),
                StaffListView(),
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