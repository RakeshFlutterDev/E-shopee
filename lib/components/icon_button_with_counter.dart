import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class IconButtonWithCounter extends StatelessWidget {
  final int numOfItems;
  final GestureTapCallback press;
  const IconButtonWithCounter({
    Key? key,
    this.numOfItems = 0,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: BorderRadius.circular(50),
      child: Stack(
        clipBehavior:
            Clip.none, // makes the stack clip over the overlapping widget
        children: [
          Icon(
            Icons.shopping_cart, size: 30,
            color: Colors.grey,
          ),
          if (numOfItems > 0)
            Positioned(
              right: 0,
              top: -3,
              child: Container(
                width: getProportionateScreenWidth(20),
                height: getProportionateScreenWidth(20),
                decoration: BoxDecoration(
                  color: Color(0xFFFF4848),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "$numOfItems",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(10),
                      color: Colors.white,
                      height: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
