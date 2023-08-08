import 'package:e_shopee/components/custom_app_bar.dart';
import 'package:e_shopee/components/nothingtoshow_container.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/ordered_product_model.dart';
import 'package:e_shopee/models/product_model.dart';
import 'package:e_shopee/screens/my_orders/order_details_screen.dart';
import 'package:e_shopee/services/data_streams/ordered_products_stream.dart';
import 'package:e_shopee/services/database/product_database_helper.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
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
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Your Orders",
          ),
        body: SafeArea(
          child: RefreshIndicator(
            color: kPrimaryColor,
            onRefresh: refreshPage,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(screenPadding)),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: getProportionateScreenHeight(20)),
                      SizedBox(
                        height: SizeConfig.screenHeight! * 0.75,
                        child: buildOrderedProductsList(),
                      ),
                    ],
                  ),
                ),
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

  Widget buildOrderedProductsList() {
    return StreamBuilder<List<String>>(
      stream: orderedProductsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orderedProductsIds = snapshot.data;
          if (orderedProductsIds!.length == 0) {
            return Center(
              child: NothingToShowContainer(
                iconPath: "assets/icons/empty_bag.svg",
                secondaryMessage: "Order something to show here",
              ),
            );
          }
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: orderedProductsIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder<OrderedProduct>(
                future: UserDatabaseHelper().getOrderedProductFromId(orderedProductsIds[index]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final orderedProduct = snapshot.data;
                    return buildOrderedProductItem(orderedProduct!);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: null);
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
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          print(error.toString());
        }
        return Center(
          child: NothingToShowContainer(
            iconPath: "assets/icons/network_error.svg",
            primaryMessage: "Something went wrong",
            secondaryMessage: "Unable to connect to Database",
          ),
        );
      },
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
            child: GestureDetector(
              onTap:()=> Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsScreen(orderedProducts: [orderedProduct],),
                ),
              ).then((_) async {
                await refreshPage();
              }),
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: getProportionateScreenWidth(65),
                          child: AspectRatio(
                            aspectRatio: 0.95,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: product?.images?.isNotEmpty == true
                                  ? Image.network(
                                product!.images![0], // Use '!' after the null check on product
                                fit: BoxFit.cover,
                              )
                                  : Text(
                                "No Image",
                                style: josefinRegular,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: getProportionateScreenWidth(10)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${'OrderId'}: #${orderedProduct.orderId}', // Use null-aware operator and provide a default empty string
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: josefinRegular,
                              maxLines: 2,
                            ),
                            SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                text: "${orderedProduct.orderDate.toString()}",
                                style: josefinRegular.copyWith(fontSize:Dimensions.fontSizeExtraSmall,color: kPrimaryColor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: getProportionateScreenWidth(30)),
                        Row(
                          children: [
                            Text('Qty: ', style: josefinRegular.copyWith(color: kTextColor)),
                            Text('${orderedProduct.quantity?.toInt() ?? 0}', style: josefinRegular.copyWith(color: kTextColor)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: null);
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
