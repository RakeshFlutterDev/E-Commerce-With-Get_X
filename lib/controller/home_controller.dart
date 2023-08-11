import 'package:get/get.dart';

class HomeController extends GetxController {
  String address = '';

  void updateAddress(String newAddress) {
    address = newAddress;
    update(); // Refreshes the UI
  }
}
