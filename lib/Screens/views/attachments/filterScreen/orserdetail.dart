// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:next_buy/app/modules/home/controllers/cart_controller.dart';
import 'package:next_buy/app/modules/home/controllers/home_controller.dart';
import 'package:next_buy/app/routes/app_routes.dart';
import 'package:next_buy/model/product.dart';

class OrderDetailScreen extends StatefulWidget {
  final HomeController? homeController;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? paymentMethod;
  final List<Product>? cartItems;

  const OrderDetailScreen({
    super.key,
    this.homeController,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.paymentMethod,
    this.cartItems,
  });

  @override
  // ignore: library_private_types_in_public_api
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final CartController cartController = Get.find<CartController>();
  final ColorController colorController = Get.find<ColorController>();

  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String _paymentMethod = 'credit_card';

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name ?? '';
    _emailController.text = widget.email ?? '';
    _phoneController.text = widget.phone ?? '';
    _addressController.text = widget.address ?? '';
    _paymentMethod = widget.paymentMethod ?? 'credit_card';

    if (widget.cartItems != null) {
      cartController.cartItems.assignAll(widget.cartItems!);
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String generateOrderTrackingNumber() {
    return "NEXT${DateTime.now().millisecondsSinceEpoch}";
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

  void _confirmOrder() {
    if (_formKey.currentState?.validate() ?? false) {
      if (cartController.cartItems.isEmpty) {
        return;
      }

      try {
        final orderDetails = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Order Receipt',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(color: Colors.black54),
            SizedBox(
              // Replaced Expanded with a Container or SizedBox
              height: 200, // Adjust the height as needed
              child: cartController.cartItems.isEmpty
                  ? const Center(child: Text("No items in the cart"))
                  : ListView.builder(
                      itemCount: cartController.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartController.cartItems[index];
                        final quantity =
                            cartController.productQuantities[item.id] ?? 1;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: FutureBuilder<String>(
                                  future: _getImageUrl(item.image),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Image.asset(
                                        'assets/images/downloud.gif',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      );
                                    } else if (snapshot.hasError ||
                                        !snapshot.hasData) {
                                      return const Icon(Icons.error, size: 60);
                                    } else {
                                      return Image.network(
                                        snapshot.data!,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      );
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Price: Pkr ${item.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      'Quantity: $quantity',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Obx(() => Text(
                                          'Color: ${colorController.selectedColorName.value.isEmpty ? 'None' : colorController.selectedColorName.value}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black87),
                                        )),
                                  ],
                                ),
                              ),
                              Text(
                                'Pkr ${(item.price * quantity).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );

        final totalPrice = cartController.getTotalPrice();

        // Navigate to OrderConfirmationScreen with all necessary details
        Get.to(() => OrderConfirmationScreen(
              orderDetails: orderDetails,
              totalPrice: totalPrice,
              name: _nameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
              address: _addressController.text,
              paymentMethod: _paymentMethod,
            ))?.then((_) {
          // Clear the cart after navigating to avoid premature clearing
          cartController.clearCart();
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Pay Now!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: [
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 3.0,
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildOrderDetails(),
              const SizedBox(height: 32),
              _buildUserDetailsForm(),
              const SizedBox(height: 24),
              _buildPaymentMethodSection(),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: _confirmOrder,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Pay Now'.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Details',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.black54),
          SizedBox(
            height: 110,
            child: ListView.builder(
              itemCount: cartController.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartController.cartItems[index];
                final quantity = cartController.productQuantities[item.id] ?? 1;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      FutureBuilder<String>(
                        future: _getImageUrl(item.image),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Image.asset(
                              'assets/images/downloud.gif',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            );
                          } else if (snapshot.hasError || !snapshot.hasData) {
                            return const Icon(Icons.error, size: 60);
                          } else {
                            return Image.network(
                              snapshot.data!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Price: \$${item.price}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Quantity: $quantity',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Color: ${colorController.selectedColorName}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.black54),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(color: Colors.black54),
              Obx(() {
                double totalPrice = cartController.getTotalPrice();
                return Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserDetailsForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Name input
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            autofocus: true, // Automatically focus this field
          ),
          const SizedBox(height: 16),
          // Email input
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              // Email validation regex
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            onChanged: (value) {
              // Auto-formatting email input (optional)
              _emailController.text = value.trim();
              _emailController.selection = TextSelection.fromPosition(
                TextPosition(offset: _emailController.text.length),
              );
            },
          ),
          const SizedBox(height: 16),
          // Phone number input
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '+92 300 123 4567',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              // Phone number validation regex for Pakistan
              final phoneRegex = RegExp(r'^\+92[0-9]{10}$');
              if (!phoneRegex.hasMatch(value)) {
                return 'Please enter a valid phone number in the format +92';
              }
              return null;
            },
            inputFormatters: [
              // If you want to limit input to just digits after +92
              FilteringTextInputFormatter.allow(RegExp(r'^\+92[0-9]*$')),
            ],
          ),
          const SizedBox(height: 16),
          // Address input
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Credit Card'),
                value: 'credit_card',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Cash on Delivery'),
                value: 'cash_on_delivery',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
            ),
          ],
        ),
        if (_paymentMethod == 'credit_card') ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _cardNumberController,
            decoration: const InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your card number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _expiryDateController,
            decoration: const InputDecoration(
              labelText: 'Expiry Date (MM/YY)',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the expiry date';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cvvController,
            decoration: const InputDecoration(
              labelText: 'CVV',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the CVV';
              }
              return null;
            },
          ),
        ],
      ],
    );
  }
}

class OrderConfirmationScreen extends StatefulWidget {
  final Widget orderDetails;
  final double totalPrice;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String paymentMethod;

  const OrderConfirmationScreen({
    super.key,
    required this.orderDetails,
    required this.totalPrice,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.paymentMethod,
  });

  @override
  // ignore: library_private_types_in_public_api
  _OrderConfirmationScreenState createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    // Show the confirmation popup dialog when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showConfirmationPopup();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Slip'),
        automaticallyImplyLeading: false, // Removes the back arrow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Order Details'),
                        Tab(text: 'User Information'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Order Details Tab
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                elevation: 4,
                                child: widget.orderDetails,
                              ),
                            ),
                          ),
                          // User Information Tab
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionTitle('User Information'),
                                  _buildUserInfoRow(
                                      Icons.person, 'Name', widget.name),
                                  _buildUserInfoRow(
                                      Icons.email, 'Email', widget.email),
                                  _buildUserInfoRow(
                                      Icons.phone, 'Phone', widget.phone),
                                  _buildUserInfoRow(Icons.location_on,
                                      'Address', widget.address),
                                  _buildUserInfoRow(Icons.payment,
                                      'Payment Method', widget.paymentMethod),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Continue Shopping Button
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.home);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Continue Shopping'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationPopup() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text('Order Details'),
          content: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/playstore.png', height: 100),
                const SizedBox(height: 8.0),
                const Text(
                  'Order Successfully Placed!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                _showSuccessSnackBar();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Your order has been placed successfully!'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            // Optionally handle any actions when OK is pressed
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up any resources or dispose of controllers if necessary
    super.dispose();
  }
}
