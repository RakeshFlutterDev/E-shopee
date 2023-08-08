import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/cart_item_model.dart';
import 'package:e_shopee/models/product_model.dart';
import 'package:e_shopee/services/database/product_database_helper.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../utils/constants.dart';


class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  const CartItemCard({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product?>(
      future: ProductDatabaseHelper().getProductWithID(cartItem.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
          return Center(
            child: Text(
              error.toString(),
            ),
          );
        } else {
          final product = snapshot.data;
          if (product == null) {
            // Product not found, handle this case
            return Center(
              child: Text(
                "Product not found",
              ),
            );
          }

          return Row(
            children: [
              SizedBox(
                width: getProportionateScreenWidth(88),
                child: AspectRatio(
                  aspectRatio: 0.88,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF5F6F9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      product.images![0],
                    ),
                  ),
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title!,
                    style: josefinRegular,
                    maxLines: 2,
                  ),
                  SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                        text: "\$${product.originalPrice}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                        children: [
                          TextSpan(
                            text: "  x${cartItem.itemCount}",
                            style: TextStyle(
                              color: kTextColor,
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
