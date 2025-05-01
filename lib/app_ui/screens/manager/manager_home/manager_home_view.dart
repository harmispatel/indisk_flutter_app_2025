import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/common_widget/common_appbar.dart';
import 'package:indisk_app/app_ui/screens/manager/food_category/food_category_list/food_category_list_view.dart';
import 'package:indisk_app/app_ui/screens/manager/food_menu/food_list/food_list_view.dart';
import 'package:indisk_app/utils/common_styles.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:indisk_app/utils/local_images.dart';

class ManagerHomeView extends StatefulWidget {
  const ManagerHomeView({super.key});

  @override
  State<ManagerHomeView> createState() => _ManagerHomeViewState();
}

class _ManagerHomeViewState extends State<ManagerHomeView> {
  final List<GridItem> items = [
    GridItem('Orders', LocalImages.img_orders),
    GridItem('Menu', LocalImages.img_food),
    GridItem('Category', LocalImages.img_food_category),
    GridItem('Staff', LocalImages.img_staff),
    GridItem('Inventory', LocalImages.img_inventory),
    GridItem('Training', LocalImages.img_training),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: "Home",
        isBackButtonVisible: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: List.generate(items.length, (index) {
            return DashboardCard(
              item: items[index],
              index: index,
            );
          }),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final GridItem item;

  final int index;

  const DashboardCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          pushToScreen(FoodListView());
        } else if (index == 2) {
          pushToScreen(FoodCategoryListView());
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                item.imagePath,
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 10),
            Text(item.title, style: getBoldTextStyle(fontSize: 20.0)),
          ],
        ),
      ),
    );
  }
}

class GridItem {
  final String title;
  final String imagePath;

  GridItem(this.title, this.imagePath);
}
