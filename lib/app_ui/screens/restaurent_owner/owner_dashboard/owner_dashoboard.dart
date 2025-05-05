import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/screens/login/login_view.dart';
import 'package:indisk_app/utils/common_utills.dart';

import '../../../../database/app_preferences.dart';
import '../../../common_widget/common_appbar.dart';
import '../order_list_page/order_list_page.dart';
import '../owner_home/owner_home_view.dart';
import '../restaurant/restaurant_list_view.dart';
import '../sale/sale_list_view.dart';
import '../staff_list/staff_list_view.dart';

class OwnerDashoboard extends StatefulWidget {
  const OwnerDashoboard({super.key});

  @override
  State<OwnerDashoboard> createState() => _OwnerDashoboardState();
}

class _OwnerDashoboardState extends State<OwnerDashoboard> {
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
        title: 'Owner Dashboard',
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
            icon: Icon(Icons.person),
            label: 'Staff',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Sale',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Restaurant',
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
          BeautifulFoodOrderList(),
          StaffListView(),
          SaleListView(),
          RestaurantListView(),
        ],
      ),
    );
  }
}
