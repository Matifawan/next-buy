import 'package:flutter/material.dart';

import '../../model/helper/constants.dart';

class CartCounter extends StatefulWidget {
  final int initialNumOfItems;
  const CartCounter({
    super.key,
    this.initialNumOfItems = 1,
  });

  @override
  State<CartCounter> createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
  late int numOfItems;

  @override
  void initState() {
    super.initState();
    numOfItems =
        widget.initialNumOfItems; // Initialize numOfItems from the widget
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 40,
          height: 32,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            onPressed: () {
              setState(() {
                if (numOfItems > 1) {
                  numOfItems--;
                }
              });
            },
            child: const Icon(Icons.remove),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Text(
            // If our item count is less than 10, show 01, 02, etc.
            numOfItems.toString().padLeft(2, "0"),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          width: 40,
          height: 32,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            onPressed: () {
              setState(() {
                numOfItems++;
              });
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
