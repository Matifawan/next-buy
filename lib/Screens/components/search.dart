import 'package:flutter/material.dart';
import 'package:next_buy/Screens/views/attachments/filterScreen/filtersacreen.dart';
import 'package:next_buy/model/product.dart'; // Adjust the import based on your project structure
import 'package:firebase_storage/firebase_storage.dart'; // Assuming Firebase is used for image storage
import 'package:flutter/foundation.dart'; // For kDebugMode

class Search extends StatefulWidget {
  final List<Product> allProducts;

  const Search({super.key, required this.allProducts});

  @override
  // ignore: library_private_types_in_public_api
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final query = _searchController.text;
      setState(() {
        if (query.isEmpty) {
          _filteredProducts = [];
          _isSearching = false;
        } else {
          _filteredProducts = widget.allProducts
              .where((product) =>
                  product.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
          _isSearching = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onProductTap(String keyword) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterScreen(
          initialProducts: widget.allProducts,
          category: keyword, // Pass the keyword to FilterScreen
          onAddToCart: (Product product) {
            // Implement cart functionality here
          },
          press: () {},
        ),
      ),
    );
  }

  void _onSearchIconTap() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FilterScreen(
            initialProducts: widget.allProducts,
            category: query, // Pass the keyword to FilterScreen
            onAddToCart: (Product product) {
              // Implement cart functionality here
            },
            press: () {},
          ),
        ),
      );
    }
  }

  Future<String> _getImageUrl(String imagePath) async {
    try {
      if (imagePath.startsWith('gs://')) {
        final ref = FirebaseStorage.instance.refFromURL(imagePath);
        return await ref.getDownloadURL();
      } else {
        return imagePath; // Assuming it's already a valid URL or local path
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting download URL: $e");
      }
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard on tap
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.centerRight, // Align the icon to the right
              children: [
                TextField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Search Product... upto 30 %Off',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                Positioned(
                  right: 0, // Aligns the container with the right edge
                  child: GestureDetector(
                    onTap: _onSearchIconTap, // Call the search tap handler
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black, // Black box around the icon
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(10), // Icon padding
                      child: const Icon(
                        Icons.search,
                        color: Colors.white, // White icon for contrast
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _isSearching && _filteredProducts.isNotEmpty
                ? SizedBox(
                    height: 200, // Adjust the height as needed
                    child: ListView.builder(
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          leading: FutureBuilder<String>(
                            future: _getImageUrl(product.image),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError ||
                                  snapshot.data == null ||
                                  snapshot.data!.isEmpty) {
                                return const Icon(Icons.error);
                              } else {
                                return Image.network(
                                  snapshot.data!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              }
                            },
                          ),
                          title: Text(
                            product.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          tileColor: Colors.grey[200], // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onTap: () => _onProductTap(product.category),
                        );
                      },
                    ),
                  )
                : _isSearching
                    ? DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey[
                              200], // Optional: background color for the message box
                          borderRadius: BorderRadius.circular(
                              10), // Optional: rounded corners
                          boxShadow: const [
                            // Optional: shadow effect
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color:
                                    Color.fromARGB(255, 255, 0, 0), // Red color
                                size: 40,
                              ),
                              SizedBox(
                                  height: 6), // Space between icon and text
                              Text(
                                'No results found. Try another keyword for view or Tap.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Color.fromARGB(
                                      255, 0, 0, 0), // Black color
                                  fontSize:
                                      13, // Adjusted font size for better readability
                                ),
                                textAlign:
                                    TextAlign.center, // Center align the text
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
