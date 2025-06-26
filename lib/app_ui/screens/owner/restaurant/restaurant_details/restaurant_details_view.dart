import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/screens/owner/restaurant/restaurant_details/restaurant_details_view_model.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/app_dimens.dart';
import '../../../../../utils/common_colors.dart';
import '../../../../../utils/local_images.dart';

class RestaurantDetailsView extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const RestaurantDetailsView(
      {super.key, required this.restaurantId, required this.restaurantName});

  @override
  State<RestaurantDetailsView> createState() => _RestaurantDetailsViewState();
}

class _RestaurantDetailsViewState extends State<RestaurantDetailsView> {
  RestaurantDetailsViewModel? mViewModel;
  int _selectedTabIndex = 0; // 0: Manager, 1: Staff, 2: Category, 3: Food

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
    final viewModel =
        mViewModel ?? Provider.of<RestaurantDetailsViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantName,
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: viewModel.isApiLoading
          ? Center(child: CircularProgressIndicator())
          : viewModel.errorMessage != null
              ? Center(child: Text(viewModel.errorMessage!))
              : SingleChildScrollView(
                  child: Column(children: [
                    // Restaurant Info Card
                    _buildRestaurantInfo(viewModel),

                    // Tabs Row
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: _buildTabButton(
                                  "Manager", 0, viewModel.managerCount)),
                          kSizedBoxH10,
                          Expanded(
                              child: _buildTabButton(
                                  "Staff", 1, viewModel.staffCount)),
                          kSizedBoxH10,
                          Expanded(
                            child: _buildTabButton(
                                "Category", 2, viewModel.categoryCount),
                          ),
                          kSizedBoxH10,
                          Expanded(
                              child: _buildTabButton(
                                  "Food", 3, viewModel.foodCount)),
                        ],
                      ),
                    ),
                    // Content based on selected tab
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildContent(viewModel),
                    ),
                  ]),
                ),
    );
  }

  Widget _buildRestaurantInfo(RestaurantDetailsViewModel viewModel) {
    final restaurant = viewModel.restaurantDetailsData?.restaurantDetails;
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (restaurant?.image != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    restaurant!.image!,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 16),
            Text(
              restaurant?.name ?? 'No Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              restaurant?.description ?? 'No Description',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(restaurant?.location ?? 'No Location'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.restaurant, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(restaurant?.cuisineType ?? 'No Cuisine Type'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index, int count) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedTabIndex == index
              ? CommonColors.primaryColor
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: _selectedTabIndex == index ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              count.toString(),
              style: TextStyle(
                color: _selectedTabIndex == index ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(RestaurantDetailsViewModel viewModel) {
    switch (_selectedTabIndex) {
      case 0: // Manager
        return _buildManagerContent(viewModel);
      case 1: // Staff
        return _buildStaffContent(viewModel);
      case 2: // Category
        return _buildCategoryContent(viewModel);
      case 3: // Food
        return _buildFoodContent(viewModel);
      default:
        return Container();
    }
  }

  Widget _buildManagerContent(RestaurantDetailsViewModel viewModel) {
    final managers = viewModel.restaurantDetailsData?.manager ?? [];
    if (managers.isEmpty) {
      return Center(child: Text("No Manager Available"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: managers.length,
      itemBuilder: (context, index) {
        final manager = managers[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: Icon(Icons.person, size: 40),
            title: Text(manager.email ?? 'No Email'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Role: ${manager.role ?? 'No Role'}"),
                Text("Phone: ${manager.phone ?? 'No Phone'}"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStaffContent(RestaurantDetailsViewModel viewModel) {
    final staffList = viewModel.restaurantDetailsData?.staff ?? [];
    if (staffList.isEmpty) {
      return Center(child: Text("No Staff Available"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: staffList.length,
      itemBuilder: (context, index) {
        final staff = staffList[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: staff.profilePicture != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(staff.profilePicture!),
                  )
                : CircleAvatar(
                    child: Icon(Icons.person),
                  ),
            title: Text(staff.name ?? 'No Name'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Role: ${staff.role ?? 'No Role'}"),
                Text("Email: ${staff.email ?? 'No Email'}"),
                Text("Phone: ${staff.phone ?? 'No Phone'}"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryContent(RestaurantDetailsViewModel viewModel) {
    final categories = viewModel.restaurantDetailsData?.categories ?? [];
    if (categories.isEmpty) {
      return Center(child: Text("No Categories Available"));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: category.imageUrl != null
                      ? Image.network(
                          category.imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.category, size: 50),
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name ?? 'No Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      category.description ?? 'No Description',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFoodContent(RestaurantDetailsViewModel viewModel) {
    final foods = viewModel.restaurantDetailsData?.foods ?? [];
    if (foods.isEmpty) {
      return Center(child: Text("No Food Items Available"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (food.image != null && food.image!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      food.image!.first,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.fastfood, size: 40),
                  ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name ?? 'No Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        food.description ?? 'No Description',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            "Base Price: \$${food.basePrice?.toStringAsFixed(2) ?? '0.00'}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          if (food.pricesByQuantity != null &&
                              food.pricesByQuantity!.isNotEmpty)
                            Text(
                              "${food.pricesByQuantity!.first.quantity} for \$${food.pricesByQuantity!.first.price?.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CommonColors.primaryColor,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "Available: ${food.availableQty ?? 0}/${food.totalQty ?? 0}",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: food.isAvailable == true
                                  ? Colors.green[100]
                                  : Colors.red[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              food.isAvailable == true
                                  ? "Available"
                                  : "Not Available",
                              style: TextStyle(
                                color: food.isAvailable == true
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Add these getters to your RestaurantDetailsViewModel class
extension RestaurantDetailsViewModelExt on RestaurantDetailsViewModel {
  int get managerCount => restaurantDetailsData?.manager?.length ?? 0;

  int get staffCount => restaurantDetailsData?.staff?.length ?? 0;

  int get categoryCount => restaurantDetailsData?.categories?.length ?? 0;

  int get foodCount => restaurantDetailsData?.foods?.length ?? 0;
}
