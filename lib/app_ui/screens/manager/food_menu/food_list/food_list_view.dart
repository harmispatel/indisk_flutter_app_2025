import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/common_widget/primary_button.dart';
import 'package:indisk_app/app_ui/screens/manager/food_menu/create_food/create_food_view.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:provider/provider.dart';

import '../../../../../api_service/models/food_list_master.dart';
import '../../../../../utils/common_utills.dart';
import '../edit_food/edit_food_view.dart';
import 'food_list_view_model.dart';

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
            icon: CircleAvatar(child: Icon(Icons.add, size: 28)),
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
                        final item = mViewModel.foodList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: FoodItemCard(
                            item: item,
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
                            onManageOptions: () =>
                                showFoodOptionsDialog(context, item),
                          ),
                        );
                      }),
                ),
    );
  }

  void showFoodOptionsDialog(BuildContext context, FoodListData foodItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return FoodOptionsDialog(
          foodItem: foodItem,
          onSave: (updatedFoodItem) {
            // Prepare discount list
            final discountList = updatedFoodItem.discount
                    ?.map((d) => {
                          'isEnable': d.isEnable,
                          'percentage': d.percentage,
                          'description': d.description,
                          '_id': (d.sId != null && d.sId!.length == 24)
                              ? d.sId
                              : null,
                        })
                    .where((item) =>
                        item['_id'] != null ||
                        (item['isEnable'] != null &&
                            item['percentage'] != null))
                    .toList() ??
                [];

            // Prepare variant list
            final varientList = updatedFoodItem.varient
                    ?.map((v) => {
                          'varientName': v.varientName,
                          'price': v.price,
                          '_id': (v.sId != null && v.sId!.length == 24)
                              ? v.sId
                              : null,
                        })
                    .where((item) => item['price'] != null)
                    .toList() ??
                [];

            // Prepare modifier list
            final modifierList = updatedFoodItem.modifier
                    ?.map((m) => {
                          'modifierName': m.modifierName,
                          'price': m.price,
                          '_id': (m.sId != null && m.sId!.length == 24)
                              ? m.sId
                              : null,
                        })
                    .where((item) =>
                        item['modifierName'] != null && item['price'] != null)
                    .toList() ??
                [];

            // Prepare topup list
            final topupList = updatedFoodItem.topup
                    ?.map((t) => {
                          'topupName': t.topupName,
                          'price': t.price,
                          '_id': (t.sId != null && t.sId!.length == 24)
                              ? t.sId
                              : null,
                        })
                    .where((item) =>
                        item['topupName'] != null && item['price'] != null)
                    .toList() ??
                [];

            // Call the API
            mViewModel
                .addFoodModifier(
              productId: updatedFoodItem.sId!,
              discount: discountList,
              varient: varientList,
              modifier: modifierList,
              topup: topupList,
            )
                .then((_) {
              mViewModel.getFoodList(); // Refresh the list
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Modifiers updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to update modifiers: $error'),
                  backgroundColor: Colors.red,
                ),
              );
            });
          },
        );
      },
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final FoodListData item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onManageOptions;

  const FoodItemCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onManageOptions,
  });

  @override
  Widget build(BuildContext context) {
    // Get all enabled discounts
    final enabledDiscounts =
        item.discount?.where((d) => d.isEnable == true).toList() ?? [];
    final hasDiscount = enabledDiscounts.isNotEmpty;
    // Get the first enabled discount for display
    final activeDiscount = hasDiscount ? enabledDiscounts.first : null;
    // Calculate discounted price
    final discountPrice = activeDiscount != null
        ? item.basePrice! * (1 - activeDiscount.percentage! / 100)
        : null;

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
                              color: item.isAvailable == true
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                item.isAvailable == true
                                    ? 'Available'
                                    : 'Out of Stock',
                                style: TextStyle(
                                  color: item.isAvailable == true
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
                              '${discountPrice.toStringAsFixed(2)} Kr',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${activeDiscount?.percentage}% OFF',
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
            if (item.varient?.isNotEmpty == true ||
                item.modifier?.isNotEmpty == true ||
                item.topup?.isNotEmpty == true ||
                hasDiscount)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (item.varient?.isNotEmpty == true)
                    _buildFeatureTag(
                        Icons.linear_scale, '${item.varient?.length} Variants'),
                  if (item.modifier?.isNotEmpty == true)
                    _buildFeatureTag(
                        Icons.tune, '${item.modifier?.length} Modifiers'),
                  if (item.topup?.isNotEmpty == true)
                    _buildFeatureTag(Icons.add_circle_outline,
                        '${item.topup?.length} Top-ups'),
                  if (hasDiscount)
                    _buildFeatureTag(
                        Icons.discount, '${enabledDiscounts.length} Discounts'),
                ],
              ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onManageOptions,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: Colors.blue),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.4),
                            spreadRadius: 0.5,
                            blurRadius: 2,
                            offset: const Offset(2, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.settings,
                            size: 18,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Options",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: Colors.green),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.4),
                            spreadRadius: 0.5,
                            blurRadius: 2,
                            offset: const Offset(2, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.green,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Edit",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: Colors.red),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            spreadRadius: 0.5,
                            blurRadius: 2,
                            offset: const Offset(2, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            size: 18,
                            color: Colors.red,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Delete",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
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
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.3))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.blue),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

