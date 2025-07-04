import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/screens/owner/restaurant/restaurant_details/restaurant_details_view.dart';
import 'package:indisk_app/utils/common_styles.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:provider/provider.dart';
import '../../../../api_service/models/restaurant_master.dart';
import 'add_restaurant/add_restaurant_view.dart';
import 'edit_restaurant/edit_restaurant_view.dart';
import 'restaurant_list_view_model.dart';

class RestaurantListView extends StatefulWidget {
  const RestaurantListView({super.key});

  @override
  State<RestaurantListView> createState() => _RestaurantListViewState();
}

class _RestaurantListViewState extends State<RestaurantListView> {
  late RestaurantListViewModel mViewModel;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final viewModel =
        Provider.of<RestaurantListViewModel>(context, listen: false);
    await viewModel.getRestaurantList();
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<RestaurantListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant List',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: CircleAvatar(child: const Icon(Icons.add)),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddRestaurantView()),
              );
              if (result == true) {
                await _loadData();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: mViewModel.restaurantList.isEmpty
            ? _buildEmptyState()
            : _buildRestaurantGrid(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 100, color: Colors.grey[400]),
            const SizedBox(height: 20),
            const Text(
              'No restaurants added yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              'Tap the + button to add your first restaurant.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final int crossAxisCount = 4;
        // final crossAxisCount = screenWidth > 1200
        //     ? 4
        //     : screenWidth > 800
        //         ? 3
        //         : 2;
        final spacing = 16.0;
        final totalSpacing = spacing * (crossAxisCount - 1);
        final itemWidth = (screenWidth - totalSpacing) / crossAxisCount;
        final itemHeight = 306.0;
        final aspectRatio = itemWidth / itemHeight;
        return GridView.builder(
          itemCount: mViewModel.restaurantList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) {
            return _buildRestaurantCard(mViewModel.restaurantList[index]);
          },
        );
      },
    );
  }

  Widget _buildRestaurantCard(RestaurantData restaurant) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                restaurant.image ?? '',
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 110,
                    width: double.infinity,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: Icon(Icons.broken_image,
                        color: Colors.grey[600], size: 40),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 110,
                    width: double.infinity,
                    color: Colors.grey[100],
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                      strokeWidth: 2,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              restaurant.name ?? '--',
              style: getBoldTextStyle(fontSize: 16.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              restaurant.phone ?? '--',
              style: getNormalTextStyle(
                  fontSize: 14.0, fontColor: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              restaurant.cuisineType ?? '--',
              style: getNormalTextStyle(
                  fontSize: 12.0, fontColor: Colors.grey[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _actionButton(
                  icon: Icons.edit,
                  label: 'Edit',
                  color: Colors.green,
                  bgColor: Colors.green.shade100,
                  onTap: () {
                    pushToScreen(EditRestaurantView(
                      name: restaurant.name ?? '--',
                      email: restaurant.email ?? '--',
                      contact: restaurant.phone ?? '--',
                      address: restaurant.address ?? '--',
                      description: restaurant.description ?? '--',
                      location: restaurant.location ?? '--',
                      cuisine: restaurant.cuisineType ?? '--',
                      status: restaurant.status ?? '--',
                      image: restaurant.image ?? '--',
                    )).then((_) => mViewModel.getRestaurantList());
                  },
                ),
                const SizedBox(width: 8),
                _actionButton(
                  icon: Icons.delete_forever,
                  label: 'Delete',
                  color: Colors.red,
                  bgColor: Colors.red.shade100,
                  onTap: () {
                    showDeleteRestaurantDialog(
                        context, restaurant.name ?? 'Restaurant', () {
                      mViewModel.deleteRestaurant(id: restaurant.sId);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            _actionButton(
              icon: Icons.info_outline,
              label: 'Details',
              color: Colors.deepPurple,
              bgColor: Colors.deepPurple.shade100,
              onTap: () {
                pushToScreen(RestaurantDetailsView(
                  restaurantId: restaurant.sId ?? '--',
                  restaurantName: restaurant.name ?? '--',
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: bgColor,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 18),
                Text(" $label",
                    style: TextStyle(
                        color: color,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDeleteRestaurantDialog(
    BuildContext context,
    String restaurantName,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: const Text("Delete Restaurant",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
              "Are you sure you want to delete $restaurantName? This action cannot be undone."),
          actions: [
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }
}
