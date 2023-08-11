// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
//
// class LocationScreen extends StatefulWidget {
//   const LocationScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LocationScreen> createState() => _LocationScreenState();
// }
//
// class _LocationScreenState extends State<LocationScreen> {
//   GoogleMapController? mapController;
//   Position? currentLocation;
//   TextEditingController searchController = TextEditingController();
//   Set<Marker> markers = {};
//   String? currentAddress;
//
//   @override
//   void initState() {
//     super.initState();
//     _getLocation();
//   }
//
//   void _getLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled on the device.
//       return;
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permission denied.
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permission permanently denied.
//       return;
//     }
//
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     setState(() {
//       currentLocation = position;
//     });
//
//     List<Placemark> placemarks = await placemarkFromCoordinates(
//       currentLocation!.latitude,
//       currentLocation!.longitude,
//     );
//
//     if (placemarks.isNotEmpty) {
//       Placemark placemark = placemarks.first;
//       setState(() {
//         currentAddress = '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.locality}';
//         markers.add(
//           Marker(
//             markerId: MarkerId('currentLocation'),
//             position: LatLng(currentLocation!.latitude, currentLocation!.longitude),
//             infoWindow: InfoWindow(title: currentAddress),
//           ),
//         );
//
//         mapController?.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
//               zoom: 14.0,
//             ),
//           ),
//         );
//       });
//     }
//   }
//
//
//   void _searchLocation() async {
//     List<Location> locations = await locationFromAddress(searchController.text);
//     if (locations.isNotEmpty) {
//       Location location = locations.first;
//       mapController?.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: LatLng(location.latitude, location.longitude),
//             zoom: 24.0,
//           ),
//         ),
//       );
//       setState(() {
//         markers.clear();
//         markers.add(
//           Marker(
//             markerId: MarkerId('searchLocation'),
//             position: LatLng(location.latitude, location.longitude),
//             infoWindow: InfoWindow(title: 'Search Location'),
//           ),
//         );
//       });
//     }
//   }
//
//   void _goToCurrentLocation() {
//     if (currentLocation != null) {
//       mapController?.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
//             zoom: 24.0,
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Map'),
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: (GoogleMapController controller) {
//               mapController = controller;
//             },
//             initialCameraPosition: currentLocation != null
//                 ? CameraPosition(
//               target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
//               zoom: 14.0,
//             )
//                 : CameraPosition(
//               target: LatLng(0, 0),
//               zoom: 14.0,
//             ),
//             zoomControlsEnabled: false,
//             markers: markers,
//             onTap: (LatLng latLng) {
//               // Clear any existing markers
//               setState(() {
//                 markers.clear();
//                 markers.add(
//                   Marker(
//                     markerId: MarkerId('tappedLocation'),
//                     position: latLng,
//                     infoWindow: InfoWindow(title: currentAddress),
//                   ),
//                 );
//               });
//             },
//             gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
//               Factory<OneSequenceGestureRecognizer>(
//                     () => EagerGestureRecognizer(),
//               ),
//             },
//             compassEnabled: true,
//             myLocationButtonEnabled: true,
//             mapToolbarEnabled: true,
//           ),
//           Positioned(
//             top: 16.0,
//             left: 16.0,
//             right: 16.0,
//             child: Container(
//               color: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: searchController,
//                         decoration: const InputDecoration(
//                           hintText: 'Search Location',
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.search),
//                       onPressed: _searchLocation,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 16.0,
//             right: 16.0,
//             child: FloatingActionButton(
//               onPressed: _goToCurrentLocation,
//               child: Icon(Icons.my_location),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
