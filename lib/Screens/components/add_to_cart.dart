import 'package:flutter/material.dart';
import 'package:next_buy/model/product.dart';

class AddToCart extends StatelessWidget {
  const AddToCart({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  final Product product;
  final Function(Product) onAddToCart;
  final Function(Product) onBuyNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center, // Center the button in the container
      child: SizedBox(
        width: double.infinity, // Make the button stretch to full width
        child: ElevatedButton(
          onPressed: () {
            onBuyNow(product);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            padding: const EdgeInsets.all(6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            'BUY NOW'.toUpperCase(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}
