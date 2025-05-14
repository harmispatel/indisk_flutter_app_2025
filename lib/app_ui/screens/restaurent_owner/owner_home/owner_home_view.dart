import 'package:flutter/material.dart';
import 'package:indisk_app/utils/app_dimens.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:provider/provider.dart';

import '../../../../utils/local_images.dart';
import 'owner_home_view_model.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late OwnerHomeViewModel mViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel.getOwnerHomeApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<OwnerHomeViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: mViewModel.isApiLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dashboard",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: kDeviceWidth,
                      child: Card(
                        elevation: 2,
                        color: CommonColors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.restaurant,
                                        size: 30,
                                      ),
                                      kSizedBoxV10,
                                      Text(
                                        "Total Hotels",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      kSizedBoxV10,
                                      Text(
                                        mViewModel.homeData?.restaurantCount
                                                .toString() ??
                                            '--',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 30,
                                      ),
                                      kSizedBoxV10,
                                      Text(
                                        "Total Managers",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      kSizedBoxV10,
                                      Text(
                                        mViewModel.homeData?.managerCount
                                                .toString() ??
                                            '--',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.group,
                                        size: 30,
                                      ),
                                      kSizedBoxV10,
                                      Text(
                                        "Total Staff",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      kSizedBoxV10,
                                      Text(
                                        mViewModel.homeData?.staffCount
                                                .toString() ??
                                            '--',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    kSizedBoxV10,
                    Text(
                      "Best Sellers",
                      style: TextStyle(fontSize: 18),
                    ),
                    kSizedBoxV10,
                    ListView.builder(
                      itemCount: mViewModel.homeData?.bestSellers?.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10, bottom: 10),
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Image.network(
                                        mViewModel.homeData?.bestSellers?[index]
                                                .image ??
                                            'https://dzinejs.lv/wp-content/plugins/lightbox/images/No-image-found.jpg',
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                  ),
                                  kSizedBoxH10,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mViewModel.homeData?.bestSellers?[index]
                                                .name ??
                                            '--',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        mViewModel.homeData?.bestSellers?[index]
                                                .name ??
                                            '--',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Total order : ${mViewModel.homeData?.bestSellers?[index].orderCount ?? '--'}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "Total sale : ${mViewModel.homeData?.bestSellers?[index].totalSales ?? '--'}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Image.asset(
                                  height: 60,
                                  width: 60,
                                  LocalImages.img_best_seller_2,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
