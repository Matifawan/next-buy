import 'package:flutter/material.dart';

import 'package:next_buy/Screens/components/body.dart';
import 'package:next_buy/model/product.dart';

class DetailsScreen extends StatelessWidget {
  final Product product;

  const DetailsScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: product.color,
      body: Body(
        product: product,
      ),
    );
  }
}
