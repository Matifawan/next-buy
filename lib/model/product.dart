import 'package:flutter/material.dart';

class Product {
  final String image, title, description, category;
  final int price, size, id;
  final Color color;
  String selectedColor; // Add this line to store the selected color
  final bool isOnSale; // Add this property
  final String? subcategory; // Make subcategory optional

  Product({
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    required this.size,
    required this.id,
    required this.color,
    required this.category,
    this.subcategory, // Make subcategory optional
    this.selectedColor = '', // Default value is an empty string
    this.isOnSale = false, // Default value is false
  });

  factory Product.empty() {
    return Product(
      image: '',
      title: '',
      description: '',
      price: 0,
      size: 0,
      id: 0,
      color: Colors.transparent,
      category: '',
      subcategory: '', // Provide a default value for the subcategory
      selectedColor: '', // Provide a default value for the selectedColor
      isOnSale: false, // Provide a default value for isOnSale
    );
  }
}

// Dummy text for description
String dummyText = "Handbag with ample space and elegant design.";
//Noo.1
// Hand Bags
///////////////////////////////////////////////////////////////////////////////////
List<Product> products = [
  Product(
    id: 1,
    title: "AK-Y001",
    price: 2500,
    size: 12,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/assets/bag_1.png",
    color: const Color(0xFF3D82AE),
    category: "Hand Bags",
    subcategory: '',
  ),
  Product(
    id: 2,
    title: "AK-Y002",
    price: 2500,
    size: 8,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/assets/bag_5.png",
    color: const Color(0xFFFB7883),
    category: "Hand Bags",
    subcategory: '',
  ),
  Product(
    id: 3,
    title: "AK-Y003",
    price: 2500,
    size: 10,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/assets/bag_3.png",
    color: const Color(0xFF989493),
    category: "Hand Bags",
    subcategory: '',
  ),

  Product(
    id: 4,
    title: "AK-Y004",
    price: 2500,
    size: 9,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/assets/bag_4.png",
    color: const Color(0xFFE6B398),
    category: " Hand Bags",
    subcategory: '',
  ),
  Product(
    id: 5,
    title: "AK-Y005",
    price: 2500,
    size: 10,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/assets/bag_5.png",
    color: const Color(0xFFFB7883),
    category: "Hand Bags",
    subcategory: '',
  ),
  Product(
    id: 6,
    title: "Women-Y006",
    price: 2500,
    size: 12,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/assets/bag_6.png",
    color: const Color(0xFFAEAEAE),
    category: "Hand Bags",
    subcategory: '',
  ),
  Product(
    id: 7,
    title: "Semi-Y006",
    price: 2500,
    size: 12,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/raw/8.png",
    color: const Color(0xFFAEAEAE),
    category: "Hand Bags",
    subcategory: '',
  ),
////////////////////////////////////////////////////////////////////////////////////////
  Product(
    id: 8,
    title: "Men-Y006",
    price: 2500,
    size: 12,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/raw/9.png",
    color: const Color.fromARGB(255, 122, 2, 2),
    category: "Top Sales",
    subcategory: '',
  ),

  Product(
    id: 9,
    title: "AK-Y007",
    price: 3000,
    size: 15,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/raw/9.png",
    color: const Color(0xFFA29BFE),
    category: "Top Sales",
    subcategory: '',
  ),
  Product(
    id: 10,
    title: "AK-Y001",
    price: 3000,
    size: 15,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/extra/next.png",
    color: const Color(0xFFA29BFE),
    category: "Top Sales",
    subcategory: '',
  ),

  Product(
    id: 9,
    title: "Winter Collection",
    price: 4500,
    size: 16,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/assets/bag_1.png",
    color: const Color(0xFF8E44AD),
    category: "Top Articles",
    subcategory: '',
  ),
  // Dresses
  Product(
    id: 10,
    title: "Floral Dress",
    price: 5000,
    size: 10,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/assets/bag_1.png",
    color: const Color(0xFFAF7AC5),
    category: "Women",
    subcategory: 'Dresses',
  ),
  Product(
    id: 11,
    title: "Floral Dress",
    price: 5000,
    size: 10,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/extra/next.png",
    color: const Color.fromARGB(255, 255, 13, 13),
    category: "Men",
    subcategory: 'Hats',
  ),
  Product(
    id: 12,
    title: "Casual Dress",
    price: 3500,
    size: 11,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/assets/bag_1.png",
    color: const Color(0xFFD4E157),
    category: "Women",
    subcategory: 'Dresses',
  ),
  // Fragrance
  Product(
    id: 13,
    title: "Luxury pk-8",
    price: 7000,
    size: 5,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/assets/bag_1.png",
    color: const Color(0xFFE57373),
    category: "Women",
    subcategory: 'Dresses',
  ),
  Product(
    id: 14,
    title: "Rose Fragrance",
    price: 5500,
    size: 7,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/assets/bag_1.png",
    color: const Color(0xFF81C784),
    category: "Women",
    subcategory: 'Dresses',
  ),
];

// Additional Products
List<Product> additionalProducts = [
  Product(
    id: 15,
    title: "t-Suit",
    price: 4500,
    size: 10,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/men/4.png",
    color: const Color.fromARGB(255, 255, 13, 13),
    category: "Men",
    subcategory: 'Suits',
  ),
  Product(
    id: 16,
    title: "Stylish Hat",
    price: 500,
    size: 7,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/Subcategory/6.png",
    color: const Color(0xFF989493),
    category: "Men",
    subcategory: 'Hats',
  ),
  Product(
    id: 17,
    title: "Summer Dress",
    price: 3500,
    size: 8,
    description: dummyText,
    image: "assets/images/dress_1.png",
    color: const Color(0xFFE6B398),
    category: "Women",
    subcategory: 'Dresses',
  ),
  Product(
    id: 18,
    title: "Casual Top",
    price: 1500,
    size: 6,
    description: dummyText,
    image: "assets/images/top_1.png",
    color: const Color(0xFFFB7883),
    category: "Women",
    subcategory: 'Tops',
  ),
  Product(
    id: 19,
    title: "Leather Belt",
    price: 700,
    size: 5,
    description: dummyText,
    image: "assets/images/belt_1.png",
    color: const Color(0xFFAEAEAE),
    category: "Men",
    subcategory: 'Accessories',
  ),
];

