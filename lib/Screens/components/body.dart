import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_buy/app/modules/home/controllers/cart_controller.dart';
import 'package:next_buy/Screens/views/attachments/cart.dart';
import 'package:next_buy/model/product.dart';
import 'package:next_buy/Screens/components/color_and_size.dart';
import 'package:next_buy/Screens/components/counter_with_fav_btn.dart';
import 'package:next_buy/Screens/components/discription.dart';
import 'package:next_buy/Screens/components/proaduct_title_with_imag.dart';
import 'package:next_buy/model/helper/constants.dart';
import 'add_to_cart.dart';

class Body extends StatelessWidget {
  final Product product;

  const Body({
    super.key,
    required this.product,
  });

  void _handleAddToCart(Product product, BuildContext context) {
    final cartController = Get.find<CartController>();
    cartController.addProduct(product);

    Get.snackbar(
      'Added to Cart',
      '${product.title} added to cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: product.color,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _handleBuyNow(Product product, BuildContext context) {
    final cartController = Get.find<CartController>();
    cartController.addProduct(product);
    Get.to(() => CartScreen(product: product)); // Pass the product instance
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: product.color,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: product.color,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          // Background Container for Product Details
          Positioned(
            top: size.height * 0.3,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: kDefaultPadding,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Column(
                      children: [
                        // Centered color selector
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ColorAnSize(product: product),
                        ),
                        const SizedBox(height: 10),
                        // Cart counter under color
                        CounterWithFavBtn(product: product),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Discription(product: product),
                        const Spacer(),
                        AddToCart(
                          product: product,
                          onAddToCart: (product) =>
                              _handleAddToCart(product, context),
                          onBuyNow: (product) =>
                              _handleBuyNow(product, context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Product title with image remains at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ProductTitleWithImage(product: product),
          ),
        ],
      ),
    );
  }
}
