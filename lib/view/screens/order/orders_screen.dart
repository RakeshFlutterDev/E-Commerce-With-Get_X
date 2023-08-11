// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class OrderScreen extends StatefulWidget {
//   @override
//   _OrderScreenState createState() => _OrderScreenState();
// }
//
// class _OrderScreenState extends State<OrderScreen> {
//   List<dynamic> orders = [];
//   late DatabaseReference databaseReference;
//   late User? currentUser;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize Firebase Realtime Database reference
//     databaseReference = FirebaseDatabase.instance.reference().child('orders');
//
//     // Listen for authentication state changes
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       setState(() {
//         currentUser = user;
//       });
//
//       // Fetch orders if a user is logged in
//       if (currentUser != null) {
//         fetchOrders(currentUser!.uid);
//       } else {
//         // Reset orders if no user is logged in
//         resetOrders();
//       }
//     });
//   }
//
//   void fetchOrders(String userId) {
//     // Clear existing orders
//     setState(() {
//       orders.clear();
//     });
//
//     // Fetch orders specific to the logged-in user
//     databaseReference
//         .orderByChild('Customer Details/userId')
//         .equalTo(userId)
//         .onValue
//         .listen((event) {
//       if (event.snapshot.value != null) {
//         if (event.snapshot.value is Map) {
//           Map<dynamic, dynamic> values =
//           (event.snapshot.value as Map<dynamic, dynamic>)
//               .cast<String, dynamic>();
//           setState(() {
//             orders = values.entries.map((entry) => entry.value).toList();
//           });
//         }
//       }
//     }, onError: (error) {
//       print("Error fetching orders: $error");
//     });
//   }
//
//   void resetOrders() {
//     setState(() {
//       orders.clear();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order Screen'),
//       ),
//       body: orders.isEmpty
//           ? Center(
//         child: Text('No Orders Found'),
//       )
//           : ListView.builder(
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//           final order = orders[index];
//           final customer = order['Customer Details'];
//
//           return ListTile(
//             title: Text('Order ID: $orderId'),
//             subtitle: Text('Order Time: $orderTime'),
//             onTap: () {
//               // Show selected order details
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: Text('Order Details'),
//                     content: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('Order ID: $orderId'),
//                         Text('Order Time: $orderTime'),
//                         Text('Payment Method: $paymentType'),
//                       ],
//                     ),
//                     actions: [
//                       TextButton(
//                         child: Text('Close'),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
