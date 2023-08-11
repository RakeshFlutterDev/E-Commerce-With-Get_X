

import 'package:e_commerce_get_x/helper/route_helper.dart';
import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:e_commerce_get_x/view/base/custom_box.dart';
import 'package:e_commerce_get_x/view/base/custom_snackbar.dart';
import 'package:e_commerce_get_x/view/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key,}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // Simulate an asynchronous delay of 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: Text(
          'Profile',
          style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
      ),
      body: isLoading ? buildLoadingContent() : buildContent(),
    );
  }

  Widget buildLoadingContent() {
    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(20.0),
      mainAxisSpacing: 20.0,
      crossAxisSpacing: 20.0,
      children: List.generate(
        9, (index) => buildLoadingBox(),
      ),
    );
  }

  Widget buildLoadingBox() {
    return Shimmer(
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
          ),
          const SizedBox(height: 5.0),
          Container(
            height: 10.0,
            width: 60.0,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget buildContent() {
    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      mainAxisSpacing: 20.0,
      crossAxisSpacing: 20.0,
      children: [

        CustomBoxWidget(
          icon: Icons.person,
          label: 'Profile',
          onTap: () {
            Get.toNamed(RouteHelper.getMyProfileRoute());
          },
        ),
        CustomBoxWidget(
          icon: Icons.location_on,
          label: 'My Address',
          onTap: () {
            Get.toNamed(RouteHelper.getAddressRoute());
          },
        ),
        CustomBoxWidget(
          icon: Icons.language,
          label: 'Language',
          onTap: () {
            // Handle Orders onTap
          },
        ),
        CustomBoxWidget(
          icon: Icons.shopping_bag,
          label: 'Orders',
          onTap: () {
            Get.toNamed(RouteHelper.getOrdersRoute());
          },
        ),
        CustomBoxWidget(
          icon: Icons.favorite,
          label: 'Favorites',
          onTap: () {
            Get.toNamed(RouteHelper.getSavedAddressRoute());
          },
        ),
        CustomBoxWidget(
          icon: Icons.help,
          label: 'Help',
          onTap: () {

          },
        ),
        CustomBoxWidget(
          icon: Icons.loyalty,
          label: 'Loyalty Points',
          onTap: () {
            // Handle Loyalty Points onTap
          },
        ),
        CustomBoxWidget(
          icon: Icons.redeem,
          label: 'Refer and Earn',
          onTap: () {
            // Handle Refer and Earn onTap
          },
        ),
        CustomBoxWidget(
          icon: Icons.logout,
          label: 'Logout',
          onTap: () {
            _logoutUser();
          },
        ),

      ],
    );
  }

  void _logoutUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('Logout',style: josefinRegular,),
          content: Text('Are you sure you want to logout?',style: josefinRegular,),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel',style: josefinRegular,),
            ),
            TextButton(
              onPressed: () {
                _performLogout(); // Perform logout
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Logout',style: josefinRegular,),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() {
    _auth.signOut().then((_) {
      // Logout successful
      showCustomSnackBar('Logout Successfully',isError: false);
      // Navigate to Login Screen after logout
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }).catchError((error) {
      // Handle logout error
      showCustomSnackBar('Logout failed. Please try again.',isError: true);
    });
  }

}
