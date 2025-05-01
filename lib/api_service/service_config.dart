import 'api_services.dart';
import 'base_services.dart';

mixin ConfigMixin {
  BaseServices? api;

  void configAPI() {
    api = ApiServices();
  }
}
