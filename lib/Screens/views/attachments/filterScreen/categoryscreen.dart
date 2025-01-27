import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Category 1'),
            onTap: () {
              Navigator.pop(context, 'Category 1');
            },
          ),
          ListTile(
            title: const Text('Category 2'),
            onTap: () {
              Navigator.pop(context, 'Category 2');
            },
          ),
          // Add more categories
        ],
      ),
    );
  }
}
