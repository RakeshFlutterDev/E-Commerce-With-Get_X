// ignore_for_file: prefer_const_constructors

import 'package:e_commerce_get_x/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Favorite', onBackPressed: (){},isBackButtonExist: false),
    );
  }
}
