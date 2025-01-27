import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:next_buy/model/product.dart';

class ItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback press;
  final void Function(Product) onAddToCart;

  const ItemCard({
    super.key,
    required this.product,
    required this.press,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: 200, // Fixed width for the card
        margin: const EdgeInsets.all(.0), // Margin around the card
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Shadow position
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.5), // Card border color
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Product Image Container
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                height: 120, // Fixed height for the image
                child: FutureBuilder<String>(
                  future: _getImageUrl(product.image),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingImage();
                    } else if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Error loading image'),
                      );
                    } else {
                      return Hero(
                        tag:
                            "product_${product.id}", // Unique tag for each product
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(
                                  16)), // Rounded corners at the top
                          child: Image.network(
                            snapshot.data ?? '',
                            fit: BoxFit.contain,
                            height: 100,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            // Sale Badge and Product Title
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.all(4), // Padding around the badge
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: Image.asset(
                      'assets/images/sale.png',
                      width: 50,
                      height: 19,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                      width: 35), // Adjust space between badge and title
                  Expanded(
                    child: Text(
                      product.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Title and Price Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "PKR 3250", // Original price
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              Colors.red, // Grey color for original price text
                          decoration: TextDecoration
                              .lineThrough, // Strikethrough effect
                          decorationColor: Colors
                              .red, // Red color for the strikethrough line
                          decorationThickness:
                              2, // Thickness of the strikethrough line
                        ),
                      ),
                      Text(
                        "PKR ${product.price}", // Discounted price
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .black, // Bold black color for discounted price
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/images/add-to-basket.png', // Add to basket icon
                    height: 19, // Adjust size as needed
                    width: 24, // Adjust size as needed
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getImageUrl(String imagePath) async {
    try {
      if (imagePath.startsWith('gs://')) {
        final ref = FirebaseStorage.instance.refFromURL(imagePath);
        return await ref.getDownloadURL();
      } else {
        return imagePath; // Assuming it's already a valid URL or local path
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting download URL: $e");
      }
      return ""; // Return an empty string in case of error
    }
  }

  Widget _buildLoadingImage() {
    return Center(
      child: Image.asset(
        'assets/images/downloud.gif',
        height: 100,
        width: 100,
      ),
    );
  }
}
