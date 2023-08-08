import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/product_model.dart';
import 'package:e_shopee/services/database/product_database_helper.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../utils/constants.dart';


class ProductShortDetailCard extends StatelessWidget {
  final String productId;
  final VoidCallback onPressed;
  const ProductShortDetailCard({
    Key? key,
    required this.productId,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: FutureBuilder<Product?>(
        future: ProductDatabaseHelper().getProductWithID(productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data;
            return Row(
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(75),
                  child: AspectRatio(
                    aspectRatio: 0.75,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: product?.images?.isNotEmpty == true
                          ? Image.network(
                        product!.images![0], // Use '!' after the null check on product
                        fit: BoxFit.contain,
                      )
                          : Text("No Image",style: josefinRegular,),
                    ),
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(20)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product!.title ?? '', // Use null-aware operator and provide a default empty string
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: josefinRegular.copyWith(color: kTextColor),
                        maxLines: 2,
                      ),
                      SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                            text: "\₹${product.discountPrice}    ",
                            style: josefinRegular.copyWith(color: kPrimaryColor),
                            children: [
                              TextSpan(
                                text: "\₹${product.originalPrice}",
                                style: TextStyle(
                                  color: kTextColor,
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),

              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ));
          } else if (snapshot.hasError) {
            final errorMessage = snapshot.error.toString();
            Logger().e(errorMessage);
          }
          return Center(
            child: Icon(
              Icons.error,
              color: kTextColor,
              size: 60,
            ),
          );
        },
      ),
    );
  }
}
