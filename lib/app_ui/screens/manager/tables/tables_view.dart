import 'package:flutter/material.dart';
import 'package:indisk_app/utils/app_dimens.dart';
import 'package:provider/provider.dart';
import '../../../../utils/local_images.dart';
import '../../../common_widget/common_textfield.dart';
import '../../../common_widget/primary_button.dart';
import 'table_view_model.dart';
import '../../../../utils/common_utills.dart';

class TablesView extends StatefulWidget {
  const TablesView({super.key});

  @override
  State<TablesView> createState() => _TablesViewState();
}

class _TablesViewState extends State<TablesView> {
  late TableViewModel mViewModel;
  final _tableNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel.getTable();
    });
  }

  @override
  void dispose() {
    _tableNoController.dispose();
    super.dispose();
  }

  void _showAddTableDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Table', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset(
                  LocalImages.img_table,
                  height: 100,
                  width: 150,
                  fit: BoxFit.fill,
                ),
              ),
              kSizedBoxV20,
              _buildTextField(
                _tableNoController,
                "Table No.",
                Icons.table_bar_rounded,
                false,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    padding: EdgeInsets.all(1),
                    height: 35,
                    text: "cancel",
                    color: Colors.red,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                kSizedBoxH10,
                Expanded(
                  child: PrimaryButton(
                    text: "Add",
                    height: 35,
                    padding: EdgeInsets.all(1),
                    onPressed: () {
                      if (_isValid()) {
                        mViewModel.addTable(tableNo: _tableNoController.text)
                            .then((_) {
                          Navigator.pop(context);
                          mViewModel.getTable();
                          _tableNoController.clear();
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon,
      bool isObscure, {
        TextInputType keyboardType = TextInputType.text,
        bool isEnable = true,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CommonTextField(
        controller: controller,
        labelText: label,
        prefixIcon: Icon(icon),
        obscureText: isObscure,
        keyboardType: keyboardType,
        enabled: isEnable,
      ),
    );
  }

  bool _isValid() {
    if (_tableNoController.text.trim().isEmpty) {
      showRedToastMessage("Please enter table number");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<TableViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tables', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 28),
            tooltip: 'Add Table',
            onPressed: _showAddTableDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: mViewModel.isApiLoading
            ? const Center(child: CircularProgressIndicator())
            : mViewModel.tablesList.isEmpty
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.table_bar_rounded,
                    size: 100, color: Colors.grey[400]),
                const SizedBox(height: 20),
                const Text(
                  'No table added yet',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
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
          children: List.generate(mViewModel.tablesList.length, (index) {
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
                    if (mViewModel.tablesList[index].orderTime != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          mViewModel.tablesList[index].orderTime ?? '',
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
                    if (mViewModel.tablesList[index].orderedItemsCount != 0)
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
          }),
        ),
      ),
    );
  }
}