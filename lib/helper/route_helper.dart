import 'package:e_commerce_get_x/view/screens/address/address_screen.dart';
import 'package:e_commerce_get_x/view/screens/auth/login_screen.dart';
import 'package:e_commerce_get_x/view/screens/auth/sign_up_screen.dart';
import 'package:e_commerce_get_x/view/screens/dashboard/dashboard_screen.dart';
import 'package:e_commerce_get_x/view/screens/home/home_screen.dart';
import 'package:e_commerce_get_x/view/screens/location/location_screen.dart';
import 'package:e_commerce_get_x/view/screens/location/pick_location.dart';
import 'package:e_commerce_get_x/view/screens/order/orders_screen.dart';
import 'package:e_commerce_get_x/view/screens/profile/my_profile_scrceen.dart';
import 'package:e_commerce_get_x/view/screens/profile/profile_screen.dart';
import 'package:e_commerce_get_x/view/screens/splash/splash_screen.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String initial = '/';
  static const String address = '/';
  static const String splash = '/splash';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String orders = '/orders';
  static const String savedAddress = '/savedAddress';
  static const String myProfile = '/myProfile';
  static const String profile = '/profile';
  static const String location = '/location';
  static const String pick_location = '/pick_location';
  // Add more routes here

  static String getInitialRoute() => initial;
  static String getAddressRoute() => address;
  static String getHomeRoute() => home;
  static String getLoginRoute() => login;
  static String getOrdersRoute() => orders;
  static String getSignupRoute() => signup;
  static String getSavedAddressRoute() => savedAddress;
  static String getMyProfileRoute() => myProfile;
  static String getProfileRoute() => profile;
  static String getLocationRoute() => location;
  static String getPickLocationRoute() => pick_location;
  static String getSplashRoute(String? address) => '$splash/$address';

  // Add more route helper methods here

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const DashboardScreen(exitFromApp: true)),
   // GetPage(name: address, page: () =>  const SavedAddressScreen()),
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => const SignUpScreen()),
   // GetPage(name: orders, page: () => OrderScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: myProfile, page: () =>  const MyProfileScreen()),
    GetPage(name: location, page: () => const LocationScreen()),
    GetPage(name: pick_location, page: () => PickLocationScreen()),
    GetPage(name: savedAddress, page: () =>  AddressScreen()),
    // Add more routes here
  ];
}

