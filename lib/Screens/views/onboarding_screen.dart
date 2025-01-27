import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_buy/app/modules/home/controllers/home_controller.dart';
import 'package:next_buy/Screens/home.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int currentIndex = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goToPreviousPage() {
    if (currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBarWidget(
            backButton: currentIndex > 0,
            updateCallback: _goToPreviousPage,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center the content
                    children: [
                      // Image section
                      Center(
                        child: Image.asset(
                          contents[i].image,
                          height: screenHeight * 0.60,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(
                          height: 10), // Space between image and text
                      // Title section
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 11.0), // Horizontal padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/playstore.png', // Replace with your logo asset
                              height: 40, // Adjust height to fit with text
                            ),
                            Text(
                              contents[i].title,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 28, // Font size for better visibility
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          height: 4), // Space between title and description
                      // Description section
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0), // Horizontal padding
                        child: Text(
                          contents[i].description,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign
                              .center, // Ensure the description is centered
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              contents.length,
              (index) => buildDots(index, context),
            ),
          ),
          Container(
            margin: EdgeInsets.all(screenWidth * 0.1),
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: ElevatedButton(
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Home(
                        homeController: Get.find<HomeController>(),
                      ),
                    ),
                  );
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                elevation: 0, // Removed shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                currentIndex == contents.length - 1
                    ? 'Get Started'
                    : 'Continue',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildDots(int index, BuildContext context) {
    return Container(
      height: 6,
      width: index == currentIndex ? 10 : 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: currentIndex == index
              ? const Color.fromARGB(255, 0, 0, 0)
              : const Color.fromARGB(255, 43, 172, 0)),
    );
  }
}

class UnboardingContent {
  final String title;
  final String image;
  final String description;

  UnboardingContent({
    required this.title,
    required this.image,
    required this.description,
  });
}

List<UnboardingContent> contents = [
  UnboardingContent(
    title: 'Easy Shopping',
    image: 'assets/images/onboding1.png',
    description: 'Enjoy a seamless shopping experience with exclusive deals.',
  ),
  UnboardingContent(
    title: 'Wide Range',
    image: 'assets/images/z.png',
    description: 'Shop effortlessly with a wide selection of products.',
  ),
  UnboardingContent(
    title: 'Best Prices',
    image: 'assets/images/on1.png',
    description:
        'Get premium products at unbeatable prices with every purchase.',
  ),
];

class CustomAppBarWidget extends StatelessWidget {
  final bool backButton;
  final VoidCallback updateCallback;

  const CustomAppBarWidget({
    super.key,
    required this.backButton,
    required this.updateCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Positioning the logo to the right
            children: [
              if (backButton)
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 16, 21, 23),
                  radius: 19,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: updateCallback,
                  ),
                ),
              // Adding the app logo to the top-right corner
            ],
          ),
        ),
      ),
    );
  }
}
