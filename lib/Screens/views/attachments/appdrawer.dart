import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:next_buy/app/routes/app_routes.dart';
import 'package:next_buy/model/product.dart';
import 'filterScreen/product_screen.dart';

// Dummy data for allProducts; replace with your actual data source
List<Product> allProducts = []; // Ensure this is populated with actual data

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  // Method to get the currently logged-in user
  Future<User?> _getUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  String selectedOption = 'Category'; // Initialize with default option
  String? expandedCategory; // Nullable type

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeaderOption('Category', 'assets/images/menu.png'),
                _buildHeaderOption('Shop', 'assets/images/add-to-basket.png'),
                _buildHeaderOption('Profile', 'assets/images/setting.png'),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                child: _buildBodyContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderOption(String option, String imagePath) {
    final bool isSelected = selectedOption == option;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = option;
          expandedCategory = null;
        });
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.asset(
                  imagePath,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    );
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.grey[600],
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4.0),
              height: 2.0,
              width: 60.0,
              color: Colors.black,
            ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    if (selectedOption == 'Category') {
      return ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildCategoryList([
            {'text': 'Men'},
            {'text': 'Women'},
            {'text': 'Kids'},
            {'text': 'Unstitched'},
            {'text': 'Sale'},
            {'text': 'Home'}
          ]),
        ],
      );
    } else if (selectedOption == 'Shop') {
      return _buildOptionList([
        {'icon': Icons.shop, 'text': 'Coming Soon'},
        {'icon': Icons.local_offer, 'text': 'Need Help'},
      ]);
    } else if (selectedOption == 'Profile') {
      return _buildOptionList([
        {'icon': Icons.person, 'text': 'Account'},
      ]);
    } else {
      return const Text(
        'Select an option above',
        style: TextStyle(fontSize: 16, color: Colors.black),
      );
    }
  }

  Widget _buildCategoryList(List<Map<String, dynamic>> categories) {
    return Column(
      children: categories.map((category) {
        final isExpanded = expandedCategory == category['text'];
        final isSelected = expandedCategory == category['text'];
        return Column(
          children: [
            Container(
              color: isSelected
                  ? const Color.fromARGB(255, 246, 207, 207).withOpacity(0.2)
                  : Colors.transparent,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                title: Text(
                  category['text'],
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                trailing: Icon(
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 30,
                  color: Colors.black,
                ),
                onTap: () {
                  setState(() {
                    expandedCategory = isExpanded ? null : category['text'];
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isExpanded ? 200 : 0,
              width: double.infinity,
              color: const Color.fromARGB(255, 255, 247, 247),
              child: ListView(
                padding: EdgeInsets.zero,
                children: _getSubCategoryList(category['text']),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

//

//
  List<Widget> _getSubCategoryList(String category) {
    List<Map<String, dynamic>> subCategories;

    switch (category) {
      case 'Men':
        subCategories = [
          {'icon': Icons.style, 'text': 'T-Shirts'},
          {'icon': Icons.accessibility, 'text': 'Suits'},
          {'icon': Icons.heat_pump, 'text': 'Hats'},
        ];
        break;
      case 'Women':
        subCategories = [
          {'icon': Icons.style, 'text': 'Dresses'},
          {'icon': Icons.accessibility_new, 'text': 'Tops'},
          {'icon': Icons.bolt, 'text': 'Skirts'},
        ];
        break;
      case 'Kids':
        subCategories = [
          {'icon': Icons.child_care, 'text': 'Kids Wear'},
          {'icon': Icons.toys, 'text': 'Toys'},
        ];
        break;
      case 'Unstitched':
        subCategories = [
          {'icon': Icons.child_care, 'text': 'Summer'},
          {'icon': Icons.toys, 'text': 'Winter'},
        ];
        break;
      case 'Sale':
        subCategories = [
          {'icon': Icons.child_care, 'text': 'Summe 2024'},
          {'icon': Icons.toys, 'text': 'WinterClose'},
        ];
        break;
      case 'Home':
        subCategories = [
          {'icon': Icons.child_care, 'text': 'Rugs'},
          {'icon': Icons.toys, 'text': 'Curtains'},
        ];
        break;
      default:
        subCategories = [];
    }
//
    return subCategories.map((subCategory) {
      return ListTile(
        leading: Icon(subCategory['icon']),
        title: Text(subCategory['text']),
        onTap: () {
          final filteredProducts = _getProductsByCategory(category,
              subcategory: subCategory['text']);

          Get.to(() => ProductScreen(
                category: category,
                allProducts: filteredProducts, // Pass filtered products
                onAddToCart: (product) {
                  // Handle add to cart functionality
                },
                filteredProducts: filteredProducts, // Pass filtered products
                press: () {}, product: null, saleProducts: const [],
              ));
        },
      );
    }).toList();
  }
//

// Define a widget to build the option list
  Widget _buildOptionList(List<Map<String, dynamic>> options) {
    return Column(
      children: options.map((option) {
        if (option['text'] == 'Account') {
          return FutureBuilder<User?>(
            future: _getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person, size: 20),
                  ),
                  title: Text('Loading...',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Please wait'),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                final user = snapshot.data!;

                // Fetch the profile image URL using another FutureBuilder
                return FutureBuilder<String?>(
                  future: getUserProfileImageUrl(user.uid),
                  builder: (context, imageSnapshot) {
                    if (imageSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const ListTile(
                        leading: CircleAvatar(
                          child: CircularProgressIndicator(),
                        ),
                        title: Text('Loading...',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      );
                    } else {
                      // Display the avatar or fallback initials if no image URL is found
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: imageSnapshot.hasData &&
                                  imageSnapshot.data != null
                              ? NetworkImage(imageSnapshot.data!)
                              : null,
                          backgroundColor: imageSnapshot.data == null
                              ? Colors.blueGrey
                              : Colors.transparent,
                          child: imageSnapshot.data == null
                              ? Text(
                                  user.displayName != null &&
                                          user.displayName!.isNotEmpty
                                      ? user.displayName![0].toUpperCase()
                                      : user.email != null &&
                                              user.email!.isNotEmpty
                                          ? user.email![0].toLowerCase()
                                          : '?',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              : null,
                        ),
                        subtitle: const Text(
                          'Welcome back! User',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Get.snackbar(
                              'Logged Out',
                              'You have successfully logged out.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                            Get.offAllNamed(Routes.home);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                          child: const Text('Logout',
                              style: TextStyle(color: Colors.white)),
                        ),
                      );
                    }
                  },
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(1),
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.grey.shade200,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(2.0),
                      onTap: () {
                        Get.toNamed(Routes.login);
                      },
                      child: ListTile(
                        leading: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.person,
                                size: 30, color: Colors.white),
                          ),
                        ),
                        title: const Text(
                          'Welcome, Guest!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          'Please log in to continue',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          );
        } else {
          return ListTile(
            leading: Icon(option['icon']),
            title: Text(option['text']),
            onTap: () {
              if (option['text'] == 'COMING SOON') {
                // Navigation logic
              } else if (option['text'] == 'Need Help') {}
            },
          );
        }
      }).toList(),
    );
  }

// Function to retrieve the image URL from Firebase
  Future<String?> getUserProfileImageUrl(String userId) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');
      return await storageRef.getDownloadURL();
    } catch (e) {
      return null; // Return null if there is no image or an error occurs
    }
  }

// Retrieve products by category with optional subcategory filtering
  List<Product> _getProductsByCategory(String category, {String? subcategory}) {
    List<Product> combinedProducts = [
      ...allProducts,
      ...additionalProducts,
      ...additionalTShirts,
    ];

    return combinedProducts.where((product) {
      final matchesCategory = product.category == category;
      final matchesSubcategory = subcategory != null && subcategory.isNotEmpty
          ? product.subcategory == subcategory
          : true;

      return matchesCategory && matchesSubcategory;
    }).toList();
  }

// Need Help Screen definition
}