///
// Additional T-Shirts
List<Product> additionalTShirts = [
  Product(
    id: 20,
    title: "Graphic T-Shirt",
    price: 1200,
    size: 12,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/men/t shrts/t-shirt mockup.png",
    color: const Color.fromARGB(255, 66, 149, 68),
    category: "Men",
    subcategory: "T-Shirts",
  ),
  Product(
    id: 21,
    title: "Plain Shirt",
    price: 800,
    size: 10,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/men/t shrts/t-shirt-1.png",
    color: const Color.fromARGB(232, 232, 152, 60),
    category: "Men",
    subcategory: "T-Shirts",
  ),
  Product(
    id: 22,
    title: "V-Neck Shirt",
    price: 1000,
    size: 11,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/men/t shrts/t-shirt-2.png",
    color: const Color(0xFFE6B398),
    category: "Men",
    subcategory: "T-Shirts",
  ),
];

// Additional Category 'Women'
List<Product> additionalWomenProducts = [
  Product(
    id: 23,
    title: "Winter Scarf",
    price: 600,
    size: 7,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/Subcategory/12.png",
    color: const Color(0xFFFB7883),
    category: "Women",
    subcategory: "Accessories",
  ),
  Product(
    id: 24,
    title: "Denim Jacket",
    price: 3000,
    size: 9,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/women/2.png",
    color: const Color(0xFFAEAEAE),
    category: "Women",
    subcategory: "Jackets",
  ),
  Product(
    id: 25,
    title: "Chic Blouse",
    price: 2000,
    size: 8,
    description: dummyText,
    image: "assets/images/blouse_1.png",
    color: const Color(0xFFD3A984),
    category: "Women",
    subcategory: "Tops",
  ),
];

// Category 'Kids'
List<Product> kidsProducts = [
  Product(
    id: 26,
    title: "Kids Dress",
    price: 1500,
    size: 6,
    description: dummyText,
    image: "assets/images/kids_dress_1.png",
    color: const Color(0xFF3D82AE),
    category: "Kids",
    subcategory: "Dresses",
  ),
  Product(
    id: 27,
    title: "Kids Hat",
    price: 500,
    size: 3,
    description: dummyText,
    image: "assets/images/kids_hat_1.png",
    color: const Color(0xFF989493),
    category: "Kids",
    subcategory: "Hats",
  ),
  Product(
    id: 28,
    title: "Kids Shoes",
    price: 1200,
    size: 5,
    description: dummyText,
    image: "assets/images/kids_shoes_1.png",
    color: const Color(0xFFE6B398),
    category: "Kids",
    subcategory: "Shoes",
  ),
];

// Additional Product IDs up to 36
List<Product> additionalCategoryProducts = [
  Product(
    id: 29,
    title: "Men Jacket",
    price: 2500,
    size: 11,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/men/7.png",
    color: const Color.fromARGB(255, 255, 13, 13),
    category: "Men",
    subcategory: "Jackets",
  ),
  Product(
    id: 30,
    title: "Casual Hat",
    price: 500,
    size: 8,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/Subcategory/8.png",
    color: const Color(0xFFD3A984),
    category: "Men",
    subcategory: "Hats",
  ),
  Product(
    id: 31,
    title: "Formal Shoes",
    price: 3500,
    size: 10,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/men/9.png",
    color: const Color(0xFF3D82AE),
    category: "Men",
    subcategory: "Shoes",
  ),
  Product(
    id: 32,
    title: "Winter Coat",
    price: 5000,
    size: 12,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/women/4.png",
    color: const Color.fromARGB(255, 255, 153, 0),
    category: "Women",
    subcategory: "Coats",
  ),
  Product(
    id: 33,
    title: "Casual Pants",
    price: 2000,
    size: 11,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/men/3.png",
    color: const Color(0xFF9C27B0),
    category: "Men",
    subcategory: "Pants",
  ),
  Product(
    id: 34,
    title: "Kids Jacket",
    price: 1800,
    size: 6,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/kids/2.png",
    color: const Color(0xFF81C784),
    category: "Kids",
    subcategory: "Jackets",
  ),
  Product(
    id: 35,
    title: "Kids Boots",
    price: 1500,
    size: 5,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/kids/5.png",
    color: const Color.fromARGB(255, 255, 128, 0),
    category: "Kids",
    subcategory: "Shoes",
  ),
  Product(
    id: 36,
    title: "Women Heels",
    price: 2200,
    size: 7,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/women/1.png",
    color: const Color(0xFFE57373),
    category: "Women",
    subcategory: "Shoes",
  ),
  //
];

List<Product> salesProducts = [
  Product(
    id: 1,
    title: "AK-Y012",
    price: 2500,
    size: 12,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/raw/9.png",
    color: const Color(0xFF3D82AE),
    category: "",
    isOnSale: true,
  ),
  Product(
    id: 2, // Change the ID to be unique
    title: "AK-Y002",
    price: 3500,
    size: 14,
    description: dummyText,
    image: "gs://next-buy-7452f.appspot.com/raw/8.png",
    color: const Color(0xFF3D82AE),
    category: "",

    isOnSale: true,
  ),
  //
];
