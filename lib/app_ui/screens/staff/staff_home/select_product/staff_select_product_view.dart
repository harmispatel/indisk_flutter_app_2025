import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/common_widget/primary_button.dart';
import 'package:indisk_app/app_ui/screens/staff/staff_home/select_product/staff_select_product_view_model.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:provider/provider.dart';
import '../../../../../api_service/models/staff_cart_master.dart';
import '../../../../../api_service/models/staff_home_master.dart';
import '../../../../../utils/app_dimens.dart';
import '../../../../../utils/common_utills.dart';
import '../../../../common_widget/common_textfield.dart';
import 'get_bill/get_bill_view.dart';

class StaffSelectProductView extends StatefulWidget {
  final String tableNo;
  final String type;

  const StaffSelectProductView({super.key, required this.tableNo,required this.type});

  @override
  State<StaffSelectProductView> createState() => _StaffSelectProductViewState();
}

class _StaffSelectProductViewState extends State<StaffSelectProductView> {
  StaffSelectProductViewModel? mViewModel;
  String? _selectedCategoryId;
  String _selectedCategoryName = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mViewModel =
          Provider.of<StaffSelectProductViewModel>(context, listen: false);
      mViewModel?.getFoodCategoryList().then((_) {
        mViewModel
            ?.getStaffFoodList(isManageable: false)
            .catchError((e) {})
            .then((_) {
          mViewModel?.getStaffCartList(
              tableNo:
                  widget.tableNo == "Take away order" ? "0" : widget.tableNo);
          if (mounted) {
            setState(() {});
          }
        });
      });
    });
  }

  List<Map<String, dynamic>> getCategories() {
    final categories = [
      {'id': null, 'name': 'All'}
    ];
    if (mViewModel?.foodCategoryList != null) {
      categories.addAll(mViewModel!.foodCategoryList
          .map((e) => {'id': e.sId, 'name': e.name ?? 'Unnamed'}));
    }
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel =
        mViewModel ?? Provider.of<StaffSelectProductViewModel>(context);
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back)),
                        Expanded(
                          child: CommonTextField(
                            keyboardType: TextInputType.emailAddress,
                            labelText: "Search Anything Here",
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                      ],
                    ),
                    kSizedBoxV20,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.tableNo == "Take away order"
                              ? "Select Items For Take Away Order"
                              : 'Select Items For Table No. ${widget.tableNo}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    viewModel.isApiLoading == true ||
                            viewModel.isFoodCategoryLoading == true
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
                                    itemCount: getCategories().length,
                                    itemBuilder: (context, index) {
                                      final category = getCategories()[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ChoiceChip(
                                          showCheckmark: false,
                                          label: Text(category['name']),
                                          selected: _selectedCategoryId ==
                                              category['id'],
                                          onSelected: (selected) {
                                            setState(() {
                                              _selectedCategoryId =
                                                  category['id'];
                                              _selectedCategoryName =
                                                  category['name'];
                                            });
                                          },
                                          selectedColor:
                                              CommonColors.primaryColor,
                                          labelStyle: TextStyle(
                                            color: _selectedCategoryId ==
                                                    category['id']
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
                                  itemCount: _selectedCategoryId == null
                                      ? viewModel.staffFoodList.length
                                      : viewModel.staffFoodList
                                          .where((item) =>
                                              item.category?.sId ==
                                              _selectedCategoryId)
                                          .length,
                                  itemBuilder: (context, index) {
                                    final foodItem = _selectedCategoryId == null
                                        ? viewModel.staffFoodList[index]
                                        : viewModel.staffFoodList
                                            .where((item) =>
                                                item.category?.sId ==
                                                _selectedCategoryId)
                                            .toList()[index];

                                    return ProductCard(
                                      image: foodItem.image?.first ?? '--',
                                      name: foodItem.name ?? '--',
                                      price: foodItem.price.toString() ?? '--',
                                      description: foodItem.description ?? '--',
                                      onAddToCartTap: () async {
                                        final hasOptions =
                                            foodItem.discount?.isNotEmpty ==
                                                    true ||
                                                foodItem.modifier?.isNotEmpty ==
                                                    true ||
                                                foodItem.topup?.isNotEmpty ==
                                                    true ||
                                                foodItem.varient?.isNotEmpty ==
                                                    true;

                                        if (hasOptions) {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                ProductOptionsDialog(
                                              product: foodItem,
                                              onOptionsSelected:
                                                  (options) async {
                                                try {
                                                  await viewModel.addToCart(
                                                    productId: foodItem.id!,
                                                    tableNo: widget.tableNo ==
                                                            "Take away order"
                                                        ? "0"
                                                        : widget.tableNo,
                                                    variantIds: options[
                                                                'variantIds']
                                                            ?.cast<String>() ??
                                                        [],
                                                    discountId:
                                                        options['discountId'],
                                                    modifierIds: options[
                                                                'modifierIds']
                                                            ?.cast<String>() ??
                                                        [],
                                                    topupIds: options[
                                                                'topupIds']
                                                            ?.cast<String>() ??
                                                        [],
                                                    specialInstruction: options[
                                                            'specialInstructions'] ??
                                                        '',
                                                  );

                                                  // Refresh cart list after adding
                                                  await viewModel.getStaffCartList(
                                                      tableNo: widget.tableNo ==
                                                              "Take away order"
                                                          ? "0"
                                                          : widget.tableNo);

                                                  if (mounted) {
                                                    setState(() {
                                                      final currentCount =
                                                          foodItem.cartCount ??
                                                              0;
                                                      foodItem.cartCount =
                                                          currentCount + 1;
                                                    });
                                                  }
                                                } catch (e) {
                                                  showRedToastMessage(
                                                      e.toString());
                                                }
                                              },
                                            ),
                                          );
                                        } else {
                                          try {
                                            await viewModel.addToCart(
                                              productId: foodItem.id!,
                                              tableNo: widget.tableNo ==
                                                      "Take away order"
                                                  ? "0"
                                                  : widget.tableNo,
                                              variantIds: [],
                                              discountId: null,
                                              modifierIds: [],
                                              topupIds: [],
                                              specialInstruction: '',
                                            );

                                            // Refresh cart list after adding
                                            await viewModel.getStaffCartList(
                                                tableNo: widget.tableNo ==
                                                        "Take away order"
                                                    ? "0"
                                                    : widget.tableNo);

                                            if (mounted) {
                                              setState(() {
                                                final currentCount =
                                                    foodItem.cartCount ?? 0;
                                                foodItem.cartCount =
                                                    currentCount + 1;
                                              });
                                            }
                                          } catch (e) {
                                            showRedToastMessage(e.toString());
                                          }
                                        }
                                      },
                                      // onAddToCartTap: () async {
                                      //   final hasOptions =
                                      //       foodItem.discount?.isNotEmpty ==
                                      //               true ||
                                      //           foodItem.modifier?.isNotEmpty ==
                                      //               true ||
                                      //           foodItem.topup?.isNotEmpty ==
                                      //               true ||
                                      //           foodItem.varient?.isNotEmpty ==
                                      //               true;
                                      //
                                      //   if (hasOptions) {
                                      //     showDialog(
                                      //       context: context,
                                      //       builder: (context) =>
                                      //           ProductOptionsDialog(
                                      //         product: foodItem,
                                      //         onOptionsSelected:
                                      //             (options) async {
                                      //           // Debug print
                                      //           print(
                                      //               'Options received in ProductCard:');
                                      //           print(options);
                                      //
                                      //           try {
                                      //             await viewModel.addToCart(
                                      //               productId: foodItem.id!,
                                      //               tableNo: widget.tableNo ==
                                      //                       "Take away order"
                                      //                   ? "0"
                                      //                   : widget.tableNo,
                                      //               variantIds: options[
                                      //                           'variantIds']
                                      //                       ?.cast<String>() ??
                                      //                   [],
                                      //               // Ensure proper type casting
                                      //               discountId:
                                      //                   options['discountId'],
                                      //               modifierIds: options[
                                      //                           'modifierIds']
                                      //                       ?.cast<String>() ??
                                      //                   [],
                                      //               topupIds: options[
                                      //                           'topupIds']
                                      //                       ?.cast<String>() ??
                                      //                   [],
                                      //               specialInstruction: options[
                                      //                       'specialInstructions'] ??
                                      //                   '',
                                      //             );
                                      //
                                      //             if (mounted) {
                                      //               setState(() {
                                      //                 final currentCount =
                                      //                     foodItem.cartCount ??
                                      //                         0;
                                      //                 foodItem.cartCount =
                                      //                     currentCount + 1;
                                      //               });
                                      //             }
                                      //           } catch (e) {
                                      //             showRedToastMessage(
                                      //                 e.toString());
                                      //           }
                                      //         },
                                      //       ),
                                      //     );
                                      //   } else {
                                      //     // No options, directly call addToCart with empty IDs
                                      //     try {
                                      //       await viewModel.addToCart(
                                      //         productId: foodItem.id!,
                                      //         tableNo: widget.tableNo ==
                                      //                 "Take away order"
                                      //             ? "0"
                                      //             : widget.tableNo,
                                      //         variantIds: [],
                                      //         discountId: null,
                                      //         modifierIds: [],
                                      //         topupIds: [],
                                      //         specialInstruction: '',
                                      //       );
                                      //
                                      //       if (mounted) {
                                      //         setState(() {
                                      //           final currentCount =
                                      //               foodItem.cartCount ?? 0;
                                      //           foodItem.cartCount =
                                      //               currentCount + 1;
                                      //         });
                                      //       }
                                      //     } catch (e) {
                                      //       showRedToastMessage(e.toString());
                                      //     }
                                      //   }
                                      // },
                                      cartCount: foodItem.cartCount ?? 0,
                                      onIncreaseTap: () async {
                                        setState(() {
                                          final currentCount =
                                              foodItem.cartCount ?? 0;
                                          foodItem.cartCount = currentCount + 1;
                                        });
                                        await viewModel.updateQuantity(
                                          productId: foodItem.id ?? '--',
                                          type: 'increase',
                                          tableNo: widget.tableNo ==
                                                  "Take away order"
                                              ? "0"
                                              : widget.tableNo,
                                        );
                                        // Refresh cart
                                        await viewModel.getStaffCartList(
                                            tableNo: widget.tableNo ==
                                                    "Take away order"
                                                ? "0"
                                                : widget.tableNo);
                                      },
                                      onDecreaseTap: () async {
                                        setState(() {
                                          final currentCount =
                                              foodItem.cartCount ?? 0;
                                          foodItem.cartCount = currentCount - 1;
                                        });
                                        await viewModel.updateQuantity(
                                          productId: foodItem.id ?? '--',
                                          type: 'decrease',
                                          tableNo: widget.tableNo ==
                                                  "Take away order"
                                              ? "0"
                                              : widget.tableNo,
                                        );
                                        // Refresh cart
                                        await viewModel.getStaffCartList(
                                            tableNo: widget.tableNo ==
                                                    "Take away order"
                                                ? "0"
                                                : widget.tableNo);
                                      },
                                      // onIncreaseTap: () {
                                      //   setState(() {
                                      //     final currentCount =
                                      //         foodItem.cartCount ?? 0;
                                      //     foodItem.cartCount = currentCount + 1;
                                      //   });
                                      //   viewModel.updateQuantity(
                                      //       productId: foodItem.id ?? '--',
                                      //       type: 'increase',
                                      //       tableNo: widget.tableNo ==
                                      //               "Take away order"
                                      //           ? "0"
                                      //           : widget.tableNo);
                                      // },
                                      // onDecreaseTap: () {
                                      //   setState(() {
                                      //     final currentCount =
                                      //         foodItem.cartCount ?? 0;
                                      //     foodItem.cartCount = currentCount - 1;
                                      //   });
                                      //   viewModel.updateQuantity(
                                      //       productId: foodItem.id ?? '--',
                                      //       type: 'decrease',
                                      //       tableNo: widget.tableNo ==
                                      //               "Take away order"
                                      //           ? "0"
                                      //           : widget.tableNo);
                                      // },
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'Cart Details',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      if (viewModel.staffCartFoodList.isNotEmpty &&
                          viewModel.isCartApiLoading == false)
                        GestureDetector(
                          onTap: () {
                            viewModel.clearCart(
                                tableNo: widget.tableNo == "Take away order"
                                    ? "0"
                                    : widget.tableNo);
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
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Spacer(),
                                  Text(
                                    "+\nAdd Product\nFrom Special Menu",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 22),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        pushToScreen(GetBillView(
                                          tableNo: widget.tableNo,
                                        ));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: CommonColors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.print,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              Text(
                                                " Get Bill",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                                            type: 'increase',
                                            tableNo: widget.tableNo ==
                                                    "Take away order"
                                                ? "0"
                                                : widget.tableNo);
                                      },
                                      onDecrement: () {
                                        viewModel.updateQuantity(
                                            productId: viewModel
                                                    .staffCartFoodList[index]
                                                    .foodItemId ??
                                                '--',
                                            type: 'decrease',
                                            tableNo: widget.tableNo ==
                                                    "Take away order"
                                                ? "0"
                                                : widget.tableNo);
                                      },
                                      onDelete: () {
                                        viewModel.removeItemFromCart(
                                            productId: viewModel
                                                    .staffCartFoodList[index]
                                                    .foodItemId ??
                                                '--',
                                            tableNo: widget.tableNo ==
                                                    "Take away order"
                                                ? "0"
                                                : widget.tableNo);
                                      });
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
                            Text('${viewModel.cartQty}',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Amount',
                                style: TextStyle(fontSize: 16)),
                            Text('Rs ${viewModel.subTotal}',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 24),
                        PrimaryButton(
                          padding: EdgeInsets.zero,
                          height: 40,
                          onPressed: () {
                            pushToScreen(GetBillView(
                              tableNo: widget.tableNo,
                            ));
                          },
                          text: 'Get Bill',
                        ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: PrimaryButton(
                        //         padding: EdgeInsets.zero,
                        //         height: 40,
                        //         onPressed: () {
                        //           viewModel.placeOrderApi(
                        //               tableNo:
                        //                   widget.tableNo == "Take away order"
                        //                       ? "0"
                        //                       : widget.tableNo);
                        //         },
                        //         text: 'Save',
                        //       ),
                        //     ),
                        //     kSizedBoxH10,
                        //     Expanded(
                        //       child: PrimaryButton(
                        //         padding: EdgeInsets.zero,
                        //         height: 40,
                        //         onPressed: () {
                        //           pushToScreen(GetBillView(tableNo: widget.tableNo,));
                        //         },
                        //         text: 'Get Bill',
                        //       ),
                        //     ),
                        //   ],
                        // ),
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

class ProductOptionsDialog extends StatefulWidget {
  final StaffHomeData product;
  final Function(Map<String, dynamic>) onOptionsSelected;

  const ProductOptionsDialog({
    Key? key,
    required this.product,
    required this.onOptionsSelected,
  }) : super(key: key);

  @override
  _ProductOptionsDialogState createState() => _ProductOptionsDialogState();
}

class _ProductOptionsDialogState extends State<ProductOptionsDialog> {
  List<Varient> _selectedVariants = [];
  Discount? _selectedDiscount;
  List<Modifier> _selectedModifiers = [];
  List<Topup> _selectedTopups = [];
  String? _specialInstructions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with product name
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.product.name ?? 'Product Options',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Divider(height: 24, thickness: 1),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Variants Section
                    if (widget.product.varient?.isNotEmpty ?? false) ...[
                      _buildSectionHeader('Variants (Multiple Selection)'),
                      Wrap(
                        spacing: 8,
                        children: widget.product.varient!
                            .map(
                              (variant) => FilterChip(
                                label: Text(
                                    '${variant.varientName} (+${variant.price} Rs)'),
                                selected: _selectedVariants.contains(variant),
                                checkmarkColor: Colors.white,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedVariants.add(variant);
                                    } else {
                                      _selectedVariants.remove(variant);
                                    }
                                  });
                                },
                                selectedColor: CommonColors.primaryColor,
                                labelStyle: TextStyle(
                                  color: _selectedVariants.contains(variant)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 20),
                    ],

                    // Discounts Section
                    if (widget.product.discount?.isNotEmpty ?? false) ...[
                      _buildSectionHeader('Discounts (Single Selection)'),
                      ...widget.product.discount!
                          .where((d) => d.isEnable ?? false)
                          .map((discount) => RadioListTile<Discount>(
                                value: discount,
                                groupValue: _selectedDiscount,
                                title: Text(discount.description ?? ''),
                                subtitle: Text('${discount.percentage}% off'),
                                onChanged: (value) =>
                                    setState(() => _selectedDiscount = value),
                                contentPadding: EdgeInsets.zero,
                              )),
                      SizedBox(height: 20),
                    ],

                    // Modifiers Section
                    if (widget.product.modifier?.isNotEmpty ?? false) ...[
                      _buildSectionHeader('Modifiers (Multiple Selection)'),
                      ...widget.product.modifier!
                          .map((modifier) => CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                    '${modifier.modifierName} (+${modifier.price} Rs)'),
                                value: _selectedModifiers.contains(modifier),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      _selectedModifiers.add(modifier);
                                    } else {
                                      _selectedModifiers.remove(modifier);
                                    }
                                  });
                                },
                              )),
                      SizedBox(height: 20),
                    ],

                    // Topups Section
                    if (widget.product.topup?.isNotEmpty ?? false) ...[
                      _buildSectionHeader('Topups (Multiple Selection)'),
                      ...widget.product.topup!.map((topup) => CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title:
                                Text('${topup.topupName} (+${topup.price} Rs)'),
                            value: _selectedTopups.contains(topup),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedTopups.add(topup);
                                } else {
                                  _selectedTopups.remove(topup);
                                }
                              });
                            },
                          )),
                      SizedBox(height: 20),
                    ],

                    // Special Instructions
                    _buildSectionHeader('Special Instructions'),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Any special requests?',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(12),
                      ),
                      onChanged: (value) => _specialInstructions = value,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Footer buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: CommonColors.primaryColor),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel',
                        style: TextStyle(
                          color: CommonColors.primaryColor,
                        )),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CommonColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      final options = {
                        'variantIds':
                            _selectedVariants.map((v) => v.sId).toList(),
                        'discountId': _selectedDiscount?.sId,
                        'modifierIds':
                            _selectedModifiers.map((m) => m.sId).toList(),
                        'topupIds': _selectedTopups.map((t) => t.sId).toList(),
                        'specialInstructions': _specialInstructions,
                      };

                      // Print for debugging
                      print('Selected options before passing:');
                      print(options);
                      Navigator.pop(context);

                      widget.onOptionsSelected(options);
                    },
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(color: Colors.white),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}

