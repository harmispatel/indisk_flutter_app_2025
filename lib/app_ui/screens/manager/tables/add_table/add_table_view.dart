import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/common_utills.dart';
import '../../../../common_widget/common_textfield.dart';
import '../../../../common_widget/primary_button.dart';
import 'add_table_view_model.dart';

class AddTableView extends StatefulWidget {
  const AddTableView({super.key});

  @override
  State<AddTableView> createState() => _AddTableViewState();
}

class _AddTableViewState extends State<AddTableView> {
  final _tableNoController = TextEditingController();
  late AddTableViewModel mViewModel;

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<AddTableViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Table', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsetsDirectional.only(
            bottom: MediaQuery.of(context).viewPadding.bottom),
        child: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: PrimaryButton(
            text: "Add table",
            onPressed: () {
              if (isValid()) {
                mViewModel.addTable(tableNo: _tableNoController.text);
              }
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _buildTextField(
                _tableNoController, "Table No.", Icons.table_bar_rounded, false,
                keyboardType: TextInputType.number),
          ],
        ),
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 15),
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

  bool isValid() {
    if (_tableNoController.text.trim().isEmpty) {
      showRedToastMessage("Please enter table number");
      return false;
    } else {
      return true;
    }
  }
}
