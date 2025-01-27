import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:next_buy/model/helper/constants.dart';
import 'package:next_buy/model/product.dart';

class ProductTitleWithImage extends StatelessWidget {
  const ProductTitleWithImage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            product.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: kDefaultPadding),
          // Row for Price and Image
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Price
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                        text: "Price\n", style: TextStyle(color: Colors.white)),
                    TextSpan(
                      text: "PKR ${product.price}", // Price in PKR
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: const Color.fromARGB(255, 212, 204, 204),
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: kDefaultPadding),
              // Product Image
              SizedBox(
                width: 200, // Adjust width as needed
                child: Hero(
                  tag: "product_${product.id}_image",
                  child: FutureBuilder<String>(
                    future: _getImageUrl(product.image),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingImage();
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error loading image'),
                        );
                      } else {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            snapshot.data ?? '',
                            fit: BoxFit.fill,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
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
      return "";
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
