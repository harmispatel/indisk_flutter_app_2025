import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/screens/restaurent_owner/restaurant/restaurant_list_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../utils/app_dimens.dart';
import '../../../../utils/common_colors.dart';
import '../../../../utils/common_styles.dart';
import '../../../../utils/common_utills.dart';
import '../../../common_widget/common_image.dart';
import 'add_restaurant/add_restaurant_view.dart';

class RestaurantListView extends StatefulWidget {
  const RestaurantListView({super.key});

  @override
  State<RestaurantListView> createState() => _RestaurantListViewState();
}

class _RestaurantListViewState extends State<RestaurantListView> {
  late RestaurantListViewModel mViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel.getRestaurantList();
    });
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<RestaurantListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add Restaurant',
            onPressed: () async {
              await pushToScreen(AddRestaurantView());
            },
          ),
        ],
      ),
      body: mViewModel.isApiLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : mViewModel.restaurantList.isEmpty
              ? Center(
                  child: Text("No restaurant found"),
                )
              : ListView.builder(
                  itemCount: mViewModel.restaurantList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsetsDirectional.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Container(
                        padding: EdgeInsetsDirectional.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonImage(
                                height: 100.0,
                                width: 100.0,
                                imageUrl:
                                    mViewModel.restaurantList[index].logo ??
                                        ''),
                            kSizedBoxH20,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mViewModel.restaurantList[index]
                                          .restaurantName ??
                                      '',
                                  style: getBoldTextStyle(fontSize: 20.0),
                                ),
                                kSizedBoxV5,
                                Text(
                                  "+91 ${mViewModel.restaurantList[index].contact.toString() ?? ''}",
                                  style: getNormalTextStyle(fontSize: 16.0),
                                ),
                                kSizedBoxV5,
                                Text(
                                  mViewModel
                                          .restaurantList[index].description ??
                                      '',
                                  style: getNormalTextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                      padding: EdgeInsetsDirectional.all(5.0),
                                      decoration: BoxDecoration(
                                          color: CommonColors.blie,
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Icon(
                                        Icons.edit,
                                        color: CommonColors.white,
                                      )),
                                ),
                                kSizedBoxV20,
                                InkWell(
                                  onTap: () {
                                    mViewModel.deleteRestaurant(
                                        id: mViewModel
                                            .restaurantList[index].sId);
                                  },
                                  child: Container(
                                      padding: EdgeInsetsDirectional.all(5.0),
                                      decoration: BoxDecoration(
                                          color: CommonColors.red,
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Icon(
                                        Icons.delete,
                                        color: CommonColors.white,
                                      )),
                                )
                              ],
                            ),
                            kSizedBoxH5
                          ],
                        ),
                      ),
                    );
                  }),
    );
  }
}
