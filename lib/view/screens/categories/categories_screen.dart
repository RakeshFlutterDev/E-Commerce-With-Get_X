// ignore_for_file: prefer_const_constructors

import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:e_commerce_get_x/util/images.dart';
import 'package:e_commerce_get_x/util/size_config.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:e_commerce_get_x/view/screens/categories/widget/category_widget.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool showShimmer = true;
  String? selectedItem;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showShimmer = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: josefinBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildShimmerContainer(
                Images.fish,
                'Fish',
              ),
              SizedBox(width: 10.0),
              _buildShimmerContainer(
                Images.prawns,
                'Prawns',
              ),
              SizedBox(width: 10.0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerContainer(String image, String text) {
    return Visibility(
      visible: showShimmer,
      replacement: GestureDetector(
        onTap: () {
          setState(() {
            selectedItem = text;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryWidgetScreen(category: text,),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Center(
            child: Container(
              height: SizeConfig.blockSizeVertical! * 12,
              width: SizeConfig.blockSizeHorizontal! * 40,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: Text(
                      text,
                      style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      child: Container(
        height: SizeConfig.blockSizeVertical! * 14,
        width: SizeConfig.blockSizeHorizontal! * 44,
        color: Colors.grey.shade200,
      ),
    );
  }
}












