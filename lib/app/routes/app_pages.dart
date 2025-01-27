import 'package:get/get.dart';
import 'package:next_buy/Auth/loginscreen.dart';
import 'package:next_buy/app/modules/home/controllers/home_controller.dart';
import 'package:next_buy/Screens/views/attachments/filterScreen/product_screen.dart';
import 'package:next_buy/Screens/views/onboarding_screen.dart' as home_views;
import 'package:next_buy/app/modules/home/bindings/home_binding.dart';
import 'package:next_buy/Screens/home.dart';
import 'package:next_buy/Screens/views/profilescreen.dart';
import 'package:next_buy/Screens/components/likesscreen.dart';
// Import the Product class

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.home,
      page: () => const Home(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const home_views.Onboarding(),
    ),
    GetPage(
      name: Routes.login,
      page: () {
        final homeController = Get.find<HomeController>();
        return LoginScreen(homeController: homeController);
      },
    ),
    GetPage(
      name: Routes.profileScreen,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: Routes.product,
      page: () {
        final arguments = Get.arguments as Map<String, dynamic>;
        return ProductScreen(
          category: arguments['category'],
          onAddToCart: arguments['onAddToCart'],
          allProducts: const [],
          filteredProducts: const [],
          product: null,
          press: () {},
          saleProducts: const [],
        );
      },
    ),
    GetPage(
      name: Routes.likes,
      page: () {
        final arguments = Get.arguments as Map<String, dynamic>;
        return LikesScreen(
          product: arguments['product'],
          onBuyNow: arguments['onBuyNow'],
          onAddToCart: arguments['onAddToCart'],
        );
      },
    ),
    // Other routes
  ];
}
