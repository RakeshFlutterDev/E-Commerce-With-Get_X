import 'package:e_commerce_get_x/helper/route_helper.dart';
import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:e_commerce_get_x/util/images.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({Key? key, }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  void navigateToHome() async {
    await Future.delayed(const Duration(seconds: 5)); // Simulating a 3-second splash screen

    if (_auth.currentUser != null) {
      // User is already authenticated, navigate to home directly
      Get.toNamed(RouteHelper.getInitialRoute());
    } else {
      // User is not authenticated, navigate to login/register screen
      // Replace the line below with your own authentication logic
      Get.toNamed(RouteHelper.getLoginRoute());// Replace '/login' with the appropriate route for login/register screen
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Images.logo,
              height: 350,
              width: 450,
              fit: BoxFit.fitHeight,
            ),
            Text(
              'E-Commerce App',
              style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
          ],
        ),
      ),
    );
  }
}