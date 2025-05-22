import 'package:flutter/material.dart';

class ManagerOrderListView extends StatefulWidget {
  const ManagerOrderListView({super.key});

  @override
  State<ManagerOrderListView> createState() => _ManagerOrderListViewState();
}

class _ManagerOrderListViewState extends State<ManagerOrderListView> {
  final List<Map<String, dynamic>> orders = [
    {
      "orderId": "ORD12345",
      "date": "Apr 24, 2025",
      "total": 430,
      "items": [
        {
          "name": "Paneer Tikka",
          "price": 250,
          "offPrice": 200,
          "image": "https://via.placeholder.com/80"
        },
        {
          "name": "Garlic Naan",
          "price": 80,
          "offPrice": 70,
          "image": "https://via.placeholder.com/80"
        }
      ]
    },
    {
      "orderId": "ORD12346",
      "date": "Apr 23, 2025",
      "total": 299,
      "items": [
        {
          "name": "Chicken Biryani",
          "price": 320,
          "offPrice": 299,
          "image": "https://via.placeholder.com/80"
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// Order Info Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Order ID",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(order['orderId'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Total",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          Text("₹${order['total']}",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700])),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(order['date'],
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                  const Divider(height: 24),

                  /// Food Items
                  ...order['items'].map<Widget>((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item['image'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, object, stacktrace) {
                                return Image.network(
                                  "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg",
                                  height: 50.0,
                                  width: 50.0,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text("₹${item['offPrice']}",
                                        style: TextStyle(
                                            color: Colors.green[700],
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    Text("₹${item['price']}",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
