 import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/common_widget/primary_button.dart';
import 'package:indisk_app/app_ui/screens/staff/staff_home/staff_home_view_model.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:provider/provider.dart';

import '../../../../api_service/models/staff_cart_master.dart';
import '../../../../database/app_preferences.dart';
import '../../../../utils/app_dimens.dart';
import '../../../../utils/common_utills.dart';
import '../../../common_widget/common_textfield.dart';
import '../../login/login_view.dart';

class StaffHomeView extends StatefulWidget {
  const StaffHomeView({super.key});

  @override
  State<StaffHomeView> createState() => _StaffHomeViewState();
}

class _StaffHomeViewState extends State<StaffHomeView> {
  StaffHomeViewModel? mViewModel;
  final List<String> _categories = [
    'All',
    'Burgers',
    'Pizzas',
    'Pastas',
    'Salads',
    'Sandwiches',
    'Japanese',
    'Appetizers',
    'Mexican',
    'Mains',
    'Asian',
    'Desserts',
  ];

  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    print("DashboardPage initState");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Initializing dashboard data");
      mViewModel = Provider.of<StaffHomeViewModel>(context, listen: false);
      mViewModel?.getStaffFoodList().catchError((e) {
        print("Dashboard init error: $e");
      }).then((_) {
        mViewModel?.getStaffCartList();
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = mViewModel ?? Provider.of<StaffHomeViewModel>(context);
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "In",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: CommonColors.primaryColor),
                        ),
                        Text(
                          "disk",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        kSizedBoxH20,
                        Expanded(
                          child: CommonTextField(
                            keyboardType: TextInputType.emailAddress,
                            labelText: "Search Anything Here",
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                        kSizedBoxH20,
                        InkWell(
                          onTap: () async {
                            await SP.instance.removeLoginDetails();
                            pushAndRemoveUntil(LoginView());
                          },
                          child: Icon(Icons.logout),
                        ),
                      ],
                    ),
                    kSizedBoxV20,
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Special Menu For You',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    viewModel.isApiLoading == true
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 300),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _categories.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ChoiceChip(
                                          showCheckmark: false,
                                          label: Text(_categories[index]),
                                          selected: _selectedCategory == _categories[index],
                                          onSelected: (selected) {
                                            setState(() {
                                              _selectedCategory = _categories[index];
                                            });
                                          },
                                          selectedColor: CommonColors.primaryColor,
                                          labelStyle: TextStyle(
                                            color: _selectedCategory == _categories[index]
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 16.0,
                                    mainAxisSpacing: 16.0,
                                    childAspectRatio: 0.8,
                                  ),
                                  itemCount: viewModel.staffFoodList.length,
                                  itemBuilder: (context, index) {
                                    return ProductCard(
                                      image: viewModel
                                              .staffFoodList[index].image?.first ??
                                          '--',
                                      name: viewModel.staffFoodList[index].name ??
                                          '--',
                                      price: viewModel.staffFoodList[index].price
                                              .toString() ??
                                          '--',
                                      description: viewModel
                                              .staffFoodList[index].description ??
                                          '--',
                                      onAddToCartTap: () {
                                        setState(() {
                                          final currentCount = viewModel
                                                  .staffFoodList[index].cartCount ??
                                              0;
                                          viewModel.staffFoodList[index].cartCount =
                                              currentCount + 1;
                                        });
                                        viewModel.addToCart(
                                            productId:
                                                viewModel.staffFoodList[index].id ??
                                                    '--');
                                      },
                                      cartCount: viewModel
                                              .staffFoodList[index].cartCount ??
                                          0,
                                      onIncreaseTap: () {
                                        setState(() {
                                          final currentCount = viewModel
                                                  .staffFoodList[index].cartCount ??
                                              0;
                                          viewModel.staffFoodList[index].cartCount =
                                              currentCount + 1;
                                        });
                                        viewModel.updateQuantity(
                                            productId:
                                                viewModel.staffFoodList[index].id ??
                                                    '--',
                                            type: 'increase');
                                      },
                                      onDecreaseTap: () {
                                        setState(() {
                                          final currentCount = viewModel
                                                  .staffFoodList[index].cartCount ??
                                              0;
                                          viewModel.staffFoodList[index].cartCount =
                                              currentCount - 1;
                                        });
                                        viewModel.updateQuantity(
                                            productId:
                                                viewModel.staffFoodList[index].id ??
                                                    '--',
                                            type: 'decrease');
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey[100],
            width: kDeviceWidth / 3.5,
            child: Column(
              children: [
                kSizedBoxV20,
                kSizedBoxV20,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text('Order Details',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500)),
                      Spacer(),
                      if(viewModel.staffCartFoodList.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          viewModel.clearCart();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 17, vertical: 5),
                            child: Text(
                              "Clear all",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                kSizedBoxV10,
                viewModel.isCartApiLoading == true
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 300),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Expanded(
                        child: viewModel.staffCartFoodList.isEmpty
                            ? Center(
                                child: Text(
                                  "+\nAdd Product\nFrom Special Menu",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 22),
                                ),
                              )
                            : ListView.builder(
                                itemCount: viewModel.staffCartFoodList.length,
                                itemBuilder: (context, index) {
                                  return CartItemWidget(
                                    item: viewModel.staffCartFoodList[index],
                                    onIncrement: () {
                                      viewModel.updateQuantity(
                                          productId: viewModel
                                                  .staffCartFoodList[index]
                                                  .foodItemId ??
                                              '--',
                                          type: 'increase');
                                    },
                                    onDecrement: () {
                                      viewModel.updateQuantity(
                                          productId: viewModel
                                                  .staffCartFoodList[index]
                                                  .foodItemId ??
                                              '--',
                                          type: 'decrease');
                                    },
                                    onDelete: () {
                                      viewModel.removeItemFromCart(
                                          productId: viewModel
                                                  .staffCartFoodList[index]
                                                  .foodItemId ??
                                              '--');
                                    },
                                  );
                                },
                              ),
                      ),
                if (viewModel.staffCartFoodList.isNotEmpty &&
                    viewModel.isCartApiLoading != true) ...[
                  Divider(height: 1),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total QTY', style: TextStyle(fontSize: 16)),
                            Text('${viewModel.cartQty} X',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sub Total', style: TextStyle(fontSize: 16)),
                            Text('Rs ${viewModel.subTotal}',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('GST (5%)', style: TextStyle(fontSize: 16)),
                            Text('Rs ${viewModel.gst}',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 16),
                        Divider(height: 1),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'To Pay',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Rs ${viewModel.cartTotal}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            onPressed: () {
                              viewModel.clearCart();
                            },
                            text: 'Proceed to checkout',
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final String description;
  final int cartCount;
  final GestureTapCallback onAddToCartTap;
  final GestureTapCallback onIncreaseTap;
  final GestureTapCallback onDecreaseTap;

  const ProductCard({
    Key? key,
    required this.image,
    required this.name,
    required this.price,
    required this.description,
    required this.onAddToCartTap,
    required this.cartCount,
    required this.onIncreaseTap,
    required this.onDecreaseTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.fastfood, size: 50, color: Colors.grey[400]),
              ),
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$$price',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (cartCount != 0) ...[
                  Spacer(),
                  GestureDetector(
                    onTap: onDecreaseTap,
                    child: Container(
                      decoration: BoxDecoration(
                          color: CommonColors.primaryColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  kSizedBoxH10,
                  kSizedBoxH10,
                  Text(
                    cartCount.toString(),
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  kSizedBoxH10,
                  kSizedBoxH10,
                  GestureDetector(
                    onTap: onIncreaseTap,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: CommonColors.primaryColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
                if (cartCount == 0)
                  GestureDetector(
                    onTap: onAddToCartTap,
                    child: Container(
                      decoration: BoxDecoration(
                          color: CommonColors.primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 17, vertical: 5),
                        child: Text(
                          "Add Product",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final StaffCartData item;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onDelete;

  const CartItemWidget(
      {required this.item,
      this.onIncrement,
      this.onDecrement,
      Key? key,
      this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          if (item.image != null && item.image!.isNotEmpty)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.image!.first,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.fastfood, size: 30, color: Colors.grey[400]),
                ),
              ),
            ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? '--',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  'Rs ${item.price ?? '--'}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          SizedBox(width: 5),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, size: 20),
                  onPressed: onDecrement,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(item.quantity?.toString() ?? '0'),
                ),
                IconButton(
                  icon: Icon(Icons.add, size: 20),
                  onPressed: onIncrement,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),
          GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
          )
        ],
      ),
    );
  }
}
