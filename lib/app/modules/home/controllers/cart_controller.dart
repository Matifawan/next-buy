import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_buy/Screens/views/attachments/appdrawer.dart';
import 'package:next_buy/model/product.dart';

class CartController extends GetxController {
  var cartItems = <Product>[].obs;
  int get cartItemCount => cartItems.length;
  var productQuantities = <int, int>{}.obs;

  void addItemToCart(Product product) {
    if (productQuantities.containsKey(product.id)) {
      productQuantities[product.id] = productQuantities[product.id]! + 1;
    } else {
      cartItems.add(product);
      productQuantities[product.id] = 1;
    }
    update();
  }

  void removeItemFromCart(Product product) {
    if (productQuantities.containsKey(product.id)) {
      if (productQuantities[product.id]! > 1) {
        productQuantities[product.id] = productQuantities[product.id]! - 1;
      } else {
        productQuantities.remove(product.id);
        cartItems.remove(product);
      }
    }
    update();
  }

  double getTotalPrice() {
    return cartItems.fold(0, (total, item) {
      int quantity = productQuantities[item.id] ?? 1;
      return total + item.price * quantity;
    });
  }

  void addProduct(Product product) {
    if (!cartItems.contains(product)) {
      cartItems.add(product);
    }
    productQuantities[product.id] = (productQuantities[product.id] ?? 0) + 1;
  }

  void removeItem(int index) {
    final productId = cartItems[index].id;
    cartItems.removeAt(index);
    productQuantities.remove(productId);
  }

  void clearCart() {
    cartItems.clear();
    productQuantities.clear();
  }

  void updateQuantity(int index, int change) {
    int productId = cartItems[index].id;
    int newQuantity = (productQuantities[productId] ?? 1) + change;
    if (newQuantity > 0) {
      productQuantities[productId] = newQuantity;
    } else {
      removeItem(index);
    }
  }

  List<Product> get items => cartItems;
}

class ColorController extends GetxController {
  var selectedColor = Colors.transparent.obs;
  var selectedColorName = ''.obs;
  var colorQuantities = <Color, int>{}.obs;

  void selectColor(Color color, String colorName) {
    selectedColor.value = color;
    selectedColorName.value = colorName;
    colorQuantities[color] = (colorQuantities[color] ?? 0) + 1;
  }

  int getColorQuantity(Color color) {
    return colorQuantities[color] ?? 0;
  }
}

//..........................................................
class LikesController extends GetxController {
  var likedItems = <Product>[].obs;
  var recentlyRemovedItem = Rx<Product?>(null);

  int get likedItemCount => likedItems.length;

  void toggleLike(Product product) {
    if (likedItems.contains(product)) {
      likedItems.remove(product);
    } else {
      likedItems.add(product);
    }
  }

  bool isLiked(Product product) {
    return likedItems.contains(product);
  }

  void removeProduct(Product product) {
    likedItems.remove(product);
    recentlyRemovedItem.value = product;
  }

  void undoRemove() {
    final product = recentlyRemovedItem.value;
    if (product != null) {
      likedItems.add(product);
      recentlyRemovedItem.value = null;
    }
  }

  void addProduct(Product likedProduct) {
    if (!likedItems.contains(likedProduct)) {
      likedItems.add(likedProduct);
    }
  }
}

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  // You can also create a getter for the current index if needed
  int get currentIndex => selectedIndex.value;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}

class FilterController extends GetxController {
  var selectedFilter = 'All'.obs;
  var displayedProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    displayedProducts
        .assignAll(allProducts); // Assume allProducts is defined somewhere
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    updateDisplayedProducts();
  }

  void updateDisplayedProducts() {
    if (selectedFilter.value == 'All') {
      displayedProducts.assignAll(allProducts);
    } else {
      displayedProducts.assignAll(
        allProducts
            .where((product) => product.category == selectedFilter.value)
            .toList(),
      );
    }
    update();
  }

  void addProduct(Product product) {
    displayedProducts.add(product);
  }

  void removeProduct(Product product) {
    displayedProducts.remove(product);
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
    updateDisplayedProducts();
  }
}

class TrackController extends GetxController {
  var trackItems = <Product>[].obs;

  bool get isEmpty => trackItems.isEmpty;

  void addProduct(Product product) {
    trackItems.add(product);
  }

  void removeProduct(Product product) {
    trackItems.remove(product);
  }

  void clearAll() {
    trackItems.clear();
  }

  int get count => trackItems.length;

  bool containsProduct(Product product) {
    return trackItems.contains(product);
  }
}
