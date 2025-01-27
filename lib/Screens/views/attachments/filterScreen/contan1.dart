import 'package:flutter/material.dart';

class ContainerWidget1 extends StatelessWidget {
  final List<String> images = [
    'assets/images/4.png',
    'assets/images/8.png',
    'assets/images/9.png',
    'assets/images/10.png',
    'assets/images/11.png',
    'assets/images/14.png',
    'assets/images/15.png',
    'assets/images/17.png',
    'assets/images/5.png',
    'assets/images/c.png',
    'assets/images/1.png',
    'assets/images/bed.png',
  ];

  final PageController _pageController = PageController();

  ContainerWidget1({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fashion Products',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              GestureDetector(
                onTap: () {
                  // Add your navigation or action logic here
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: screenHeight * 0.4, // Adjust height dynamically
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: SizedBox(
                      child: Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                },
              ),
              // Left navigation indicator
              Positioned(
                top: 0,
                bottom: 0,
                left: 0, // Aligns to the left edge
                child: GestureDetector(
                  onTap: () {
                    if (_pageController.page!.toInt() > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 100, // Adjust the size
                    color:
                        Colors.white.withOpacity(0.3), // For darker backgrounds
                  ),
                ),
              ),
              // Right navigation indicator
              Positioned(
                top: 0,
                bottom: 0,
                right: 0, // Aligns to the right edge
                child: GestureDetector(
                  onTap: () {
                    if (_pageController.page!.toInt() < images.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 110, // Adjust the size
                    color: Colors.tealAccent
                        .withOpacity(0.5), // For darker backgrounds
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
