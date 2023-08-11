/*
import 'package:e_commerce_get_x/model/color_model.dart';
import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:e_commerce_get_x/util/images.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:e_commerce_get_x/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class VisualizationScreen extends StatefulWidget {
  const VisualizationScreen({Key? key}) : super(key: key);

  @override
  State<VisualizationScreen> createState() => _VisualizationScreenState();
}

class _VisualizationScreenState extends State<VisualizationScreen> {
  bool isLoading = true;
  final ColorModel colorModel = ColorModel();

  @override
  void initState() {
    super.initState();
    // Simulate loading for 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title:  Text(
          "Visualization",
          style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          child: isLoading ? buildLoadingContent() : buildContent(),
        ),
      ),
    );
  }

  Widget buildLoadingContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildLoadingImage(),
        const SizedBox(height: 20.0),
        buildLoadingColorIcons(),
      ],
    );
  }

  Widget buildLoadingImage() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Shimmer(
        child: Container(
          color: Colors.grey[300],
        ),
      ),
    );
  }

  Widget buildLoadingColorIcons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              colorModel.colors.length,
                  (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Shimmer(
                  child: Image.asset(
                    Images.button,
                    height: 50,
                    width: 50,
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildImage(),
        const SizedBox(height: 20.0),
        buildColorIcons(),
      ],
    );
  }

  Widget buildImage() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 5),
        ],
      ),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          colorModel.primaryColor,
          BlendMode.hue,
        ),
        child: Transform.translate(
          offset: const Offset(0, -0),
          child: Image.asset(
            Images.room,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget buildColorIcons() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Choose Color',
        style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
      ),
      const SizedBox(height: 30),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (var i = 0; i < colorModel.colors.length; i++)
            buildIconBtn(colorModel.colors[i])
        ],
      ),
    ],
  );

  Widget buildIconBtn(Color myColor) => Stack(
    children: [
      Positioned(
        top: 12.5,
        left: 12.5,
        child: Icon(
          Icons.check,
          size: 25,
          color:
          colorModel.primaryColor == myColor ? myColor : Colors.transparent,
        ),
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            colorModel.primaryColor = myColor;
          });
          showCustomSnackBar(
            "Selected Color : ${colorModel.getColorName(myColor)}",isError: false,
          );
        },
        child: Image.asset(
          Images.button,
          height: 50,
          width: 50,
          color: myColor.withOpacity(0.65),
        ),
      )
    ],
  );
}*/
