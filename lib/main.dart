import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:next_buy/Auth/services.dart';
import 'package:next_buy/app/modules/home/controllers/home_controller.dart';
import 'package:next_buy/app/modules/home/controllers/cart_controller.dart';
import 'package:next_buy/app/routes/app_pages.dart';
import 'package:next_buy/app/routes/app_routes.dart';
import 'model/helper/firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: hasSeenOnboarding ? Routes.home : Routes.onboarding,
      getPages: AppPages.pages,
      initialBinding: BindingsBuilder(() {
        Get.put<AuthService>(AuthService());
        Get.put<HomeController>(HomeController(Get.find<AuthService>()));
        Get.put<CartController>(CartController());
        Get.put<LikesController>(LikesController());
        Get.put<ColorController>(ColorController());
        Get.put<BottomNavController>(BottomNavController());
        Get.put<FilterController>(FilterController());
        Get.lazyPut<FilterController>(() => FilterController());
        Get.put(TrackController());
      }),
    ),
  );
}
