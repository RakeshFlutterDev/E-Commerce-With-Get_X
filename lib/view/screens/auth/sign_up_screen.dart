import 'package:e_commerce_get_x/database/database_controller.dart';
import 'package:e_commerce_get_x/helper/route_helper.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:e_commerce_get_x/view/base/custom_snackbar.dart';
import 'package:e_commerce_get_x/view/screens/auth/widget/validator_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool showPassword = false;
  bool isLoading = false;
  bool agreeToTerms = false;

  void togglePasswordVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final phoneNumber = _phoneNumberController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    setState(() {
      isLoading = true;
    });

    try {
      User? user = await _firebaseService.signUpWithEmailAndPassword(
        email,
        password,
        firstName,
        lastName,
        phoneNumber,
      );

      if (user != null) {
        showCustomSnackBar('Registration Successful!', isError: false);
        // Check if it's the first time the user registers
        if (user.metadata.creationTime == user.metadata.lastSignInTime) {
          // Navigate to the address screen for first-time users
          Get.offNamed(RouteHelper.getPickLocationRoute());
        } else {
          Get.offNamed(RouteHelper.getPickLocationRoute());
        }
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          showCustomSnackBar(
            'The email address is already in use by another account.',
            isError: true,
          );
        } else if (e.code == 'invalid-email') {
          showCustomSnackBar('Please enter a valid email address.', isError: true);
        } else if (e.code == 'weak-password') {
          showCustomSnackBar(
            'The password is too weak. Please choose a stronger password.',
            isError: true,
          );
        } else {
          print(e.toString());
        }
      } else {
        print(e.toString());
      }
    }

    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange.shade900,
              Colors.orange.shade800,
              Colors.orange.shade400,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 100),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            "Register",
                            style: josefinBold.copyWith(fontSize: 30),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Please fill all details to create an account ",
                            style: josefinRegular.copyWith(
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(225, 95, 27, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _firstNameController,
                                    decoration: InputDecoration(
                                      labelText: 'First Name',
                                      labelStyle: josefinRegular,
                                      prefixIcon: Icon(Icons.person,color: Colors.orange.shade900,),
                                      border: const OutlineInputBorder(),
                                    ),
                                    validator: Validators.validateFirstName,
                                    style: josefinRegular,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _lastNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Last Name',
                                      prefixIcon: Icon(Icons.person,color: Colors.orange.shade900,),
                                      labelStyle: josefinRegular,
                                      border: const OutlineInputBorder(),
                                    ),
                                    validator: Validators.validateLastName,
                                    style: josefinRegular,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: Icon(Icons.email,color: Colors.orange.shade900,),
                                      labelStyle: josefinRegular,
                                      border: const OutlineInputBorder(),
                                    ),
                                    validator: Validators.validateEmail,
                                    style: josefinRegular,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _phoneNumberController,
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      prefixIcon: Icon(Icons.phone,color: Colors.orange.shade900,),
                                      labelStyle: josefinRegular,
                                      border: const OutlineInputBorder(),
                                    ),
                                    validator: Validators.validatePhoneNumber,
                                    style: josefinRegular,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: Icon(Icons.lock,color: Colors.orange.shade900,),
                                      labelStyle: josefinRegular,
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        onPressed: togglePasswordVisibility,
                                        icon: Icon(
                                          showPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                      ),
                                    ),
                                    obscureText: !showPassword,
                                    validator: Validators.validatePassword,
                                    style: josefinRegular,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _confirmPasswordController,
                                    decoration: InputDecoration(
                                      labelText: 'Confirm Password',
                                      prefixIcon: Icon(Icons.lock,color: Colors.orange.shade900,),
                                      labelStyle: josefinRegular,
                                      border: const OutlineInputBorder(),
                                    ),
                                    obscureText: true,
                                    validator: (value) => Validators.validateConfirmPassword(
                                        value, _passwordController.text),
                                    style: josefinRegular,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        activeColor: Colors.orange.shade900,
                                        value: agreeToTerms,
                                        onChanged: (value) {
                                          setState(() {
                                            agreeToTerms = value ?? false;
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'I agree to the terms and conditions',
                                        style: josefinRegular,
                                      ),
                                    ],
                                  ),
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Visibility(
                                      visible: !isLoading,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (_formKey.currentState!.validate()) {
                                            if (!agreeToTerms) {
                                              showCustomSnackBar(
                                                  'Please agree to the Terms and Conditions',
                                                  isError: true);
                                            } else {
                                              signUp();
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: 50,
                                          margin: const EdgeInsets.symmetric(horizontal: 50),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: Colors.orange[900],
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Sign Up',
                                              style: josefinBold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: isLoading,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.orange.shade900),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account ?",
                                      style: josefinRegular,
                                    ),
                                    TextButton(
                                      onPressed: () => Get.offNamed('/login'),
                                      child: Text(
                                        'Login',
                                        style: josefinRegular.copyWith(
                                            color: Colors.orange.shade900),
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    _firstNameController.text = 'rakesh';
                                    _lastNameController.text = 'nani';
                                    _emailController.text = 'nani@gmail.com';
                                    _phoneNumberController.text = '9010510476';
                                    _passwordController.text = 'Rakesh@123';
                                    _confirmPasswordController.text = 'Rakesh@123';
                                  },
                                  child: const Text(
                                    'Auto Fill Credentials',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
