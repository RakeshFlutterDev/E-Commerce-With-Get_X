// ignore_for_file: prefer_const_constructors

import 'package:e_commerce_get_x/model/address_mode.dart';
import 'package:e_commerce_get_x/model/tool_model.dart';
import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:e_commerce_get_x/view/screens/cart/cart_screen.dart';
import 'package:e_commerce_get_x/view/screens/products/product_screen.dart';
import 'package:flutter/material.dart';

class CategoryWidgetScreen extends StatefulWidget {
  final String category;
  const CategoryWidgetScreen({Key? key, required this.category }) : super(key: key);

  @override
  State<CategoryWidgetScreen> createState() => _CategoryWidgetScreenState();
}

class _CategoryWidgetScreenState extends State<CategoryWidgetScreen> {
  List<Tool> categoryItems = [];
  List<Tool> cartItems = [];

  @override
  void initState() {
    super.initState();
    categoryItems = tools.where((tool) => tool.name.toLowerCase().contains(widget.category.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Tool> favoriteItems = [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: Text(widget.category,style: josefinBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(cartItems: cartItems)));
            },
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(overscroll: true),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: categoryItems.length,
          itemBuilder: (context, index) {
            Tool tool = categoryItems[index];
            bool isFavorite = false;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductScreen(
                      tool: tool.copyWith(), // Create a copy of the selected tool
                      cartItems: cartItems,
                      favoriteItems: favoriteItems,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 4.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                tool.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Flexible(
                            flex: 1,
                            child: Text(
                              tool.name,
                              style: josefinRegular,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            '₹ ${tool.price.toStringAsFixed(2)}',
                            style: josefinRegular.copyWith(color: Colors.green),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });

                                  if (isFavorite) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Added to Favorites',style: josefinRegular,),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
