import 'package:flutter/material.dart';
import 'package:indisk_app/api_service/models/staff_list_master.dart';
import 'package:indisk_app/app_ui/common_widget/common_image.dart';
import 'package:indisk_app/app_ui/screens/restaurent_owner/add_manager/add_manager_view.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:indisk_app/utils/common_styles.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:indisk_app/utils/local_images.dart';
import 'package:provider/provider.dart';

import '../../../../utils/app_dimens.dart';
import 'staff_list_view_model.dart';

class StaffListView extends StatefulWidget {
  @override
  _StaffListViewState createState() => _StaffListViewState();
}

class _StaffListViewState extends State<StaffListView> {
  late StaffListViewModel mViewModel;

  void _addStaff({StaffListDetails? staffListDetails}) async {
    await pushToScreen(AddManagerView(
      staffListDetails: staffListDetails,
    ));
    mViewModel.getStaffList();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel.getStaffList();
    });
  }

  Widget _buildStaffCard(StaffListDetails staff, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: CommonImage(
                    height: 80.0,
                    width: 80.0,
                    imageUrl: staff.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              staff.name!,
              style: getBoldTextStyle(fontSize: 16.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              staff.phone!,
              style: getNormalTextStyle(fontSize: 14.0, fontColor: Colors.grey[600]),
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                // pushToScreen(AddManagerView(
                //   staffListDetails: staff,
                // ));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.green.shade100
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.green,
                        size: 18,
                      ),
                      Text(
                        " Edit",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

            GestureDetector(
              onTap: () {
                showDeleteStaffDialog(context, staff.name!, () {
                  mViewModel.deleteStaff(staffId: staff.sId);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.red.shade100
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                      size: 18,
                    ),
                    Text(
                      "Delete",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
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
        title: Text('Staff List', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 28),
            tooltip: 'Add Staff',
            onPressed: (){},
            // onPressed: _addStaff,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: mViewModel.staffList.isEmpty
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
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Text(
                  'Tap the + button to add your first staff member.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        )
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.9,
          ),
          itemCount: mViewModel.staffList.length,
          itemBuilder: (context, index) =>
              _buildStaffCard(mViewModel.staffList[index], index),
        ),
      ),
    );
  }

  void showDeleteStaffDialog(
      BuildContext context, String staffName, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text("Delete Staff", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
              "Are you sure you want to delete $staffName? This action cannot be undone."),
          actions: [
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text("Delete"),
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