import 'package:flutter/material.dart';
import 'package:indisk_app/utils/common_colors.dart';

class KitchenDashboardView extends StatefulWidget {
  const KitchenDashboardView({super.key});

  @override
  State<KitchenDashboardView> createState() => _KitchenDashboardViewState();
}

class _KitchenDashboardViewState extends State<KitchenDashboardView> {
  // Static food list data with added categories
  final List<Map<String, dynamic>> _foodList = [
    {
      'id': '1',
      'name': 'Burger',
      'price': '1',
      'description': 'Juicy beef burger with cheese and special sauce',
      'image': 'https://cdn.pixabay.com/photo/2016/03/05/19/02/hamburger-1238246_1280.jpg',
      'ingredients': 'Beef patty, Cheese, Lettuce, Tomato, Special sauce',
      'prepTime': '15 mins',
      'category': 'Burgers',
    },
    {
      'id': '2',
      'name': 'Pizza',
      'price': '5',
      'description': 'Margherita pizza with fresh basil and mozzarella',
      'image': 'https://cdn.pixabay.com/photo/2017/12/09/08/18/pizza-3007395_1280.jpg',
      'ingredients': 'Dough, Tomato sauce, Mozzarella, Basil, Olive oil',
      'prepTime': '20 mins',
      'category': 'Pizzas',
    },
    {
      'id': '3',
      'name': 'Pasta',
      'price': '6',
      'description': 'Creamy Alfredo pasta with mushrooms',
      'image': 'https://cdn.pixabay.com/photo/2017/11/08/22/18/spaghetti-2931846_1280.jpg',
      'ingredients': 'Pasta, Cream, Parmesan, Mushrooms, Garlic',
      'prepTime': '25 mins',
      'category': 'Pastas',
    },
    {
      'id': '4',
      'name': 'Salad',
      'price': '5',
      'description': 'Fresh garden salad with vinaigrette',
      'image': 'https://cdn.pixabay.com/photo/2017/09/16/19/21/salad-2756467_1280.jpg',
      'ingredients': 'Lettuce, Cucumber, Tomato, Olives, Feta cheese',
      'prepTime': '10 mins',
      'category': 'Salads',
    },
    {
      'id': '5',
      'name': 'Sandwich',
      'price': '9',
      'description': 'Club sandwich with fries',
      'image': 'https://cdn.pixabay.com/photo/2016/03/05/20/02/sandwich-1238615_1280.jpg',
      'ingredients': 'Bread, Chicken, Bacon, Lettuce, Mayo',
      'prepTime': '12 mins',
      'category': 'Sandwiches',
    },
    {
      'id': '6',
      'name': 'Sushi',
      'price': '3',
      'description': 'Assorted sushi platter with wasabi and soy sauce',
      'image': 'https://cdn.pixabay.com/photo/2014/05/23/23/17/sushi-352420_1280.jpg',
      'ingredients': 'Rice, Salmon, Tuna, Avocado, Nori',
      'prepTime': '30 mins',
      'category': 'Japanese',
    },
    {
      'id': '7',
      'name': 'Chicken Wings',
      'price': '8',
      'description': 'Crispy fried chicken wings with spicy buffalo sauce',
      'image': 'https://cdn.pixabay.com/photo/2017/09/30/15/10/plate-2802332_1280.jpg',
      'ingredients': 'Chicken wings, Flour, Spices, Buffalo sauce, Butter',
      'prepTime': '20 mins',
      'category': 'Appetizers',
    },
    {
      'id': '8',
      'name': 'Tacos',
      'price': '7',
      'description': 'Authentic Mexican tacos with seasoned ground beef',
      'image': 'https://cdn.pixabay.com/photo/2017/12/10/14/47/taco-3011568_1280.jpg',
      'ingredients': 'Tortillas, Ground beef, Lettuce, Cheese, Salsa',
      'prepTime': '15 mins',
      'category': 'Mexican',
    },
    {
      'id': '9',
      'name': 'Steak',
      'price': '18',
      'description': 'Juicy ribeye steak cooked to perfection',
      'image': 'https://cdn.pixabay.com/photo/2018/09/14/11/12/food-3676796_1280.jpg',
      'ingredients': 'Ribeye steak, Salt, Pepper, Butter, Garlic',
      'prepTime': '25 mins',
      'category': 'Mains',
    },
    {
      'id': '10',
      'name': 'Ramen',
      'price': '12',
      'description': 'Japanese ramen with rich pork broth and noodles',
      'image': 'https://cdn.pixabay.com/photo/2017/06/30/20/33/ramen-2459941_1280.jpg',
      'ingredients': 'Noodles, Pork broth, Chashu pork, Egg, Green onions',
      'prepTime': '30 mins',
      'category': 'Japanese',
    },
    {
      'id': '11',
      'name': 'Fried Rice',
      'price': '9',
      'description': 'Classic Asian-style fried rice with vegetables',
      'image': 'https://cdn.pixabay.com/photo/2017/06/30/04/58/fried-rice-2457321_1280.jpg',
      'ingredients': 'Rice, Eggs, Vegetables, Soy sauce, Chicken',
      'prepTime': '15 mins',
      'category': 'Asian',
    },
    {
      'id': '12',
      'name': 'Cheesecake',
      'price': '6',
      'description': 'Creamy New York style cheesecake with berry topping',
      'image': 'https://cdn.pixabay.com/photo/2017/01/11/11/33/cake-1971552_1280.jpg',
      'ingredients': 'Cream cheese, Sugar, Eggs, Graham crackers, Berries',
      'prepTime': '40 mins',
      'category': 'Desserts',
    },
    {
      'id': '13',
      'name': 'Chocolate Cake',
      'price': '7',
      'description': 'Rich chocolate cake with fudge frosting',
      'image': 'https://cdn.pixabay.com/photo/2016/11/22/18/52/cake-1850011_1280.jpg',
      'ingredients': 'Flour, Cocoa, Sugar, Eggs, Butter, Chocolate',
      'prepTime': '45 mins',
      'category': 'Desserts',
    },
    {
      'id': '14',
      'name': 'Ice Cream',
      'price': '4',
      'description': 'Creamy vanilla ice cream with chocolate sauce',
      'image': 'https://cdn.pixabay.com/photo/2018/03/18/17/05/ice-cream-3237928_1280.jpg',
      'ingredients': 'Milk, Cream, Sugar, Vanilla, Chocolate sauce',
      'prepTime': '10 mins',
      'category': 'Desserts',
    },
  ];

