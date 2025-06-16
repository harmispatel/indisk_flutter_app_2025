import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/common_widget/primary_button.dart';
import 'package:indisk_app/app_ui/screens/manager/food_menu/create_food/create_food_view.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:provider/provider.dart';

import '../../../../../api_service/models/food_list_master.dart';
import '../../../../../utils/common_utills.dart';
import '../edit_food/edit_food_view.dart';
import 'food_list_view_model.dart';

//
// class FoodListView extends StatefulWidget {
//   @override
//   _FoodListViewState createState() => _FoodListViewState();
// }
//
// class _FoodListViewState extends State<FoodListView> {
//   late FoodListViewModel mViewModel;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       mViewModel.getFoodList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     mViewModel = Provider.of<FoodListViewModel>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Food List', style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add, size: 28),
//             onPressed: () {
//               pushToScreen(CreateFoodView());
//             },
//           ),
//         ],
//       ),
//       body: mViewModel.isApiLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : mViewModel.foodList.isEmpty
//               ? Center(
//                   child: Text("No food found"),
//                 )
//               : Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: ListView.builder(
//                     itemCount: mViewModel.foodList.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 16),
//                         child: buildFoodCard(mViewModel.foodList[index], index),
//                       );
//                     },
//                   ),
//                 ),
//     );
//   }
//
//   Widget buildFoodCard(FoodListData item, int index) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
//       ),
//       padding: EdgeInsets.all(12),
//       child: Row(
//         children: [
//           Container(
//             clipBehavior: Clip.antiAlias,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Image.network(
//               item.image?.first ??
//                   'https://cdn-icons-png.flaticon.com/512/4067/4067447.png',
//               width: 70,
//               height: 70,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Image.network(
//                   'https://cdn-icons-png.flaticon.com/512/4067/4067447.png',
//                   width: 70,
//                   height: 70,
//                   fit: BoxFit.cover,
//                 );
//               },
//             ),
//           ),
//           SizedBox(width: 16),
//           Text(item.name ?? '',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           SizedBox(width: 16),
//           Text("Price: ${item.basePrice?.toStringAsFixed(2)} Kr",
//               style: TextStyle(fontSize: 16)),
//           SizedBox(width: 16),
//           Text(item.isAvailable == "true" ? "In Stock" : "Out Of Stock",
//               style: TextStyle(
//                   fontSize: 16,
//                   color: item.isAvailable == "true" ? Colors.green : Colors.red,
//                   fontWeight: FontWeight.w500)),
//           SizedBox(width: 16),
//           Text("Quantity: ${item.availableQty}",
//               style: TextStyle(fontSize: 16)),
//           Spacer(),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       EditFoodView(foodItem: mViewModel.foodList[index]),
//                 ),
//               ).then((_) {
//                 mViewModel.getFoodList();
//               });
//             },
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.edit,
//                   color: Colors.green,
//                 ),
//                 Text(
//                   "Edit",
//                   style: TextStyle(
//                       color: Colors.green,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500),
//                 )
//               ],
//             ),
//           ),
//           SizedBox(width: 15),
//           GestureDetector(
//             onTap: () {
//               mViewModel.deleteFood(id: mViewModel.foodList[index].sId);
//             },
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.delete_forever,
//                   color: Colors.red,
//                 ),
//                 Text(
//                   "Delete",
//                   style: TextStyle(
//                       color: Colors.red,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

///

class FoodListView extends StatefulWidget {
  @override
  _FoodListViewState createState() => _FoodListViewState();
}

class _FoodListViewState extends State<FoodListView> {
  late FoodListViewModel mViewModel;

