import 'package:e_shopee/helper/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class SocialCard extends StatelessWidget {
  final String icon;
  final VoidCallback? press;

  const SocialCard({
    Key? key,
    required this.icon,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenWidth(40),
        margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
        padding: EdgeInsets.all(getProportionateScreenWidth(8)),
        decoration: BoxDecoration(
          color: Color(0xFFF5F6F9),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: SvgPicture.asset(icon),
        ),
      ),
    );
  }
}
