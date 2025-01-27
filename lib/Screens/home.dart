import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_buy/Screens/views/attachments/filterScreen/contan1.dart';
import 'package:next_buy/app/modules/home/controllers/home_controller.dart';
import 'package:next_buy/app/modules/home/controllers/cart_controller.dart';
import 'package:next_buy/Screens/views/attachments/bottomnavigationbar.dart';
import 'package:next_buy/Screens/components/category.dart';
import 'package:next_buy/Screens/components/crouser.dart';
import 'package:next_buy/Screens/components/itemcard.dart';
import 'package:next_buy/Screens/components/likesscreen.dart';
import 'package:next_buy/Screens/components/search.dart';
import 'package:next_buy/model/helper/constants.dart';
import 'package:next_buy/Screens/views/detailscreen.dart';
import 'package:next_buy/model/product.dart';
import 'views/attachments/appdrawer.dart';
import 'views/attachments/cart.dart';
import 'views/attachments/container.dart';
import 'views/attachments/containerwidget2.dart';

class Home extends StatefulWidget {
  final HomeController? homeController;

  const Home({super.key, this.homeController});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeController get controller =>
      widget.homeController ?? Get.find<HomeController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedCategory = 'Hand Bags';
  final BottomNavController bottomNavController =
      Get.put(BottomNavController());

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<LikesController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        automaticallyImplyLeading: false, // Prevents default leading behavior
        titleSpacing: 0, // Removes extra space before the title
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.start, // Align items to the start
          crossAxisAlignment:
              CrossAxisAlignment.center, // Vertically align items
          children: [
            IconButton(
              icon: const Icon(Icons.apps, color: Colors.black),
              onPressed: _openDrawer,
            ),
            Image.asset('assets/images/playstore.png', height: 40),
            const SizedBox(width: 4), // Add a small spacing if needed
            const Text(
              'NextBuy',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            child: InkWell(
              onTap: () {
                Get.to(() => CartScreen(product: products.first));
              },
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_bag_outlined,
                        size: 35, color: Colors.grey),
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Text(
                        'Cart',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Search(allProducts: products),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SliderWidget(
                    allProducts: [
                      ...products,
                      ...additionalProducts,
                      ...additionalTShirts,
                      ...additionalWomenProducts,
                      ...kidsProducts,
                      ...additionalCategoryProducts,
                    ],
                    saleProducts: salesProducts,
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'SHOP BY POPULAR',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Category(
                    onCategorySelected: (category) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: kDefaultPadding,
                        crossAxisSpacing: kDefaultPadding,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: _filteredProducts().isEmpty
                          ? 1
                          : _filteredProducts().length,
                      itemBuilder: (context, index) {
                        final filteredProducts = _filteredProducts();
                        if (filteredProducts.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/onboding2.png',
                                    height: 180),
                                const SizedBox(height: 5),
                                const Text('Coming Soon!',
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          );
                        }
                        return ItemCard(
                          product: filteredProducts[index],
                          press: () {
                            Get.to(DetailsScreen(
                                product: filteredProducts[index]));
                          },
                          onAddToCart: (Product p1) {},
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 2),
                  const SizedBox(
                    height: 1,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(1.0),
                    child: ContainerWidget(),
                  ),
                  //
                  const SizedBox(height: 2),
                  const SizedBox(
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ContainerWidget1(),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(
                    height: 1,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(1.0),
                    child: ContainerWidget2(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return CustomBottomNavigationBar(
          currentIndex: bottomNavController.selectedIndex.value,
          onTap: (index) {
            bottomNavController.changeIndex(index);
            switch (index) {
              case 0:
                Get.toNamed('/home', arguments: controller);
                break;
              case 1:
              case 2:
                _openDrawer();
                break;
              case 3:
                Get.to(() => LikesScreen(
                      product: products.first,
                      onAddToCart: (Product product) {
                        Get.find<CartController>().addProduct(product);
                      },
                      onBuyNow: (Product product) {},
                    ));
                break;
            }
          },
          product: products.first,
          openDrawer: _openDrawer,
          onAddToCart: (Product product) {
            Get.find<CartController>().addProduct(product);
          },
          onBuyNow: (Product product) {},
        );
      }),
    );
  }

  List<Product> _filteredProducts() {
    if (selectedCategory == 'Top Sales') return products;
    return products.where((p) => p.category == selectedCategory).toList();
  }
}
