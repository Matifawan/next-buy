import 'package:flutter/material.dart';
import 'package:next_buy/model/helper/constants.dart';
import 'package:next_buy/model/product.dart';

class Discription extends StatelessWidget {
  const Discription({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Text(
        product.description,
        style: const TextStyle(height: 1.5),
      ),
    );
  }
}
