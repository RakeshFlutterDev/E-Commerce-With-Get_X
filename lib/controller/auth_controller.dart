import 'package:e_commerce_get_x/view/base/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  bool showPassword = false;
  bool isLoading = false;
  bool agreeToTerms = false;

  Future<void> signUp() async {
    final name = firstNameController.text;
    final lastname = lastNameController.text;
    final phone = phoneNumberController.text;
    final email = emailController.text;
    final password = passwordController.text;

    isLoading = true;
    update();

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users');
        userRef.child(user.uid).set({
          'first name': name,
          'last name': lastname,
          'email': email,
          'phone': phone,
        });

        showCustomSnackBar('Registration Successful!', isError: false);
        Get.offNamed('/home');
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          showCustomSnackBar(
              'The email address is already in use by another account.',
              isError: true);
        } else if (e.code == 'invalid-email') {
          showCustomSnackBar('Please enter a valid email address.',
              isError: true);
        } else if (e.code == 'weak-password') {
          showCustomSnackBar(
              'The password is too weak. Please choose a stronger password.',
              isError: true);
        } else {
          print(e.toString());
        }
      } else {
        print(e.toString());
      }
    }

    isLoading = false;
    update();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
