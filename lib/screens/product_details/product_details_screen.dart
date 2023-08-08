import 'package:e_shopee/components/custom_app_bar.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/product_model.dart';
import 'package:e_shopee/screens/product_details/components/fab.dart';
import 'package:e_shopee/screens/product_details/components/product_actions_section.dart';
import 'package:e_shopee/screens/product_details/components/product_images.dart';
import 'package:e_shopee/screens/product_details/components/product_review_section.dart';
import 'package:e_shopee/screens/product_details/provider_models/ProductActions.dart';
import 'package:e_shopee/services/database/product_database_helper.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductActions(),
      child: Scaffold(
        backgroundColor: Color(0xFFF5F6F9),
        appBar: CustomAppBar(
          title: 'Product Details',isBackButtonExist: true,onBackPressed: () =>Navigator.pop(context),
        ),
        body:SafeArea(
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(screenPadding),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<Product?>(
                      future: ProductDatabaseHelper().getProductWithID(productId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Placeholder while loading
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          // Print the error for debugging purposes
                          print('Error loading product: ${snapshot.error}');
                          return Center(
                            child: Icon(
                              Icons.error,
                              color: kTextColor,
                              size: 60,
                            ),
                          );
                        } else {
                          // Check if the product is null
                          if (snapshot.data == null) {
                            return Center(
                              child: Text('Product not found', style: josefinRegular),
                            );
                          }
                          // Product data is not null, continue with building the UI
                          final product = snapshot.data!;
                          return Column(
                            children: [
                              ProductImages(product: product),
                              SizedBox(height: getProportionateScreenHeight(20)),
                              ProductActionsSection(product: product),
                              SizedBox(height: getProportionateScreenHeight(20)),
                              ProductReviewsSection(product: product),
                              SizedBox(height: getProportionateScreenHeight(100)),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              )

          ),
        ),
        floatingActionButton: AddToCartFAB(productId: productId),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
