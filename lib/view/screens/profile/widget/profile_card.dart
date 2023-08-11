
import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String title;
  final String data;
  ProfileCard({super.key, required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 1)],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(data, style: TextStyle(fontSize:20,color: Colors.redAccent)),
        SizedBox(height: Dimensions.paddingSizeSmall),
        Text(title, style:TextStyle(fontSize:20,color:Theme.of(context).disabledColor,
        )),
      ]),
    ));
  }
}
