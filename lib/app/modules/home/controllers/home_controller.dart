// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:next_buy/Auth/services.dart' as auth_services;
import 'package:next_buy/Auth/services.dart';

class HomeController extends GetxController {
  final AuthService authService;
  final count = 0.obs;

  HomeController(this.authService);

  void increment() => count.value++;
}

class AuthController extends GetxController {
  final auth_services.AuthService authService = auth_services.AuthService();
}
