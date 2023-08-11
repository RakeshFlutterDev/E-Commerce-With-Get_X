import 'dart:ui' as ui;
import 'package:e_commerce_get_x/model/address_mode.dart';
import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:e_commerce_get_x/view/base/custom_snackbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  GoogleMapController? mapController;
  late Position currentPosition;
  LatLng? selectedLocation;
  BitmapDescriptor? markerIcon;
  AddressModel? selectedAddress;
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController houseNoController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  late DatabaseReference _userReference;
  String? selectedOption;
  List<String> locationOptions = ['Home', 'Office', 'Others'];

  void _onOptionSelected(String option) {
    setState(() {
      selectedOption = option;
    });
  }

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
      showCustomSnackBar('Location services are disabled', isError: true);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      showCustomSnackBar('Location permissions are permanently denied, please enable them in app settings', isError: true);
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        showCustomSnackBar('Location permissions are denied', isError: true);
        return;
      }
    }

    try {
      currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          selectedAddress = AddressModel(
            selectedOption: selectedOption,
            selectedAddress: '${placemark.street}, ${placemark.locality}, ${placemark.country}',
            houseNo: '',
            street: '',
            locality: '',
          );
          addressController.text = selectedAddress!.selectedAddress!;
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
      showCustomSnackBar('Failed to get current location: $e', isError: true);
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
    final Uint8List markerIconData = await getBytesFromAsset('assets/images/location.png', 100);

    setState(() {
      markerIcon = BitmapDescriptor.fromBytes(markerIconData);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void handleMapTap(LatLng tapLocation) async {
    if (mounted) {
      setState(() {
        selectedLocation = tapLocation;
        selectedAddress = null; // Reset the selectedAddress while loading new address
      });

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(tapLocation.latitude, tapLocation.longitude);
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          List<String> addressComponents = [];
          if (placemark.name != null) addressComponents.add(placemark.name!);
          if (placemark.thoroughfare != null) {
            addressComponents.add(placemark.thoroughfare!);
          }
          if (placemark.subThoroughfare != null) {
            addressComponents.add(placemark.subThoroughfare!);
          }
          if (placemark.locality != null) {
            addressComponents.add(placemark.locality!);
          }
          if (placemark.subLocality != null) {
            addressComponents.add(placemark.subLocality!);
          }
          if (placemark.administrativeArea != null) {
            addressComponents.add(placemark.administrativeArea!);
          }
          if (placemark.subAdministrativeArea != null) {
            addressComponents.add(placemark.subAdministrativeArea!);
          }
          if (placemark.postalCode != null) {
            addressComponents.add(placemark.postalCode!);
          }
          if (placemark.country != null) {
            addressComponents.add(placemark.country!);
          }

          if (mounted) {
            setState(() {
              selectedAddress = AddressModel(
                selectedOption: selectedOption,
                selectedAddress: addressComponents.join(', '),
                houseNo: '',
                street: '',
                locality: '',
              );
              addressController.text = selectedAddress!.selectedAddress!;
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            selectedAddress = AddressModel(
              selectedOption: selectedOption,
              selectedAddress: 'Failed to retrieve address',
              houseNo: '',
              street: '',
              locality: '',
            );
            addressController.text = selectedAddress!.selectedAddress!;
          });
        }
      }
    }
  }

  void navigateToHomeScreen() async {
    bool isMounted = mounted; // Store the mounted state

    if (selectedAddress != null && selectedAddress!.selectedAddress!.isNotEmpty) {
      if (selectedOption != null && selectedOption!.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Save the address to SharedPreferences
        await prefs.setString('selectedOption', selectedOption!);
        await prefs.setString('selectedAddress', selectedAddress!.selectedAddress!);
        await prefs.setString('userName', nameController.text);
        await prefs.setString('userNumber', numberController.text);
        await prefs.setString('houseNo', houseNoController.text);
        await prefs.setString('street', streetController.text);
        await prefs.setString('locality', localityController.text);

    if (isMounted) {
    setState(() {});
    }

    // Navigate to the SavedAddressScreen if still mounted
    } else {
    showCustomSnackBar('Please select an option Home, Office, Others', isError: true);
    }
    } else {
    showCustomSnackBar('Please select a valid address', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: const Text('Address Screen'),
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 1)],
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).cardColor,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 1)],
                  ),
                  child: Stack(
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
                            icon: markerIcon != null ? markerIcon! : BitmapDescriptor.defaultMarker,
                            infoWindow: InfoWindow(title: selectedAddress?.selectedAddress),
                          ),
                        }
                            : Set<Marker>(),
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
                              hintText: selectedAddress?.selectedAddress,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () async {
                                  if (searchController.text.isNotEmpty) {
                                    List<Location> locations = await locationFromAddress(searchController.text);
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
                        bottom: 10.0,
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
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Current Location',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: houseNoController,
                            decoration: InputDecoration(
                              labelText: 'House No',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: streetController,
                            decoration: InputDecoration(
                              labelText: 'Street',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: localityController,
                      decoration: InputDecoration(
                        labelText: 'Locality',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: locationOptions.map((option) {
                        final isSelected = option == selectedOption;
                        return GestureDetector(
                          onTap: () => _onOptionSelected(option),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 20.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected ? Colors.orange[900]! : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                              color: isSelected ? Colors.orange[100] : Colors.transparent,
                            ),
                            child: Text(
                              option,
                              style: isSelected ? josefinBold : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 50,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.orange[900],
                      ),
                      child: TextButton(
                        onPressed: navigateToHomeScreen,
                        child: Text(
                          "Save Address",
                          style: josefinMedium.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
