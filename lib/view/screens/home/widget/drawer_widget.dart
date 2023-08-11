// ignore_for_file: prefer_const_constructors

import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:e_commerce_get_x/util/images.dart';
import 'package:e_commerce_get_x/util/string_extension.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:e_commerce_get_x/view/base/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref().child('users');
  bool isLoading = true;
  late User? _user;
  late String _firstName = '';
  late String _lastName = '';

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    _user = _auth.currentUser;
    if (_user != null) {
      final snapshot = await _usersRef.child(_user!.uid).once();
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _firstName = data['first_name'] ?? '';
        _lastName = data['last_name'] ?? '';
        isLoading = false;
      });
    }
  }
  void _logoutUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout',style: josefinBold,),
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
      showCustomSnackBar('Logout Successfully');
      // Navigate to Login Screen after logout
    //  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(location: widget.location)));
    }).catchError((error) {
      // Handle logout error
      showCustomSnackBar('Logout failed. Please try again.',isError: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
          backgroundColor: Colors.white,
          child: ListView(padding: EdgeInsets.zero, children: [
             DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(Images.avatar),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    '${_firstName.capitalize()} ${_lastName.capitalize()}',
                    style: josefinMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile',style: josefinRegular,),
              onTap: () {
                // handle drawer item press
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Language',style: josefinRegular,),
              onTap: () {
                // handle drawer item press
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('Orders',style: josefinRegular,),
              onTap: () {
                // handle drawer item press
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today_outlined),
              title: Text('Calender',style: josefinRegular,),
              onTap: () {
                // handle drawer item press
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_sharp),
              title: Text('LogOut',style: josefinRegular,),
              onTap: () {
                _logoutUser();
              },
            ),
          ])
      ),
    );
  }
}
