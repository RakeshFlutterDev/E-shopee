import 'package:e_shopee/components/async_progress_dialog.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/product_model.dart';
import 'package:e_shopee/screens/cart/cart_screen.dart';
import 'package:e_shopee/screens/category_products/category_products_screen.dart';
import 'package:e_shopee/screens/home/components/banner_card.dart';
import 'package:e_shopee/screens/home/components/categories.dart';
import 'package:e_shopee/screens/notification/notification_screen.dart';
import 'package:e_shopee/screens/product_details/product_details_screen.dart';
import 'package:e_shopee/screens/search/search_screen.dart';
import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:e_shopee/services/data_streams/all_products_stream.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';
import '../../../helper/utils.dart';
import '../../../utils/constants.dart';
import '../components/home_header.dart';
import 'product_type_box.dart';
import 'products_section.dart';

const String ICON_KEY = "icon";
const String TITLE_KEY = "title";
const String PRODUCT_TYPE_KEY = "product_type";

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AllProductsStream allProductsStream = AllProductsStream();

  final List<String> bannerImages = [
    "assets/images/electronics_banner.jpg",
    "assets/images/books_banner.jpg",
    "assets/images/fashions_banner.jpg",
    "assets/images/groceries_banner.jpg",
    "assets/images/arts_banner.jpg",
  ];
  final List<String> bannerNames = [
    "Electronics",
    "Books",
    "Fashion",
    "Groceries",
    "Arts"
  ];

  final List<Map<String, dynamic>> productCategories = <Map<String, dynamic>>[
    <String, dynamic>{
      ICON_KEY: "assets/icons/Electronics.svg",
      TITLE_KEY: "Electronics",
      PRODUCT_TYPE_KEY: ProductType.Electronics,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Books.svg",
      TITLE_KEY: "Books",
      PRODUCT_TYPE_KEY: ProductType.Books,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Fashion.svg",
      TITLE_KEY: "Fashion",
      PRODUCT_TYPE_KEY: ProductType.Fashion,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Groceries.svg",
      TITLE_KEY: "Groceries",
      PRODUCT_TYPE_KEY: ProductType.Groceries,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Art.svg",
      TITLE_KEY: "Art",
      PRODUCT_TYPE_KEY: ProductType.Art,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Others.svg",
      TITLE_KEY: "Others",
      PRODUCT_TYPE_KEY: ProductType.Others,
    },
  ];

  @override
  void initState() {
    super.initState();
    allProductsStream.init();
  }

  @override
  void dispose() {
    allProductsStream.dispose();
    super.dispose();
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: getProportionateScreenHeight(15)),
                HomeHeader(
                  onNotificationBtnPressed: () async {
                    bool allowed = AuthService().currentUserVerified;
                    if (!allowed) {
                      final reverify = await ConfirmationDialog(context,
                          "You haven't verified your email address. This action is only allowed for verified users.",
                          positiveResponse: "Resend Email",
                          negativeResponse: "Go back");
                      if (reverify) {
                        final future = AuthService()
                            .sendVerificationEmailToCurrentUser();
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AsyncProgressDialog(
                              future,
                              message: Text("Resending verification email",
                                style: josefinRegular,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            );
                          },
                        );
                      }
                      return;
                    }
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                    await refreshPage();
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
                SizedBox(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 5)],
                        ),
                        child: Row(
                            children: [
                              SizedBox(width: Dimensions.paddingSizeExtraLarge),
                              Text('Search for your desired products',style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),
                              SizedBox(width: Dimensions.paddingSizeExtraSmall),
                              Expanded(child:Icon(
                                Icons.search, size: 25, color: Theme.of(context).hintColor,),
                              ),
                            ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
                BannerCard(bannerImages: bannerImages, bannerNames: bannerNames, productCategories: productCategories,), // Use BannerCarousel widget here
                SizedBox(height: getProportionateScreenHeight(15)),
                SizedBox(
                  height: Dimensions.paddingSizeDefault,
                  child: Categories(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text(
                        "Categories",
                        style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge)
                       ),
                     ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          children: [
                            ...List.generate(
                              productCategories.length,
                              (index) {
                                return ProductTypeBox(
                                  icon: productCategories[index][ICON_KEY],
                                  title: productCategories[index][TITLE_KEY],
                                  onPress: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryProductsScreen(
                                          productType: productCategories[index]
                                              [PRODUCT_TYPE_KEY],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.8,
                  child: ProductsSection(
                    sectionTitle: "Explore All Products",
                    productsStreamController: allProductsStream,
                    emptyListMessage: "Looks like all Stores are closed",
                    onProductCardTapped: onProductCardTapped,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    allProductsStream.reload();
    return Future<void>.value();
  }

  void onProductCardTapped(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(productId: productId),
      ),
    ).then((_) async {
      await refreshPage();
    });
  }

}
