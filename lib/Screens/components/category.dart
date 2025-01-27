import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  final ValueChanged<String> onCategorySelected;

  const Category({super.key, required this.onCategorySelected});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final List<String> categories = [
    'Hand Bags',
    'Top Sales',
    'Unstiched',
    'Dresses',
    'Top Sales',
    'Unstiched',
    'Dresses',
    'Hand Bags',
    'Top weeks',
    'Unstiched',
    'Dresses',
    'Kids-New',
    'Summer',
    'Formal',
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget
                  .onCategorySelected(categories[index]); // Pass category name
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.black
                            : Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: const Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 2.0),
                        height: 2,
                        width: 30,
                        color: Colors.black,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
