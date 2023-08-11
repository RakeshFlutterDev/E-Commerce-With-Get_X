//
// import 'package:flutter/material.dart';
//
// import '../../tools/painting_tools.dart';
//
// class ProductScreen extends StatefulWidget {
//   final Tool tool;
//   final List<Tool> cartItems;
//
//   ProductScreen({required this.tool, required this.cartItems});
//
//   @override
//   _ProductScreenState createState() => _ProductScreenState();
// }
//
// class _ProductScreenState extends State<ProductScreen> {
//   int quantity = 1;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.tool.name),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Image.asset(
//                     widget.tool.image,
//                     width: 500,
//                     height: 200,
//                   ),
//                 ),
//                 SizedBox(height: 16.0),
//                 Text(
//                   'Price: \$${widget.tool.price.toStringAsFixed(2)}',
//                   style: TextStyle(fontSize: 20.0),
//                 ),
//                 SizedBox(height: 8.0),
//                 Text(
//                   'Description: ${widget.tool.description}',
//                   style: TextStyle(fontSize: 16.0),
//                 ),
//               ],
//             ),
//           ),
//           Spacer(),
//           Container(
//             padding: EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.remove),
//                       onPressed: () {
//                         setState(() {
//                           if (quantity > 1) {
//                             quantity--;
//                           }
//                         });
//                       },
//                     ),
//                     Text(
//                       quantity.toString(),
//                       style: TextStyle(fontSize: 18.0),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.add),
//                       onPressed: () {
//                         setState(() {
//                           quantity++;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 ElevatedButton(
//                   child: Text('Add to Cart'),
//                   onPressed: () {
//                     addToCart();
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('${widget.tool.name} added to cart'),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void addToCart() {
//     Tool selectedTool = widget.tool.copyWith(quantity: quantity);
//     setState(() {
//       widget.cartItems.add(selectedTool);
//     });
//   }
// }