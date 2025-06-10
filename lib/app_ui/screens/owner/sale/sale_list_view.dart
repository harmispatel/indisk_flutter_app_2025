import 'package:flutter/material.dart';

import '../../../../utils/app_dimens.dart';
import '../../../../utils/common_colors.dart';
import '../../../../utils/common_styles.dart';
import '../../../common_widget/common_image.dart';

class SaleListView extends StatefulWidget {
  const SaleListView({super.key});

  @override
  State<SaleListView> createState() => _SaleListViewState();
}

class _SaleListViewState extends State<SaleListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            "https://img.freepik.com/free-psd/fresh-beef-burger-isolated-transparent-background_191095-9018.jpg?semt=ais_hybrid&w=740"),
                    kSizedBoxH20,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cheese Burger",
                          style: getBoldTextStyle(fontSize: 20.0),
                        ),
                        kSizedBoxV5,
                        Text(
                          "Qty: 157",
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
                    InkWell(
                      onTap: () {},
                      child: Container(
                          padding: EdgeInsetsDirectional.all(5.0),
                          decoration: BoxDecoration(
                              color: CommonColors.blue,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Icon(
                            Icons.remove_red_eye,
                            color: CommonColors.white,
                          )),
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
