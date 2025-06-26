import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../api_service/models/staff_cart_master.dart';
import '../../../../utils/app_dimens.dart';
import '../../../../utils/common_colors.dart';
import '../../../common_widget/common_textfield.dart';
import '../../../common_widget/primary_button.dart';
import '../staff_home/select_product/staff_select_product_view_model.dart';

class StaffManageFoodView extends StatefulWidget {
  const StaffManageFoodView({super.key});

  @override
  State<StaffManageFoodView> createState() => _StaffManageFoodViewState();
}

class _StaffManageFoodViewState extends State<StaffManageFoodView> {
  StaffSelectProductViewModel? mViewModel;
  String? _selectedCategoryId;
  String _selectedCategoryName = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mViewModel = Provider.of<StaffSelectProductViewModel>(context, listen: false);
      mViewModel?.getFoodCategoryList().then((_) {
        mViewModel?.getStaffFoodList(isManageable: true).catchError((e) {
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
      appBar: AppBar(
        title: const Text('Manage Food'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        kSizedBoxH10,
                        Expanded(
                          child: CommonTextField(
                            keyboardType: TextInputType.emailAddress,
                            labelText: "Search Anything Here",
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                        kSizedBoxH10,
                      ],
                    ),
                    kSizedBoxV10,
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
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 16.0,
                                    mainAxisSpacing: 16.0,
                                    childAspectRatio: 0.9,
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

                                    final isAvailable =
                                            foodItem.isAvailable  ??
                                        true;

                                    return ProductCard(
                                      productId: foodItem.id ?? '--',
                                      image: foodItem.image?.first ?? '--',
                                      name: foodItem.name ?? '--',
                                      price: foodItem.price.toString() ?? '--',
                                      description: foodItem.description ?? '--',
                                      isAvailable: isAvailable,
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
        ],
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final String productId;
  final String image;
  final String name;
  final String price;
  final String description;
  final bool isAvailable;

  const ProductCard({
    Key? key,
    required this.productId,
    required this.image,
    required this.name,
    required this.price,
    required this.description,
    required this.isAvailable,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool _isAvailable;

  StaffSelectProductViewModel? mViewModel;


  @override
  void initState() {
    super.initState();
    _isAvailable = widget.isAvailable;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      mViewModel = Provider.of<StaffSelectProductViewModel>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = mViewModel ?? Provider.of<StaffSelectProductViewModel>(context);

    return Card(
      elevation: 4,
      color: !_isAvailable ? Colors.grey.shade300 : null,
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
                widget.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.fastfood, size: 50, color: Colors.grey[400]),
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              widget.description,
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
                  '\$${widget.price}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: _isAvailable,
                  onChanged: (value) {
                    setState(() {
                      _isAvailable = value;
                    });
                    viewModel.updateFoodAvailability(productId: widget.productId, status: _isAvailable);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
