import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/common_widget/common_appbar.dart';
import 'package:indisk_app/app_ui/screens/manager/food_menu/create_food/create_food_view.dart';
import 'package:provider/provider.dart';

import '../../../../../api_service/models/food_list_master.dart';
import '../../../../../utils/common_utills.dart';
import '../edit_food/edit_food_view.dart';
import 'food_list_view_model.dart';

class FoodListView extends StatefulWidget {
  @override
  _FoodListViewState createState() => _FoodListViewState();
}

class _FoodListViewState extends State<FoodListView> {
  late FoodListViewModel mViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel.getFoodList();
    });
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<FoodListViewModel>(context);

    final isTablet = MediaQuery.of(context).size.width >= 600;
    return Scaffold(
      appBar: CommonAppbar(
        title: "Food List",
        actions: [
          InkWell(
            onTap: () {
              pushToScreen(CreateFoodView());
            },
            child: Icon(Icons.add),
          )
        ],
      ),
      body: mViewModel.isApiLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : mViewModel.foodList.isEmpty
              ? Center(
                  child: Text("No food found"),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: isTablet
                      ? GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisExtent: 150,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: mViewModel.foodList.length,
                          itemBuilder: (context, index) {
                            return buildFoodCard(
                                mViewModel.foodList[index], index);
                          },
                        )
                      : ListView.builder(
                          itemCount: mViewModel.foodList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: buildFoodCard(
                                  mViewModel.foodList[index], index),
                            );
                          },
                        ),
                ),
    );
  }

  Widget buildFoodCard(FoodListData item, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl?.first ?? '',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name ?? '',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text("Price: ${item.basePrice?.toStringAsFixed(2)} Kr",
                      style: TextStyle(fontSize: 16)),
                  Text("Quantity: ${item.availableQty}",
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditFoodView(foodItem: mViewModel.foodList[index]),
                    ),
                  ).then((_) {
                    mViewModel.getFoodList();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  mViewModel.deleteFood(id: mViewModel.foodList[index].sId);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
