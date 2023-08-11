// ignore_for_file: prefer_const_constructors


import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:flutter/material.dart';


class ProfileBgWidget extends StatelessWidget {
  final Widget circularImage;
  final Widget mainWidget;
  final bool backButton;
  const ProfileBgWidget({super.key, required this.mainWidget, required this.circularImage, required this.backButton});

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Stack(clipBehavior: Clip.none, children: [

        SizedBox(
          width: Dimensions.webMaxWidth, height: 260,
          child: Center(child: Image(
            image: AssetImage('assets/images/menu_bg.png'),
              height: 260, width: 1170, fit: BoxFit.fill),
          ),
        ),

        Positioned(
          top: 200, left: 0, right: 0, bottom: 0,
          child: Center(
            child: Container(
              width: 1170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                color: Theme.of(context).cardColor,
              ),
            ),
          ),
        ),


        backButton ? Positioned(
          top: MediaQuery.of(context).padding.top, left: 10,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).cardColor, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ) : SizedBox(),

        Positioned(
          top: 150, left: 0, right: 0,
          child: circularImage,
        ),

      ]),

      Expanded(
        child: mainWidget,
      ),

    ]);
  }
}
