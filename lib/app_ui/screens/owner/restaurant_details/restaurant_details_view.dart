import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/screens/owner/restaurant_details/restaurant_details_view_model.dart';
import 'package:provider/provider.dart';
import '../../../../utils/app_dimens.dart';
import '../../../../utils/common_colors.dart';
import '../../../../utils/local_images.dart';

class RestaurantDetailsView extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailsView({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailsView> createState() => _RestaurantDetailsViewState();
}

class _RestaurantDetailsViewState extends State<RestaurantDetailsView> {
  RestaurantDetailsViewModel? mViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mViewModel =
          Provider.of<RestaurantDetailsViewModel>(context, listen: false);
      mViewModel
          ?.getRestaurantDetailsApi(restaurantId: widget.restaurantId)
          .catchError((e) {})
          .then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = mViewModel ?? Provider.of<RestaurantDetailsViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: viewModel.isApiLoading && (viewModel.restaurantDetailsData == null)
          ? Center(child: CircularProgressIndicator())
          : _buildDashboardContent(viewModel),
    );
  }

  Widget _buildDashboardContent(RestaurantDetailsViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(top: 35, left: 15, right: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_outlined),
            ),
            kSizedBoxV20,
            Text(
              viewModel.restaurantDetailsData?.name ?? '--',
              style: TextStyle(fontSize: 18),
            ),
            kSizedBoxV10,
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
                                "Total Food",
                                style: TextStyle(fontSize: 18),
                              ),
                              kSizedBoxV10,
                              Text(
                                viewModel.restaurantDetailsData?.foods?.length
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
                                "Manager",
                                style: TextStyle(fontSize: 18),
                              ),
                              kSizedBoxV10,
                              Text(
                                viewModel
                                        .restaurantDetailsData?.manager?.name ??
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
                                viewModel.restaurantDetailsData?.staff?.length.toString() ?? '--',
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
              "Most Selling Food",
              style: TextStyle(fontSize: 18),
            ),
            ListView.builder(
              itemCount: viewModel.restaurantDetailsData?.foods?.length ?? 0,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 10, bottom: 10),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Image.network(
                                viewModel.restaurantDetailsData?.foods?[index]
                                        .image ??
                                    'https://dzinejs.lv/wp-content/plugins/lightbox/images/No-image-found.jpg',
                                height: 100,
                                width: 100,
                              ),
                            ),
                          ),
                          kSizedBoxH10,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewModel.restaurantDetailsData?.foods?[index]
                                        .name ??
                                    '--',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                viewModel.restaurantDetailsData?.foods?[index]
                                        .categoryId ??
                                    '--',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Price : ${viewModel.restaurantDetailsData?.foods?[index].price ?? '--'}",
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
    );
  }
}