import 'package:e_commerce_get_x/util/styles.dart';
import 'package:e_commerce_get_x/view/screens/favorite/favorite_screen.dart';
import 'package:e_commerce_get_x/view/screens/home/home_screen.dart';
import 'package:e_commerce_get_x/view/screens/profile/profile_screen.dart';
import 'package:e_commerce_get_x/view/screens/visualization/visualization_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  final bool exitFromApp;
  const DashboardScreen({Key? key, required this.exitFromApp}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  String? address;
  int _currentIndex = 0;
  bool _shouldExit = false;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    address = Get.arguments?['address'];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex == 0) {
          if (_shouldExit) {
            SystemNavigator.pop();
            return true;
          } else {
            setState(() {
              _shouldExit = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Press back again to exit', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
                margin: EdgeInsets.all(10.0),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return false;
          }
        } else {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomeScreen(),
            FavoriteScreen(),
            VisualizationScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // Handle floating action button tap
        //   },
        //   child: Icon(Icons.shopping_cart, color: Colors.grey),
        //   backgroundColor: Theme.of(context).cardColor,
        // ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedLabelStyle: josefinRegular,
      unselectedLabelStyle: josefinRegular,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 4,
      fixedColor: Colors.black,
      onTap: onTabTapped,
      currentIndex: _currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled, size: 35),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite, size: 35),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt_sharp, size: 35),
          label: 'Visualization',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 35),
          label: 'Profile',
        ),
      ],
    );
  }
}

