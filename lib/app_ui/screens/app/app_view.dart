import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:indisk_app/app_ui/screens/login/login_view_model.dart';
import 'package:indisk_app/app_ui/screens/manager/food_menu/create_food/create_food_view_model.dart';
import 'package:indisk_app/app_ui/screens/manager/manager_home/manager_home_view_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../../language/app_localizations.dart';
import '../../../utils/common_colors.dart';
import '../../../utils/global_variables.dart';
import '../../common_screen/change_password/change_password_view_model.dart';
import '../../common_screen/edit_profile/edit_profile_view_model.dart';
import '../../common_screen/profile/profile_view_model.dart';
import '../kitchen_staff/kitchen_staff_home/kitchen_staff_home_view_model.dart';
import '../manager/food_category/create_food_category/create_food_category_view_model.dart';
import '../manager/food_category/food_category_list/food_category_list_view_model.dart';
import '../manager/food_menu/edit_food/edit_food_view_model.dart';
import '../manager/food_menu/food_list/food_list_view_model.dart';
import '../manager/manager_vat/manager_vat_view_model.dart';
import '../manager/staff_list/add_staff/add_staff_view_model.dart';
import '../manager/staff_list/staff_list_view_model.dart';
import '../manager/tables/table_view_model.dart';
import '../owner/owner_home/owner_home_view_model.dart';
import '../owner/restaurant/add_restaurant/add_restaurant_view_model.dart';
import '../owner/restaurant/edit_restaurant/edit_restaurant_view_model.dart';
import '../owner/restaurant/restaurant_details/restaurant_details_view_model.dart';
import '../owner/restaurant/restaurant_list_view_model.dart';
import '../splash/splash_view.dart';
import '../splash/splash_view_model.dart';
import '../staff/order_history/order_history_view_model.dart';
import '../staff/staff_home/select_product/staff_select_product_view_model.dart';
import '../staff/staff_home/select_table_view_model.dart';
import 'app_model.dart';

GlobalKey<NavigatorState> mainNavKey = GlobalKey();

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<StatefulWidget> createState() {
    return AppViewState();
  }
}

class AppViewState extends State<AppView> with WidgetsBindingObserver {
  final _app = AppModel();
  final _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _app.setLanguage();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("$state");
    _app.updateAppLifeCycleState(state);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _app.connectionStatus = result.first;

    if (result.contains(ConnectivityResult.mobile)) {
      connectivity = true;
    } else if (result.contains(ConnectivityResult.wifi)) {
      connectivity = true;
    } else if (result.contains(ConnectivityResult.ethernet)) {
      connectivity = true;
    } else if (result.contains(ConnectivityResult.vpn)) {
      connectivity = true;
    } else if (result.contains(ConnectivityResult.bluetooth)) {
      connectivity = true;
    } else if (result.contains(ConnectivityResult.other)) {
      connectivity = true;
    } else if (result.contains(ConnectivityResult.none)) {
      connectivity = false;
    }

    log("InternetChanges :: ${_app.connectionStatus}");
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppModel>(create: (_) => AppModel()),
        ChangeNotifierProvider<SplashViewModel>(
            create: (_) => SplashViewModel()),
        ChangeNotifierProvider<LoginViewModel>(create: (_) => LoginViewModel()),
        ChangeNotifierProvider<AddStaffViewModel>(
            create: (_) => AddStaffViewModel()),
        ChangeNotifierProvider<StaffListViewModel>(
            create: (_) => StaffListViewModel()),
        ChangeNotifierProvider<FoodCategoryListViewModel>(
            create: (_) => FoodCategoryListViewModel()),
        ChangeNotifierProvider<CreateFoodCategoryViewModel>(
            create: (_) => CreateFoodCategoryViewModel()),
        ChangeNotifierProvider<CreateFoodViewModel>(
            create: (_) => CreateFoodViewModel()),
        ChangeNotifierProvider<FoodListViewModel>(
            create: (_) => FoodListViewModel()),
        ChangeNotifierProvider<EditFoodViewModel>(
            create: (_) => EditFoodViewModel()),
        ChangeNotifierProvider<RestaurantViewModel>(
            create: (_) => RestaurantViewModel()),
        ChangeNotifierProvider<RestaurantListViewModel>(
            create: (_) => RestaurantListViewModel()),
        ChangeNotifierProvider<OwnerHomeViewModel>(
            create: (_) => OwnerHomeViewModel()),
        ChangeNotifierProvider<RestaurantEditModel>(
            create: (_) => RestaurantEditModel()),
        ChangeNotifierProvider<ChangePasswordViewModel>(
            create: (_) => ChangePasswordViewModel()),
        ChangeNotifierProvider<EditProfileViewModel>(
            create: (_) => EditProfileViewModel()),
        ChangeNotifierProvider<ProfileViewModel>(
            create: (_) => ProfileViewModel()),
        ChangeNotifierProvider<RestaurantDetailsViewModel>(
            create: (_) => RestaurantDetailsViewModel()),
        ChangeNotifierProvider<StaffSelectProductViewModel>(
            create: (_) => StaffSelectProductViewModel()),
        ChangeNotifierProvider<TableViewModel>(create: (_) => TableViewModel()),
        ChangeNotifierProvider<SelectTableViewModel>(
            create: (_) => SelectTableViewModel()),
        ChangeNotifierProvider<KitchenStaffHomeViewModel>(
            create: (_) => KitchenStaffHomeViewModel()),
        ChangeNotifierProvider<OrderHistoryViewModel>(
            create: (_) => OrderHistoryViewModel()),
        ChangeNotifierProvider<ManagerVatViewModel>(
            create: (_) => ManagerVatViewModel()),
        ChangeNotifierProvider<ManagerHomeViewModel>(
            create: (_) => ManagerHomeViewModel()),
      ],
      child: Consumer<AppModel>(
        builder: (context, appModel, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          color: CommonColors.primaryColor,
          navigatorKey: mainNavKey,
          theme: ThemeData(primaryColor: CommonColors.primaryColor),
          themeMode: _app.darkTheme ? ThemeMode.dark : ThemeMode.light,
          supportedLocales: LanguageDataModel.languageLocales(),
          localizationsDelegates: [
            AppLocalizations(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) => locale,
          locale: Locale(appModel.locale),
          home: SplashView(),
        ),
      ),
    );
  }
}
