import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/product_model.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/constants.dart';
import 'expandable_text.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: product.title,
                  style:josefinRegular.copyWith(color: kBlackColor,fontSize: Dimensions.fontSizeLarge),
                  children: [
                    TextSpan(
                      text: "\n${product.variant} ",
                      style: josefinRegular
                    ),
                  ]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: getProportionateScreenHeight(64),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 4,
                    child: Text.rich(
                      TextSpan(
                        text: "\₹${product.discountPrice}   ",
                        style: josefinRegular.copyWith(color: kPrimaryColor,fontSize: Dimensions.fontSizeExtraLarge),
                        children: [
                          TextSpan(
                            text: "\n\₹${product.originalPrice}",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: kTextColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Stack(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/Discount.svg",
                          color: kPrimaryColor,
                        ),
                        Center(
                          child: Text(
                            " ${product.calculatePercentageDiscount()}%\nOff",
                            style: josefinRegular.copyWith(color: kPrimaryLightColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ExpandableText(
              title: "Highlights",
              content: product.highlights!,
            ),
            const SizedBox(height: 16),
            ExpandableText(
              title: "Description",
              content: product.description!,
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                text: "Sold by ",
                style: josefinBold,
                children: [
                  TextSpan(
                    text: "${product.seller}",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
