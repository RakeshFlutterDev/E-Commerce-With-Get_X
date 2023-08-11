// ignore_for_file: prefer_const_constructors


import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_get_x/model/tool_model.dart';
import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:e_commerce_get_x/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final Tool tool;
  final List<Tool> cartItems;
  final List<Tool> favoriteItems;

  const ProductScreen({
    Key? key,
    required this.tool,
    required this.cartItems,
    required this.favoriteItems,
  }) : super(key: key);

  @override
 State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int quantity = 1;
  bool isFavorite = false;
  int _currentImageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: Text(widget.tool.name,style: josefinBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
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
              CarouselSlider(
                items: List.generate(
                  3, // Number of times to repeat the image
                      (index) => ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset(
                      widget.tool.image,
                      width: Dimensions.webMaxWidth,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                options: CarouselOptions(
                  height: 200,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1.0,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  scrollDirection: Axis.horizontal,
                ),
                carouselController: CarouselController(),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3, // Number of color indicators
                      (index) => buildColorIndicator(index),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price: ${widget.tool.price.toStringAsFixed(2)}',
                    style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 30,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      toggleFavoriteStatus(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                'Description:',
                style: josefinBold.copyWith(fontSize: Dimensions.fontSizeOverLarge),
              ),
              SizedBox(height: 10),
              // ExpandableText(
              //   widget.tool.description,
              //   readLessText: 'Read Less',
              //   readMoreText: 'Read More',
              //   style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.black),
              //   trim: 2,
              // ),
              Text(widget.tool.description,style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Colors.black),),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Quantity ',
                        style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                      SizedBox(width: 10.0),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity--;
                            }
                          });
                        },
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        quantity.toString(),
                        style: josefinRegular,
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade900,
                    ),
                    onPressed: () {
                      addToCart();
                      Navigator.pop(context);
                      showCustomSnackBar("Item added to cart");
                    },
                    child: Text('Add to Cart', style: josefinRegular),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildColorIndicator(int index) {
    return Container(
      width: 10,
      height: 10,
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentImageIndex == index ? Colors.orange : Colors.grey,
      ),
    );
  }

  void toggleFavoriteStatus(BuildContext context) {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        widget.favoriteItems.add(widget.tool);
        showCustomSnackBar('Item Added to Favorites');
      } else {
        widget.favoriteItems.remove(widget.tool);
        showCustomSnackBar('Item removed from Favorites');
      }
    });
  }

  void addToCart() {
    Tool selectedTool = widget.tool.copyWith(quantity: quantity);
    setState(() {
      widget.cartItems.add(selectedTool);
    });
  }
}
