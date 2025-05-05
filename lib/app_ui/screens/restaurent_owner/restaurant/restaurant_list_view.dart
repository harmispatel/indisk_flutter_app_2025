import 'package:flutter/material.dart';

import '../../../../utils/app_dimens.dart';
import '../../../../utils/common_colors.dart';
import '../../../../utils/common_styles.dart';
import '../../../common_widget/common_image.dart';

class RestaurantListView extends StatefulWidget {
  const RestaurantListView({super.key});

  @override
  State<RestaurantListView> createState() => _RestaurantListViewState();
}

class _RestaurantListViewState extends State<RestaurantListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add Restaurant',
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: 5,
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
                            "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/08/ee/2d/9d/jw-marriott-hotel-mumbai.jpg?w=900&h=500&s=1"),
                    kSizedBoxH20,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jw marriot",
                          style: getBoldTextStyle(fontSize: 20.0),
                        ),
                        kSizedBoxV5,
                        Text(
                          "+91 888-999-1010",
                          style: getNormalTextStyle(fontSize: 16.0),
                        ),
                        kSizedBoxV5,
                        Text(
                          "Ahmedabad",
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
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Icon(
                                Icons.edit,
                                color: CommonColors.white,
                              )),
                        ),
                        kSizedBoxV20,
                        InkWell(
                          onTap: () {},
                          child: Container(
                              padding: EdgeInsetsDirectional.all(5.0),
                              decoration: BoxDecoration(
                                  color: CommonColors.red,
                                  borderRadius: BorderRadius.circular(10.0)),
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
