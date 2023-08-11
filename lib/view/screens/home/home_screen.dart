import 'package:e_commerce_get_x/helper/route_helper.dart';
import 'package:e_commerce_get_x/model/tool_model.dart';
import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:e_commerce_get_x/util/images.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:e_commerce_get_x/view/screens/cart/cart_screen.dart';
import 'package:e_commerce_get_x/view/screens/home/widget/drawer_widget.dart';
import 'package:e_commerce_get_x/view/screens/products/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? address;
  List<Tool> cartItems = [];
  List<Tool> favoriteItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    startLoading();
    getAddressFromSharedPreferences();
  }

  void startLoading() async {
    // Simulating a delay of 3 seconds
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  void getAddressFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getString('selectedAddress');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: Text(
          'E-Commerce',
          style: josefinBold,
        ),
        actions: [
          Image(
            image: AssetImage(Images.logo),
            height: 20,
            width: 20,
          ),
          IconButton(
            icon: Icon(Icons.location_on_outlined),
            onPressed: () {
              //    Navigator.push(context, MaterialPageRoute(builder: (context)=> SavedAddressScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle_outlined),
            onPressed: () {
              //         Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfileScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CartScreen(
                          cartItems: cartItems,
                        )),
              );
              // handle cart button press
            },
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 2.0,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Colour, Product and Categories...',
                    hintStyle: josefinRegular,
                    filled: true,
                    fillColor: Colors.white54,
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        // TODO: Handle search button press
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 14.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Get.offNamed(RouteHelper.pick_location),
                    child: Row(
                      children: [
                        Icon(Icons.location_pin),
                        Flexible(
                          flex: 1,
                          child: Text(
                            address ?? 'No address selected',
                            style: josefinRegular,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.0),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(10.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CategoriesScreen(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Items',
                      style: josefinBold.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge),
                    ),
                  ),
                  SizedBox(
                    height: 160.0,
                    child: isLoading
                        ? HomeShimmer()
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: tools.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductScreen(
                                        tool: tools[index].copyWith(),
                                        cartItems: cartItems,
                                        favoriteItems: favoriteItems,
                                      ),
                                    ),
                                  );
                                },
                                child: ToolWidget(tool: tools[index]),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[300],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 16.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[300],
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Container(
                    height: 16.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ToolWidget extends StatelessWidget {
  final Tool tool;

  const ToolWidget({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                tool.image,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          tool.name,
          style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
        SizedBox(height: 4.0),
        Text(
          '₹ ${tool.price.toStringAsFixed(2)}',
          style: josefinRegular,
        ),
      ],
    );
  }
}
