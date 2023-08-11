import 'package:e_commerce_get_x/util/images.dart';
import 'package:e_commerce_get_x/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class CurrentLocationWidget extends StatefulWidget {
  const CurrentLocationWidget({Key? key}) : super(key: key);

  @override
  _CurrentLocationWidgetState createState() => _CurrentLocationWidgetState();
}

class _CurrentLocationWidgetState extends State<CurrentLocationWidget> {
  bool _isLoading = false;
  late SharedPreferences _prefs;
  bool _isNewUser = true;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNewUser = _prefs.getBool('isNewUser') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: Text(
          'Location',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  Images.deliver_location,
                  height: 280,
                ),
              ),
              SizedBox(height: 40.0),
              _isLoading
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.orange.shade900,
                ),
              )
                  : GestureDetector(
                onTap: () => _getCurrentLocation(context),
                child: Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.orange[900],
                  ),
                  child: Center(
                    child: Text(
                      "Use Current Location",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getCurrentLocation(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    // Check location permission
    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      Position position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {

          bool isLoggedIn = isUserLoggedIn();
          if (_isNewUser || !isLoggedIn) {
            await _prefs.setBool('isNewUser', false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => DashboardScreen(
                  exitFromApp: true,
                ),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => DashboardScreen(
                  exitFromApp: true,
                ),
              ),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Location permission not granted"),
          backgroundColor: Colors.red,
        ),
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool isUserLoggedIn() {
    String? authToken = _prefs.getString('authToken');
    return authToken != null && authToken.isNotEmpty;
  }
}
