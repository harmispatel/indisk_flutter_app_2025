import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/local_images.dart';
import 'add_table/add_table_view.dart';
import 'add_table/add_table_view_model.dart';

class TablesView extends StatefulWidget {
  const TablesView({super.key});

  @override
  State<TablesView> createState() => _TablesViewState();
}

class _TablesViewState extends State<TablesView> {
  late AddTableViewModel mViewModel;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel.getTable();
    });
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<AddTableViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Tables', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 28),
            tooltip: 'Add Table',
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddTableView()))
                  .then((_) {
                mViewModel.getTable();
              });
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: mViewModel.isApiLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : mViewModel.tablesList.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.table_bar_rounded,
                                size: 100, color: Colors.grey[400]),
                            SizedBox(height: 20),
                            Text(
                              'No table added yet',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tap the + button to add your first table.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    )
                  : GridView.count(
                      crossAxisCount: 5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.3,
                      children:
                          List.generate(mViewModel.tablesList.length, (index) {
                        final tableNumber = index + 1;
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if(mViewModel.tablesList[index].orderTime != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    mViewModel.tablesList[index].orderTime ??
                                        '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Image.asset(
                                    LocalImages.img_table,
                                    height: 100,
                                    width: 150,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if(mViewModel.tablesList[index].orderedItemsCount != 0)
                                Center(
                                  child: Text(
                                    'Ordered ${mViewModel.tablesList[index].orderedItemsCount} items',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Table ${mViewModel.tablesList[index].tableNo}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                          ),
                    ),
      ),
    );
  }
}