// class FoodItemCard extends StatelessWidget {
//   final FoodListData item;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//   final VoidCallback onManageOptions;
//
//   const FoodItemCard({
//     required this.item,
//     required this.onEdit,
//     required this.onDelete,
//     required this.onManageOptions,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Get all enabled discounts
//     final enabledDiscounts = item.discount?.where((d) => d.isEnable == true).toList() ?? [];
//     final hasDiscount = enabledDiscounts.isNotEmpty;
//     // Get the first enabled discount for display
//     final activeDiscount = hasDiscount ? enabledDiscounts.first : null;
//     // Calculate discounted price
//     final discountPrice = activeDiscount != null
//         ? item.basePrice! * (1 - activeDiscount.percentage! / 100)
//         : null;
//
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.network(
//                       item.image?.first ??
//                           'https://cdn-icons-png.flaticon.com/512/4067/4067447.png',
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) =>
//                           Icon(Icons.fastfood, size: 40),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               item.name ?? 'Unnamed Item',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: item.isAvailable == true
//                                   ? Colors.green.withOpacity(0.2)
//                                   : Colors.red.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 5),
//                               child: Text(
//                                 item.isAvailable == true
//                                     ? 'Available'
//                                     : 'Out of Stock',
//                                 style: TextStyle(
//                                   color: item.isAvailable == true
//                                       ? Colors.green
//                                       : Colors.red,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Text(
//                             '${item.basePrice?.toStringAsFixed(2)} Kr',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               decoration: hasDiscount
//                                   ? TextDecoration.lineThrough
//                                   : null,
//                               color: hasDiscount ? Colors.grey : null,
//                             ),
//                           ),
//                           if (hasDiscount && discountPrice != null) ...[
//                             SizedBox(width: 8),
//                             Text(
//                               '${discountPrice.toStringAsFixed(2)} Kr',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.green,
//                               ),
//                             ),
//                             SizedBox(width: 8),
//                             Text(
//                               '${activeDiscount?.percentage}% OFF',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.green,
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         'Stock: ${item.availableQty ?? 0} ${item.unit ?? ''}',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),
//             Row(
//               children: [
//                 if (item.varient?.isNotEmpty == true ||
//                     item.modifier?.isNotEmpty == true ||
//                     item.topup?.isNotEmpty == true ||
//                     hasDiscount)
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 4,
//                     children: [
//                       if (item.varient?.isNotEmpty == true)
//                         _buildFeatureTag(Icons.linear_scale,
//                             '${item.varient?.length} Variants'),
//                       if (item.modifier?.isNotEmpty == true)
//                         _buildFeatureTag(
//                             Icons.tune, '${item.modifier?.length} Modifiers'),
//                       if (item.topup?.isNotEmpty == true)
//                         _buildFeatureTag(Icons.add_circle_outline,
//                             '${item.topup?.length} Top-ups'),
//                       if (hasDiscount)
//                         _buildFeatureTag(Icons.discount, '${enabledDiscounts.length} Discounts'),
//                     ],
//                   ),
//                 Spacer(),
//                 GestureDetector(
//                   onTap: onManageOptions,
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(7),
//                         border: Border.all(color: Colors.blue),
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.blue.withOpacity(0.4),
//                               spreadRadius: 0.5,
//                               blurRadius: 2,
//                               offset: const Offset(2, 1))
//                         ]),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 2, horizontal: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.settings,
//                             size: 18,
//                             color: Colors.blue,
//                           ),
//                           Text(
//                             " Options",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 GestureDetector(
//                   onTap: onEdit,
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(7),
//                         border: Border.all(color: Colors.green),
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.green.withOpacity(0.4),
//                               spreadRadius: 0.5,
//                               blurRadius: 2,
//                               offset: const Offset(2, 1))
//                         ]),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 2, horizontal: 35),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.edit,
//                             size: 18,
//                             color: Colors.green,
//                           ),
//                           Text(
//                             " Edit",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 GestureDetector(
//                   onTap: onDelete,
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(7),
//                         border: Border.all(color: Colors.red),
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.red.withOpacity(0.4),
//                               spreadRadius: 0.5,
//                               blurRadius: 2,
//                               offset: const Offset(2, 1))
//                         ]),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 2, horizontal: 30),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.delete,
//                             size: 18,
//                             color: Colors.red,
//                           ),
//                           Text(
//                             " Delete",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.red,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFeatureTag(IconData icon, String label) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//           color: Colors.blue.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.blue.withOpacity(0.3))),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: Colors.blue),
//           SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.blue,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Food Options Dialog
class FoodOptionsDialog extends StatefulWidget {
  final FoodListData foodItem;
  final Function(FoodListData) onSave;

