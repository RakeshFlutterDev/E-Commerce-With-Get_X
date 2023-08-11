import 'dart:ui' as ui;

import 'package:e_commerce_get_x/helper/route_helper.dart';
import 'package:e_commerce_get_x/model/order_model.dart';
import 'package:e_commerce_get_x/view/base/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  GoogleMapController? mapController;
  late Position currentPosition;
  LatLng? selectedLocation;
  BitmapDescriptor? markerIcon;
  String? selectedAddress;
  TextEditingController searchController = TextEditingController();
  late DatabaseReference _userReference;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    setMarkerIcon();
    // Initialize the Firebase Realtime Database reference
    _userReference = FirebaseDatabase.instance.ref().child('users');
  }

  void getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showCustomSnackBar('Location services are disabled',isError: true);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      showCustomSnackBar(
          'Location permissions are permanently denied, please enable them in app settings',isError: true);
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        showCustomSnackBar('Location permissions are denied',isError: true);
        return;
      }
    }

    try {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          selectedAddress =
          '${placemark.street}, ${placemark.locality}, ${placemark.country}';
        });
      }

      setState(() {
        selectedLocation = LatLng(
          currentPosition.latitude,
          currentPosition.longitude,
        );
      });

      zoomToCurrentLocation();

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            currentPosition.latitude,
            currentPosition.longitude,
          ),
          20.0,
        ),
      );
    } catch (e) {
      showCustomSnackBar('Failed to get current location: $e',isError: true);
    }
  }

  void zoomToCurrentLocation() {
    if (selectedLocation != null && mapController != null) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          selectedLocation!,
          25.0,
        ),
      );
    }
  }

  void setMarkerIcon() async {
    final Uint8List markerIconData =
    await getBytesFromAsset('assets/images/location.png', 100);

    setState(() {
      markerIcon = BitmapDescriptor.fromBytes(markerIconData);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec =
    await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer
        .asUint8List();
  }

  void handleMapTap(LatLng tapLocation) async {
    setState(() {
      selectedLocation = tapLocation;
      selectedAddress = 'Loading...';
    });

    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(tapLocation.latitude, tapLocation.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        List<String> addressComponents = [];
        if (placemark.name != null) addressComponents.add(placemark.name!);
        if (placemark.thoroughfare != null) addressComponents.add(placemark.thoroughfare!);
        if (placemark.subThoroughfare != null) addressComponents.add(placemark.subThoroughfare!);
        if (placemark.locality != null) addressComponents.add(placemark.locality!);
        if (placemark.subLocality != null) addressComponents.add(placemark.subLocality!);
        if (placemark.administrativeArea != null) addressComponents.add(placemark.administrativeArea!);
        if (placemark.subAdministrativeArea != null) {
          addressComponents.add(placemark.subAdministrativeArea!);
        }
        if (placemark.postalCode != null) addressComponents.add(placemark.postalCode!);
        if (placemark.country != null) addressComponents.add(placemark.country!);

        setState(() {
          selectedAddress = addressComponents.join(', ');
          searchController.text = selectedAddress!;
        });
      }
    } catch (e) {
      setState(() {
        selectedAddress = 'Failed to retrieve address';
      });
    }
  }


  void navigateToHomeScreen() async {
    if (selectedAddress != null && selectedAddress!.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedAddress', selectedAddress!);

      // Save the order data to the database
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user != null) {
        Order order = Order(
          userId: user.uid,
          address: selectedAddress,
        );

        DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('orders');
        DatabaseReference newOrderRef = ordersRef.push();
        newOrderRef.set(order.toJson()).then((_) {
          Get.offNamed(RouteHelper.getInitialRoute(), arguments: {'address': selectedAddress});
        }).catchError((error) {
          showCustomSnackBar('Failed to save the order: $error',isError: true);
        });
      } else {
        showCustomSnackBar('User not logged in',isError: true);
      }
    } else {
      showCustomSnackBar('Please select a valid address',isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: const Text('Location Screen'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
            onTap: handleMapTap,
            initialCameraPosition: CameraPosition(
              target: selectedLocation ?? const LatLng(0.0, 0.0),
              zoom: 12.0,
            ),
            markers: selectedLocation != null
                ? <Marker>{
              Marker(
                markerId: const MarkerId('selected_location'),
                position: selectedLocation!,
                icon: markerIcon != null
                    ? markerIcon!
                    : BitmapDescriptor.defaultMarker,
                infoWindow: InfoWindow(title: selectedAddress),
              ),
            }
                : <Marker>{},
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: selectedAddress,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      if (searchController.text.isNotEmpty) {
                        List<Location> locations =
                        await locationFromAddress(searchController.text);
                        if (locations.isNotEmpty) {
                          Location location = locations[0];
                          mapController?.animateCamera(
                            CameraUpdate.newLatLngZoom(
                              LatLng(location.latitude, location.longitude),
                              30.0,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: navigateToHomeScreen,
              child: const Text('Confirm Address and Proceed'),
            ),
          ),
          Positioned(
            bottom: 80.0,
            right: 16.0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(4.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6.0,
                    offset: const Offset(0.0, 3.0),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: zoomToCurrentLocation,
                icon: const Icon(Icons.my_location),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



