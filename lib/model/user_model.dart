import 'package:e_commerce_get_x/model/order_model.dart';

class UserModel {
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final List<Order> orders;

  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.orders,
  });
}
