// ignore_for_file: prefer_const_constructors

import 'package:e_commerce_get_x/util/styles.dart';
import 'package:flutter/material.dart';

class CustomBoxWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const CustomBoxWidget({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60.0,
            width: 60.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40.0),
          ),
          SizedBox(height: 5.0),
          Text(label,style: josefinRegular,),
        ],
      ),
    );
  }
}