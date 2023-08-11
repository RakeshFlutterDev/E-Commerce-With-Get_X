// ignore_for_file: prefer_const_constructors

import 'dart:math';
import 'package:e_commerce_get_x/database/database_controller.dart';
import 'package:e_commerce_get_x/helper/route_helper.dart';
import 'package:e_commerce_get_x/model/tool_model.dart';
import 'package:e_commerce_get_x/model/user_model.dart';
import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:e_commerce_get_x/view/base/custom_snackbar.dart';
import 'package:e_commerce_get_x/view/screens/order/widget/order_placed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Tool> cartItems;
  final double deliveryCharge;
  const CheckoutScreen({Key? key, required this.cartItems, this.deliveryCharge = 0.0}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String couponCode = '';
  double discount = 0.0;
  double subtotal = 0.0;
  String location = '';
  bool isCODSelected = true; // Set to true by default
  bool isDigitalPaymentSelected = false;
  bool _isLoading = false; // Track if the order is being placed
  DateTime selectedDateTime = DateTime.now();
  String? address;
  TextEditingController houseNoController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  User? currentUser;

  @override
  void initState() {
    super.initState();
    getAddressFromSharedPreferences();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  void getAddressFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getString('selectedAddress');
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = calculateTotalPrice();
    double totalWithDeliveryCharge = total + widget.deliveryCharge - discount;
    double tax = calculateTax(); // Calculate the tax separately

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: Text(
          'Checkout',
          style: josefinBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
        ),
      ),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery Address',
                      style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),
                    TextButton(
                      onPressed: selectOrAddAddress,
                      child: Text(
                        '+ Custom Address',
                        style: josefinRegular.copyWith(color: Colors.orange.shade900, fontSize: Dimensions.fontSizeLarge),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () => Get.offAllNamed(RouteHelper.getPickLocationRoute()),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      color: Theme.of(context).cardColor,
                      boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 1)],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            address ?? 'No address selected',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: josefinRegular,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: Theme.of(context).textTheme.bodyLarge!.color),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: houseNoController,
                        decoration: InputDecoration(
                          labelText: 'House No',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: TextField(
                        controller: streetController,
                        decoration: InputDecoration(
                          labelText: 'Street',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: localityController,
                  decoration: InputDecoration(
                    labelText: 'Locality',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(height: 10),
                Divider(height: 10, thickness: 1),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    selectDateTime();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Date & Time:',
                        style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        selectedDateTime.toString(), // Display the selected date and time
                        style: josefinRegular,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Coupon Code',
                  style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).cardColor,
                    boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 1)],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter Coupon Code',
                            labelStyle: josefinRegular,
                            border: InputBorder.none, // Hide the underline
                          ),
                          onChanged: (value) {
                            setState(() {
                              couponCode = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          applyDiscount();
                        },
                        child: Text('Apply', style: josefinRegular.copyWith(color: Colors.orange.shade900)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18),
                Divider(height: 10, thickness: 2),
                SizedBox(height: 16),
                Text(
                  'Payment Method',
                  style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                SizedBox(height: 8),
                CheckboxListTile(
                  title: Text(
                    'Cash on Delivery (COD)',
                    style: josefinRegular,
                  ),
                  activeColor: Colors.orange.shade900,
                  value: isCODSelected,
                  onChanged: (value) {
                    setState(() {
                      isCODSelected = value!;
                      isDigitalPaymentSelected = !value;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text(
                    'Digital Payment',
                    style: josefinRegular,
                  ),
                  activeColor: Colors.orange.shade900,
                  value: isDigitalPaymentSelected,
                  onChanged: (value) {
                    setState(() {
                      isDigitalPaymentSelected = value!;
                      isCODSelected = !value;
                    });
                  },
                ),
                SizedBox(height: 18),
                Divider(height: 10, thickness: 2),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),
                    SizedBox(height: 10.0),
                    // Subtotal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal:',
                          style: josefinRegular,
                        ),
                        Text(
                          calculateSubtotal().toStringAsFixed(2),
                          style: josefinRegular,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Discount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discount:',
                          style: josefinRegular,
                        ),
                        Text(
                          discount.toStringAsFixed(2),
                          style: josefinRegular,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Tax
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tax:',
                          style: josefinRegular,
                        ),
                        Text(
                          tax.toStringAsFixed(2),
                          style: josefinRegular,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Delivery Charge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery Charge:',
                          style: josefinRegular,
                        ),
                        Text(
                          widget.deliveryCharge.toStringAsFixed(2),
                          style: josefinRegular,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Divider and Total
                    Divider(height: 10, thickness: 2),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                        ),
                        Text(
                          totalWithDeliveryCharge.toStringAsFixed(2),
                          style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              placeOrder();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade900,
                            ),
                            child: Text(
                              'Place Order',
                              style: josefinRegular,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double calculateTotalPrice() {
    double subtotal = calculateSubtotal();
    double tax = calculateTax();
    double total = subtotal + tax + widget.deliveryCharge;
    return total;
  }

  double calculateSubtotal() {
    double subtotal = 0.0;
    for (var tool in widget.cartItems) {
      subtotal += tool.price * tool.quantity;
    }
    return subtotal;
  }

  double calculateTax() {
    double subtotal = calculateSubtotal();
    double tax = subtotal * 0.05; // Assuming 5% tax rate
    return tax;
  }

  void applyDiscount() {
    setState(() {
      if (couponCode == 'Coupon10') {
        // Apply a discount of 10%
        discount = calculateSubtotal() * 0.1;
        showCustomSnackBar('10% discount applied');
      } else if (couponCode == 'Coupon20') {
        // Apply a discount of 20%
        discount = calculateSubtotal() * 0.2;
        showCustomSnackBar('20% discount applied');
      } else if (couponCode == 'Coupon50') {
        // Apply a discount of 50%
        discount = calculateSubtotal() * 0.5;
        showCustomSnackBar('50% discount applied');
      } else {
        // No valid discount code entered, so set the discount to 0
        discount = 0.0;
        showCustomSnackBar('Invalid Coupon');
      }
    });
  }

  void selectOrAddAddress() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delivery Address',
            style: josefinRegular,
          ),
          content: TextFormField(
            decoration: InputDecoration(
              labelText: 'Enter your delivery address',
              labelStyle: josefinRegular,
            ),
            onChanged: (value) {
              setState(() {
                location = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: josefinRegular,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: josefinRegular,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)), // Limit selection to 7 days from today
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void placeOrder() async {
    // Check if the user is logged in
    if (currentUser == null) {
      showCustomSnackBar('User not logged in');
      return;
    }

    // Logic to place the order
    // Set _isLoading to true to show the progress indicator
    setState(() {
      _isLoading = true;
    });

    try {
      String userId = currentUser!.uid;
      String? address = this.address;
      String email = currentUser!.email ?? '';
      String firstName = currentUser!.displayName ?? '';
      String? phone = currentUser!.phoneNumber;

      // Retrieve the manually entered address
      String houseNo = houseNoController.text;
      String street = streetController.text;
      String locality = localityController.text;

      // Generate an order ID
      String orderId = generateOrderId();
      DateTime orderTime = DateTime.now();
      List<Tool> orderedItems = List.from(widget.cartItems); // Create a copy of the cartItems list

      // Get a reference to the Firebase Realtime Database root
      DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

      // Create a new order node with a uniqueID under the "orders" node
      DatabaseReference orderReference = databaseReference.child('orders').push();

      // Store the order details as a map
      Map<String, dynamic> orderData = {
        'userId': userId, // Use the user's ID
        'firstName': firstName,
        'email': email,
        'phone': phone,
        'address': {
          'houseNo': houseNo,
          'street': street,
          'locality': locality,
          'address': address,
        },
        'orderedItems': orderedItems.map((item) => {
          'name': item.name,
          'image': item.image,
          'quantity': item.quantity,
          'subtotal': item.price * item.quantity,
        }).toList(),
        'orderId': orderId,
        'orderTime': orderTime.toIso8601String(),
        'paymentType': isCODSelected ? 'Cash on Delivery' : 'Digital Payment',
        'subtotal': calculateSubtotal(),
        'discount': discount,
        'tax': calculateTax(),
        'deliveryCharge': widget.deliveryCharge,
        'total': calculateTotalPrice(),
      };

      // Set the order data in the database
      await orderReference.set(orderData);

      // Reset the cart and other variables
      resetCart();

      // Navigate to the OrderPlacedWidget with the necessary order information
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderPlacedWidget(
          ),
        ),
      );
    } catch (error) {
      // Handle any errors that occur during the database operation
      print('Error placing order: $error');
      // Show an error message or handle the error in an appropriate way
    } finally {
      // Set _isLoading back to false after the database operation is complete
      setState(() {
        _isLoading = false;
      });
    }
  }

  void resetCart() {
    // Reset the cart items and other variables
    setState(() {
      widget.cartItems.clear();
      // Reset other variables as needed
    });
  }

  String generateOrderId() {
    int orderId = Random().nextInt(999999); // Generate a random 6-digit number
    return orderId.toString().padLeft(6, '0'); // Pad the number with leading zeros if necessary
  }
}
