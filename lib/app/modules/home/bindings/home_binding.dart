import 'package:get/get.dart';
import 'package:next_buy/Auth/services.dart';
import 'package:next_buy/app/modules/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController()); // Register AuthController
    Get.put(HomeController(Get.find<
        AuthService>())); // Register HomeController with injected AuthService
  }
}