  @override
  void initState() {
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
            onPressed: () => pushToScreen(CreateFoodView()),
          ),
        ],
      ),
      body: mViewModel.isApiLoading
          ? Center(child: CircularProgressIndicator())
          : mViewModel.foodList.isEmpty
              ? Center(child: Text("No food found"))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: mViewModel.foodList.length,
                    itemBuilder: (context, index) {
                      // Add static data for demo purposes
                      final item = mViewModel.foodList[index];
                      // Add demo variants
                      final demoVariants = [
                        Variant(name: 'Small', price: item.basePrice! * 0.8),
                        Variant(name: 'Medium', price: item.basePrice!),
                        Variant(name: 'Large', price: item.basePrice! * 1.2),
                      ];
                      // Add demo modifiers
                      final demoModifiers = [
                        Modifier(name: 'Extra Cheese', isOptional: true),
                        Modifier(name: 'No Onions', isOptional: false),
                        Modifier(name: 'Spicy', isOptional: true),
                      ];
                      // Add demo top-ups
                      final demoTopUps = [
                        TopUp(name: 'Extra Dip', price: 10),
                        TopUp(name: 'Side Salad', price: 15),
                      ];
                      // Add demo discount
                      final hasDiscount = index % 2 == 0; // Just for demo

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: FoodItemCard(
                          item: item,
                          variants: demoVariants,
                          modifiers: demoModifiers,
                          topUps: demoTopUps,
                          hasDiscount: hasDiscount,
                          discountPrice:
                              hasDiscount ? item.basePrice! * 0.9 : null,
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditFoodView(foodItem: item),
                              ),
                            ).then((_) => mViewModel.getFoodList());
                          },
                          onDelete: () => mViewModel.deleteFood(id: item.sId),
                          onManageOptions: () => showFoodOptionsDialog(
                              context,
                              item,
                              demoVariants,
                              demoModifiers,
                              demoTopUps,
                              hasDiscount),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void showFoodOptionsDialog(
    BuildContext context,
    FoodListData foodItem,
    List<Variant> variants,
    List<Modifier> modifiers,
    List<TopUp> topUps,
    bool hasDiscount,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FoodOptionsDialog(
          foodItem: foodItem,
          variants: variants,
          modifiers: modifiers,
          topUps: topUps,
          hasDiscount: hasDiscount,
        );
      },
    );
  }
}

class Variant {
  final String name;
  final dynamic price;

  Variant({required this.name, required this.price});
}

class Modifier {
  final String name;
  final bool isOptional;

  Modifier({required this.name, required this.isOptional});
}

class TopUp {
  final String name;
  final double price;

  TopUp({required this.name, required this.price});
}

// Food Item Card Widget
class FoodItemCard extends StatelessWidget {
  final FoodListData item;
  final List<Variant> variants;
  final List<Modifier> modifiers;
  final List<TopUp> topUps;
  final bool hasDiscount;
  final double? discountPrice;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onManageOptions;