class CartItemWidget extends StatefulWidget {
  final StaffCartData item;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onDelete;

  const CartItemWidget({
    required this.item,
    this.onIncrement,
    this.onDecrement,
    this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    final hasAdditionalInfo = widget.item.additionalPrice != null &&
        ((widget.item.additionalPrice!.modifier?.isNotEmpty ?? false) ||
            (widget.item.additionalPrice!.topup?.isNotEmpty ?? false) ||
            (widget.item.additionalPrice!.varient?.isNotEmpty ?? false) ||
            (widget.item.additionalPrice!.discount?.isEnable ?? false));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.item.image != null && widget.item.image!.isNotEmpty)
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
                      widget.item.image!.first,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.fastfood,
                          size: 30,
                          color: Colors.grey[400]),
                    ),
                  ),
                ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(widget.item.productName ?? '--',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                        Text(
                          'Rs ${widget.item.totalPrice ?? '--'}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    if (widget.item.specialInstruction != null &&
                        widget.item.specialInstruction!.isNotEmpty)
                      Text(
                        'Note: ${widget.item.specialInstruction}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    if (hasAdditionalInfo)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showDetails = !_showDetails;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _showDetails ? 'Hide Info' : 'More Info',
                            style: TextStyle(
                              fontSize: 12,
                              color: CommonColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, size: 20),
                      onPressed: widget.onDecrement,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(widget.item.quantity?.toString() ?? '0'),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, size: 20),
                      onPressed: widget.onIncrement,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: widget.onDelete,
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                  size: 24,
                ),
              ),
            ],
          ),
          // Details section (shown when expanded)
          if (_showDetails && widget.item.additionalPrice != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modifiers
                  if (widget.item.additionalPrice!.modifier != null &&
                      widget.item.additionalPrice!.modifier!.isNotEmpty)
                    _buildDetailSection(
                      title: 'Modifiers',
                      items: widget.item.additionalPrice!.modifier!
                          .map((m) =>
                              '${m.modifierName}${m.price != null && m.price! > 0 ? ' (+Rs${m.price})' : ''}')
                          .toList(),
                      color: Colors.blue[50]!,
                    ),
                  // Top-ups
                  if (widget.item.additionalPrice!.topup != null &&
                      widget.item.additionalPrice!.topup!.isNotEmpty)
                    _buildDetailSection(
                      title: 'Top-ups',
                      items: widget.item.additionalPrice!.topup!
                          .map((t) =>
                              '${t.topupName}${t.price != null && t.price! > 0 ? ' (+Rs${t.price})' : ''}')
                          .toList(),
                      color: Colors.green[50]!,
                    ),
                  // Variants
                  if (widget.item.additionalPrice!.varient != null &&
                      widget.item.additionalPrice!.varient!.isNotEmpty)
                    _buildDetailSection(
                      title: 'Variants',
                      items: widget.item.additionalPrice!.varient!
                          .map((v) =>
                              '${v.varientName}${v.price != null && v.price! > 0 ? ' (+Rs${v.price})' : ''}')
                          .toList(),
                      color: Colors.purple[50]!,
                    ),
                  // Discount
                  if (widget.item.additionalPrice!.discount != null &&
                      widget.item.additionalPrice!.discount!.isEnable == true)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Discount: ${widget.item.additionalPrice!.discount!.percentage}%${widget.item.additionalPrice!.discount!.description != null ? ' (${widget.item.additionalPrice!.discount!.description})' : ''}',
                        style: TextStyle(fontSize: 12, color: Colors.red[800]),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailSection({
    required String title,
    required List<String> items,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: items
                .map((item) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item,
                        style: TextStyle(fontSize: 12),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

///
//
// class PaymentMethodDialog extends StatefulWidget {
//   final String tableNo;
//
//   const PaymentMethodDialog({super.key, required this.tableNo});
//
//   @override
//   _PaymentMethodDialogState createState() => _PaymentMethodDialogState();
// }
//
// class _PaymentMethodDialogState extends State<PaymentMethodDialog> {
//   String selectedPayment = '';
//   StaffSelectProductViewModel? mViewModel;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       mViewModel =
//           Provider.of<StaffSelectProductViewModel>(context, listen: false);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel =
//         mViewModel ?? Provider.of<StaffSelectProductViewModel>(context);
//     return AlertDialog(
//       title: const Text(
//         'Select Payment Method',
//         style: TextStyle(fontSize: 18),
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     selectedPayment = 'viva';
//                   });
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                         color: selectedPayment == 'viva'
//                             ? CommonColors.primaryColor
//                             : Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Column(
//                     children: [
//                       Image.network(
//                         'https://ibsintelligence.com/wp-content/uploads/2020/07/vivawallet1.jpg',
//                         width: 100,
//                         height: 80,
//                         fit: BoxFit.fill,
//                       ),
//                       const SizedBox(height: 8),
//                       Text('Viva',
//                           style: TextStyle(
//                               color: selectedPayment == 'viva'
//                                   ? CommonColors.primaryColor
//                                   : Colors.grey)),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     selectedPayment = 'cash';
//                   });
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                         color: selectedPayment == 'cash'
//                             ? CommonColors.primaryColor
//                             : Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Column(
//                     children: [
//                       Image.network(
//                         'https://www.shutterstock.com/image-vector/doller-money-icon-vector-png-600nw-2086977352.jpg',
//                         width: 100,
//                         height: 80,
//                         fit: BoxFit.fill,
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Cash',
//                         style: TextStyle(
//                             color: selectedPayment == 'cash'
//                                 ? CommonColors.primaryColor
//                                 : Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           if (selectedPayment != '') ...[
//             const SizedBox(height: 20),
//             PrimaryButton(
//               height: 45,
//               padding: EdgeInsets.zero,
//               onPressed: () {
//                 // viewModel.placeOrderApi(
//                 //     tableNo: widget.tableNo, paymentType: selectedPayment);
//               },
//               text: 'Submit',
//             )
//           ]
//         ],
//       ),
//     );
//   }
// }
