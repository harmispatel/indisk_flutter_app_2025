import 'package:flutter/cupertino.dart';

import '../../../../api_service/api_para.dart';
import '../../../../api_service/index.dart';
import '../../../../api_service/models/owner_home_master.dart';
import '../../../../utils/common_utills.dart';
import '../../../../utils/global_variables.dart';

class OwnerHomeViewModel with ChangeNotifier {
  Services services = Services();

  OwnerHomeData? homeData;

  bool isApiLoading = false;

  Future<void> getOwnerHomeApi() async {
    isApiLoading = true;
    notifyListeners();
    OwnerHomeMaster? master = await services.api!
        .getOwnerHome(params: {ApiParams.user_id: gLoginDetails!.sId!});
    isApiLoading = false;
    notifyListeners();

    if (master != null) {
      if (master.success != null && master.success!) {
        homeData = master.data;
      } else {
        showRedToastMessage("Something went wrong in get data");
      }
    } else {
      oopsMSG();
    }
    notifyListeners();
  }
}
