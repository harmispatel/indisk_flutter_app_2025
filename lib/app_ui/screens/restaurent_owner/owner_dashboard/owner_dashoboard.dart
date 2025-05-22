import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/screens/login/login_view.dart';
import 'package:indisk_app/utils/common_utills.dart';

import '../../../../database/app_preferences.dart';
import '../../../common_widget/common_appbar.dart';
import '../owner_home/owner_home_view.dart';
import '../owner_profile/owner_profile_view.dart';
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
      appBar: CommonAppbar(
        title: 'Welcome Owner',
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
            icon: Icon(Icons.restaurant),
            label: 'Restaurant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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
          DashboardPage(),
          // Container(color: Colors.red, child: Center(child: Text("TEST PAGE"))),

          RestaurantListView(),
          OwnerProfileView(),
          // BeautifulFoodOrderList(),
          // StaffListView(),
          // SaleListView(),
        ],
      ),
    );
  }
}
