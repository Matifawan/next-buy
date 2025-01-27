import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_buy/Screens/components/cart_counter.dart';
import 'package:next_buy/model/product.dart';
import '../../app/modules/home/controllers/cart_controller.dart';

class CounterWithFavBtn extends StatelessWidget {
  final Product product;

  const CounterWithFavBtn({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final likesController = Get.put(LikesController());

    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CartCounter(), // Display the cart counter at the top
          const SizedBox(height: 10), // Add spacing between elements
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Combined Heart (Favorite) and "ADD TO CART" Buttons
              Obx(() {
                final isLiked = likesController.isLiked(product);
                return GestureDetector(
                  onTap: () {
                    likesController.toggleLike(product);
                    Get.snackbar(
                      isLiked ? 'Removed from Liked' : 'Added to Liked',
                      isLiked
                          ? '${product.title} has been removed from liked items'
                          : '${product.title} has been added to liked items',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.black54,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: isLiked ? Colors.redAccent : Colors.grey[300],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 10), // Add space between buttons
              // "ADD TO CART" Button
              TextButton(
                onPressed: () {
                  final cartController = Get.find<CartController>();
                  cartController.addProduct(product);
                  Get.snackbar(
                    'Added to Cart',
                    '${product.title} added to cart',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.withOpacity(0.8),
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: product.color,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13.0, vertical: 6.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'ADD TO CART'.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