  const FoodItemCard({
    required this.item,
    required this.variants,
    required this.modifiers,
    required this.topUps,
    required this.hasDiscount,
    this.discountPrice,
    required this.onEdit,
    required this.onDelete,
    required this.onManageOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.image?.first ??
                          'https://cdn-icons-png.flaticon.com/512/4067/4067447.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.fastfood, size: 40),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name ?? 'Unnamed Item',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: item.isAvailable == "true"
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                item.isAvailable == "true"
                                    ? 'Available'
                                    : 'Out of Stock',
                                style: TextStyle(
                                  color: item.isAvailable == "true"
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${item.basePrice?.toStringAsFixed(2)} Kr',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: hasDiscount
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: hasDiscount ? Colors.grey : null,
                            ),
                          ),
                          if (hasDiscount && discountPrice != null) ...[
                            SizedBox(width: 8),
                            Text(
                              '${discountPrice?.toStringAsFixed(2)} Kr',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${((item.basePrice! - discountPrice!) / item.basePrice! * 100).toStringAsFixed(0)}% OFF',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Stock: ${item.availableQty ?? 0} ${item.unit ?? ''}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
              Row(
                children: [
                  if (variants.isNotEmpty || modifiers.isNotEmpty || topUps.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (variants.isNotEmpty)
                        _buildFeatureTag(
                            Icons.linear_scale, '${variants.length} Variants'),
                      if (modifiers.isNotEmpty)
                        _buildFeatureTag(
                            Icons.tune, '${modifiers.length} Modifiers'),
                      if (topUps.isNotEmpty)
                        _buildFeatureTag(
                            Icons.add_circle_outline, '${topUps.length} Top-ups'),
                      if (hasDiscount) _buildFeatureTag(Icons.discount, 'Discount'),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: onManageOptions,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: CommonColors.primaryColor),
                          boxShadow: [
                            BoxShadow(
                                color: CommonColors.primaryColor.withOpacity(0.4),
                                spreadRadius: 0.5,
                                blurRadius: 2,
                                offset: const Offset(2, 1)
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.settings,
                              size: 18,
                              color: CommonColors.primaryColor,
                            ),
                            Text(
                              " Options",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: CommonColors.primaryColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: Colors.green),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.green.withOpacity(0.4),
                                spreadRadius: 0.5,
                                blurRadius: 2,
                                offset: const Offset(2, 1)
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.green,
                            ),
                            Text(
                              " Edit",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: Colors.red),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.red.withOpacity(0.4),
                                spreadRadius: 0.5,
                                blurRadius: 2,
                                offset: const Offset(2, 1)
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              size: 18,
                              color: Colors.red,
                            ),
                            Text(
                              " Delete",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTag(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: CommonColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CommonColors.primaryColor.withOpacity(0.3))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: CommonColors.primaryColor),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: CommonColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Food Options Dialog
class FoodOptionsDialog extends StatefulWidget {
  final FoodListData foodItem;
  final List<Variant> variants;
  final List<Modifier> modifiers;
  final List<TopUp> topUps;
  final bool hasDiscount;

  const FoodOptionsDialog({
    required this.foodItem,
    required this.variants,
    required this.modifiers,
    required this.topUps,
    required this.hasDiscount,
  });

  @override
  _FoodOptionsDialogState createState() => _FoodOptionsDialogState();
}

class _FoodOptionsDialogState extends State<FoodOptionsDialog> {
  late bool hasDiscount;
  late double discountPrice;
  late TextEditingController discountController;

  @override
  void initState() {
    super.initState();
    hasDiscount = widget.hasDiscount;
    discountPrice = widget.foodItem.basePrice! * 0.9; // Default 10% off
    discountController =
        TextEditingController(text: discountPrice.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Manage ${widget.foodItem.name}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Configure all options for this food item',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: [
                      Tab(text: 'Discount'),
                      Tab(text: 'Variants'),
                      Tab(text: 'Modifiers'),
                      Tab(text: 'Top-ups'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildDiscountTab(),
                        _buildVariantsTab(),
                        _buildModifiersTab(),
                        _buildTopUpsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: Colors.red),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.red.withOpacity(0.4),
                              spreadRadius: 0.5,
                              blurRadius: 2,
                              offset: const Offset(2, 1)
                          )
                        ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.red,
                          ),
                          Text(
                            " Cancel",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: Colors.green),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.green.withOpacity(0.4),
                              spreadRadius: 0.5,
                              blurRadius: 2,
                              offset: const Offset(2, 1)
                          )
                        ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.save,
                            size: 18,
                            color: Colors.green,
                          ),
                          Text(
                            " Save",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          SwitchListTile(
            title: Text('Enable Discount'),
            value: hasDiscount,
            onChanged: (value) {
              setState(() {
                hasDiscount = value;
              });
            },
          ),
          if (hasDiscount) ...[
            SizedBox(height: 16),
            TextFormField(
              controller: discountController,
              decoration: InputDecoration(
                labelText: 'Discount Price',
                suffixText: 'Kr',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  discountPrice = double.tryParse(value) ?? discountPrice;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Discount Description (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Original Price: ${widget.foodItem.basePrice?.toStringAsFixed(2)} Kr',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Discount: ${((widget.foodItem.basePrice! - discountPrice) / widget.foodItem.basePrice! * 100).toStringAsFixed(0)}% OFF',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVariantsTab() {
    return Column(
      children: [
        ListTile(
          title: Text('Variants Options'),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Add new variant
              _showAddVariantDialog();
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.variants.length,
            itemBuilder: (context, index) {
              final variant = widget.variants[index];
              return ListTile(
                title: Text(variant.name),
                subtitle: Text('+${variant.price.toStringAsFixed(2)} Kr'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, size: 20),
                      onPressed: () => _showEditVariantDialog(variant, index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          widget.variants.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModifiersTab() {
    return Column(
      children: [
        ListTile(
          title: Text('Modifiers Options'),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Add new modifier
              _showAddModifierDialog();
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.modifiers.length,
            itemBuilder: (context, index) {
              final modifier = widget.modifiers[index];
              return ListTile(
                title: Text(modifier.name),
                subtitle: Text(modifier.isOptional ? 'Optional' : 'Required'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, size: 20),
                      onPressed: () => _showEditModifierDialog(modifier, index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          widget.modifiers.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopUpsTab() {
    return Column(
      children: [
        ListTile(
          title: Text('Top-up Options'),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Add new top-up
              _showAddTopUpDialog();
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.topUps.length,
            itemBuilder: (context, index) {
              final topUp = widget.topUps[index];
              return ListTile(
                title: Text(topUp.name),
                subtitle: Text('+${topUp.price.toStringAsFixed(2)} Kr'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, size: 20),
                      onPressed: () => _showEditTopUpDialog(topUp, index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          widget.topUps.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddVariantDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Variant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Variant Name'),
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price (Kr)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final price = double.tryParse(priceController.text) ?? 0;
                if (nameController.text.isNotEmpty && price > 0) {
                  setState(() {
                    widget.variants.add(
                      Variant(
                        name: nameController.text,
                        price: price,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditVariantDialog(Variant variant, int index) {
    TextEditingController nameController =
        TextEditingController(text: variant.name);
    TextEditingController priceController =
        TextEditingController(text: variant.price.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Variant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Variant Name'),
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price (Kr)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final price = double.tryParse(priceController.text) ?? 0;
                if (nameController.text.isNotEmpty && price > 0) {
                  setState(() {
                    widget.variants[index] = Variant(
                      name: nameController.text,
                      price: price,
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAddModifierDialog() {
    TextEditingController nameController = TextEditingController();
    bool isOptional = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Modifier'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Modifier Name'),
                  ),
                  SizedBox(height: 16),
                  SwitchListTile(
                    title: Text('Optional'),
                    value: isOptional,
                    onChanged: (value) {
                      setState(() {
                        isOptional = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      setState(() {
                        widget.modifiers.add(
                          Modifier(
                            name: nameController.text,
                            isOptional: isOptional,
                          ),
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditModifierDialog(Modifier modifier, int index) {
    TextEditingController nameController =
        TextEditingController(text: modifier.name);
    bool isOptional = modifier.isOptional;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Modifier'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Modifier Name'),
                  ),
                  SizedBox(height: 16),
                  SwitchListTile(
                    title: Text('Optional'),
                    value: isOptional,
                    onChanged: (value) {
                      setState(() {
                        isOptional = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      setState(() {
                        widget.modifiers[index] = Modifier(
                          name: nameController.text,
                          isOptional: isOptional,
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddTopUpDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Top-up'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Top-up Name'),
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price (Kr)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final price = double.tryParse(priceController.text) ?? 0;
                if (nameController.text.isNotEmpty && price > 0) {
                  setState(() {
                    widget.topUps.add(
                      TopUp(
                        name: nameController.text,
                        price: price,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTopUpDialog(TopUp topUp, int index) {
    TextEditingController nameController =
        TextEditingController(text: topUp.name);
    TextEditingController priceController =
        TextEditingController(text: topUp.price.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Top-up'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Top-up Name'),
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price (Kr)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final price = double.tryParse(priceController.text) ?? 0;
                if (nameController.text.isNotEmpty && price > 0) {
                  setState(() {
                    widget.topUps[index] = TopUp(
                      name: nameController.text,
                      price: price,
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
