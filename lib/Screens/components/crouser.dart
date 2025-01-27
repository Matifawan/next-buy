// ignore_for_file: unrelated_type_equality_checks

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:next_buy/Screens/views/attachments/filterScreen/salescreen.dart';
import 'package:next_buy/model/product.dart';
import 'package:rxdart/rxdart.dart';

class SliderWidget extends StatefulWidget {
  final List<Product> allProducts;
  final List<Product> saleProducts;

  const SliderWidget({
    super.key,
    required this.allProducts,
    required this.saleProducts,
  });

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  List<String> imgList = [
    'gs://next-buy-7452f.appspot.com/new-/1.png',
    'gs://next-buy-7452f.appspot.com/fresh/7.png',
    'gs://next-buy-7452f.appspot.com/fresh/1.png',
    'gs://next-buy-7452f.appspot.com/fresh/5.png',
    'gs://next-buy-7452f.appspot.com/new-/2.png',
    'gs://next-buy-7452f.appspot.com/new-/3.png',
    'gs://next-buy-7452f.appspot.com/new-/4.png',
    'gs://next-buy-7452f.appspot.com/new-/5.png',
    'gs://next-buy-7452f.appspot.com/new-/6.png',
    'gs://next-buy-7452f.appspot.com/new-/7.png',
    'gs://next-buy-7452f.appspot.com/new-/8.png',
    'gs://next-buy-7452f.appspot.com/fresh/6.png',
    'gs://next-buy-7452f.appspot.com/fresh/8.png',
    'gs://next-buy-7452f.appspot.com/fresh/9.png',
    'gs://next-buy-7452f.appspot.com/fresh/11.png',
  ];

  final Map<String, String> _imageUrlCache = {};
  int _currentIndex = 0;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _preloadImages();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    _isOnline = connectivityResult != ConnectivityResult.none;

    // Listen to connectivity changes with debounce to limit checks
    Connectivity()
        .onConnectivityChanged
        .debounceTime(const Duration(seconds: 5))
        .listen((result) {
      setState(() {
        _isOnline = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _preloadImages() async {
    if (_isOnline) {
      for (String path in imgList) {
        _getImageUrl(path); // Preload URLs to cache
      }
    }
  }

  void _onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<String> _getImageUrl(String imagePath) async {
    if (_imageUrlCache.containsKey(imagePath)) {
      return _imageUrlCache[imagePath]!;
    }

    if (_isOnline) {
      try {
        final ref = FirebaseStorage.instance.refFromURL(imagePath);
        final url = await ref.getDownloadURL();
        _imageUrlCache[imagePath] = url;
        return url;
      } catch (e) {
        if (kDebugMode) print('Error loading image: $e');
        return Future.error('Error loading image');
      }
    } else {
      return Future.error('No internet connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 350,
          child: CarouselSlider.builder(
            itemCount: imgList.length,
            itemBuilder: (context, index, realIndex) {
              String path = imgList[index];
              return FutureBuilder<String>(
                future: _getImageUrl(path),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingImage();
                  } else if (snapshot.hasError) {
                    return _buildErrorWidget();
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildNoImageAvailableWidget();
                  } else {
                    return _buildImageWidget(snapshot.data!);
                  }
                },
              );
            },
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              autoPlay: false,
              autoPlayInterval: const Duration(seconds: 5),
              enlargeCenterPage: false,
              enableInfiniteScroll: true,
              onPageChanged: _onPageChanged,
              scrollPhysics: const BouncingScrollPhysics(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildDots(),
      ],
    );
  }

  Widget _buildLoadingImage() {
    return Center(
      child: Image.asset(
        'assets/images/downloud.gif',
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return const Center(
      child: Text(
        'Error loading image',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildNoImageAvailableWidget() {
    return const Center(
      child: Text(
        'No image available',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (context, url) => _buildLoadingImage(),
          errorWidget: (context, url, error) => _buildErrorWidget(),
        ),
        Positioned(
          bottom: 6,
          right: 10,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to SaleScreen with saleProducts
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SaleScreen(
                    saleProducts: widget.saleProducts,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color.fromARGB(255, 42, 172, 1).withOpacity(0.4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(50), // Increase to make it circular
              ),
            ),
            child: const Text(
              'Order Now!',
              style: TextStyle(
                  color: Color.fromARGB(255, 254, 254, 254),
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        imgList.length,
        (index) => buildDots(index, context),
      ),
    );
  }

  Container buildDots(int index, BuildContext context) {
    return Container(
      height: 7,
      width: index == _currentIndex ? 30 : 9,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: _currentIndex == index
            ? const Color.fromARGB(255, 44, 206, 117)
            : const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }
}
