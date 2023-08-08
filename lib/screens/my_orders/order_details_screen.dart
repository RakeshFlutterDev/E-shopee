import 'package:e_shopee/components/custom_app_bar.dart';
import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/product_model.dart';
import 'package:e_shopee/models/ordered_product_model.dart';
import 'package:e_shopee/models/review_model.dart';
import 'package:e_shopee/screens/my_orders/components/product_review_dialog.dart';
import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:e_shopee/services/data_streams/ordered_products_stream.dart';
import 'package:e_shopee/services/database/product_database_helper.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  final List<OrderedProduct> orderedProducts;

  OrderDetailsScreen({required this.orderedProducts});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final OrderedProductsStream orderedProductsStream = OrderedProductsStream();

  @override
  void initState() {
    super.initState();
    orderedProductsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    orderedProductsStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Order Details',isBackButtonExist: true,onBackPressed: ()=>Navigator.pop(context)),
      body: SafeArea(
        child: RefreshIndicator(
          color: kPrimaryColor,
          onRefresh: refreshPage,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text('${'OrderId'}:', style: josefinMedium),
                    SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Text('${widget.orderedProducts[0].orderId}', style: josefinMedium),
                    const Expanded(child: SizedBox()),
                    const Icon(Icons.watch_later, size: 17),
                    SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Text(
                      '${widget.orderedProducts[0].orderDate.toString()}',
                      style: josefinMedium,
                    ),
                  ]),
                  SizedBox(height: Dimensions.paddingSizeExtraLarge),
                  Row(children: [
                    Text(
                      'Payment Type',
                      style: josefinMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),
                    const Expanded(child: SizedBox()),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Text(
                        '${widget.orderedProducts[0].paymentType}',
                        style: josefinMedium.copyWith(
                            color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraSmall),
                      ),
                    ),
                  ]),
                  Divider(height: Dimensions.paddingSizeLarge),
                  SizedBox(height: Dimensions.paddingSizeDefault),
                  Text(
                    'Ordered Products',
                    style: josefinMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),
                  SizedBox(height: Dimensions.paddingSizeSmall),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.orderedProducts.length,
                    itemBuilder: (context, index) {
                      return buildOrderedProductItem(widget.orderedProducts[index]);
                    },
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Order Summary',
                    style: josefinMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),
                  SizedBox(height: Dimensions.paddingSizeSmall),
                  Divider(thickness: 2),
                  SizedBox(height: Dimensions.paddingSizeSmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "OriginalPrice",
                            style: josefinRegular.copyWith(color: kTextColor, decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "\₹${widget.orderedProducts[0].originalPrice}",
                            style: josefinRegular.copyWith(color: kTextColor, decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                    ],
                  ),
                  buildOrderSummaryRow('Discount Price', '\₹${widget.orderedProducts[0].subtotal}'),
                  buildOrderSummaryRow('Tax', '\₹${widget.orderedProducts[0].tax}'),
                  buildOrderSummaryRow('Delivery Charge', '\₹${widget.orderedProducts[0].deliveryCharge}'),
                  buildOrderSummaryRow('Discount', '-\₹${widget.orderedProducts[0].discount}'),
                  Divider(thickness: 2),
                  buildOrderSummaryRow('Total', '\₹${widget.orderedProducts[0].total}'),
                  Divider(thickness: 2),
                  SizedBox(height: Dimensions.paddingSizeDefault),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            if (widget.orderedProducts.isEmpty) {
                              // Handle the case where there are no ordered products.
                              return;
                            }

                            String currentUserUid = AuthService().currentUser.uid;
                            Review? prevReview;
                            try {
                              prevReview = await ProductDatabaseHelper()
                                  .getProductReviewWithID(widget.orderedProducts[0].productUid!, currentUserUid);
                              // Add the null-aware operator (!) to assert that orderedProducts[0].productUid is non-null.
                            } on FirebaseException catch (e) {
                              print("Firebase Exception: $e");
                            } catch (e) {
                              print("Unknown Exception: $e");
                            } finally {
                              if (prevReview == null) {
                                prevReview = Review(
                                  currentUserUid,
                                  reviewerUid: currentUserUid,
                                );
                              }
                            }

                            bool hasReviewed = await ProductDatabaseHelper().hasUserReviewedProduct(
                              widget.orderedProducts[0].productUid!,
                              currentUserUid,
                            );

                            if (hasReviewed) {
                              showCustomSnackBar(
                                context,
                                "You have already submitted review",
                                isError: false,
                              );
                            } else {
                              final result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return ProductReviewDialog(
                                    review: prevReview!,
                                  );
                                },
                              );
                              if (result is Review) {
                                bool reviewAdded = false;
                                try {
                                  reviewAdded = await ProductDatabaseHelper().addProductReview(
                                    widget.orderedProducts[0].productUid!,
                                    result,
                                  );
                                  // Add the null-aware operator (!) to assert that orderedProducts[0].productUid is non-null.
                                  if (reviewAdded == true) {
                                    showCustomSnackBar(context, "Product review added successfully", isError: false);
                                  } else {
                                    throw "Couldn't add product review due to an unknown reason";
                                  }
                                } on FirebaseException catch (e) {
                                  print("Firebase Exception: $e");
                                  showCustomSnackBar(context, e.toString());
                                } catch (e) {
                                  print("Unknown Exception: $e");
                                  showCustomSnackBar(context, e.toString());
                                }
                              }
                            }
                            await refreshPage();
                          },
                          child: Text(
                            "Review",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: josefinMedium.copyWith(color: kPrimaryLightColor),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            minimumSize: Size(Dimensions.webMaxWidth, 40),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: TextButton(
                          child: Text(
                            'Download Pdf',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: josefinMedium.copyWith(color: kPrimaryLightColor),
                          ),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: kPrimaryColor,minimumSize: Size(Dimensions.webMaxWidth, 40), padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    orderedProductsStream.reload();
    return Future<void>.value();
  }

  Widget buildOrderSummaryRow(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: josefinRegular),
          Text(amount, style: josefinRegular),
        ],
      ),
    );
  }

  Widget buildOrderedProductItem(OrderedProduct orderedProduct) {
    return FutureBuilder<Product?>(
      future: ProductDatabaseHelper().getProductWithID(orderedProduct.productUid!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final product = snapshot.data;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Card(
              shadowColor: kTextColor,
              elevation: 2,
              child: Row(
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
                            : Text(
                          "No Image",
                          style: josefinRegular,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(20)),
                  Column(
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
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: getProportionateScreenWidth(65)),
                  Row(
                    children: [
                      Text('Qty: ', style: josefinRegular.copyWith(color: kTextColor)),
                      Text('${widget.orderedProducts[0].quantity!.toInt()}', style: josefinRegular.copyWith(color: kTextColor)),
                    ],
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ));
        } else if (snapshot.hasError) {
          final error = snapshot.error.toString();
          print(error);
        }
        return Icon(
          Icons.error,
          size: 60,
          color: kTextColor,
        );
      },
    );
  }
}
