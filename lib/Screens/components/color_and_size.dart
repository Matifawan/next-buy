import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_buy/app/modules/home/controllers/cart_controller.dart';

import 'package:next_buy/model/helper/constants.dart';
import 'package:next_buy/model/product.dart';

// ColorDot widget remains the same
class ColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorDot({
    super.key,
    required this.color,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.all(2.5),
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

// Updated ColorAnSize widget
class ColorAnSize extends StatelessWidget {
  const ColorAnSize({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final ColorController colorController = Get.find<ColorController>();

    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Color',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                Row(
                  children: <Widget>[
                    Obx(() => ColorDot(
                          color: const Color(0xFF356C95),
                          isSelected: colorController.selectedColor.value ==
                              const Color(0xFF356C95),
                          onTap: () => colorController.selectColor(
                              const Color(0xFF356C95), 'Blue'),
                        )),
                    Obx(() => ColorDot(
                          color: const Color(0xFFF8C078),
                          isSelected: colorController.selectedColor.value ==
                              const Color(0xFFF8C078),
                          onTap: () => colorController.selectColor(
                              const Color(0xFFF8C078), 'Yellow'),
                        )),
                    Obx(() => ColorDot(
                          color: const Color(0xFFA29B9B),
                          isSelected: colorController.selectedColor.value ==
                              const Color(0xFFA29B9B),
                          onTap: () => colorController.selectColor(
                              const Color(0xFFA29B9B), 'Gray'),
                        )),
                  ],
                ),
                Obx(() => Text(
                      'Selected Color: ${colorController.selectedColorName.value}', // Display selected color name
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                    )),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.topRight,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: kTextColor),
                children: [
                  const TextSpan(text: "Size\n"),
                  TextSpan(
                    text: "${product.size} cm",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
