
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/constants.dart';

class NothingToShowContainer extends StatelessWidget {
  final String iconPath;
  final String primaryMessage;
  final String secondaryMessage;

  const NothingToShowContainer({
    Key? key,
    this.iconPath = "assets/icons/empty_box.svg",
    this.primaryMessage = "No data found",
    this.secondaryMessage = "",
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth! * 0.75,
      height: SizeConfig.screenHeight! * 0.2,
      child: Column(
        children: [
          SvgPicture.asset(
            iconPath,
            color: kTextColor,
            width: getProportionateScreenWidth(75),
          ),
          SizedBox(height: 16),
          Text(
            primaryMessage,
            style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeLarge),

    ),
          Text(
            secondaryMessage,
            style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
        ],
      ),
    );
  }
}
