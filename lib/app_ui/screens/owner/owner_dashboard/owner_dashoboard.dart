import 'package:flutter/material.dart';
import 'package:indisk_app/utils/common_colors.dart';
import '../../../common_screen/profile/profile_view.dart';
import '../owner_home/owner_home_view.dart';
import '../restaurant/restaurant_list_view.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  int _selectedIndex = 0;
  final _pageController = PageController();

  void _onItemTapped(int index) {
    print("Navigating to index $index");
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  void initState() {
    super.initState();
    print("OwnerDashboard initialized");
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
              border: Border(
                right: BorderSide(color: Colors.grey.shade300, width: 2),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildNavItem(Icons.home, 0, 'Home'),
                _buildNavItem(Icons.restaurant, 1, 'Restaurants'),
                _buildNavItem(Icons.person, 2, 'Profile'),
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
                DashboardPage(),
                RestaurantListView(),
                ProfileView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, String tooltip) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? CommonColors.primaryColor : Colors.grey,
              size: 30,
            ),
            const SizedBox(height: 4),
            Text(
              tooltip,
              style: TextStyle(
                color: isSelected ? CommonColors.primaryColor : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}