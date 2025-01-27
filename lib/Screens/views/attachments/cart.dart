import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:next_buy/app/modules/home/controllers/cart_controller.dart';
import 'package:next_buy/Screens/views/attachments/appdrawer.dart';
import 'package:next_buy/Screens/views/attachments/filterScreen/orserdetail.dart';
import 'package:next_buy/model/product.dart';

class CartScreen extends StatelessWidget {
  final Product product;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CartScreen({super.key, required this.product});

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
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

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final ColorController colorController =
        Get.find<ColorController>(); // Declare ColorController instance

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
              'Cart',
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
          // Image drawer icon at top right
          IconButton(
            icon: const Icon(Icons.apps, color: Colors.black),
            onPressed: openDrawer,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Obx(() {
          if (cartController.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/playstore.png',
                    height: 280,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No items found.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'It looks like your cart is empty.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/home',
                          arguments: {'controller': 'controller'});
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
                      'Shop Now',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Swipe right to delete',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    final quantity =
                        cartController.productQuantities[item.id] ?? 1;

                    return Dismissible(
                      key: Key(item.id.toString()),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      // No background for the left swipe (no undo)
                      secondaryBackground: Container(
                        color: Colors.transparent, // No undo background
                      ),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          cartController.removeItemFromCart(item);

                          Get.snackbar(
                            'Item Removed',
                            '${item.title} has been removed from your cart.',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      direction: DismissDirection
                          .startToEnd, // Only right swipe allowed
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            Flexible(
                              child: FutureBuilder<String>(
                                future: _getImageUrl(item.image),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Image.asset(
                                      'assets/images/downloud.gif',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    );
                                  } else if (snapshot.hasError ||
                                      !snapshot.hasData) {
                                    return const Icon(Icons.error, size: 60);
                                  } else {
                                    return Image.network(
                                      snapshot.data!,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Price: Pkr ${item.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Quantity: $quantity',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Obx(() => Text(
                                        'Color: ${colorController.selectedColorName.value.isEmpty ? 'None' : colorController.selectedColorName.value}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black87),
                                      )),
                                ],
                              ),
                            ),
                            Text(
                              'Pkr ${(item.price * quantity).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Check out button should only show if cart is not empty
              if (cartController.cartItems.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  child: Obx(() {
                    return ElevatedButton(
                      onPressed: cartController.cartItems.isEmpty
                          ? null // Disable button if cart is empty
                          : () {
                              Get.to(() => const OrderDetailScreen());
                            },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: cartController.cartItems.isEmpty
                            ? Colors.grey // Use grey color when disabled
                            : const Color.fromARGB(255, 0, 0, 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Check out'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: cartController.cartItems.isEmpty
                              ? Colors.white54
                              : Colors
                                  .white, // Change text color based on state
                        ),
                      ),
                    );
                  }),
                ),
            ],
          );
        }),
      ),
    );
  }
}
