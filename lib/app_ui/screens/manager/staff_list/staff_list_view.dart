import 'package:flutter/material.dart';
import 'package:indisk_app/api_service/models/staff_list_master.dart';
import 'package:indisk_app/app_ui/common_widget/common_image.dart';
import 'package:indisk_app/utils/common_styles.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:provider/provider.dart';
import 'add_staff/add_staff_view.dart';
import 'staff_list_view_model.dart';

class StaffListView extends StatefulWidget {
  const StaffListView({super.key});

  @override
  _StaffListViewState createState() => _StaffListViewState();
}

class _StaffListViewState extends State<StaffListView> {
  late StaffListViewModel mViewModel;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel.getStaffList();
    });
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<StaffListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Staff List', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: CircleAvatar(child: Icon(Icons.add, size: 28)),
            tooltip: 'Add Staff',
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddStaffView()))
                  .then((_) {
                mViewModel.getStaffList();
              });
            },
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
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              )
            : LayoutBuilder(builder: (context, constraints) {
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
                final itemHeight = 260;
                final aspectRatio = itemWidth / itemHeight;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: mViewModel.staffList.length,
                  itemBuilder: (context, index) =>
                      _buildStaffCard(mViewModel.staffList[index], index),
                );
              }),
      ),
    );
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
                    imageUrl: staff.profilePicture!,
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
              style: getNormalTextStyle(
                  fontSize: 14.0, fontColor: Colors.grey[600]),
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                pushToScreen(AddStaffView(
                  staffListDetails: staff,
                ));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.green.shade100),
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
                padding: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.red.shade100),
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

  void showDeleteStaffDialog(
      BuildContext context, String staffName, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text("Delete Staff",
              style: TextStyle(fontWeight: FontWeight.bold)),
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
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
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
