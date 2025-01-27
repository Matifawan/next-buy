abstract class Routes {
  Routes._(); // Private constructor to prevent instantiation

  static const onboarding = _Paths.onboarding;
  static const home = _Paths.home;
  static const login =
      _Paths.login; // Use 'login' if that is the route name you are using
  static const product = _Paths.product;
  static const profileScreen = _Paths.profile;
  static const likes = _Paths.likes;
  static const cart = _Paths.cart;
}

abstract class _Paths {
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const login = '/login'; // Define 'login' route here
  static const product = '/product';
  static const profile = '/profile';
  static const likes = '/likes';
  static const cart = '/cart';
}
