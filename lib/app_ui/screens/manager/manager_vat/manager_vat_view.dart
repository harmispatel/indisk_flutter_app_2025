import 'package:flutter/material.dart';
import 'package:indisk_app/utils/app_dimens.dart';
import 'package:provider/provider.dart';

import '../../../../utils/common_utills.dart';
import '../../../common_widget/common_textfield.dart';
import '../../../common_widget/primary_button.dart';
import '../staff_list/staff_list_view_model.dart';
import 'manager_vat_view_model.dart';

class ManagerVatView extends StatefulWidget {
  const ManagerVatView({super.key});

  @override
  State<ManagerVatView> createState() => _ManagerVatViewState();
}

class _ManagerVatViewState extends State<ManagerVatView> {
  late ManagerVatViewModel mViewModel;
  final vatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel.getVat().whenComplete(() {
        vatController.text = mViewModel.currentVat;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<ManagerVatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Vat'),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: PrimaryButton(
            text: 'Save',
            onPressed: () {
              if (vatController.text.trim().isEmpty) {
                showRedToastMessage("Please enter vat");
              } else {
                mViewModel
                    .saveVat(vat: vatController.text.trim())
                    .whenComplete(() {
                  vatController.text = mViewModel.currentVat;
                });
              }
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _buildTextField(vatController, "Vat", Icons.percent, false,
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
}
