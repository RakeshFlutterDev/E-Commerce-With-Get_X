import 'dart:io';

import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';


class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  final DateTime orderTime;
  final String formattedDate;
  final String formattedTime;
  final String address;
  final double discount;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final double subtotal;
  final double tax;
  final double deliveryCharge;
  final double total;
  final String paymentType;
  final List<Map<String, dynamic>> items;
  final String houseNo;
  final String street;
  final String locality;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.orderTime,
    required this.formattedDate,
    required this.formattedTime,
    required this.address,
    required this.discount,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.subtotal,
    required this.tax,
    required this.deliveryCharge,
    required this.total,
    required this.paymentType,
    required this.items,
    required this.houseNo,
    required this.street,
    required this.locality,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: Text(
          'Order Details',
          style: josefinMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          color: Theme.of(context).cardColor,
          boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 1)
          ],
        ),
        child: FutureBuilder(
          future:
          Future.delayed(const Duration(seconds: 2)), // Simulating loading time
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.orange.shade900),
                ),
              );
            } else {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Order ID : $orderId', style: josefinBold),
                              Row(
                                children: [
                                  Icon(Icons.timer,color: Colors.orange.shade900, size: 20.0),
                                  Text('$formattedDate at $formattedTime',
                                      style: josefinBold
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Divider(height: 10.0, thickness: 2),
                          SizedBox(height: 16.0),
                          Text(
                            'Delivery Address: ',
                            style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                          ),
                          SizedBox(height: 10),
                          Text(
                            address,
                            style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeLarge
                            ),
                          ),
                          Row(
                            children: [
                              Text('House No : $houseNo, ', style: josefinRegular,),
                              Text('Street : $street', style: josefinRegular,),
                            ],
                          ),
                          Text(
                            'Locality : $locality',
                            style:
                            josefinRegular,
                          ),
                          SizedBox(height: 16.0),
                          Divider(height: 10.0, thickness: 2),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Payment Method ',
                                style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                              ),
                              Text(
                                paymentType,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Divider(height: 10.0, thickness: 2),
                          SizedBox(height: 16.0),
                          Center(
                            child: Text(
                              'Ordered Items',
                              style: josefinBold.copyWith(
                                  fontSize: Dimensions.fontSizeLarge),
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(height: 10.0, thickness: 2),
                          SizedBox(height: 10),

                          // Displaying the item details
                          Column(
                            children: [
                              for (var item in items)
                                ListTile(
                                  leading: Image.asset(item['image'] ?? ''), // Display the asset image
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item['name'] ?? '',style: josefinMedium,),
                                      Text('₹ ${item['price'] ?? ''}',style: josefinMedium,),
                                    ],
                                  ),
                                  subtitle: Text('Quantity: ${item['quantity'] ?? ''}',style: josefinRegular,),
                                ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Divider(height: 10.0, thickness: 2),
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Order Summary',
                              style: josefinBold.copyWith(
                                  fontSize: Dimensions.fontSizeLarge),
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(height: 10.0, thickness: 2),
                          SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal: ',
                                style: josefinRegular.copyWith(
                                    fontSize: Dimensions.fontSizeLarge),
                              ),
                              Text(
                                '₹ ${subtotal.toStringAsFixed(2)}',
                                style: josefinRegular.copyWith(
                                    fontSize: Dimensions.fontSizeLarge),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount: ',
                                style: josefinRegular.copyWith(
                                    fontSize: Dimensions.fontSizeLarge),
                              ),
                              Text(
                                '₹ ${discount.toStringAsFixed(2)}',
                                style: josefinRegular.copyWith(
                                    fontSize: Dimensions.fontSizeLarge),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tax: ',
                                style: josefinRegular.copyWith(
                                    fontSize: Dimensions.fontSizeLarge),
                              ),
                              Text(
                                '₹ ${tax.toStringAsFixed(2)}',
                                style: josefinRegular.copyWith(
                                    fontSize: Dimensions.fontSizeLarge),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery Charge: ',
                                style: josefinRegular.copyWith(
                                    fontSize: Dimensions.fontSizeLarge),
                              ),
                              Text(
                                '₹ ${deliveryCharge.toStringAsFixed(2)}',
                                style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Divider(height: 10, thickness: 2),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount: ',
                                style: josefinBold.copyWith(
                                    fontSize: Dimensions.fontSizeLarge),
                              ),
                              Text(
                                '₹ ${total.toStringAsFixed(2)}',
                                style: josefinBold.copyWith(
                                    fontSize: Dimensions.fontSizeLarge),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Divider(height: 10, thickness: 2),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed: generatePDF,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade900,
                                ),
                                child: Text(
                                  'Download Invoice',
                                  style: josefinRegular,
                                ),
                              )

                            ],
                          ),
                          // Add more order details as needed
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    final pw.TextStyle headerText = pw.TextStyle(
      fontSize: 30,
      font: pw.Font.ttf(await rootBundle.load("assets/font/JosefinSans-Bold.ttf")),
      fontWeight: pw.FontWeight.bold,
    );
    final pw.TextStyle titleStyle = pw.TextStyle(
      fontSize: 20,
      font: pw.Font.ttf(await rootBundle.load("assets/font/JosefinSans-Bold.ttf")),
      fontWeight: pw.FontWeight.bold,
    );
    final pw.TextStyle contentStyle = pw.TextStyle(
      fontSize: 16,
      font: pw.Font.ttf(await rootBundle.load("assets/font/JosefinSans-Medium.ttf")),
      fontWeight: pw.FontWeight.normal,
    );

    const double quantityWidth = 110.0;

    pdf.addPage(
        pw.Page(
            build: (pw.Context context){
              return pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text('Invoice', style: headerText),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Divider(thickness: 2, height: 10),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Order ID : $orderId', style: titleStyle),
                      pw.Text('Date : $formattedDate at $formattedTime',style: contentStyle),
                    ],
                  ),
                  pw.SizedBox(height: 16),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Customer Details',
                        style: titleStyle,
                      ),
                      pw.Text(
                        'Payment Method',
                        style: titleStyle,
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children:[
                        pw.Text(
                          '$firstName$lastName',
                          style: contentStyle,
                        ),
                        pw.Text(
                          paymentType,
                          style: contentStyle,
                        ),
                      ]),
                  pw.SizedBox(height: 10.0),
                  pw.Text(
                    phone,
                    style: contentStyle,
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Address: ',
                    style: titleStyle,
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                      address,
                      style: contentStyle
                  ),
                  pw.Row(
                    children: [
                      pw.Text('House No : $houseNo, ',style: contentStyle),
                      pw.Text('Street : $street', style: contentStyle),
                    ],
                  ),
                  pw.Text(
                    'Locality : $locality',
                    style:
                    contentStyle,
                  ),
                  pw.SizedBox(height: 16.0),
                  pw.Divider(thickness: 2, height: 10.0),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Item',
                        style: titleStyle,
                      ),
                      pw.Text(
                        'Quantity',
                        style: titleStyle,
                      ),
                      pw.Text(
                        'Price',
                        style: titleStyle,
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10.0),
                  pw.Divider(height: 10, thickness: 2),
                  pw.SizedBox(height: 10.0),
                  pw.Column(
                    children: [
                      for (var item in items)
                        pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Container(
                                width: quantityWidth,
                                child:pw.Text(item['name'] ?? '', style: contentStyle),
                              ),
                              pw.Text('${item['quantity'] ?? ''}',style: contentStyle),
                              pw.Text('₹ ${item['price'] ?? ''}', style:contentStyle),
                            ],
                          ),
                        ),
                    ],
                  ),
                  pw.Divider(height: 10, thickness: 2),
                  pw.SizedBox(height: 10.0),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Subtotal: ₹ ${subtotal.toStringAsFixed(2)}',
                        style: contentStyle,
                      ),
                      pw.SizedBox(height: 5.0),
                      pw.Text(
                        'Discount: ₹ ${discount.toStringAsFixed(2)}',
                        style: contentStyle,
                      ),
                      pw.SizedBox(height: 5.0),
                      pw.Text(
                        'Tax: ₹ ${tax.toStringAsFixed(2)}',
                        style: contentStyle,
                      ),
                      pw.SizedBox(height: 5.0),
                      pw.Text(
                        'Delivery Charge: ₹ ${deliveryCharge.toStringAsFixed(2)}',
                        style: contentStyle,
                      ),

                      pw.Divider(thickness: 2, height: 20),
                      pw.SizedBox(height: 10.0),
                      pw.Text(
                        'Total: ₹ ${total.toStringAsFixed(2)}',
                        style: titleStyle,
                      ),
                      // pw.Text(
                      // 'Payment Status: ${isPaymentSuccessful ? "Paid" : "Pending"}',
                      // style: pw.TextStyle(
                      // fontSize: 16,
                      // ),
                      // ),
                      // pw.Divider(thickness: 2, height: 20),
                      // pw.SizedBox(height: 10),
                      pw.SizedBox(height: 10.0),
                      pw.Divider(thickness: 2, height: 10),
                      pw.SizedBox(height: 20.0),
                      pw.Center(
                          child: pw.Text(
                              'Thank you for your order!',style: titleStyle
                          )),
                    ],
                  ),
                ],
              );
            }
        )
    );
    // Save and open the PDF file
    final directory = await getExternalStorageDirectory();
    final file = File('${directory?.path}/Invoice.pdf');
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }
}