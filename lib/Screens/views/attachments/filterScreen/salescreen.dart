import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:next_buy/Screens/components/itemcard.dart';
import 'package:next_buy/Screens/views/detailscreen.dart';
import 'package:next_buy/model/product.dart';
import 'package:get/get.dart'; // Ensure you have the Get package imported

class SaleScreen extends StatelessWidget {
  final List<Product> saleProducts;

  const SaleScreen({super.key, required this.saleProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 6.0, // Add vertical spacing
            crossAxisSpacing: 6.0, // Add horizontal spacing
            childAspectRatio: 0.75,
          ),
          itemCount: saleProducts.length,
          itemBuilder: (context, index) {
            final product = saleProducts[index];
            return ItemCard(
              product: product,
              press: () {
                Get.to(
                  DetailsScreen(
                    product: product,
                  ),
                );
              },
              onAddToCart: (Product p) {
                // Implement add to cart logic here, using the `p` product
                if (kDebugMode) {
                  print('Added to cart: ${p.title}');
                }
              },
            );
          },
        ),
      ),
    );
  }
}
