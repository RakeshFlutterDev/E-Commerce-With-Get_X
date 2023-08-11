// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class OrderRunningWidget extends StatefulWidget {
  const OrderRunningWidget({super.key});

  @override
  State<OrderRunningWidget> createState() => _OrderRunningWidgetState();
}

class _OrderRunningWidgetState extends State<OrderRunningWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: const [
            Text('List of Ordered Items')
          ],
        ),
      ),
    );
  }
}
