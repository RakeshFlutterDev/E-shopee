import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/components/nothingtoshow_container.dart';
import 'package:e_shopee/components/product_card.dart';
import 'package:e_shopee/components/search_field.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/screens/product_details/product_details_screen.dart';
import 'package:e_shopee/services/data_streams/all_products_stream.dart';
import 'package:e_shopee/services/database/product_database_helper.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AllProductsStream allProductsStream = AllProductsStream();
  List<String> searchResultProductsId = []; // Store the search results here
  String searchQuery = ''; // Store the search query here

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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Row(
                children: [
                  SizedBox(width: 5),
                  Expanded(
                    child: SearchField(
                      onSubmit: (value) async {
                        final query = value.toString();
                        if (query.isEmpty) {
                          setState(() {
                            searchResultProductsId = [];
                            searchQuery = '';
                          });
                          return;
                        }

                        List<String> searchedProductsId;
                        try {
                          searchedProductsId = await ProductDatabaseHelper().searchInProducts(query.toLowerCase());
                          setState(() {
                            searchResultProductsId = searchedProductsId;
                            searchQuery = query;
                          });
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
                  ),
                ],
              ),
              if (searchQuery.isNotEmpty && searchResultProductsId.isNotEmpty) // Show the "Search Result" section only when there are search results
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        "Search Result",
                        style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                      Text.rich(
                        TextSpan(
                          text: "$searchQuery",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                          children: [
                            TextSpan(
                                text: " in ",
                                style: josefinRegular
                            ),
                            TextSpan(
                              text: "All Products", // Replace with the appropriate search category
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(30)),
                    ],
                  ),
                ),
              // Display the search results
              if (searchResultProductsId.isNotEmpty)
                Expanded(
                  child: buildProductsGrid(),
                ),
              // Show a message when there are no search results
              if (searchQuery.isNotEmpty && searchResultProductsId.isEmpty)
                Expanded(
                  child: Center(
                    child: Text("No products found for '$searchQuery'.", style: josefinRegular),
                  ),
                ),
              // Show a message asking the user to search for something if the search query is blank
              if (searchQuery.isEmpty)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    SvgPicture.asset(
                      "assets/icons/Search Icon.svg",
                      width: 60, height: 60,
                    ),
                      SizedBox(height: 10.0),
                      Center(
                        child: Text("Search something...", style: josefinRegular.copyWith(color: Colors.grey)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> refreshPage() {
    allProductsStream.reload();
    return Future<void>.value();
  }

  Widget buildProductsGrid() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Builder(
        builder: (context) {
          if (searchResultProductsId.isNotEmpty) {
            return GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: searchResultProductsId.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  productId: searchResultProductsId[index],
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          productId: searchResultProductsId[index],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return Center(
            child: NothingToShowContainer(
              iconPath: "assets/icons/search_no_found.svg",
              secondaryMessage: "Found 0 Products",
              primaryMessage: "Try another search keyword",
            ),
          );
        },
      ),
    );
  }
}
