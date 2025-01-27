import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_buy/model/product.dart';

import '../../../app/modules/home/controllers/cart_controller.dart';
import '../../components/likesscreen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Product product;
  final Function() openDrawer;
  final void Function(Product) onAddToCart;
  final void Function(Product) onBuyNow;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.product,
    required this.openDrawer,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    Get.find<CartController>();
    final LikesController likesController = Get.find<LikesController>();

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Category',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.favorite),
              if (likesController.likedItemCount > 0)
                const Positioned(
                  top:
                      -1, // Adjust this value for fine-tuning vertical position
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 5, // Size of the dot
                    ),
                  ),
                ),
            ],
          ),
          label: 'Likes',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: currentIndex == 0
          ? const Color.fromARGB(255, 44, 206, 117) // Green for Home
          : currentIndex == 1
              ? const Color.fromARGB(255, 43, 172, 0) // Green for Category
              : currentIndex == 2
                  ? const Color.fromARGB(255, 43, 172, 0) // Green for Profile
                  : const Color.fromARGB(255, 43, 172, 0), // Green for Likes
      unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      onTap: (index) {
        switch (index) {
          case 0:
            onTap(index); // Go to Home
            break;
          case 1:
            openDrawer(); // Open Drawer (for Category)
            break;
          case 2:
            openDrawer(); // Open Drawer (for Profile)
            break;
          case 3:
            Get.to(() => LikesScreen(
                  product: product,
                  onAddToCart: onAddToCart,
                  onBuyNow: onBuyNow,
                )); // Go to Likes Screen
            break;
          default:
            break;
        }
      },
    );
  }
}
