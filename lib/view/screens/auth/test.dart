// import 'package:e_commerce_get_x/controller/auth_controller.dart';
// import 'package:e_commerce_get_x/util/styles.dart';
// import 'package:e_commerce_get_x/view/base/custom_snackbar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   late SignUpController _signUpController;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _signUpController = Get.put(SignUpController());
//   }
//
//   @override
//   void dispose() {
//     Get.delete<SignUpController>();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Sign Up',
//           style: josefinBold,
//         ),
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _signUpController.formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _signUpController.firstNameController,
//                   decoration: InputDecoration(
//                     labelText: 'Name',
//                     labelStyle: josefinRegular,
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your firstname';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _signUpController.lastNameController,
//                   decoration: InputDecoration(
//                     labelText: 'Last Name',
//                     labelStyle: josefinRegular,
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your lastname';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _signUpController.emailController,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     labelStyle: josefinRegular,
//                   ),
//                   validator: (value) {
//                     if (value == null ||
//                         value.isEmpty ||
//                         !value.contains('@')) {
//                       return 'Please enter a valid e-mail';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _signUpController.phoneNumberController,
//                   decoration: InputDecoration(
//                     labelText: 'Phone Number',
//                     labelStyle: josefinRegular,
//                   ),
//                   validator: (value) {
//                     if (value == null ||
//                         value.isEmpty ||
//                         !(value.startsWith('6') ||
//                             value.startsWith('7') ||
//                             value.startsWith('8') ||
//                             value.startsWith('9'))) {
//                       return 'Please enter a valid Phone number';
//                     } else if (value.length != 10) {
//                       return 'Phone number should be 10 digits';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _signUpController.passwordController,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     labelStyle: josefinRegular,
//                   ),
//                   obscureText: true,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a password';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _signUpController.confirmPasswordController,
//                   decoration: InputDecoration(
//                     labelText: 'Confirm Password',
//                     labelStyle: josefinRegular,
//                   ),
//                   obscureText: true,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter confirm password';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16.0),
//                 Row(
//                   children: [
//                     Checkbox(
//                       value: _signUpController.agreeToTerms,
//                       onChanged: (value) {
//                         setState(() {
//                           _signUpController.agreeToTerms = value ?? false;
//                         });
//                       },
//                     ),
//                     const SizedBox(width: 8.0),
//                     Text('I agree to the terms and conditions',
//                         style: josefinRegular),
//                   ],
//                 ),
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Visibility(
//                       visible: !_signUpController.isLoading,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           if (_signUpController.formKey.currentState!.validate()) {
//                             if (!_signUpController.agreeToTerms) {
//                               showCustomSnackBar(
//                                 'Please agree to the Terms and Conditions',
//                                 isError: true,
//                               );
//                             } else {
//                               _signUpController.signUp();
//                             }
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           elevation: 0,
//                           shadowColor: Colors.transparent,
//                         ),
//                         child: Text(
//                           'Sign Up',
//                           style: josefinBold,
//                         ),
//                       ),
//                     ),
//                     Visibility(
//                       visible: _signUpController.isLoading,
//                       child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade900),
//                       ),
//                     ),
//                   ],
//                 ),
//
//
//                 SizedBox(height: 10.0),
//                 TextButton(
//                   onPressed: () => Get.offNamed('/login'),
//                   child: Text('Already have an account? Login'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     _signUpController.firstNameController.text = 'rakesh';
//                     _signUpController.lastNameController.text = 'nani';
//                     _signUpController.emailController.text = 'nani@gmail.com';
//                     _signUpController.phoneNumberController.text = '9010510476';
//                     _signUpController.passwordController.text = 'Rakesh@123';
//                     _signUpController.confirmPasswordController.text =
//                         'Rakesh@123';
//                   },
//                   child: Text(
//                     'Auto Fill Credentials',
//                     style: TextStyle(
//                       color: Colors.blue,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
