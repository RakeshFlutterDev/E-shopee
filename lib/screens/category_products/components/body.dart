import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/components/nothingtoshow_container.dart';
import 'package:e_shopee/components/product_card.dart';
import 'package:e_shopee/components/search_field.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/product_model.dart';
import 'package:e_shopee/screens/product_details/product_details_screen.dart';
import 'package:e_shopee/screens/search/search_result_screen.dart';
import 'package:e_shopee/services/data_streams/category_products_stream.dart';
import 'package:e_shopee/services/database/product_database_helper.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class Body extends StatefulWidget {
  final ProductType productType;

  Body({
    Key? key,
    required this.productType,
  }) : super(key: key);

  @override
  _BodyState createState() =>
      _BodyState(categoryProductsStream: CategoryProductsStream(productType));
}

class _BodyState extends State<Body> {
  final CategoryProductsStream categoryProductsStream;

  _BodyState({required this.categoryProductsStream});

  @override
  void initState() {
    super.initState();
    categoryProductsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    categoryProductsStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  buildHeadBar(),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.13,
                    child: buildCategoryBanner(),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.68,
                    child: StreamBuilder<List<String>>(
                      stream: categoryProductsStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<String> productsId = snapshot.data!;
                          if (productsId.length == 0) {
                            return Center(
                              child: NothingToShowContainer(
                                secondaryMessage:
                                "No Products in ${EnumToString.convertToString(widget.productType)}",
                              ),
                            );
                          }

                          return buildProductsGrid(productsId);
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeadBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 5),
        Expanded(
          child: SearchField(
            onSubmit: (value) async {
              final query = value.toString();
              if (query.length <= 0) return;
              List<String> searchedProductsId;
              try {
                searchedProductsId = await ProductDatabaseHelper()
                    .searchInProducts(query.toLowerCase(),
                    productType: widget.productType);
                if (searchedProductsId != null) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResultScreen(
                        searchQuery: query,
                        searchResultProductsId: searchedProductsId,
                        searchIn:
                        EnumToString.convertToString(widget.productType),
                      ),
                    ),
                  );
                  await refreshPage();
                } else {
                  throw "Couldn't perform search due to some unknown reason";
                }
              } catch (e) {
                final error = e.toString();
                print(error);
                showCustomSnackBar(context, "$error");
              }
            },
          ),
        ),
        SizedBox(width: 8.0),
        Container(
          height: 35,
          decoration: BoxDecoration(
            border: Border.all(color: kPrimaryColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: josefinRegular.copyWith(color: kBlackColor),
            ),
          ),
        )
      ],
    );
  }

  Future<void> refreshPage() {
    categoryProductsStream.reload();
    return Future<void>.value();
  }

  Widget buildCategoryBanner() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(bannerFromProductType()),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                kPrimaryColor,
                BlendMode.hue,
              ),
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              EnumToString.convertToString(widget.productType),
              style:josefinBold.copyWith(color: kPrimaryLightColor,fontSize: Dimensions.fontSizeLarge),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProductsGrid(List<String> productsId) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: productsId.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ProductCard(
            productId: productsId[index],
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(
                    productId: productsId[index],
                  ),
                ),
              ).then(
                    (_) async {
                  await refreshPage();
                },
              );
            },
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 2,
          mainAxisSpacing: 8,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 12,
        ),
      ),
    );
  }

  String bannerFromProductType() {
    switch (widget.productType) {
      case ProductType.Electronics:
        return "assets/images/electronics_banner.jpg";
      case ProductType.Books:
        return "assets/images/books_banner.jpg";
      case ProductType.Fashion:
        return "assets/images/fashions_banner.jpg";
      case ProductType.Groceries:
        return "assets/images/groceries_banner.jpg";
      case ProductType.Art:
        return "assets/images/arts_banner.jpg";
      case ProductType.Others:
        return "assets/images/others_banner.jpg";
      default:
        return "assets/images/others_banner.jpg";
    }
  }
}
