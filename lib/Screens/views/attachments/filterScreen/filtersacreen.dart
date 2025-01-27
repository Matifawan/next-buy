import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Assuming you're using GetX for navigation
import 'package:next_buy/Screens/components/itemcard.dart';
import 'package:next_buy/Screens/views/detailscreen.dart'; // Assuming this is your details screen
import 'package:next_buy/model/product.dart';

class FilterScreen extends StatelessWidget {
  final List<Product> initialProducts;
  final String category;
  final Function(Product) onAddToCart;
  final VoidCallback press;

  const FilterScreen({
    super.key,
    required this.initialProducts,
    required this.category,
    required this.press,
    required this.onAddToCart,
  });

  List<Product> getProductsByCategory(String category) {
    return initialProducts
        .where((product) =>
            product.category.trim().toLowerCase() ==
            category.trim().toLowerCase())
        .toList();
  }

  List<Product> getRecommendedProducts() {
    return initialProducts
        .where((product) => !getProductsByCategory(category).contains(product))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = getProductsByCategory(category);
    final recommendedProducts = getRecommendedProducts();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter action here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Showing results for "$category"',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                ),
              ),
              const SizedBox(height: 10),
              filteredProducts.isNotEmpty
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.0, // Add vertical spacing
                        crossAxisSpacing: 16.0, // Add horizontal spacing
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        // Ensure index is valid
                        if (index < filteredProducts.length) {
                          return ItemCard(
                            product: filteredProducts[index],
                            press: () {
                              Get.to(
                                DetailsScreen(
                                  product: filteredProducts[index],
                                ),
                              );
                            },
                            onAddToCart: onAddToCart,
                            // Pass the actual callback
                          );
                        } else {
                          return const SizedBox
                              .shrink(); // Handle invalid index
                        }
                      },
                    )
                  : Center(
                      child: Text('No Products found',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 66, 4, 4),
                                  ))),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'You May Also Like',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                ),
              ),
              const SizedBox(height: 15),
              recommendedProducts.isEmpty
                  ? const Center(child: Text('No recommendations available'))
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.0, // Add vertical spacing
                        crossAxisSpacing: 16.0, // Add horizontal spacing
                        childAspectRatio: 0.75,
                      ),
                      itemCount: recommendedProducts.length,
                      itemBuilder: (context, index) {
                        // Ensure index is valid
                        if (index < recommendedProducts.length) {
                          return ItemCard(
                            product: recommendedProducts[index],
                            press: () {
                              Get.to(
                                DetailsScreen(
                                  product: recommendedProducts[index],
                                ),
                              );
                            },
                            onAddToCart: onAddToCart,
                          );
                        } else {
                          return const SizedBox
                              .shrink(); // Handle invalid index
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