  // Define categories
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
  Map<String, dynamic>? _selectedProduct;

  // Get filtered food list based on selected category
  List<Map<String, dynamic>> get _filteredFoodList {
    if (_selectedCategory == 'All') {
      return _foodList;
    }
    return _foodList.where((item) => item['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Product Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Today's Order",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Category tabs
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

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: _filteredFoodList.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            image: _filteredFoodList[index]['image'],
                            name: _filteredFoodList[index]['name'],
                            price: _filteredFoodList[index]['price'],
                            description: _filteredFoodList[index]['description'],
                            onTap: () {
                              setState(() {
                                _selectedProduct = _filteredFoodList[index];
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right side - Product Details
          Container(
            color: Colors.grey[100],
            width: MediaQuery.of(context).size.width / 3.5,
            child: _selectedProduct == null
                ? const Center(
              child: Text(
                "Select a product to view details",
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            )
                : Column(
              children: [
                const SizedBox(height: 20),
                const SizedBox(height: 20),

                // Product details header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _selectedProduct = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Product image
                Container(
                  height: 200,
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _selectedProduct!['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                    ),
                  ),
                ),

                // Product details
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedProduct!['name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Qty ${_selectedProduct!['price']}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Description:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _selectedProduct!['description'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Ingredients:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _selectedProduct!['ingredients'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Preparation Time:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _selectedProduct!['prepTime'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            // Cancel action
                            setState(() {
                              _selectedProduct = null;
                            });
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            // Ready action
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${_selectedProduct!['name']} marked as ready'),
                              ),
                            );
                            setState(() {
                              _selectedProduct = null;
                            });
                          },
                          child: const Text(
                            'Ready',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
  final GestureTapCallback onTap;

  const ProductCard({
    Key? key,
    required this.image,
    required this.name,
    required this.price,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
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
                  const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),

              // Product name
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Product description
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),

              // Product price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Qty ${price}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}