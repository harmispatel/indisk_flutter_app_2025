import 'package:flutter/material.dart';
import 'package:indisk_app/api_service/models/staff_list_master.dart';
import 'package:indisk_app/app_ui/common_widget/common_image.dart';
import 'package:indisk_app/app_ui/screens/restaurent_owner/add_manager/add_manager_view.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:indisk_app/utils/common_styles.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../../utils/app_dimens.dart';
import 'staff_list_view_model.dart';

class StaffListView extends StatefulWidget {
  @override
  _StaffListViewState createState() => _StaffListViewState();
}

class _StaffListViewState extends State<StaffListView> {
  late StaffListViewModel mViewModel;

  void _addStaff({StaffListDetails? staffListDetails}) async{
    await pushToScreen(AddManagerView(
      staffListDetails: staffListDetails,
    ));
    mViewModel.getStaffList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel.getStaffList();
    });
  }

  Widget _buildStaffTile(StaffListDetails staff, int index) {
    return Card(
      margin: EdgeInsetsDirectional.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        padding: EdgeInsetsDirectional.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonImage(height: 100.0, width: 100.0, imageUrl: staff.image!),
            kSizedBoxH20,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  staff.name!,
                  style: getBoldTextStyle(fontSize: 20.0),
                ),
                kSizedBoxV5,
                Text(
                  staff.phone!,
                  style: getNormalTextStyle(fontSize: 16.0),
                ),
                kSizedBoxV5,
                Container(
                  height: 40.0,
                  width: 100.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: CommonColors.blie,
                    borderRadius: BorderRadius.circular(5.0)
                  ),
                  child: Text(staff.role == 2 ?  "Waiter" : "Manager" ,style: getBoldTextStyle(
                    fontColor: CommonColors.white
                  ),),
                )
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    pushToScreen(AddManagerView(
                      staffListDetails: staff,
                    ));
                  },
                  child: Container(
                      padding: EdgeInsetsDirectional.all(5.0),
                      decoration: BoxDecoration(
                          color: CommonColors.blie,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Icon(
                        Icons.edit,
                        color: CommonColors.white,
                      )),
                ),
                kSizedBoxV20,
                InkWell(
                  onTap: () {
                   showDeleteStaffDialog(context, staff.name!, (){
                     mViewModel.deleteStaff(staffId: staff.sId);
                   });
                  },
                  child: Container(
                      padding: EdgeInsetsDirectional.all(5.0),
                      decoration: BoxDecoration(
                          color: CommonColors.red,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Icon(
                        Icons.delete,
                        color: CommonColors.white,
                      )),
                )
              ],
            ),
            kSizedBoxH5
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<StaffListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add Staff',
            onPressed: _addStaff,
          ),
        ],
      ),
      body: mViewModel.staffList.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group_off, size: 100, color: Colors.grey[400]),
                    SizedBox(height: 20),
                    Text(
                      'No staff added yet',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tap the + button to add your first staff member.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: mViewModel.staffList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) =>
                  _buildStaffTile(mViewModel.staffList[index], index),
            ),
    );
  }

  void showDeleteStaffDialog(BuildContext context, String staffName, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text("Delete Staff"),
          content: Text("Are you sure you want to delete $staffName? This action cannot be undone."),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Execute the delete logic
              },
            ),
          ],
        );
      },
    );
  }

}
