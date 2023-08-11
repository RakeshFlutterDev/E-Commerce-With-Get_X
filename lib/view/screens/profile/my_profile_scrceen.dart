import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:e_commerce_get_x/util/images.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:e_commerce_get_x/view/base/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widget/profile_bg_widget.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _usersRef =
  FirebaseDatabase.instance.reference().child('users');
  bool isLoading = true;
  late User? _user;
  late String _firstName = '';
  late String _lastName = '';
  late String _email = '';
  late String _phoneNumber = '';
  String address = '';

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    _user = _auth.currentUser;
    if (_user != null) {
      final snapshot = await _usersRef.child(_user!.uid).once();
      final data = snapshot.snapshot.value;
      if (data != null && data is Map<dynamic, dynamic>) {
        setState(() {
          _firstName = data['first_name'] ?? '';
          _lastName = data['last_name'] ?? '';
          _email = data['email'] ?? '';
          _phoneNumber = data['phone'] ?? '';
          address = data['address'] ?? '';
          isLoading = false;
        });
        print('User Details Fetched:');
        print('First Name: $_firstName');
        print('Last Name: $_lastName');
        print('Email: $_email');
        print('Phone Number: $_phoneNumber');
        print('Address: $address');
      } else {
        print('User details not found');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Profile',
          onBackPressed: () {
            Get.back();
          },
          isBackButtonExist: true,
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade900),
          )
              : ProfileBgWidget(
            backButton: false,
            circularImage: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).cardColor,
                ),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: ClipOval(
                child: Image.asset(
                  Images.avatar,
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            mainWidget: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Center(
                child: Container(
                  width: 1170,
                  color: Theme.of(context).cardColor,
                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(
                    children: [
                      Text(
                        '${_firstName} $_lastName',
                        style: josefinMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        _email,
                        style: josefinMedium,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        _phoneNumber,
                        style: josefinMedium,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        address,
                        style: josefinMedium,
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Version:',
                            style: josefinMedium,
                          ),
                          SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Text(
                            '1.0',
                            style: josefinMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
