import 'package:e_commerce_get_x/helper/route_helper.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:e_commerce_get_x/view/base/custom_snackbar.dart';
import 'package:e_commerce_get_x/view/screens/address/saved_address_screen.dart';
import 'package:e_commerce_get_x/view/screens/address/widget/current_location_screen.dart';
import 'package:e_commerce_get_x/view/screens/dashboard/dashboard_screen.dart';
import 'package:e_commerce_get_x/view/screens/location/pick_location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool showPassword = false;
  bool isLoading = false;
  bool rememberMe = false;
  bool agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMeState();
  }

  Future<void> _loadRememberMeState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
      if (rememberMe) {
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      } else {
        _emailController.clear();
        _passwordController.clear();
      }
    });
  }

  Future<void> _saveRememberMeState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', value);
    if (!value) {
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);

    // Save the flag indicating whether the address has been saved or not
    await prefs.setBool('hasSavedAddress', true);
  }

  Future<void> login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    setState(() {
      isLoading = true;
    });
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        final hasSavedAddress = prefs.getBool('hasSavedAddress') ?? true;

        if (hasSavedAddress) {
          // Redirect to saved address screen
          Get.off(() => DashboardScreen(exitFromApp: true));
        } else {
          // Redirect to pick location screen
          Get.off(() => PickLocationScreen());
        }
        showCustomSnackBar('Login Success', isError: false);
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Error!',
        '',
        messageText: Text(
          'Invalid email or password',
          style: josefinBold,
        ),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
            SizedBox(height: 100),
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
                        children: <Widget>[
                          SizedBox(height: 30),
                          Text("Welcome Back", style: josefinBold.copyWith(fontSize: 40)),
                          SizedBox(height: 10.0),
                          Text(
                            "Please enter your E-Mail and Password for login",
                            style: josefinRegular.copyWith(color: Theme.of(context).disabledColor),
                          ),
                          SizedBox(height: 30),
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
                                  padding: EdgeInsets.all(10),
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
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) =>
                                        value == null || value.isEmpty || !value.contains('@')
                                            ? 'Please enter a valid email'
                                            : null,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
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
                                      border: OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: Icon(showPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            showPassword = !showPassword;
                                          });
                                        },
                                      ),
                                    ),
                                    obscureText: !showPassword,
                                    validator: (value) => value == null || value.isEmpty
                                        ? 'Please enter a password'
                                        : null,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: rememberMe,
                                      onChanged: (value) => setState(() {
                                        rememberMe = value!;
                                        _saveRememberMeState(rememberMe);
                                      }),
                                      activeColor:Colors.orange.shade900,
                                      checkColor: Colors.grey,
                                    ),
                                    Text('Remember Me',style: josefinRegular),
                                    Spacer(),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Forgot Password ?',
                                        style: josefinRegular.copyWith(color: Colors.orange.shade900),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: agreeToTerms,
                                      onChanged: (value) => setState(() {
                                        agreeToTerms = value!;
                                      }),
                                      activeColor:Colors.orange.shade900,
                                      checkColor: Colors.grey,
                                    ),
                                    Text('I Agree to Terms and Conditions',style: josefinRegular),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Visibility(
                                      visible: !isLoading,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (_formKey.currentState!.validate()) {
                                            if (!agreeToTerms) {
                                              showCustomSnackBar('Please accept to the Terms and Conditions',isError: true);
                                            } else {
                                              if (rememberMe) {
                                                _saveCredentials(
                                                  _emailController.text,
                                                  _passwordController.text,
                                                );
                                              }
                                              login();
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: 50,
                                          margin: EdgeInsets.symmetric(horizontal: 50),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: Colors.orange[900],
                                          ),
                                          child: Center(
                                            child: Text(
                                              'SignIn',
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
                                const SizedBox(height: 16.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account?",
                                      style: josefinRegular,
                                    ),
                                    TextButton(
                                      onPressed: () => Get.offNamed(RouteHelper.getSignupRoute()),
                                        child: Text(
                                        'SignUp',
                                        style: josefinRegular.copyWith(color: Colors.orange.shade900),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0,),
                                TextButton(
                                  onPressed: () {
                                    _emailController.text = 'nani@gmail.com';
                                    _passwordController.text = 'Rakesh@123';
                                  },
                                  child: Text(
                                    'Auto Fill Credentials',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30.0,),
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
