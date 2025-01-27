import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_buy/app/modules/home/controllers/cart_controller.dart';
import 'package:next_buy/Screens/views/attachments/appdrawer.dart';
import 'package:next_buy/Screens/views/attachments/cart.dart';
import 'package:next_buy/model/product.dart';

class LikesScreen extends StatelessWidget {
  final Product product;
  final void Function(Product) onAddToCart;
  final Function(Product) onBuyNow;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  LikesScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _handleAddToCart(Product product, BuildContext context) {
    final cartController = Get.find<CartController>();
    cartController.addProduct(product);

    Get.snackbar(
      'Added to Cart',
      '${product.title} added to cart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _handleBuyNow(Product product, BuildContext context) {
    final cartController = Get.find<CartController>();
    cartController.addProduct(product);
    Get.to(() => CartScreen(product: product));
  }

  Future<String> _getImageUrl(String imagePath) async {
    try {
      if (imagePath.startsWith('gs://')) {
        final ref = FirebaseStorage.instance.refFromURL(imagePath);
        return await ref.getDownloadURL();
      } else {
        return imagePath;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting download URL: $e");
      }
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final likesController = Get.find<LikesController>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back arrow at top left
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Liked Items',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.black,
                shadows: [
                  Shadow(
                    offset: const Offset(2.0, 2.0),
                    blurRadius: 3.0,
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.apps, color: Colors.black),
            onPressed: openDrawer,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Obx(() {
        if (likesController.likedItems.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/playstore.png',
                height: 280,
              ),
              const SizedBox(height: 5),
              const Center(
                child: Text(
                  'No items Found.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/home', arguments: {'controller': 'controller'});
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 7, 115, 151),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Explore ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            // Show the swipe instruction in the center of the body
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Center(
                child: Text(
                  'Swipe right to delete or swipe left to undo',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: likesController.likedItems.length,
                itemBuilder: (context, index) {
                  final likedProduct = likesController.likedItems[index];
                  return Dismissible(
                    key: Key(likedProduct.id.toString()),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      color: Colors.red,
                      child: const Center(
                        child: Text(
                          'Swipe Right to Delete',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.blue,
                      child: const Center(
                        child: Text(
                          'Swipe Left to Undo',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        // Swipe right to delete
                        likesController.removeProduct(likedProduct);
                        Get.snackbar(
                          'Removed from Liked',
                          '${likedProduct.title} has been removed from liked items',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.black54,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                        return true;
                      } else if (direction == DismissDirection.endToStart) {
                        // Swipe left to undo
                        likesController.addProduct(likedProduct);
                        Get.snackbar(
                          'Undo',
                          '${likedProduct.title} has been added back to liked items',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                        return false;
                      }
                      return false;
                    },
                    child: ListTile(
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: FutureBuilder<String>(
                          future: _getImageUrl(likedProduct.image),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return _buildLoadingImage();
                            } else if (snapshot.hasError) {
                              return Image.asset(
                                'assets/images/loading.gif',
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text('Error loading image'),
                              );
                            } else {
                              return Image.network(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),
                      subtitle: Text('Price: \$${likedProduct.price}'),
                      trailing: SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: likedProduct.color,
                                  ),
                                ),
                                child: IconButton(
                                  icon: Image.asset(
                                    'assets/images/add-to-basket.png',
                                  ),
                                  iconSize: 35.0,
                                  color: likedProduct.color,
                                  onPressed: () {
                                    _handleAddToCart(likedProduct, context);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: SizedBox(
                                height: 50,
                                child: TextButton(
                                  onPressed: () {
                                    _handleBuyNow(likedProduct, context);
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: likedProduct.color,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 13.0, vertical: 6.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    'BUY NOW'.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLoadingImage() {
    return const Center(child: CircularProgressIndicator());
  }
}
