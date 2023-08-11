// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class OrderScreen extends StatefulWidget {
//   @override
//   _OrderScreenState createState() => _OrderScreenState();
// }
//
// class _OrderScreenState extends State<OrderScreen> {
//   List<dynamic> orders = [];
//
//   late DatabaseReference databaseReference;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize Firebase Realtime Database reference
//     databaseReference =
//         FirebaseDatabase.instance.reference().child('orders');
//
//     // Listen for data changes
//     databaseReference.onValue.listen((event) {
//       if (event.snapshot.value != null) {
//         if (event.snapshot.value is Map) {
//           Map<dynamic, dynamic> values =
//           (event.snapshot.value as Map<dynamic, dynamic>).cast<String, dynamic>();
//           setState(() {
//             orders = values.entries.map((entry) => entry.value).toList();
//           });
//
//           // Print orders on the console
//           printOrders();
//         }
//       }
//     }, onError: (error) {
//       print("Error fetching orders: $error");
//     });
//   }
//   void printOrders() {
//     for (var order in orders) {
//       final customer = order['Customer Details'];
//       final orderId = customer['Ordered Items'] != null &&
//           customer['Ordered Items'].isNotEmpty &&
//           customer['Ordered Items'][0]['orderId'] != null
//           ? customer['Ordered Items'][0]['orderId']
//           : 'N/A';
//       final orderTime = customer['Ordered Items'] != null &&
//           customer['Ordered Items'].isNotEmpty &&
//           customer['Ordered Items'][0]['orderTime'] != null
//           ? customer['Ordered Items'][0]['orderTime']
//           : 'N/A';
//       final paymentType = customer['Ordered Items'] != null &&
//           customer['Ordered Items'].isNotEmpty &&
//           customer['Ordered Items'][0]['paymentType'] != null
//           ? customer['Ordered Items'][0]['paymentType']
//           : 'N/A';
//
//       print('Order ID: $orderId');
//       print('Order Time: $orderTime');
//       print('Payment Type: $paymentType');
//       print('');
//     }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order Screen'),
//       ),
//       body: ListView.builder(
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//           final order = orders[index];
//           final customer = order['Customer Details'];
//
//           final orderId = customer['Ordered Items'] != null &&
//               customer['Ordered Items'].isNotEmpty &&
//               customer['Ordered Items'][0]['orderId'] != null
//               ? customer['Ordered Items'][0]['orderId']
//               : 'N/A';
//
//           final orderTime = customer['Ordered Items'] != null &&
//               customer['Ordered Items'].isNotEmpty &&
//               customer['Ordered Items'][0]['orderTime'] != null
//               ? customer['Ordered Items'][0]['orderTime']
//               : 'N/A';
//           final paymentType = customer['Ordered Items'] != null &&
//               customer['Ordered Items'].isNotEmpty &&
//               customer['Ordered Items'][0]['paymentType'] != null
//               ? customer['Ordered Items'][0]['paymentType']
//               : 'N/A';
//
//           final firstName = customer['firstName'] ?? 'N/A';
//           final lastName = customer['lastName'] ?? 'N/A';
//
//           final customerAddress = customer['address'] != null &&
//               customer['address']['address'] != null
//               ? customer['address']['address']
//               : 'N/A';
//
//           final phoneNumber = customer['phone'] ?? 'N/A';
//           final email = customer['email'] ?? 'N/A';
//
//           final orderedItems = customer['Ordered Items'] ?? [];
//
//           return ListTile(
//             title: Text('Order ID: $orderId'),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Text('Customer: $firstName $lastName'),
//                 // Text('Address: $customerAddress'),
//                 // Text('Phone: $phoneNumber'),
//                 //Text('Email: $email'),
//                 Text('OrderTime: $orderTime'),
//                 Text('Payment Method: $paymentType'),
//                 // Text('Ordered Items:'),
//                 // for (var item in orderedItems)
//                 //   Text('- ${item['name'] ?? 'N/A'} (${item['quantity'] ?? 'N/A'})'),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User App',
      home: Scaffold(
        appBar: AppBar(title: Text('User Details')),
        body: UserWidget(userId: '10001'),
      ),
    );
  }
}

class UserWidget extends StatefulWidget {
  final String userId;

  UserWidget({required this.userId});

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  late DatabaseReference _databaseReference;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.reference();
    fetchUserData(widget.userId);
  }

  void fetchUserData(String userId) {
    _databaseReference
        .child('users')
        .child(userId)
        .onValue
        .listen((event) {
      final userData = event.snapshot.value;
      if (userData != null) {
        final userDataMap = (userData as Map<dynamic, dynamic>)
            .cast<String, dynamic>(); // Cast to Map<String, dynamic>
        print('Email: ${userDataMap['email']}');
        print('First Name: ${userDataMap['first_name']}');
        print('Last Name: ${userDataMap['last_name']}');
        print('Phone: ${userDataMap['phone']}');
      } else {
        print('User not found');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Empty container as we won't display anything
  }
}
