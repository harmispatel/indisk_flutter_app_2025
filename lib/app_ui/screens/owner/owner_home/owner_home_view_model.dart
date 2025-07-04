import 'package:flutter/cupertino.dart';
import 'package:indisk_app/api_service/models/salep_graph_master.dart';
import 'package:indisk_app/api_service/models/sales_count_master.dart';
import '../../../../api_service/api_para.dart';
import '../../../../api_service/index.dart';
import '../../../../api_service/models/owner_home_master.dart';
import '../../../../utils/common_utills.dart';
import '../../../../utils/global_variables.dart';

class OwnerHomeViewModel with ChangeNotifier {
  final Services services = Services();

  OwnerHomeData? homeData;
  SalesCountData? salesCountData;
  List<SalesGraphData>? salesGraph;
  bool isApiLoading = false;
  bool isSalesGraphApiLoading = false;
  bool isSalesCountApiLoading = false;
  String? errorMessage;

  Future<void> getOwnerHomeApi() async {
    try {
      // Check if user is logged in
      if (gLoginDetails == null || gLoginDetails?.sId == null) {
        errorMessage = "User not logged in";
        isApiLoading = false;
        notifyListeners();
        return;
      }
      isApiLoading = true;
      errorMessage = null;
      notifyListeners();
      final master = await services.api!.getOwnerHome(
        params: {ApiParams.owner_id: gLoginDetails!.sId!},
      );
      isApiLoading = false;
      if (master != null && master.success == true) {
        homeData = master.data;
      } else {
        errorMessage = "Something went wrong";
        showRedToastMessage(errorMessage!);
      }
    } catch (e) {
      isApiLoading = false;
      errorMessage = "Failed to load data: ${e.toString()}";
      showRedToastMessage(errorMessage!);
    } finally {
      notifyListeners();
    }
  }

  Future<void> salesGraphApi({
    required String ownerId,
    required String graphType,
    required String timePeriod,
  }) async {
    try {
      print('[DEBUG] Starting salesGraphApi call');
      isSalesGraphApiLoading = true;
      notifyListeners();
      final params = {
        'owner_id': ownerId,
        'graphType': graphType,
        'timePeriod': timePeriod,
      };
      print('[DEBUG] API params: $params');
      final response = await services.api?.salesGraphApi(params: params);
      if (response == null) {
        print('[ERROR] Null response from API');
        //showRedToastMessage("No response from server");
        return;
      }
      print('[DEBUG] API response: ${response.toJson()}');
      if (response.success == false) {
        print('[ERROR] API returned success=false: ${response.message}');
        //showRedToastMessage(response.message ?? "Request failed");
        return;
      }
      if (response.data == null || response.data!.isEmpty) {
        print('[ERROR] API returned empty data');
        //showRedToastMessage("No data available");
        return;
      }
      salesGraph = response.data!;
      print('[SUCCESS] Loaded ${salesGraph!.length} data points');
    } catch (e, stackTrace) {
      //print('[EXCEPTION] Error in salesGraphApi: $e');
      print('[STACK TRACE] $stackTrace');
      //showRedToastMessage("Error loading data: ${e.toString()}");
    } finally {
      isSalesGraphApiLoading = false;
      notifyListeners();
      print('[DEBUG] salesGraphApi execution completed');
    }
  }

  Future<void> salesCountApi({
    required String ownerId,
  }) async {
    try {
      print('[DEBUG] Starting salesGraphApi call');
      isSalesCountApiLoading = true;
      notifyListeners();
      final params = {
        'owner_id': ownerId,
      };
      print('[DEBUG] API params: $params');
      final response = await services.api?.salesCountApi(params: params);
      if (response == null) {
        print('[ERROR] Null response from API');
        showRedToastMessage("No response from server");
        return;
      }
      print('[DEBUG] API response: ${response.toJson()}');
      if (response.success == false) {
        print('[ERROR] API returned success=false: ${response.message}');
        showRedToastMessage(response.message ?? "Request failed");
        return;
      }
      if (response.data == null) {
        print('[ERROR] API returned empty data');
        showRedToastMessage("No data available");
        return;
      }
      salesCountData = response.data!;
      print('[SUCCESS] Loaded ${salesGraph!.length} data points');
    } catch (e, stackTrace) {
      print('[EXCEPTION] Error in salesGraphApi: $e');
      print('[STACK TRACE] $stackTrace');
      //showRedToastMessage("Error loading data: ${e.toString()}");
    } finally {
      isSalesCountApiLoading = false;
      notifyListeners();
      print('[DEBUG] salesGraphApi execution completed');
    }
  }
}