  const FoodOptionsDialog({
    super.key,
    required this.foodItem,
    required this.onSave,
  });

  @override
  _FoodOptionsDialogState createState() => _FoodOptionsDialogState();
}

class _FoodOptionsDialogState extends State<FoodOptionsDialog> {
  late FoodListData editedFoodItem;

  @override
  void initState() {
    super.initState();
    // Create a copy of the food item for editing
    editedFoodItem = FoodListData.fromJson(widget.foodItem.toJson());

    // Initialize empty lists if null
    editedFoodItem.discount ??= [];
    editedFoodItem.varient ??= [];
    editedFoodItem.modifier ??= [];
    editedFoodItem.topup ??= [];
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
                  onTap: () {
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
                              offset: const Offset(2, 1))
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.close,
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
                  onTap: () {
                    widget.onSave(editedFoodItem);
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
                              offset: const Offset(2, 1))
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save, size: 18, color: Colors.green),
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
          // Button to add new discount
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: Icon(Icons.add, size: 18),
              label: Text('Add Discount'),
              onPressed: _showAddDiscountDialog,
            ),
          ),

          // List of discounts
          if (editedFoodItem.discount?.isEmpty ?? true)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text('No discounts added yet',
                    style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ...editedFoodItem.discount!.map((discount) {
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${discount.percentage}% OFF',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: discount.isEnable == true
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          Switch(
                            value: discount.isEnable ?? false,
                            onChanged: (value) {
                              setState(() {
                                discount.isEnable = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (discount.description?.isNotEmpty == true)
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(discount.description!),
                            ),
                          Spacer(),
                          TextButton(
                            child: Text('Edit'),
                            onPressed: () => _showEditDiscountDialog(discount),
                          ),
                          SizedBox(width: 8),
                          TextButton(
                            child: Text('Delete',
                                style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              setState(() {
                                editedFoodItem.discount?.remove(discount);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildVariantsTab() {
    return Column(
      children: [
        // Button to add new variant
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: Icon(Icons.add, size: 18),
            label: Text('Add Variant'),
            onPressed: _showAddVariantDialog,
          ),
        ),

        // List of variants
        if (editedFoodItem.varient?.isEmpty ?? true)
          Expanded(
              child: Center(
            child: Text('No variants added yet',
                style: TextStyle(color: Colors.grey)),
          ))
        else
          Expanded(
            child: ListView.builder(
              itemCount: editedFoodItem.varient?.length ?? 0,
              itemBuilder: (context, index) {
                final variant = editedFoodItem.varient![index];
                return ListTile(
                  title: Text(variant.varientName ??
                      'Unnamed Variant'), // Show the custom name
                  subtitle: Text('Price: ${variant.price} Kr'),
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
                            editedFoodItem.varient?.removeAt(index);
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
        // Button to add new modifier
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: Icon(Icons.add, size: 18),
            label: Text('Add Modifier'),
            onPressed: _showAddModifierDialog,
          ),
        ),

        // List of modifiers
        if (editedFoodItem.modifier?.isEmpty ?? true)
          Expanded(
              child: Center(
            child: Text('No modifiers added yet',
                style: TextStyle(color: Colors.grey)),
          ))
        else
          Expanded(
            child: ListView.builder(
              itemCount: editedFoodItem.modifier?.length ?? 0,
              itemBuilder: (context, index) {
                final modifier = editedFoodItem.modifier![index];
                return ListTile(
                  title: Text(modifier.modifierName ?? 'Unnamed Modifier'),
                  subtitle: Text('Price: ${modifier.price} Kr'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, size: 20),
                        onPressed: () =>
                            _showEditModifierDialog(modifier, index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            editedFoodItem.modifier?.removeAt(index);
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
        // Button to add new top-up
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: Icon(Icons.add, size: 18),
            label: Text('Add Top-up'),
            onPressed: _showAddTopUpDialog,
          ),
        ),

        // List of top-ups
        if (editedFoodItem.topup?.isEmpty ?? true)
          Expanded(
              child: Center(
            child: Text('No top-ups added yet',
                style: TextStyle(color: Colors.grey)),
          ))
        else
          Expanded(
            child: ListView.builder(
              itemCount: editedFoodItem.topup?.length ?? 0,
              itemBuilder: (context, index) {
                final topup = editedFoodItem.topup![index];
                return ListTile(
                  title: Text(topup.topupName ?? 'Unnamed Top-up'),
                  subtitle: Text('Price: ${topup.price} Kr'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, size: 20),
                        onPressed: () => _showEditTopUpDialog(topup, index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            editedFoodItem.topup?.removeAt(index);
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
                decoration: InputDecoration(
                  labelText: 'Variant Name',
                ),
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price (Kr)',
                ),
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
                final price = int.tryParse(priceController.text);
                if (nameController.text.isNotEmpty &&
                    price != null &&
                    price > 0) {
                  setState(() {
                    editedFoodItem.varient?.add(Varient(
                      varientName: nameController.text,
                      price: price,
                      sId: DateTime.now().millisecondsSinceEpoch.toString(),
                    ));
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

  void _showAddDiscountDialog() {
    TextEditingController percentageController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    bool isEnable = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Discount'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: percentageController,
                    decoration: InputDecoration(
                      labelText: 'Discount Percentage',
                      suffixText: '%',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description (Optional)',
                    ),
                  ),
                  SwitchListTile(
                    title: Text('Enable Discount'),
                    value: isEnable,
                    onChanged: (value) {
                      setState(() {
                        isEnable = value;
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
                    final percentage = int.tryParse(percentageController.text);
                    if (percentage != null &&
                        percentage > 0 &&
                        percentage <= 100) {
                      setState(() {
                        editedFoodItem.discount?.add(Discount(
                          isEnable: isEnable,
                          percentage: percentage,
                          description: descriptionController.text.isNotEmpty
                              ? descriptionController.text
                              : null,
                          sId: DateTime.now().millisecondsSinceEpoch.toString(),
                        ));
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

  void _showEditDiscountDialog(Discount discount) {
    TextEditingController percentageController =
        TextEditingController(text: discount.percentage?.toString());
    TextEditingController descriptionController =
        TextEditingController(text: discount.description);
    bool isEnable = discount.isEnable ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Discount'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: percentageController,
                    decoration: InputDecoration(
                      labelText: 'Discount Percentage',
                      suffixText: '%',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description (Optional)',
                    ),
                  ),
                  SwitchListTile(
                    title: Text('Enable Discount'),
                    value: isEnable,
                    onChanged: (value) {
                      setState(() {
                        isEnable = value;
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
                    final percentage = int.tryParse(percentageController.text);
                    if (percentage != null &&
                        percentage > 0 &&
                        percentage <= 100) {
                      setState(() {
                        discount.isEnable = isEnable;
                        discount.percentage = percentage;
                        discount.description =
                            descriptionController.text.isNotEmpty
                                ? descriptionController.text
                                : null;
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

  void _showEditVariantDialog(Varient variant, int index) {
    TextEditingController nameController =
        TextEditingController(text: variant.varientName);
    TextEditingController priceController =
        TextEditingController(text: variant.price?.toString());

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
                decoration: InputDecoration(
                  labelText: 'Variant Name',
                ),
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price (Kr)',
                ),
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
                final price = int.tryParse(priceController.text);
                if (nameController.text.isNotEmpty &&
                    price != null &&
                    price > 0) {
                  setState(() {
                    editedFoodItem.varient?[index].varientName =
                        nameController.text;
                    editedFoodItem.varient?[index].price = price;
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
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Modifier'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Modifier Name',
                ),
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price (Kr)',
                ),
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
                final price = int.tryParse(priceController.text);
                if (nameController.text.isNotEmpty && price != null) {
                  setState(() {
                    editedFoodItem.modifier?.add(Modifier(
                      modifierName: nameController.text,
                      price: price,
                      sId: DateTime.now().millisecondsSinceEpoch.toString(),
                    ));
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

  void _showEditModifierDialog(Modifier modifier, int index) {
    TextEditingController nameController =
        TextEditingController(text: modifier.modifierName);
    TextEditingController priceController =
        TextEditingController(text: modifier.price?.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Modifier'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Modifier Name',
                ),
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price (Kr)',
                ),
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
                final price = int.tryParse(priceController.text);
                if (nameController.text.isNotEmpty && price != null) {
                  setState(() {
                    editedFoodItem.modifier?[index].modifierName =
                        nameController.text;
                    editedFoodItem.modifier?[index].price = price;
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
                decoration: InputDecoration(
                  labelText: 'Top-up Name',
                ),
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price (Kr)',
                ),
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
                final price = int.tryParse(priceController.text);
                if (nameController.text.isNotEmpty && price != null) {
                  setState(() {
                    editedFoodItem.topup?.add(Topup(
                      topupName: nameController.text,
                      price: price,
                      sId: DateTime.now().millisecondsSinceEpoch.toString(),
                    ));
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

  void _showEditTopUpDialog(Topup topup, int index) {
    TextEditingController nameController =
        TextEditingController(text: topup.topupName);
    TextEditingController priceController =
        TextEditingController(text: topup.price?.toString());

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
                decoration: InputDecoration(
                  labelText: 'Top-up Name',
                ),
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price (Kr)',
                ),
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
                final price = int.tryParse(priceController.text);
                if (nameController.text.isNotEmpty && price != null) {
                  setState(() {
                    editedFoodItem.topup?[index].topupName =
                        nameController.text;
                    editedFoodItem.topup?[index].price = price;
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
