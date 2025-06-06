import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/common_widget/common_appbar.dart';
import 'package:indisk_app/app_ui/common_widget/primary_button.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Food List', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 28),
            tooltip: 'Add Category',
            onPressed: () {
              pushToScreen(CreateFoodView());
            },
          ),
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
                  child:ListView.builder(
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
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.network(
              item.image?.first ?? '',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          Text(item.name ?? '',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(width: 16),
          Text("Price: ${item.basePrice?.toStringAsFixed(2)} Kr",
              style: TextStyle(fontSize: 16)),
          SizedBox(width: 16),
          Text(item.isAvailable == "true" ? "In Stock" : "Out Of Stock",
              style: TextStyle(
                  fontSize: 16,
                  color: item.isAvailable == "true" ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500)),
          SizedBox(width: 16),
          Text("Quantity: ${item.availableQty}",
              style: TextStyle(fontSize: 16)),
          Spacer(),
          GestureDetector(
            onTap: () {
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
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  color: Colors.green,
                ),
                Text(
                  "Edit",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              mViewModel.deleteFood(id: mViewModel.foodList[index].sId);
            },
            child: Row(
              children: [
                Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                Text(
                  "Delete",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
