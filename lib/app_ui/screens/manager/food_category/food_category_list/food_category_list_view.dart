import 'package:flutter/material.dart';
import 'package:indisk_app/api_service/models/food_category_master.dart';
import 'package:indisk_app/app_ui/common_widget/common_appbar.dart';
import 'package:indisk_app/app_ui/screens/manager/food_category/food_category_list/food_category_list_view_model.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:indisk_app/utils/local_images.dart';
import 'package:provider/provider.dart';

import '../create_food_category/create_food_category_view.dart';

class FoodCategoryListView extends StatefulWidget {
  @override
  State<FoodCategoryListView> createState() => _FoodCategoryListViewState();
}

class _FoodCategoryListViewState extends State<FoodCategoryListView> {
  late FoodCategoryListViewModel mViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel.getFoodCategoryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<FoodCategoryListViewModel>(context);
    return Scaffold(
      appBar: CommonAppbar(
        title: "Food Categories",
        actions: [
          InkWell(
            onTap: () {
              pushToScreen(CreateFoodCategoryView());
            },
            child: Icon(Icons.add),
          )
        ],
      ),
      body: mViewModel.isApiLoading!
          ? Center(
              child: CircularProgressIndicator(),
            )
          : mViewModel.foodCategoryList.isEmpty
              ? Center(
                  child: Text("No category found"),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    itemCount: mViewModel.foodCategoryList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // 🔥 4 columns
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      final category = mViewModel.foodCategoryList[index];
                      return FoodCard(
                        category: category,
                        onDelete: () {
                          mViewModel.deleteFoodCategory();
                        },
                      );
                    },
                  ),
                ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final FoodCategoryDetails category;

  final Function onDelete;

  const FoodCard({required this.category, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pushToScreen(CreateFoodCategoryView(
          foodCategoryDetails: category,
        ));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    category.imageUrl!,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      LocalImages.appLogo,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      height: 100.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(category.name!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 4),
                      Text(
                        category.description!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Container(
                padding: EdgeInsetsDirectional.all(10.0),
                child: InkWell(
                  onTap: () {
                    onDelete();
                  },
                  child: Icon(
                    Icons.delete,
                    color: CommonColors.red,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
