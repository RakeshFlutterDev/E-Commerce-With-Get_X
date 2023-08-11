import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function onBackPressed;
  final bool showCart;
  const CustomAppBar({super.key, required this.title, this.isBackButtonExist = true,  required this.onBackPressed, this.showCart = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.white)),
      centerTitle: true,
      leading: isBackButtonExist ? IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: Theme.of(context).textTheme.bodyLarge!.color,
        onPressed: () => onBackPressed != null ? onBackPressed() : Navigator.pop(context),
      ) : const SizedBox(),
      backgroundColor: Colors.orange.shade900,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size(Dimensions.webMaxWidth, GetPlatform.isDesktop ? 70 : 50);
}
