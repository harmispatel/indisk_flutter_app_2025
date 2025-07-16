import 'package:flutter/cupertino.dart';
import 'package:indisk_app/api_service/models/sales_graph_manager.dart';
import '../../../../api_service/index.dart';
import '../../../../api_service/models/owner_home_master.dart';


class ManagerHomeViewModel with ChangeNotifier {
  final Services services = Services();
  OwnerHomeData? homeData;
  SalesGraphManagerData? salesCountData;
  List<FoodiesCount>? salesGraph;
  List<String>? foodies;
  SalesGraphMangerMaster? salesData;
  bool isApiLoading = false;

  Future<void> salesMangerGraphApi({
    required String managerId,
    required String graphType,
    required String timePeriod,
  }) async {
    try {
      print('[DEBUG] Starting salesGraphApi call');
      isApiLoading = true;
      notifyListeners();
      final params = {
        'manager_id': managerId,
        'graphType': graphType,
        'timePeriod': timePeriod,
      };
      print('[DEBUG] API params: $params');
      final response = await services.api?.salesMangerGraphApi(params: params);
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
      if (response.data == null) {
        print('[ERROR] API returned empty data');
        //showRedToastMessage("No data available");
        return;
      }
      salesGraph = response.foodiesCount!;
      salesCountData = response.data!;
      foodies = response.foodies!;
      print('[SUCCESS] Loaded ${salesGraph!.length} data points');
    } catch (e, stackTrace) {
      //print('[EXCEPTION] Error in salesGraphApi: $e');
      print('[STACK TRACE] $stackTrace');
      //showRedToastMessage("Error loading data: ${e.toString()}");
    } finally {
      isApiLoading = false;
      notifyListeners();
      print('[DEBUG] salesGraphApi execution completed');
    }
  }
}
