// ignore_for_file: prefer_const_constructors

import 'package:e_commerce_get_x/model/tool_model.dart';
import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:e_commerce_get_x/view/screens/checkout/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CartScreen extends StatefulWidget {
  final List<Tool> cartItems;
  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true; // Added to track the loading state

  @override
  void initState() {
    super.initState();
    // Simulate loading for 3 seconds
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: Text(
          'Cart',
          style: josefinBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
        ),
      ),
      body: _isLoading // Check if data is still loading
          ? Shimmer(
        child: ListView.builder(
          itemCount: 5, // Show a placeholder for 5 items
          itemBuilder: (context, index) {
            return CartItemShimmer(); // Display shimmer animation for each item
          },
        ),
      ) : widget.cartItems.isEmpty
          ? Center(
        child: Text(
          'Your cart is empty',
          style: josefinRegular,
        ),
      ) : ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          return CartItemWidget(
            tool: widget.cartItems[index],
            onQuantityChanged: (newQuantity) {
              setState(() {
                if (newQuantity >= 1) {
                  widget.cartItems[index].quantity = newQuantity;
                } else {
                  widget.cartItems.removeAt(index);
                  if (widget.cartItems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Your cart is empty',
                          style: josefinRegular,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Item removed from cart',
                          style: josefinRegular,
                        ),
                      ),
                    );
                  }
                }
              });
            },
          );
        },
      ),
      bottomNavigationBar: _isLoading // Show a loading indicator for the bottom navigation bar
          ? Shimmer(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
      )
          : widget.cartItems.isNotEmpty
          ? Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total : ₹ ${calculateTotalPrice().toStringAsFixed(2)}',
              style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(cartItems: widget.cartItems),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade900,
              ),
              child: Text(
                'CheckOut',
                style: josefinRegular,
              ),
            ),
          ],
        ),
      )
          : null,
    );
  }

  double calculateTotalPrice() {
    double total = 0.0;
    for (var tool in widget.cartItems) {
      total += tool.price * tool.quantity;
    }
    return total;
  }
}

class CartItemShimmer extends StatelessWidget {
  const CartItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 100,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              color: Colors.grey.shade200, // Placeholder color
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.grey.shade200, // Placeholder color
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 150,
                    height: 16,
                    color: Colors.grey.shade200, // Placeholder color
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.0),
            Container(
              width: 80,
              height: 25,
              color: Colors.grey.shade200, // Placeholder color
            ),
            SizedBox(width: 20.0),
          ],
        ),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final Tool tool;
  final ValueChanged<int> onQuantityChanged;

  const CartItemWidget({Key? key, required this.tool, required this.onQuantityChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 100,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.asset(tool.image),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tool.name,
                    style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        '₹ ${tool.price.toStringAsFixed(2)}',
                        style: josefinRegular,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.0),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    if (tool.quantity > 1) {
                      onQuantityChanged(tool.quantity - 1);
                    } else {
                      onQuantityChanged(0);
                    }
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  tool.quantity.toString(),
                  style: josefinRegular,
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    onQuantityChanged(tool.quantity + 1);
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
