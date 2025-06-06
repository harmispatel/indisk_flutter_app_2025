import 'package:flutter/material.dart';
import 'package:indisk_app/api_service/models/food_category_master.dart';
import 'package:indisk_app/app_ui/common_widget/common_appbar.dart';
import 'package:indisk_app/app_ui/common_widget/common_image.dart';
import 'package:indisk_app/app_ui/screens/manager/food_category/food_category_list/food_category_list_view_model.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:indisk_app/utils/common_styles.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:indisk_app/utils/local_images.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/app_dimens.dart';
import '../../../../../utils/global_variables.dart';
import '../create_food_category/create_food_category_view.dart';

class FoodCategoryListView extends StatefulWidget {
  @override
  State<FoodCategoryListView> createState() => _FoodCategoryListViewState();
}

class _FoodCategoryListViewState extends State<FoodCategoryListView> {
  late FoodCategoryListViewModel mViewModel;

  void _addCategory({FoodCategoryDetails? foodCategoryDetails}) async {
    await pushToScreen(CreateFoodCategoryView(
      foodCategoryDetails: foodCategoryDetails,
    ));
    mViewModel.getFoodCategoryList();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      print("Restaurant Id is :: ${gRestaurantDetails?.sId}");
      mViewModel.getFoodCategoryList();
    });
  }

  Widget _buildCategoryCard(FoodCategoryDetails category, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CommonImage(
                height: 120.0,
                width: double.infinity,
                imageUrl: category.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12),
            Text(
              category.name!,
              style: getBoldTextStyle(fontSize: 16.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              category.description ?? "No description",
              style: getNormalTextStyle(fontSize: 14.0, fontColor: Colors.grey[600]),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                _addCategory(foodCategoryDetails: category);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.green.shade100
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.green,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Edit",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                showDeleteCategoryDialog(context, category.name!, () {
                  mViewModel.deleteFoodCategory(staffId: category.sId);
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.red.shade100
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Delete",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<FoodCategoryListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Categories', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 28),
            tooltip: 'Add Category',
            onPressed: _addCategory,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: mViewModel.isApiLoading!
            ? Center(
          child: CircularProgressIndicator(),
        )
            : mViewModel.foodCategoryList.isEmpty
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.category_outlined,
                    size: 100, color: Colors.grey[400]),
                SizedBox(height: 20),
                Text(
                  'No categories added yet',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Text(
                  'Tap the + button to add your first food category.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        )
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8,
          ),
          itemCount: mViewModel.foodCategoryList.length,
          itemBuilder: (context, index) =>
              _buildCategoryCard(mViewModel.foodCategoryList[index], index),
        ),
      ),
    );
  }

  void showDeleteCategoryDialog(
      BuildContext context, String categoryName, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text("Delete Category", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
              "Are you sure you want to delete $categoryName? This action cannot be undone."),
          actions: [
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text("Delete",style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }
}