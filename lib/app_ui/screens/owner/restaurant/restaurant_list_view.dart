import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/common_widget/common_image.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:indisk_app/utils/common_styles.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:provider/provider.dart';

import '../../../../api_service/models/restaurant_master.dart';
import '../../../../utils/app_dimens.dart';
import 'add_restaurant/add_restaurant_view.dart';
import 'edit_restaurant/edit_restaurant_view.dart';
import 'restaurant_list_view_model.dart';
import '../restaurant_details/restaurant_details_view.dart';

class RestaurantListView extends StatefulWidget {
  const RestaurantListView({super.key});

  @override
  State<RestaurantListView> createState() => _RestaurantListViewState();
}

class _RestaurantListViewState extends State<RestaurantListView> {
  late RestaurantListViewModel mViewModel;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel.getRestaurantList();
    });
  }

  Widget _buildRestaurantCard(RestaurantData restaurant, int index) {
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
            Container(
              height: 110,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12)
              ),
                child: Image.network(restaurant.image ?? '',fit: BoxFit.cover,),
            ),

            SizedBox(height: 12),
            Text(
              restaurant.name ?? '--',
              style: getBoldTextStyle(fontSize: 16.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              restaurant.phone ?? '--',
              style: getNormalTextStyle(fontSize: 14.0, fontColor: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Text(
              restaurant.cuisineType ?? '--',
              style: getNormalTextStyle(fontSize: 12.0, fontColor: Colors.grey[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      pushToScreen(
                        EditRestaurantView(
                          name: restaurant.name ?? '--',
                          email: restaurant.email ?? '--',
                          contact: restaurant.phone ?? '--',
                          address: restaurant.address ?? '--',
                          description: restaurant.description ?? '--',
                          location: restaurant.location ?? '--',
                          cuisine: restaurant.cuisineType ?? '--',
                          status: restaurant.status ?? '--',
                          image: restaurant.image ?? '--',
                        ),
                      ).then((_) {
                        mViewModel.getRestaurantList();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.green.shade100,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              color: Colors.green,
                              size: 18,
                            ),
                            Text(
                              " Edit",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showDeleteRestaurantDialog(context, restaurant.name ?? 'Restaurant', () {
                        mViewModel.deleteRestaurant(id: restaurant.sId);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.red.shade100,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                              size: 18,
                            ),
                            Text(
                              "Delete",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // pushToScreen(
                //   RestaurantDetailsView(
                //     restaurantId: restaurant.sId ?? '--',
                //   ),
                // );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.deepPurple.shade100,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.deepPurple,
                        size: 18,
                      ),
                      Text(
                        " Details",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
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
    mViewModel = Provider.of<RestaurantListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant List', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 28),
            tooltip: 'Add Restaurant',
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddRestaurantView())).then((_) {
                mViewModel.getRestaurantList();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: mViewModel.isApiLoading
            ? Center(child: CircularProgressIndicator())
            : mViewModel.restaurantList.isEmpty
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant, size: 100, color: Colors.grey[400]),
                SizedBox(height: 20),
                Text(
                  'No restaurants added yet',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Text(
                  'Tap the + button to add your first restaurant.',
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
            childAspectRatio: 0.9,
          ),
          itemCount: mViewModel.restaurantList.length,
          itemBuilder: (context, index) =>
              _buildRestaurantCard(mViewModel.restaurantList[index], index),
        ),
      ),
    );
  }

  void showDeleteRestaurantDialog(
      BuildContext context, String restaurantName, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text("Delete Restaurant", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
              "Are you sure you want to delete $restaurantName? This action cannot be undone."),
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
              child: Text("Delete"),
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