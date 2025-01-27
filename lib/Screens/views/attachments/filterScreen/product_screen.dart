import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:next_buy/Screens/components/itemcard.dart';
import 'package:next_buy/Screens/views/detailscreen.dart';
import 'package:next_buy/model/product.dart';

class ProductScreen extends StatelessWidget {
  final String category;
  final List<Product> saleProducts;
  final List<Product> filteredProducts;
  final Function(Product) onAddToCart;
  final VoidCallback press;
  final List<Product> allProducts;
  final Product? product;

  const ProductScreen({
    super.key,
    required this.category,
    required this.saleProducts,
    required this.filteredProducts,
    required this.onAddToCart,
    required this.press,
    required this.allProducts,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    // Determine which list to display based on the category
    List<Product> productsToDisplay =
        category == 'Sale' ? saleProducts : filteredProducts;

    return GestureDetector(
      onTap: press,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                category,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      offset: const Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: productsToDisplay.isNotEmpty
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 6.0, // Add vertical spacing
                    crossAxisSpacing: 6.0, // Add horizontal spacing
                    childAspectRatio: 0.75,
                  ),
                  itemCount: productsToDisplay.length,
                  itemBuilder: (context, index) {
                    return ItemCard(
                      product: productsToDisplay[index],
                      press: () {
                        Get.to(
                          DetailsScreen(
                            product: productsToDisplay[index],
                          ),
                        );
                      },
                      onAddToCart: onAddToCart,
                    );
                  },
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/onboding2.png',
                          height: 150,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Coming SOON!'.toUpperCase(),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
